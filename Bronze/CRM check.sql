-- ===============================================
-- CRM Data Warehouse Quality Checks (Bronze Layer)
-- ===============================================

-- ✅ Check: View all customer records
SELECT * FROM cust_info;

-- ✅ Switch to the 'bronze' database (assuming staging layer)
USE bronze;

-- ✅ Check: Duplicate customer IDs
SELECT cst_id, COUNT(*) 
FROM cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1;

-- ✅ Check: Leading/trailing spaces in customer first names
SELECT cst_firstname 
FROM cust_info 
WHERE cst_firstname != TRIM(cst_firstname);

-- ✅ Check: Leading/trailing spaces in customer last names
SELECT cst_lastname 
FROM cust_info 
WHERE cst_lastname != TRIM(cst_lastname);

-- ✅ Check: Unique gender values (standardization needed)
SELECT DISTINCT cst_gender FROM cust_info;

-- ✅ Standardize gender values
SELECT *, 
  CASE
    WHEN cst_gender = 'M' THEN 'Male'
    WHEN cst_gender = 'F' THEN 'Female'
    ELSE 'N/A'
  END AS standardized_gender
FROM cust_info;

-- ✅ Standardize marital status values
SELECT *,
  CASE 
    WHEN cst_martial_status = 'M' THEN 'Married'
    WHEN cst_martial_status = 'S' THEN 'Single'
    ELSE 'N/A'
  END AS standardized_status
FROM cust_info;

-- ✅ Start a transaction (in case of updates)
START TRANSACTION;
COMMIT;
ROLLBACK;

-- ✅ Disable safe updates temporarily (required for some update queries)
SET SQL_SAFE_UPDATES = 0;

-- ===============================================
-- PRODUCT INFO QUALITY CHECKS
-- ===============================================

-- ✅ View all product records
SELECT * FROM prd_info;

-- ✅ Check: Duplicate product IDs
SELECT prd_id, COUNT(*) 
FROM prd_info 
GROUP BY prd_id 
HAVING COUNT(*) > 1;

-- ✅ Check: Negative or NULL product costs
SELECT prd_cost 
FROM prd_info 
WHERE prd_cost < 1 OR prd_cost IS NULL;

-- ✅ Check: Leading/trailing spaces in product names
SELECT prd_nm 
FROM prd_info 
WHERE prd_nm != TRIM(prd_nm);

-- ✅ Check: Distinct values in product line (standardization)
SELECT DISTINCT prd_line FROM prd_info;

-- ✅ Standardize product line values
SELECT *,
  CASE 
    WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
    WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
    WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Roads'
    WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Training'
    ELSE 'N/A'
  END AS standardized_line
FROM prd_info;

-- ✅ Check: Product start date should be earlier than end date
SELECT * 
FROM prd_info 
WHERE prd_start_date >= prd_end_date;

-- ✅ Extract category ID and update product key
SELECT prd_id, 
       prd_key,
       REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
       SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS cleaned_prd_key,
       prd_nm,
       prd_cost,
       prd_line,
       prd_start_date,
       prd_end_date
FROM prd_info;

-- ===============================================
-- SALES DETAILS QUALITY CHECKS
-- ===============================================

-- ✅ Check: Orphan sales records (invalid product key)
SELECT * 
FROM sales_details 
WHERE sls_prd_key NOT IN (
  SELECT prd_key FROM prd_info
);

-- ✅ Check: Leading/trailing spaces in sales order numbers
SELECT * 
FROM sales_details 
WHERE sls_ord_num != TRIM(sls_ord_num);

-- ✅ Check: Invalid or missing quantities
SELECT * 
FROM sales_details 
WHERE sls_quantity < 0 OR sls_quantity IS NULL;

-- ✅ Check: Invalid or missing sales amount
SELECT * 
FROM sales_details 
WHERE sls_sales < 0 OR sls_sales IS NULL;

-- ✅ Check: Invalid or missing prices
SELECT * 
FROM sales_details 
WHERE sls_price < 0 OR sls_price IS NULL;

-- ===============================================
-- END OF QUALITY CHECKS (BRONZE LAYER)
-- ===============================================
