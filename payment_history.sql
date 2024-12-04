
-- 1) create database
CREATE DATABASE `lalco_lms1`;


-- 2) Export and Import 
-- ____________________ Export ____________________
  mysqldump -u Kham -p -h 18.140.117.112 --port 3306 --single-transaction --column-statistics=0 lalco tblcontract tblprospect tblpayment tblcollection tblcurrencyrate > D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1.sql
  
  password: Khaml@l#3Et#


-- ____________________ Import ____________________
  mysql -u kham -p -h 172.16.11.30 --port 3306 lalco_lms1 < D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1.sql
  
  password: Khm@431134



-- 3) create table sme_lock_down to keep 

CREATE TABLE `sme_lock_down` (
  `id` int NOT NULL AUTO_INCREMENT,
  `no` int NOT NULL,
  `times` int DEFAULT NULL,
  `contract_no` int DEFAULT NULL,
  `ncn` varchar(50) NOT NULL,
  `duration_month` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `contract_date` date DEFAULT NULL,
  `new_lastpayment_date` date DEFAULT NULL,
  `scenario` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `rank` varchar(255) DEFAULT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `input_date` varchar(255) DEFAULT NULL,
  `sale_staff_no` varchar(50) DEFAULT NULL,
  `sales_name` varchar(255) DEFAULT NULL,
  `contract_staff` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_new_lastpayment_date` (`new_lastpayment_date`)
) ENGINE=InnoDB AUTO_INCREMENT=31179 DEFAULT CHARSET=utf8mb3;



-- 4) create index

show index from sme_lock_down

create index idx_new_lastpayment_date on sme_lock_down(new_lastpayment_date);

create index idx_contract_no on sme_lock_down(contract_no);

create index idx_ncn on sme_lock_down(ncn);

create index idx_status on sme_lock_down(status);



-- 5) update the contract_no

update sme_lock_down sld inner join tblcontract c on (sld.ncn = c.ncn)
set sld.contract_no = c.contract_no ;










