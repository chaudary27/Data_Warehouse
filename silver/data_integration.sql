-- Switch to the Silver layer database
USE silver;

-- Preview of all tables involved in the dimension building
SELECT * FROM cust_info;
SELECT * FROM cust_az12;
SELECT * FROM prd_info;
SELECT * FROM sales_details;
SELECT * FROM px_cat_g1v2;
SELECT * FROM loc_a101;

-- =====================================================
-- Step 1: Combine customer data with demographic and location data
-- This will help enrich the Silver Layer customer information
-- =====================================================
SELECT
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_martial_status,
    ci.cst_gender,
    cu.GEN,
    lc.COUNTRY,
    ci.cst_create_date,
    cu.BDATE
FROM cust_info ci
LEFT JOIN cust_az12 cu ON ci.cst_key = cu.CID
LEFT JOIN loc_a101 lc ON ci.cst_key = lc.CID;

-- =====================================================
-- Step 2: Gender logic enhancement
-- Use existing gender if present, else use GEN from ERP table (cust_az12)
-- =====================================================
SELECT
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_martial_status,
    CASE 
        WHEN ci.cst_gender != 'N/A' THEN ci.cst_gender
        ELSE COALESCE(cu.GEN, 'N/A')
    END AS Gender,
    lc.COUNTRY,
    ci.cst_create_date,
    cu.BDATE
FROM cust_info ci
LEFT JOIN cust_az12 cu ON ci.cst_key = cu.CID
LEFT JOIN loc_a101 lc ON ci.cst_key = lc.CID;

-- =====================================================
-- Step 3: Preview only gender logic check for validation
-- =====================================================
SELECT
    ci.cst_gender,
    cu.GEN,
    CASE 
        WHEN ci.cst_gender != 'N/A' THEN ci.cst_gender
        ELSE COALESCE(cu.GEN, 'N/A')
    END AS Gender
FROM cust_info ci
LEFT JOIN cust_az12 cu ON ci.cst_key = cu.CID
LEFT JOIN loc_a101 lc ON ci.cst_key = lc.CID;

-- =====================================================
-- Step 4: Final Customer Dimension Structure for Gold Layer
-- With Aliases to standardize business terminology
-- =====================================================
SELECT
    ci.cst_id AS Customer_id,
    ci.cst_key AS Customer_number,
    ci.cst_firstname AS Customer_firstname,
    ci.cst_lastname AS Customer_lastname,
    ci.cst_martial_status AS Customer_martial_status,
    CASE 
        WHEN ci.cst_gender != 'N/A' THEN ci.cst_gender
        ELSE COALESCE(cu.GEN, 'N/A')
    END AS Customer_gender,
    lc.COUNTRY AS Customer_country,
    cu.BDATE AS Customer_birthdate,
    ci.cst_create_date AS create_date
FROM cust_info ci
LEFT JOIN cust_az12 cu ON ci.cst_key = cu.CID
LEFT JOIN loc_a101 lc ON ci.cst_key = lc.CID;

-- =====================================================
-- Step 5: Add Surrogate Key using ROW_NUMBER for Data Warehouse compliance
-- =====================================================
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS Customer_key,
    ci.cst_id AS Customer_id,
    ci.cst_key AS Customer_number,
    ci.cst_firstname AS Customer_firstname,
    ci.cst_lastname AS Customer_lastname,
    ci.cst_martial_status AS Customer_martial_status,
    CASE 
        WHEN ci.cst_gender != 'N/A' THEN ci.cst_gender
        ELSE COALESCE(cu.GEN, 'N/A')
    END AS Customer_gender,
    lc.COUNTRY AS Customer_country,
    cu.BDATE AS Customer_birthdate,
    ci.cst_create_date AS create_date
FROM cust_info ci
LEFT JOIN cust_az12 cu ON ci.cst_key = cu.CID
LEFT JOIN loc_a101 lc ON ci.cst_key = lc.CID;

-- =====================================================
-- Step 6: Create Gold Layer View for Dimensional Modeling (Star Schema)
-- This becomes dim_customers in the Gold Layer
-- =====================================================
CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS Customer_key,
    ci.cst_id AS Customer_id,
    ci.cst_key AS Customer_number,
    ci.cst_firstname AS Customer_firstname,
    ci.cst_lastname AS Customer_lastname,
    ci.cst_martial_status AS Customer_martial_status,
    CASE 
        WHEN ci.cst_gender != 'N/A' THEN ci.cst_gender
        ELSE COALESCE(cu.GEN, 'N/A')
    END AS Customer_gender,
    lc.COUNTRY AS Customer_country,
    cu.BDATE AS Customer_birthdate,
    ci.cst_create_date AS create_date
FROM cust_info ci
LEFT JOIN cust_az12 cu ON ci.cst_key = cu.CID
LEFT JOIN loc_a101 lc ON ci.cst_key = lc.CID;

-- =====================================================
-- Step 7: Final check of the View created in Gold Layer
-- =====================================================
SELECT * FROM gold.dim_customers;
