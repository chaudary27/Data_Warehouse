select * from cust_info;
use bronze;

select cst_id ,count(*) from cust_info group by cst_id having count(*)>1;

select cst_firstname from cust_info where cst_firstname!=trim(cst_firstname);

select cst_lastname from cust_info where cst_lastname!= trim(cst_lastname);

SELECT DISTINCT cst_gender FROM cust_info;




select *, 
case
	when cst_gender ='M' then 'Male'
    when cst_gender ='F' then 'Female'
    else 'N/A'
    end as cst_gender
    FROM cust_info;
    
select *,
case 
	when cst_martial_status = 'M' then 'Married'
    when cst_martial_status = 'S' then 'Single'
    else 'N/A'
    end as cst_martial_status
from cust_info;


START TRANSACTION;
COMMIT;
ROLLBACK; 

SET SQL_SAFE_UPDATES = 0;



select * from prd_info;

select prd_id , count(*) from prd_info group by prd_id having count(*)>1;

-- NEAGTIVE VALUE CHECK
select prd_cost from prd_info where prd_cost <1 or prd_cost is null;
-- SPACING CHECK
select prd_nm from prd_info where prd_nm != trim(prd_nm);

-- STANDARDIZATION
select distinct prd_line from prd_info;
select *,
case 
	when upper(trim(prd_line) ='S') then 'Other Sales'
	when upper(trim(prd_line) ='M') then 'Mountain'
	when upper(trim(prd_line) ='R') then 'Roads'
	when upper(trim(prd_line) ='T') then 'Training'
    else 'N/A'
end as prd_line
from prd_info;
    
-- Time check
select * from prd_info where prd_start_date < prd_end_date;




select prd_id , 
prd_key  ,
replace (substring(prd_key ,1,5 ),'-','_') as cat_id,
substring(prd_key ,7,length(prd_key)  ) as prd_key,
prd_nm ,
prd_cost ,
prd_line ,
prd_start_date,
prd_end_date
from prd_info;

select * from prd_info;

START TRANSACTION;
COMMIT;
ROLLBACK; 

-- SALES DETAILS 
select * from sales_details
where sls_prd_key not in (select prd_key from prd_info)
;

select * from prd_info;

select * from sales_details;

-- Spacing 

select * from sales_details where sls_ord_num != trim(sls_ord_num);



select * from sales_details where sls_quantity <0 or  sls_quantity  is null; 

select * from sales_details where  sls_sales <0 or  sls_sales   is null; 

select * from sales_details where sls_price <0 or sls_price   is null; 


-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\






