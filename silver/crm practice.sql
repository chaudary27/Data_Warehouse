
select * from cust_info;

-- PRIMARY KEY UPDATE
select cst_id ,count(*) from cust_info group by cst_id having count(*)>1;

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

-- SPACING CHECK
select cst_firstname from cust_info where cst_firstname!=trim(cst_firstname);
select cst_lastname from cust_info where cst_lastname!= trim(cst_lastname);

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
  
-- CARDINALITY CHECK
select * from cust_info;

START TRANSACTION;
UPDATE cust_info
SET cst_gender = CASE 
    WHEN UPPER(cst_gender) = 'M' THEN 'Male'
    WHEN UPPER(cst_gender) = 'F' THEN 'Female'
    ELSE cst_gender  -- Preserve any existing valid values
END
WHERE cst_gender IN ('M', 'F', 'm', 'f'); 
COMMIT;
ROLLBACK;

-- CARDINALITY CHECK
select * from cust_info;

START TRANSACTION;
UPDATE cust_info
SET cst_martial_status = CASE 
    WHEN UPPER(cst_martial_status) = 'M' THEN 'Married'
    WHEN UPPER(cst_martial_status) = 'S' THEN 'Single'
    ELSE cst_martial_status  -- Preserve any existing valid values
END
WHERE cst_martial_status IN ('M', 'S', 'm', 's');
COMMIT;
ROLLBACK;

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

-- PRODUCT TABLE 
-- PRIMARY KEY CHECK
select prd_id , count(*) from prd_info group by prd_id having count(*)>1;


-- STANDARDIZATION
ALTER TABLE prd_info ADD COLUMN cat_id VARCHAR(50);
UPDATE prd_info
SET 
  cat_id = REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
  prd_key = SUBSTRING(prd_key, 7, LENGTH(prd_key));

select * from prd_info;

ALTER TABLE prd_info DROP COLUMN cat_id;



START TRANSACTION;
COMMIT;
ROLLBACK; 


UPDATE sales_details
SET sls_sales = ABS(sls_sales);

UPDATE sales_details
SET sls_price = ABS(sls_price);






