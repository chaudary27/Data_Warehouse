
--                 CHECKING CUST_AZ12   
-- Step 1: View unique gender values to detect inconsistencies
SELECT DISTINCT GEN FROM cust_az12;

-- Step 2: Standardize gender values: 'M', 'F', 'Male ', etc. → 'Male', 'Female', or 'N/A'
SELECT *, 
    CASE 
        WHEN TRIM(GEN) IN ('Male', 'M') THEN 'Male'
        WHEN TRIM(GEN) IN ('Female', 'F') THEN 'Female'
        ELSE 'N/A'
    END AS standardized_GEN
FROM cust_az12;

-- Step 3: Remove 'NAS' prefix from CID to clean customer IDs
SELECT *, 
    CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))
        ELSE CID
    END AS cleaned_CID
FROM cust_az12;

-- /////////////////////////////////////////////////////////////////////////////////////////////////
--                 CHECKING LOC_A101
-- Step 1: View complete location data
SELECT * FROM loc_a101;

-- Step 2: Check unique country codes to identify standardization needs
SELECT DISTINCT COUNTRY FROM loc_a101;

-- Step 3: Check for extra spaces in country values
SELECT COUNTRY FROM loc_a101 WHERE COUNTRY != TRIM(COUNTRY);

-- Step 4: Standardize COUNTRY names and remove special characters from CID
SELECT 
    REPLACE(CID, '-', '') AS cleaned_CID,
    CASE 
        WHEN TRIM(COUNTRY) = 'DE' THEN 'Germany'
        WHEN TRIM(COUNTRY) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(COUNTRY) = '' OR COUNTRY IS NULL THEN 'N/A'
        ELSE TRIM(COUNTRY)
    END AS standardized_COUNTRY
FROM loc_a101;
   
-- /////////////////////////////////////////////////////////////////////////////////////////////////
--                 CHECKING px_cat_g1v2

-- Step 1: View full category dataset
SELECT * FROM px_cat_g1v2;

-- Step 2: Trim unwanted spaces from key columns: SUBCAT, CAT, MAINTENANCE
SELECT SUBCAT FROM px_cat_g1v2 WHERE SUBCAT != TRIM(SUBCAT);
SELECT CAT FROM px_cat_g1v2 WHERE CAT != TRIM(CAT);
SELECT MAINTENANCE FROM px_cat_g1v2 WHERE MAINTENANCE != TRIM(MAINTENANCE);
