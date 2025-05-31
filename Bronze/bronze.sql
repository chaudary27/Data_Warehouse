create database bronze;
use bronze;

create table cust_info(
cst_id int,
cst_key VARCHAR(25),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_martial_status VARCHAR(50),
cst_gender VARCHAR(50),
cst_create_date date
);

create table prd_info(
prd_id int,
prd_key VARCHAR(100),
prd_nm VARCHAR(100),
prd_cost float,
prd_line VARCHAR(10),
prd_start_date date,
prd_end_date date
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
sls_price int
);
create table CUST_AZ12(
CID VARCHAR(25),
BDATE DATE,
GEN VARCHAR(20)
);
create table LOC_A101(
CID varchar(25),
COUNTRY varchar(25)
);

create table PX_CAT_G1V2(
CID VARCHAR(25),
CAT VARCHAR(50),
SUBCAT VARCHAR(50),
MAINTENANCE VARCHAR(50)
);


drop table sales_details;
select count(*) from prd_info;
select count(*) from cust_info;
select count(*) from sales_details;
select count(*) from CUST_AZ12;
select count(*) from LOC_A101;
select count(*) from PX_CAT_G1V2;

