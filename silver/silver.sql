create database silver;
use silver;
drop database silver;
create table cust_info(
cst_id int,
cst_key VARCHAR(25),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_martial_status VARCHAR(50),
cst_gender VARCHAR(50),
cst_create_date date,
dwh_create_date datetime default now()
);

create table prd_info(
prd_id int,
prd_key VARCHAR(100),
prd_nm VARCHAR(100),
prd_cost float,
prd_line VARCHAR(10),
prd_start_date date,
prd_end_date date,
dwh_create_date datetime default now()
);

create table sales_details(
sls_ord_num varchar(25),
sls_prd_key varchar(25),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime default now()
);
create table CUST_AZ12(
CID VARCHAR(25),
BDATE DATE,
GEN VARCHAR(20),
dwh_create_date datetime default now()
);
create table LOC_A101(
CID varchar(25),
COUNTRY varchar(25),
dwh_create_date datetime default now()
);

create table PX_CAT_G1V2(
ID VARCHAR(25),
CAT VARCHAR(50),
SUBCAT VARCHAR(50),
MAINTENANCE VARCHAR(50),
dwh_create_date datetime default now()
);


drop table sales_details;
select count(*) from prd_info;
select count(*) from cust_info;
select count(*) from sales_details;
select * from CUST_AZ12
px_cat_g1v2;
select count(*) from LOC_A101;
select count(*) from PX_CAT_G1V2;

