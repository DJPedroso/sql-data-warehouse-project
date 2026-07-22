/*
============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
============================================================
Purpose:
  Loads data into the 'bronze' schema from external CSV 
  files. It performs the following actions:
  - Truncates bronze tables before loading data
  - Uses the COPY command to load data from CSV files into 
  the Bronze tables.

Parameters:
  This procedure does not accept any parameters and does not 
  return a value.

--

Usage:
  CALL bronze.load_bronze;

Checking:
  SELECT COUNT(*) FROM bronze.crm_cust_info;
  SELECT COUNT(*) FROM bronze.crm_prd_info;
  SELECT COUNT(*) FROM bronze.crm_sales_details;
  SELECT COUNT(*) FROM bronze.erp_cust_az12;
  SELECT COUNT(*) FROM bronze.erp_loc_a101;
  SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
============================================================

*/

DROP PROCEDURE IF EXISTS bronze.load_bronze();

CREATE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
	v_start_time TIMESTAMP;
  v_table_start_time TIMESTAMP;
	v_end_time TIMESTAMP;
BEGIN
	v_start_time := clock_timestamp();

	RAISE NOTICE '=================================';
	RAISE NOTICE 'Loading Bronze Layer';
	RAISE NOTICE '=================================';
	RAISE NOTICE ' ';
	RAISE NOTICE '=================================';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '=================================';
	
	-- crm_cust_info
  v_table_start_time := clock_timestamp();

	TRUNCATE TABLE bronze.crm_cust_info;
	COPY bronze.crm_cust_info
	FROM 'C:\sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FORMAT csv,
		HEADER true
	);
  v_end_time := clock_timestamp();

  RAISE NOTICE 'crm_cust_info loaded in %',
    v_end_time - v_table_start_time;
	
	-- crm_prd_info

  v_table_start_time := clock_timestamp();
	TRUNCATE TABLE bronze.crm_prd_info;
	COPY bronze.crm_prd_info
	FROM 'C:\sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FORMAT csv,
		HEADER true
	);

  v_end_time := clock_timestamp();

  RAISE NOTICE 'crm_prd_info loaded in %',
    v_end_time - v_table_start_time;
	
	-- crm_sales_details

  v_table_start_time := clock_timestamp();
	TRUNCATE TABLE bronze.crm_sales_details;
	COPY bronze.crm_sales_details
	FROM 'C:\sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FORMAT csv,
		HEADER true
	);

  v_end_time := clock_timestamp();

  RAISE NOTICE 'crm_sales_details loaded in %',
    v_end_time - v_table_start_time;

	RAISE NOTICE '=================================';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '=================================';

	-- erp_cust_az12

  v_table_start_time := clock_timestamp();
	TRUNCATE TABLE bronze.erp_cust_az12;
	COPY bronze.erp_cust_az12
	FROM 'C:\sql\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
		FORMAT csv,
		HEADER true
	);

  v_end_time := clock_timestamp();

  RAISE NOTICE 'erp_cust_az12 loaded in %',
    v_end_time - v_table_start_time;
	
	-- erp_loc_a101

  v_table_start_time := clock_timestamp();
	TRUNCATE TABLE bronze.erp_loc_a101;
	COPY bronze.erp_loc_a101
	FROM 'C:\sql\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
		FORMAT csv,
		HEADER true
	);

  v_end_time := clock_timestamp();

  RAISE NOTICE 'erp_loc_a101 loaded in %',
    v_end_time - v_table_start_time;
	
	-- erp_px_cat_g1v2

  v_table_start_time := clock_timestamp();
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	COPY bronze.erp_px_cat_g1v2
	FROM 'C:\sql\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FORMAT csv,
		HEADER true
	);

  v_end_time := clock_timestamp();

  RAISE NOTICE 'erp_px_cat_g1v2 loaded in %',
    v_end_time - v_table_start_time;

	RAISE NOTICE ' ';
	RAISE NOTICE '=================================';
	RAISE NOTICE 'Bronze Layer Loaded Successfully';
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
        RAISE NOTICE 'Bronze Layer Load Failed';
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE NOTICE 'Elapsed Time: %', v_end_time - v_start_time;
        RAISE NOTICE '=================================';
        RAISE;
END;
$$;
