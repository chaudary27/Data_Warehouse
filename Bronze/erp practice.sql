-- GENDER CHECK
select distinct GEN from cust_az12;

select * ,
case 
	when trim(GEN)='Male' then 'Male'
	when trim(GEN)='Female' then 'Female'
	when trim(GEN)='M' then 'Male'
    when trim(GEN)='F' then 'Female'
    else 'N/A'
    END AS GEN
from cust_az12;


select * , 
case 
	when CID LIKE 'NAS%' THEN substring(CID ,4, length(CID))
    ELSE CID
end as ID
from cust_az12;

SELECT * FROM px_cat_g1v2;


-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


SELECT * FROM loc_a101;
select distinct COUNTRY from loc_a101;
select 
replace(CID, '-','') AS CID,
case 
	when trim(COUNTRY) = 'DE' THEN 'Germany'
	when trim(COUNTRY) in ('US','USA') THEN 'United States'
	WHEN trim(COUNTRY) = '' or COUNTRY is NULL THEN 'N/A'
    ELSE TRIM(COUNTRY)
end AS COUNTRY
 from loc_a101;

select COUNTRY from loc_a101 where COUNTRY != trim(COUNTRY);

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

select * from px_cat_g1v2;

select SUBCAT from px_cat_g1v2 where SUBCAT != TRIM(SUBCAT);
select CAT from px_cat_g1v2 where CAT != TRIM(CAT);
select MAINTENANCE from px_cat_g1v2 where MAINTENANCE != TRIM(MAINTENANCE);

