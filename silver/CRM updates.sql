-- ==============================
-- SILVER LAYER UPDATES - CRM
-- ==============================

-- VIEW ORIGINAL CUSTOMER INFO
SELECT * FROM cust_info;

-- ============ PRIMARY KEY CHECK & FIX ============
-- Find duplicate customer IDs
SELECT cst_id, COUNT(*) 
FROM cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1;

-- Keep latest record by cst_create_date and delete duplicates
START TRANSACTION;
DELETE FROM cust_info
WHERE cst_id IN (29466, 29433, 29473, 29449, 29483)
  AND (cst_id, cst_create_date) NOT IN (
    SELECT cst_id, MAX(cst_create_date)
    FROM (SELECT * FROM cust_info) AS temp
    WHERE cst_id IN (29466, 29433, 29473, 29449, 29483)
    GROUP BY cst_id
);
COMMIT;
ROLLBACK;

-- ============ SPACING CLEANUP ============
-- Identify extra spaces in first and last names
SELECT cst_firstname FROM cust_info WHERE cst_firstname != TRIM(cst_firstname);
SELECT cst_lastname FROM cust_info WHERE cst_lastname != TRIM(cst_lastname);

-- Update to remove spaces
START TRANSACTION;
UPDATE cust_info
SET 
  cst_firstname = TRIM(cst_firstname),
  cst_lastname = TRIM(cst_lastname)
WHERE 
  cst_firstname != TRIM(cst_firstname) 
  OR cst_lastname != TRIM(cst_lastname);
COMMIT;
ROLLBACK;

-- ============ CARDINALITY STANDARDIZATION ============
-- Normalize gender values
SELECT DISTINCT cst_gender FROM cust_info;
START TRANSACTION;
UPDATE cust_info
SET cst_gender = CASE 
  WHEN UPPER(cst_gender) = 'M' THEN 'Male'
  WHEN UPPER(cst_gender) = 'F' THEN 'Female'
  ELSE cst_gender
END
WHERE cst_gender IN ('M', 'F', 'm', 'f');
COMMIT;
ROLLBACK;

-- Normalize marital status
SELECT DISTINCT cst_martial_status FROM cust_info;
START TRANSACTION;
UPDATE cust_info
SET cst_martial_status = CASE 
  WHEN UPPER(cst_martial_status) = 'M' THEN 'Married'
  WHEN UPPER(cst_martial_status) = 'S' THEN 'Single'
  ELSE cst_martial_status
END
WHERE cst_martial_status IN ('M', 'S', 'm', 's');
COMMIT;
ROLLBACK;

-- ==============================
-- SILVER LAYER UPDATES - PRODUCT
-- ==============================

-- Find duplicate product IDs
SELECT prd_id, COUNT(*) FROM prd_info GROUP BY prd_id HAVING COUNT(*) > 1;

-- Add & update cat_id from prd_key, and refine prd_key itself
ALTER TABLE prd_info ADD COLUMN cat_id VARCHAR(50);
UPDATE prd_info
SET 
  cat_id = REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
  prd_key = SUBSTRING(prd_key, 7, LENGTH(prd_key));

SELECT * FROM prd_info;

-- Drop cat_id column after transformation if no longer needed
ALTER TABLE prd_info DROP COLUMN cat_id;

START TRANSACTION;
COMMIT;
ROLLBACK;

-- ==============================
-- SALES DETAILS FIXES
-- ==============================

-- Convert negative sales and price to positive
UPDATE sales_details
SET sls_sales = ABS(sls_sales);

UPDATE sales_details
SET sls_price = ABS(sls_price);
