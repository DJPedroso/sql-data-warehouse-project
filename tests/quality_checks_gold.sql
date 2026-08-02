/*
==============================================================
Quality Checks
==============================================================
Purpose: 
  Performs quality checks to validate the integrity,
  consistency, and accuracy of the Gold layer.

  It ensures:
  - Uniqueness of surrogate keys in dimension tables.
  - Referential integrity between fact and dimension tables.
  - Validation of relationships in the data model for 
  analytical purposes.

Usage:
  - Run these checks after loading the Gold layer.
  - Investigate and resolve any discrepancies found during
  the checks.
==============================================================
*/

/*
==============================================================
Checking 'gold.dim_customers'
==============================================================
Check for uniqueness of customer_key in gold.dim_customers: Expect no results
*/
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

/*
==============================================================
Checking 'gold.dim_products'
==============================================================
Check for uniqueness of product_key in gold.dim_products: Expect no results
*/
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

/*
==============================================================
Checking 'gold.fact_sales'
==============================================================
Check for orphan records in gold.fact_sales that do not match 
records in the dimension tables: Expect no results
*/
SELECT *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key 
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key 
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
