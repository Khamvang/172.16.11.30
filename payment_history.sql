
-- 1) create database
CREATE DATABASE `lalco_lms1`;


-- 2) Export and Import 
-- ____________________ Export ____________________
  mysqldump -u Kham -p -h 18.140.117.112 --port 3306 --single-transaction --column-statistics=0 lalco tblcontract tblprospect tblpayment tblcollection tblcurrencyrate > D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1.sql
  
  password: Khaml@l#3Et#


-- ____________________ Import ____________________
  mysql -u kham -p -h 172.16.11.30 --port 3306 lalco_lms1 < D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1.sql
  
  password: Khm@431134



-- 3) 



