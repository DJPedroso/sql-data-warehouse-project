/*
============================================================
Stored Procedure: Load Silver Layer (Bronze to Silver)
============================================================
Purpose:
  Performs the ETL process to populate the 'silver' schema
  tables from the 'bronze' schema.

Actions Performed:
  - Truncates Silver tables.
  - Inserts transformed & cleansed data from Bronze into 
  Silver tables

Parameters:
  None.

Usage Example:
  CALL silver.load_silver()

============================================================
*/

DROP PROCEDURE IF EXISTS silver.load_silver();
CREATE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
	v_start_time TIMESTAMP;
	v_table_start_time TIMESTAMP;
	v_end_time TIMESTAMP;

BEGIN
	v_start_time := clock_timestamp();

    	RAISE NOTICE '=================================';
    	RAISE NOTICE 'Loading Silver Layer';
    	RAISE NOTICE '=================================';
    	RAISE NOTICE ' ';
    	RAISE NOTICE '=================================';
    	RAISE NOTICE 'Loading CRM Tables';
    	RAISE NOTICE '=================================';

	-- crm_cust_info
	v_table_start_time := clock_timestamp();

	TRUNCATE TABLE silver.crm_cust_info;
	INSERT INTO silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date)
	SELECT
		cst_id,
		cst_key,
		-- Removing Unwanted Spaces
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		-- Data Normalization/Standardization
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		-- Handling of missing data
		ELSE 'n/a'
		END AS cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
		END AS cst_gndr,
		cst_create_date
		-- Removing of duplicates
	FROM (
		-- Keeps only 1 (latest) record for each customer (cst_id),
		-- removing duplicates based on cst_create_date
		SELECT *,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
	) AS t WHERE flag_last = 1;

	v_end_time := clock_timestamp();
	RAISE NOTICE 'crm_cust_info loaded in %',
		v_end_time - v_table_start_time;

	-- crm_prd_info
	v_table_start_time := clock_timestamp();

	TRUNCATE TABLE silver.crm_prd_info;
	INSERT INTO silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')  AS cat_id, -- Extract category ID
		SUBSTRING(prd_key, 7, CHAR_LENGTH(prd_key)) AS prd_key, -- Extract product key
		prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost, -- Change NULLs to 0
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END AS prd_line, -- Map product line codes to descriptive values
		prd_start_dt,
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS 	prd_end_dt -- Calculate end date as 1 day before the next start date
	FROM bronze.crm_prd_info;

	v_end_time := clock_timestamp();
   	RAISE NOTICE 'crm_prd_info loaded in %',
		v_end_time - v_table_start_time;

	-- crm_sales_details
	v_table_start_time := clock_timestamp();

	TRUNCATE TABLE silver.crm_sales_details;
	INSERT INTO silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)

	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt = 0 OR CHAR_LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
			ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt = 0 OR CHAR_LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
			ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
		END AS sls_ship_dt,
		CASE WHEN sls_due_dt = 0 OR CHAR_LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
			ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
		END AS sls_due_dt,

		-- Recalculate sales if original value is missing or incorrect
		CASE
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,

		sls_quantity,
		CASE WHEN sls_price <= 0 OR sls_price IS NULL
				THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price -- Derive price if original value is invalid
	FROM bronze.crm_sales_details;

	v_end_time := clock_timestamp();
	RAISE NOTICE 'crm_sales_details loaded in %',
		v_end_time - v_table_start_time;



	RAISE NOTICE '=================================';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '=================================';

	-- erp_cust_az12
	v_table_start_time := clock_timestamp();

	TRUNCATE TABLE silver.erp_cust_az12;
	INSERT INTO silver.erp_cust_az12(cid, bdate, gen)

	SELECT
		-- Remove 'NAS' prefix if present
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, CHAR_LENGTH(cid))
			ELSE cid
		END AS cid,
		CASE WHEN bdate > CURRENT_DATE THEN NULL
			ELSE bdate
		END AS bdate, -- Set future birthdates to NULL
		CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			ELSE 'n/a'
		END AS gen -- Normalize gender values & handle unknown cases
	FROM bronze.erp_cust_az12;

	v_end_time := clock_timestamp();
	RAISE NOTICE 'erp_cust_az12 loaded in %',
		v_end_time - v_table_start_time;

	-- erp_loc_a101
	v_table_start_time := clock_timestamp();

	TRUNCATE TABLE silver.erp_loc_a101;
	INSERT INTO silver.erp_loc_a101 (cid, cntry)

	SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
		END AS cntry -- Normalize & handle missing or blank country codes
	FROM bronze.erp_loc_a101;

	v_end_time := clock_timestamp();
	RAISE NOTICE 'erp_loc_a101 loaded in %',
		v_end_time - v_table_start_time;

	-- erp_px_cat_g1v2
	v_table_start_time := clock_timestamp();

	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
	SELECT
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2; -- clean table, no cleaning needed

	v_end_time := clock_timestamp();
	RAISE NOTICE 'erp_px_cat_g1v2 loaded in %',
		v_end_time - v_table_start_time;

	RAISE NOTICE ' ';
	RAISE NOTICE '=================================';
	RAISE NOTICE 'Silver Layer Loaded Successfully';
	RAISE NOTICE '=================================';

	v_end_time := clock_timestamp();

	RAISE NOTICE ' ';
	RAISE NOTICE 'Execution Summary';
	RAISE NOTICE '---------------------------------';
	RAISE NOTICE 'Start Time : %', v_start_time;
	RAISE NOTICE 'End Time   : %', v_end_time;
	RAISE NOTICE 'Duration   : %', v_end_time - v_start_time;

EXCEPTION
    WHEN OTHERS THEN
        v_end_time := clock_timestamp();

        RAISE NOTICE '=================================';
        RAISE NOTICE 'Silver Layer Load Failed';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE 'Elapsed Time: %',
            v_end_time - v_start_time;
        RAISE NOTICE '=================================';

        RAISE;
END;
$$;
