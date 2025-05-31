-- Standardizing gender and cleaning CID (removing 'NAS' prefix)

SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

UPDATE cust_az12
SET 
    GEN = CASE 
        WHEN TRIM(GEN) IN ('Male', 'M') THEN 'Male'
        WHEN TRIM(GEN) IN ('Female', 'F') THEN 'Female'
        ELSE 'N/A'
    END,
    CID = CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))
        ELSE CID
    END;

COMMIT;
-- ROLLBACK; -- Uncomment to revert if needed





-- Standardizing COUNTRY and removing '-' from CID

SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

UPDATE loc_a101
SET 
    COUNTRY = CASE 
        WHEN TRIM(COUNTRY) = 'DE' THEN 'Germany'
        WHEN TRIM(COUNTRY) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(COUNTRY) = '' OR COUNTRY IS NULL THEN 'N/A'
        ELSE TRIM(COUNTRY)
    END,
    CID = REPLACE(CID, '-', '');

COMMIT;
-- ROLLBACK; -- Uncomment to undo changes if required



-- Check if any GEN values are still invalid
SELECT DISTINCT GEN FROM cust_az12;

-- Check if any CID values still contain 'NAS'
SELECT * FROM cust_az12 WHERE CID LIKE 'NAS%';

-- Check if any COUNTRY values are still raw
SELECT DISTINCT COUNTRY FROM loc_a101;
