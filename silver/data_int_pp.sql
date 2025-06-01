use silver;
select * from cust_info;
select * from cust_az12;
select * from prd_info;
select * from sales_details;
select * from  px_cat_g1v2 ;
select * from loc_a101;

select
ci.cst_id ,
ci.cst_key ,
ci.cst_firstname ,
ci.cst_lastname, 
ci.cst_martial_status , 
ci.cst_gender ,
cu.GEN,
lc.COUNTRY,
ci.cst_create_date,
cu.BDATE
from cust_info ci
left join  cust_az12 cu on ci.cst_key=cu.CID
left join loc_a101 lc on ci.cst_key =lc.CID ;

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

select
ci.cst_id ,
ci.cst_key ,
ci.cst_firstname ,
ci.cst_lastname, 
ci.cst_martial_status , 
case 
	when ci.cst_gender != 'N/A' then ci.cst_gender
    else coalesce(CU.gen , 'N/A')
end AS Gender ,
lc.COUNTRY,
ci.cst_create_date,
cu.BDATE
from cust_info ci
left join  cust_az12 cu on ci.cst_key=cu.CID
left join loc_a101 lc on ci.cst_key =lc.CID ;
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
select
ci.cst_gender ,
cu.GEN,
case 
	when ci.cst_gender != 'N/A' then ci.cst_gender
    else coalesce(CU.gen , 'N/A')
end AS Gender

from cust_info ci
left join  cust_az12 cu on ci.cst_key=cu.CID
left join loc_a101 lc on ci.cst_key =lc.CID;
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


select
ci.cst_id as Customer_id,
ci.cst_key as Customer_number,
ci.cst_firstname as Customer_firstname,
ci.cst_lastname as Customer_lastname, 
ci.cst_martial_status as Customer_martial_status, 
case 
	when ci.cst_gender != 'N/A' then ci.cst_gender
    else coalesce(CU.gen , 'N/A')
end AS Customer_gender ,
lc.COUNTRY AS Customer_country,
cu.BDATE  AS Customer_birthdate,
ci.cst_create_date AS create_date
from cust_info ci
left join  cust_az12 cu on ci.cst_key=cu.CID
left join loc_a101 lc on ci.cst_key =lc.CID ;

-- SURROGATE KEY

select
row_number() over (order by ci.cst_id) as Customer_key,
ci.cst_id as Customer_id,
ci.cst_key as Customer_number,
ci.cst_firstname as Customer_firstname,
ci.cst_lastname as Customer_lastname, 
ci.cst_martial_status as Customer_martial_status, 
case 
	when ci.cst_gender != 'N/A' then ci.cst_gender
    else coalesce(CU.gen , 'N/A')
end AS Customer_gender ,
lc.COUNTRY AS Customer_country,
cu.BDATE  AS Customer_birthdate,
ci.cst_create_date AS create_date
from cust_info ci
left join  cust_az12 cu on ci.cst_key=cu.CID
left join loc_a101 lc on ci.cst_key =lc.CID ;
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

create view gold.dim_customers AS 
select
row_number() over (order by ci.cst_id) as Customer_key,
ci.cst_id as Customer_id,
ci.cst_key as Customer_number,
ci.cst_firstname as Customer_firstname,
ci.cst_lastname as Customer_lastname, 
ci.cst_martial_status as Customer_martial_status, 
case 
	when ci.cst_gender != 'N/A' then ci.cst_gender
    else coalesce(CU.gen , 'N/A')
end AS Customer_gender ,
lc.COUNTRY AS Customer_country,
cu.BDATE  AS Customer_birthdate,
ci.cst_create_date AS create_date
from cust_info ci
left join  cust_az12 cu on ci.cst_key=cu.CID
left join loc_a101 lc on ci.cst_key =lc.CID ;


select * FROM GOLD.dim_customers;
