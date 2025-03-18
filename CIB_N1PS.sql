-- 1) Create database and table

create database cib_realestate character set utf8mb4 collate utf8mb4_general_ci;


create table `cib_realestate.tbla1` (
	`id` int(11) not null auto_increment ,
	`date_report` date not null ,
	`contract_no` int(11) not null ,
	`bank_customer_ID` varchar(255) default null,
	`branch_ID_code` varchar(255) default null,
	`group_ID` varchar(255) default null,
	`head_of_group` varchar(255) default null,
	`national_ID` varchar(255) default null,
	`national_ID_expiry_date` varchar(255) default null,
	`passport_number` varchar(255) default null,
	`passport_expiry_date` varchar(255) default null,
	`familybook` varchar(255) default null,
	`family_province_code_if_issue` varchar(255) default null,
	`family_issue_date` varchar(255) default null,
	`birthdate` varchar(255) default null,
	`1st_name_(english)` varchar(255) default null,
	`2nd_name_(english)` varchar(255) default null,
	`surname_(english)` varchar(255) default null,
	`1st_name_(lao)` varchar(255) default null,
	`surname_(lao)` varchar(255) default null,
	`old _surname_(english)` varchar(255) default null,
	`old_surname_(lao)` varchar(255) default null,
	`nationality` varchar(255) default null,
	`gender` varchar(255) default null,
	`civil_status` varchar(255) default null,
	`spouse_1st_(english)` varchar(255) default null,
	`spouse_2nd_(english)` varchar(255) default null,
	`spouse_surname_(english)` varchar(255) default null,
	`spouse_1st_(lao)` varchar(255) default null,
	`spouse_surname_(lao)` varchar(255) default null,
	`datetime_updated` varchar(255) default null,
	primary key (`id`)
)ENGINE=InnoDB auto_increment=1 default CHARSET = utf8mb4 collate utf8mb4_general_ci;


create table `cib_realestate.tbla4` (
	`id` int(11) not null auto_increment ,
	`date_report` date not null ,
	`contract_no` int(11) not null ,
	`bank_customer_ID` varchar(255) not null,
	`branch_ID_code` varchar(255) default null,
	`address_number_and_street_(english)` varchar(255) default null,
	`address_village_(english)` varchar(255) default null,
	`address_district_(english)` varchar(255) default null,
	`address_number_and_street_(lao)` varchar(255) default null,
	`address_village_(lao)` varchar(255) default null,
	`address_district_(lao)` varchar(255) default null,
	`address_province_code` varchar(255) default null,
	`datetime_updated` varchar(255) default null,
	primary key (`id`)
)ENGINE=InnoDB auto_increment=1 default CHARSET = utf8mb4 collate utf8mb4_general_ci;


create table `cib_realestate.tbla5` (
	`id` int(11) not null auto_increment ,
	`date_report` date not null ,
	`contract_no` int(11) not null ,
	`bank_customer_ID` varchar(255) not null,
	`branch_ID_code` varchar(255) default null,
	`telephone_no` varchar(255) default null,
	`mobile_no` varchar(255) default null,
	`fax` varchar(255) default null,
	`datetime_updated` varchar(255) default null,
	primary key (`id`)
)ENGINE=InnoDB auto_increment=1 default CHARSET = utf8mb4 collate utf8mb4_general_ci;


create table `cib_realestate.tblb1` (
	`id` int(11) not null auto_increment ,
	`date_report` date not null ,
	`contract_no` int(11) not null ,
	`bank_customer_ID` varchar(255) not null,
	`branch_ID_code` varchar(255) not null,
	`loan_ID` varchar(255) not null,
	`open_date` varchar(255) not null,
	`expiry_date` varchar(255) default null,
	`extension_date` varchar(255) default null,
	`interest_rate` decimal(20,2) not null,
	`purpose_code` varchar(255) not null,
	`amount_of_loan` decimal(20,2) not null,
	`currency_code` varchar(255) not null,
	`outstanding_balance` decimal(20,2) not null,
	`loan_account_number` varchar(255) default null,
	`number_of_days_slow` int(11) not null,
	`loan_class` varchar(255) not null,
	`loan_type` varchar(255) not null,
	`loan_term` varchar(255) not null,
	`loan_status` varchar(255) not null,
	`date_time_updated` varchar(255) not null,
	primary key (`id`)
)ENGINE=InnoDB auto_increment=1 default CHARSET = utf8mb4 collate utf8mb4_general_ci;


create table `cib_realestate.tblc1` (
	`id` int(11) not null auto_increment ,
	`date_report` date not null ,
	`contract_no` int(11) not null ,
	`bank_customer_ID` varchar(255) default null,
	`branch_ID_code` varchar(255) default null,
	`loan_ID` varchar(255) default null,
	`collateral_ID` varchar(255) default null,
	`owner_gender` varchar(255) default null,
	`owner_1st_name_(english)` varchar(255) default null,
	`owner 2nd_name_(english)` varchar(255) default null,
	`owner_surname_(english)` varchar(255) default null,
	`owner_1st_name_(lao)` varchar(255) default null,
	`owner_surname_(lao)` varchar(255) default null,
	`collateral_type` varchar(255) default null,
	`collateral_value`  decimal(20,2) not null,
	`currency_code` varchar(255) default null,
	`collateral_status` varchar(255) default null,
	`date_time_updated` varchar(255) default null,
	primary key (`id`)
)ENGINE=InnoDB auto_increment=1 default CHARSET = utf8mb4 collate utf8mb4_general_ci;


create table cib_realestate.`tblc2.1` (
	`id` int(11) not null auto_increment ,
	`date_report` date not null ,
	`contract_no` int(11) not null ,
	`bank_customer_ID` varchar(255) default null,
	`branch_ID_code` varchar(255) default null,
	`loan_ID` varchar(255) default null,
	`collateral_ID` varchar(255) default null,
	`value` decimal(20,2) not null,
	`land_number` varchar(255) default null,
	`land_size` varchar(255) default null,
	`land_unit` varchar(255) default null,
	`land_mapcode` varchar(255) default null,
	`land_title_date` varchar(255) default null,
	`location_number_and_street_(english)` varchar(255) default null,
	`location_village_(english)` varchar(255) default null,
	`location_distrcit_(english)` varchar(255) default null,
	`location_number_and_street_(lao)` varchar(255) default null,
	`location_village_(lao)` varchar(255) default null,
	`location_distrcit_(lao)` varchar(255) default null,
	`location_province_code`varchar(255) default null,
	primary key (`id`)
)ENGINE=InnoDB auto_increment=1 default CHARSET = utf8mb4 collate utf8mb4_general_ci;


-- 2) Export data from LALCO
# check and export the contract numbers
select c.contract_no , from_unixtime(c.disbursed_datetime, '%Y-%m-%d') 'disbursed_date' 
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
where p.contract_type in (5) and c.status in (4,6,7) and from_unixtime(c.disbursed_datetime, '%Y-%m-%d') between '2023-01-01' and '2025-02-28';


#CIB A1 as table

-- insert A1 the old data from last month report 
insert into cib_realestate.tbla1 (`date_report`,`contract_no`,`bank_customer_ID`,`branch_ID_code`,`group_ID`,`head_of_group`,`national_ID`,`national_ID_expiry_date`,`passport_number`,`passport_expiry_date`,`familybook`,`family_province_code_if_issue`,`family_issue_date`,`birthdate`,`1st_name_(english)`,`2nd_name_(english)`,`surname_(english)`,`1st_name_(lao)`,`surname_(lao)`,`old _surname_(english)`,`old_surname_(lao)`,`nationality`,`gender`,`civil_status`,`spouse_1st_(english)`,`spouse_2nd_(english)`,`spouse_surname_(english)`,`spouse_1st_(lao)`,`spouse_surname_(lao)`,`datetime_updated`)
select '2025-02-28',`contract_no`,`bank_customer_ID`,`branch_ID_code`,`group_ID`,`head_of_group`,`national_ID`,`national_ID_expiry_date`,`passport_number`,`passport_expiry_date`,`familybook`,`family_province_code_if_issue`,`family_issue_date`,`birthdate`,`1st_name_(english)`,`2nd_name_(english)`,`surname_(english)`,`1st_name_(lao)`,`surname_(lao)`,`old _surname_(english)`,`old_surname_(lao)`,`nationality`,`gender`,`civil_status`,`spouse_1st_(english)`,`spouse_2nd_(english)`,`spouse_surname_(english)`,`spouse_1st_(lao)`,`spouse_surname_(lao)`,`datetime_updated`
from cib_realestate.tbla1 where date_report = '2025-01-31'
	AND contract_no NOT IN (SELECT contract_no FROM cib_realestate.tbla1 WHERE date_report = '2025-02-28' ) ;


-- insert A1 new data from LALCO live server
SELECT DISTINCT 
	dr.`date` `date_report`,
	c.contract_no ,
	cu.id  `bank_customer_ID`,
	CASE p.call_centre WHEN 1 THEN '01' ELSE '01' END `branch_ID_code`,
	'' `group_ID`,
	'' `head_of_group`,
	'' `national_ID`,
	'' `national_ID_expiry_date`,
	'' `passport_number`,
	'' `passport_expiry_date`,
	CASE WHEN cu.identifier_id = '' THEN 000 
		ELSE convert(cast(convert(cu.identifier_id using latin1) as binary) using utf8)
	END `familybook`,
	CASE
		cu.address_province WHEN 1 THEN 'ATP' -- ATTAPEU
		WHEN 2 THEN 'BK' -- BORKEO
		WHEN 3 THEN 'BKX' -- BORLIKHAMXAY
		WHEN 4 THEN 'CPS' -- CHAMPASACK
		WHEN 5 THEN 'HP' -- HOUAPHAN
		WHEN 6 THEN 'KM' -- KHAMMOUANE
		WHEN 7 THEN 'LNT' -- LUANGNAMTHA
		WHEN 8 THEN 'LPB' -- LUANGPRABANG
		WHEN 9 THEN 'ODX' -- OUDOMXAY
		WHEN 10 THEN 'PSL' -- PHONGSALY
		WHEN 11 THEN 'SLV' -- SALAVAN
		WHEN 12 THEN 'SV' -- SAVANNAKHET
		WHEN 13 THEN 'NKL' -- VIENTIANE CAPITAL
		WHEN 14 THEN 'VT' -- VIENTIANE PROVINCE
		WHEN 15 THEN 'XYL' -- XAYABOULY
		WHEN 16 THEN 'XSB' -- XAYSOMBOUN
		WHEN 17 THEN 'SK' -- SEKONG
		WHEN 18 THEN 'XKH' -- XIENGKHUANG
		ELSE ''
	END `family_province_code_if_issue`,
	CASE WHEN DATE_FORMAT(cu.family_book_issue_date,'%d/%m/%Y') = '00/00/0000' THEN '01/01/1970' 
		ELSE DATE_FORMAT(cu.family_book_issue_date,'%d/%m/%Y')
	END `family_issue_date`,
	DATE_FORMAT(cu.date_of_birth, '%d/%m/%Y') `birthdate`,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en) using latin1) as binary) using utf8) `1st_name_(english)`,
	'' `2nd_name_(english)`,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_last_name_en ) using latin1) as binary) using utf8) `surname_(english)`,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo) using latin1) as binary) using utf8) `1st_name_(lao)`,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_last_name_lo) using latin1) as binary) using utf8) `surname_(lao)`,
	'' `old _surname_(english)`,
	'' `old_surname_(lao)`,
	CASE p.call_centre WHEN 1 THEN 'LA' ELSE 'LA' END 'nationality',
	CASE  WHEN cu.gender = 'Male' THEN 'M' WHEN cu.gender = 'Female' THEN 'F' ELSE '' END `gender`,
	CASE  WHEN cu.marital_status = 'Married' THEN 'M' WHEN cu.marital_status = 'Single' THEN 'S' ELSE '' END `civil_status`,
	'' `spouse_1st_(english)`,
	'' `spouse_2nd_(english)`,
	'' `spouse_surname_(english)`,
	'' `spouse_1st_(lao)`,
	'' `spouse_surname_(lao)`,
	FROM_UNIXTIME(c.date_updated , '%d/%m/%Y %H:%m:%S') `datetime_updated`
FROM  tblcustomer cu
RIGHT JOIN tblprospect p ON (p.customer_id = cu.id)
RIGHT JOIN tblcontract c ON (c.prospect_id = p.id)
LEFT JOIN tbldailyreport dr ON  (dr.contract_id = c.id)
where p.contract_type = 5 and p.status = 3 AND c.status in (4,6,7) AND dr.`date` = '2025-02-28' 
	-- and c.contract_no in ()
ORDER BY c.contract_no ;


#CIB A4 as table 

-- insert A4 the old data from last month report 
insert into cib_realestate.tbla4 (`date_report`,`contract_no`,`bank_customer_ID`,`branch_ID_code`,`address_number_and_street_(english)`,`address_village_(english)`,`address_district_(english)`,`address_number_and_street_(lao)`,`address_village_(lao)`,`address_district_(lao)`,`address_province_code`,`datetime_updated`)
select '2025-02-28',`contract_no`,`bank_customer_ID`,`branch_ID_code`,`address_number_and_street_(english)`,`address_village_(english)`,`address_district_(english)`,`address_number_and_street_(lao)`,`address_village_(lao)`,`address_district_(lao)`,`address_province_code`,`datetime_updated`
from cib_realestate.tbla4 where date_report = '2025-01-31'
	AND contract_no NOT IN (SELECT contract_no FROM cib_realestate.tbla4 WHERE date_report = '2025-02-28' ) ;


-- insert A4 the old data from LALCO live server
SELECT DISTINCT 
	dr.`date` `date_report`,
	c.contract_no ,
	cu.id  `bank_customer_ID`,
	CASE p.call_centre WHEN 1 THEN '01' ELSE '01' END `branch_ID_code`,
	CASE WHEN cu.address_village_id != 0 THEN CONVERT(CAST(CONVERT(v.village_name using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END `address_number_and_street_(english)`,
	CASE WHEN cu.address_village_id != 0 THEN CONVERT(CAST(CONVERT(v.village_name using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END `address_village_(english)`,
	ci.city_name  `address_district_(english)`,
	CASE WHEN cu.address_village_id != 0 THEN CONVERT(CAST(CONVERT(v.village_name_lao using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END `address_number_and_street_(lao)`,
	CASE WHEN cu.address_village_id != 0 THEN CONVERT(CAST(CONVERT(v.village_name_lao using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END `address_village_(lao)`,
	convert(cast(convert(ci.city_name_lao using latin1) as binary) using utf8) `address_district_(lao)`,
	CASE cu.address_province WHEN 1 THEN 'ATP' -- ATTAPEU
		WHEN 2 THEN 'BK' -- BORKEO
		WHEN 3 THEN 'BKX' -- BORLIKHAMXAY
		WHEN 4 THEN 'CPS' -- CHAMPASACK
		WHEN 5 THEN 'HP' -- HOUAPHAN
		WHEN 6 THEN 'KM' -- KHAMMOUANE
		WHEN 7 THEN 'LNT' -- LUANGNAMTHA
		WHEN 8 THEN 'LPB' -- LUANGPRABANG
		WHEN 9 THEN 'ODX' -- OUDOMXAY
		WHEN 10 THEN 'PSL' -- PHONGSALY
		WHEN 11 THEN 'SLV' -- SALAVAN
		WHEN 12 THEN 'SV' -- SAVANNAKHET
		WHEN 13 THEN 'NKL' -- VIENTIANE CAPITAL
		WHEN 14 THEN 'VT' -- VIENTIANE PROVINCE
		WHEN 15 THEN 'XYL' -- XAYABOULY
		WHEN 16 THEN 'XSB' -- XAYSOMBOUN
		WHEN 17 THEN 'SK' -- SEKONG
		WHEN 18 THEN 'XKH' -- XIENGKHUANG
		ELSE ''
	END `address_province_code`,
	FROM_UNIXTIME(c.date_updated, '%d/%m/%Y %H:%m:%S') `datetime_updated`
FROM tblcustomer cu
RIGHT JOIN tblprospect p ON (p.customer_id = cu.id)
RIGHT JOIN tblcontract c ON (c.prospect_id = p.id)
left join tblcity ci on (ci.id = cu.address_city)
left join tblvillage v on (v.id = cu.address_village_id)
LEFT JOIN tbldailyreport dr ON  (dr.contract_id = c.id)
where p.contract_type = 5 and p.status = 3 AND c.status in (4,6,7) AND dr.`date` = '2025-02-28'
	-- and c.contract_no in ()
ORDER BY c.contract_no ;



#CIB A5 as table (Ready to export)

-- insert A5 the old data from last month report 
insert into cib_realestate.tbla5 (`date_report`,`contract_no`,`bank_customer_ID`,`branch_ID_code`,`telephone_no`,`mobile_no`,`fax`,`datetime_updated`)
select '2025-02-28',`contract_no`,`bank_customer_ID`,`branch_ID_code`,`telephone_no`,`mobile_no`,`fax`,`datetime_updated`
from cib_realestate.tbla5 where date_report = '2025-01-31'
	AND contract_no NOT IN (SELECT contract_no FROM cib_realestate.tbla5 WHERE date_report = '2025-02-28' ) ;


-- insert A5 the old data from LALCO live server
SELECT DISTINCT 
	dr.`date` `date_report`,
	c.contract_no ,
	cu.id  `bank_customer_ID`,
	CASE p.call_centre WHEN 1 THEN '01' ELSE '01' END `branch_ID_code`,
	CASE WHEN cu.main_contact_no = '' or cu.main_contact_no = 0 THEN '020'
		ELSE cu.main_contact_no
	END `telephone_no`,
	CASE WHEN cu.sec_contact_no = '' or  cu.sec_contact_no = 0 THEN cu.main_contact_no
		ELSE cu.sec_contact_no
	END `mobile_no`,
	'' `fax`,
	FROM_UNIXTIME(c.date_updated, '%d/%m/%Y %H:%m:%S') `datetime_updated`
FROM  tblcustomer cu
RIGHT JOIN tblprospect p ON (p.customer_id = cu.id)
RIGHT JOIN tblcontract c ON (c.prospect_id = p.id)
LEFT JOIN tbldailyreport dr ON  (dr.contract_id = c.id)
where p.contract_type = 5 and p.status = 3 AND c.status in (4,6,7) AND dr.`date` = '2025-02-28'
	-- and c.contract_no in ()
ORDER BY c.contract_no ;



#CIB B1 as table

-- insert B1 the old data from LALCO live server
SELECT 
	dr.`date` `date_report`,
	c.contract_no ,
	cu.id `bank_customer_ID`,
	CASE p.call_centre WHEN 1 THEN '01' ELSE '01' END `branch_ID_code`,
	c.contract_no `loan_ID`,
	CASE WHEN DATE_FORMAT(c.contract_date, '%d/%m/%Y') = '00/00/0000' THEN '01/01/1970'
		ELSE DATE_FORMAT(c.contract_date, '%d/%m/%Y')
	END `open_date`, 
	CASE WHEN DATE_FORMAT(p.last_payment_date, '%d/%m/%Y') = '00/00/0000' THEN '01/01/1970' 
		ELSE DATE_FORMAT(p.last_payment_date, '%d/%m/%Y')
	END `expiry_date`,
	'' `extension_date`,
	p.monthly_interest /100 `interest_rate`,
	'CL' `purpose_code`,
	p.loan_amount `amount_of_loan`,
	p.trading_currency `currency_code`,
	case when c.contract_no in (2051043) then 0 else dr.total_principal_outstanding end `outstanding_balance`,
	'' `loan_account_number`,
	case when c.contract_no in (2051043) then 0 else dr.days_due end `number_of_days_slow`,
	CASE when c.contract_no in (2051043) then 'A'
		WHEN dr.days_due BETWEEN 0 AND 30 THEN 'A'
		WHEN dr.days_due BETWEEN 31 AND 60 THEN 'B'
		WHEN dr.days_due BETWEEN 61 AND 90 THEN 'C'
		WHEN dr.days_due BETWEEN 91 AND 180 THEN 'D'
		ELSE 'E'
	END `loan_class`,
	'CL' `loan_type`,
	CASE WHEN p.no_of_payment BETWEEN 0 AND 12 THEN 'ST'
		WHEN p.no_of_payment BETWEEN 13 AND 60 THEN 'MT'
		ELSE 'LT'
	END `loan_term`,
	case when c.contract_no in (2051043) then 'INACTIVE' 
		when dr.contract_status = 4 then 'ACTIVE' when dr.contract_status in (6,7) then 'INACTIVE' else 'INACTIVE' 
	END `loan_status`,
	DATE_FORMAT(dr.`date`, '%d/%m/%Y %H:%m:%s') `date_time_updated` 
FROM  tblcustomer cu
RIGHT JOIN tblprospect p ON  (p.customer_id = cu.id)
RIGHT JOIN tblcontract c ON  (c.prospect_id = p.id)
LEFT JOIN tbldailyreport dr ON  (dr.contract_id = c.id)
where p.contract_type = 5 and p.status = 3 AND c.status in (4,6,7) AND dr.`date` = '2025-02-28'
-- 	and c.contract_no in ()
ORDER BY c.contract_no ;

-- ___________________________________ B1 if not data in table daily report _______________________________________
-- insert B1 the old data from LALCO live server
SELECT 
	'2025-02-28' `date_report`,
	c.contract_no ,
	cu.id `bank_customer_ID`,
	CASE p.call_centre WHEN 1 THEN '01' ELSE '01' END `branch_ID_code`,
	c.contract_no `loan_ID`,
	CASE WHEN DATE_FORMAT(c.contract_date, '%d/%m/%Y') = '00/00/0000' THEN '01/01/1970'
		ELSE DATE_FORMAT(c.contract_date, '%d/%m/%Y')
	END `open_date`, 
	CASE WHEN DATE_FORMAT(p.last_payment_date, '%d/%m/%Y') = '00/00/0000' THEN '01/01/1970' 
		ELSE DATE_FORMAT(p.last_payment_date, '%d/%m/%Y')
	END `expiry_date`,
	'' `extension_date`,
	p.monthly_interest /100 `interest_rate`,
	'CL' `purpose_code`,
	p.loan_amount `amount_of_loan`,
	p.trading_currency `currency_code`,
	case when c.contract_no in (2051043) then 0 else po.principal_outstanding end `outstanding_balance`,
	'' `loan_account_number`,
	case when c.contract_no in (2051043) then 0 
		WHEN c.status in (6,7) THEN 0 WHEN p.first_payment_date >= '2025-02-28' THEN 0 
		WHEN c.status = 4 and DATEDIFF('2025-02-28', date_add(ps.payment_date, interval + 1 month) ) + 1 <=0 then 0
		WHEN c.status = 4 THEN DATEDIFF('2025-02-28', case when ps.payment_date is null then p.first_payment_date else date_add(ps.payment_date, interval + 1 month) end) + 1
	end `number_of_days_slow`,
	CASE when c.contract_no in (2051043) then 'A'
		WHEN c.status in (6,7) THEN 'A'
		WHEN p.first_payment_date >= '2025-02-28' THEN 'A'
		WHEN c.status = 4 and DATEDIFF('2025-02-28', case when ps.payment_date is null then p.first_payment_date else date_add(ps.payment_date, interval + 1 month) end) + 1 BETWEEN 0 AND 30 THEN 'A'
		WHEN c.status = 4 and DATEDIFF('2025-02-28', case when ps.payment_date is null then p.first_payment_date else date_add(ps.payment_date, interval + 1 month) end) + 1 BETWEEN 31 AND 60 THEN 'B'
		WHEN c.status = 4 and DATEDIFF('2025-02-28', case when ps.payment_date is null then p.first_payment_date else date_add(ps.payment_date, interval + 1 month) end) + 1 BETWEEN 61 AND 90 THEN 'C'
		WHEN c.status = 4 and DATEDIFF('2025-02-28', case when ps.payment_date is null then p.first_payment_date else date_add(ps.payment_date, interval + 1 month) end) + 1 BETWEEN 91 AND 180 THEN 'D'
		ELSE 'E'
	END `loan_class`,
	'CL' `loan_type`,
	CASE WHEN p.no_of_payment BETWEEN 0 AND 12 THEN 'ST'
		WHEN p.no_of_payment BETWEEN 13 AND 60 THEN 'MT'
		ELSE 'LT'
	END `loan_term`,
	case when c.contract_no in (2051043) then 'INACTIVE' 
		when c.status = 4 then 'ACTIVE' when c.status in (6,7) then 'INACTIVE' else 'INACTIVE' 
	END `loan_status`,
	DATE_FORMAT('2025-02-28', '%d/%m/%Y %H:%m:%s') `date_time_updated` 
FROM  tblcustomer cu
RIGHT JOIN tblprospect p ON  (p.customer_id = cu.id)
RIGHT JOIN tblcontract c ON  (c.prospect_id = p.id)
left join (select c.contract_no, SUM(CASE WHEN pm.`type` = 'principal' THEN pm.amount - pm.paid_amount - (pm.refinance_amount + pm.void_amount) END) 'principal_outstanding'
	from tblcontract c left join tblpayment pm on (pm.contract_id = c.id) group by c.contract_no ) po on (po.contract_no = c.contract_no)
LEFT JOIN tblpaymentschedule ps ON ps.id = (SELECT id FROM tblpaymentschedule WHERE status = 1 and payment_amount !=0 and contract_id = c.id ORDER BY payment_date DESC LIMIT 1)
where p.contract_type = 5 and p.status = 3 AND c.status in (4,6,7)
  and c.contract_no in ()
ORDER BY c.contract_no ; 

#C1 as table

-- insert C1 the old data from last month report 
insert into cib_realestate.tblc1 (`date_report`,`contract_no`,`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`collateral_ID`,`owner_gender`,`owner_1st_name_(english)`,`owner 2nd_name_(english)`,`owner_surname_(english)`,`owner_1st_name_(lao)`,`owner_surname_(lao)`,`collateral_type`,`collateral_value`,`currency_code`,`collateral_status`,`date_time_updated`)
select '2025-02-28',`contract_no`,`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`collateral_ID`,`owner_gender`,`owner_1st_name_(english)`,`owner 2nd_name_(english)`,`owner_surname_(english)`,`owner_1st_name_(lao)`,`owner_surname_(lao)`,`collateral_type`,`collateral_value`,`currency_code`,`collateral_status`,`date_time_updated`
from cib_realestate.tblc1 where date_report = '2025-01-31'
	AND contract_no NOT IN (SELECT contract_no FROM cib_realestate.tblc1 WHERE date_report = '2025-02-28' ) ;


-- insert C1 the old data from LALCO live server
SELECT 
	dr.`date` `date_report`,
	c.contract_no ,
	cu.id  `bank_customer_ID`,
	CASE p.call_centre WHEN 1 THEN '01' ELSE '01' END `branch_ID_code`,
	c.contract_no `loan_ID`,
	av.id `collateral_ID`,
	'M' `owner_gender`,
	'CHANNAKHONE' `owner_1st_name_(english)`,
	'' `owner 2nd_name_(english)`,
	'PHIMXAIVONG' `owner_surname_(english)`,
	'ຈັນນະຄອນ' `owner_1st_name_(lao)`,
	'ພີມໄຊວົງ' `owner_surname_(lao) `,
	'C2.1' `collateral_type`,
	av.land_estimated_price `collateral_value`,
	'USD' `currency_code`,
	case when c.contract_no in (2051043) then 'INACTIVE' 
		when dr.contract_status = 4 then 'ACTIVE' when dr.contract_status in (6,7) then 'INACTIVE' else 'INACTIVE' 
	end `collateral_status`,
	case when from_unixtime(av.date_updated, '%Y-%m-%d') = '2038-01-19' then '13/08/2022 17:08:34'
		else from_unixtime(av.date_updated, '%d/%m/%Y %H:%m:%s') 
	end `date_time_updated`
FROM  tblcustomer cu
RIGHT JOIN tblprospect p ON (p.customer_id = cu.id)
RIGHT JOIN tblcontract c ON (c.prospect_id = p.id)
LEFT JOIN tblprospectassetland pa ON  (p.id = pa.prospect_id)
LEFT JOIN tblassetvaluationland av ON (av.id = pa.assetvaluation_land_id)
LEFT JOIN tbldailyreport dr ON  (dr.contract_id = c.id)
WHERE p.contract_type = 5 and p.status = 3 AND c.status in (4,6,7) AND dr.`date` = '2025-02-28' 
	-- and c.contract_no in ()
ORDER BY c.contract_no ;


-- update collateral status
select * from cib_realestate.tblc1 c1 join cib_realestate.tblb1 b1 on (c1.contract_no = b1.contract_no and c1.date_report = '2025-02-28' and b1.date_report = c1.date_report) 
where c1.`collateral_status` = '' or c1.`collateral_status` != b1.`loan_status`;


update cib_realestate.tblc1 c1 join cib_realestate.tblb1 b1 on (c1.contract_no = b1.contract_no and c1.date_report = '2025-02-28' and b1.date_report = c1.date_report) 
set c1.`collateral_status` = b1.`loan_status`;


#C2.1 as table

-- insert C2.1 the old data from last month report 
insert into cib_realestate.`tblc2.1` (`date_report`,`contract_no`,`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`collateral_ID`,`value`,`land_number`,`land_size`,`land_unit`,`land_mapcode`,`land_title_date`,`location_number_and_street_(english)`,`location_village_(english)`,`location_distrcit_(english)`,`location_number_and_street_(lao)`,`location_village_(lao)`,`location_distrcit_(lao)`,`location_province_code`)
select '2025-02-28',`contract_no`,`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`collateral_ID`,`value`,`land_number`,`land_size`,`land_unit`,`land_mapcode`,`land_title_date`,`location_number_and_street_(english)`,`location_village_(english)`,`location_distrcit_(english)`,`location_number_and_street_(lao)`,`location_village_(lao)`,`location_distrcit_(lao)`,`location_province_code`
from cib_realestate.`tblc2.1` where date_report = '2025-01-31'
	AND contract_no NOT IN (SELECT contract_no FROM cib_realestate.`tblc2.1` WHERE date_report = '2025-02-28' ) ;


-- insert C2.1 the old data from LALCO live server
select 
	'2025-02-28' `date_report`,
	c.contract_no ,
	cu.id `bank_customer_ID`,
	case p.call_centre when 1 then '01' else '01' end `branch_ID_code`,
	c.contract_no `loan_ID`,
	av.id `collateral_ID`,
	av.land_estimated_price `value`,
	convert(cast(convert(av.deed_no using latin1) as binary) using utf8) `land_number`, 
	av.land_area `land_size`,
	'M2' `land_unit`,
	av.map_no `land_mapcode`,
	DATE_FORMAT(av.land_register_date, '%d/%m/%Y') `land_title_date`,
	v.village_name `location_number_and_street_(english)`,
	v.village_name `location_village_(english)`,
	ci.city_name `location_distrcit_(english)`,
	convert(cast(convert(v.village_name_lao using latin1) as binary) using utf8) `location_number_and_street_(lao)`,
	convert(cast(convert(v.village_name_lao using latin1) as binary) using utf8) `location_village_(lao)`,
	convert(cast(convert(ci.city_name_lao using latin1) as binary) using utf8) `location_distrcit_(lao)`,
	case av.land_province_id when 1 then 'ATP' -- ATTAPEU
		when 2 then 'BK' -- BORKEO
		when 3 then 'BKX' -- BORLIKHAMXAY
		when 4 then 'CPS' -- CHAMPASACK
		when 5 then 'HP' -- HOUAPHAN
		when 6 then 'KM' -- KHAMMOUANE
		when 7 then 'LNT' -- LUANGNAMTHA
		when 8 then 'LPB' -- LUANGPRABANG
		when 9 then 'ODX' -- OUDOMXAY
		when 10 then 'PSL' -- PHONGSALY
		when 11 then 'SLV' -- SALAVAN
		when 12 then 'SV' -- SAVANNAKHET
		when 13 then 'NKL' -- VIENTIANE CAPITAL
		when 14 then 'VT' -- VIENTIANE PROVINCE
		when 15 then 'XYL' -- XAYABOULY
		when 16 then 'XSB' -- XAYSOMBOUN
		when 17 then 'SK' -- SEKONG
		when 18 then 'XKH' -- XIENGKHUANG
		else ''
	end `location_province_code`
from  tblcustomer cu
right join tblprospect p on (p.customer_id = cu.id)
right join tblcontract c on (c.prospect_id = p.id)
left join tblprospectassetland pa on  (p.id = pa.prospect_id)
left join tblassetvaluationland av on (av.id = pa.assetvaluation_land_id)
left join tblprovince pv on (pv.id = av.land_province_id)
left join tblcity ci on (ci.id=av.land_city_id)
left join tblvillage v on (v.id=av.land_village_id)
-- LEFT JOIN tbldailyreport dr ON  (dr.contract_id = c.id)
where p.contract_type = 5 and p.status = 3 and c.status in (4,6,7) -- AND dr.`date` = '2025-02-28'
	-- and c.contract_no in ()
order by c.contract_no ;




-- check
select * from cib_realestate.tbla1 where date_report = '2025-02-28';
select * from cib_realestate.tbla4 where date_report = '2025-02-28';
select * from cib_realestate.tbla5 where date_report = '2025-02-28';
select * from cib_realestate.tblb1 where date_report = '2025-02-28';
select * from cib_realestate.tblc1 where date_report = '2025-02-28';
select * from cib_realestate.`tblc2.1` where date_report = '2025-02-28';



-- 3) Export to report 
-- export A1
select concat_ws('|','A1',`bank_customer_ID`,`branch_ID_code`,`group_ID`,`head_of_group`,`national_ID`,`national_ID_expiry_date`,`passport_number`,`passport_expiry_date`,`familybook`,`family_province_code_if_issue`,`family_issue_date`,`birthdate`,`1st_name_(english)`,`2nd_name_(english)`,`surname_(english)`,`1st_name_(lao)`,`surname_(lao)`,`old _surname_(english)`,`old_surname_(lao)`,`nationality`,`gender`,`civil_status`,`spouse_1st_(english)`,`spouse_2nd_(english)`,`spouse_surname_(english)`,`spouse_1st_(lao)`,`spouse_surname_(lao)`,`datetime_updated`)
from cib_realestate.tbla1 
where date_report = '2025-02-28' ;


-- export A4
select concat_ws('|','A4',`bank_customer_ID`,`branch_ID_code`,`address_number_and_street_(english)`,`address_village_(english)`,`address_district_(english)`,`address_number_and_street_(lao)`,`address_village_(lao)`,`address_district_(lao)`,`address_province_code`,`datetime_updated`)
from cib_realestate.tbla4
where date_report = '2025-02-28' ;


-- export A5
select concat_ws('|','A5',`bank_customer_ID`,`branch_ID_code`,`telephone_no`,`mobile_no`,`fax`,`datetime_updated`)
from cib_realestate.tbla5
where date_report = '2025-02-28' ;


-- export B1
select concat_ws('|','B1',`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`open_date`,`expiry_date`,`extension_date`,`interest_rate`,`purpose_code`,`amount_of_loan`,`currency_code`,`outstanding_balance`,`loan_account_number`,`number_of_days_slow`,`loan_class`,`loan_type`,`loan_term`,`loan_status`,`date_time_updated`)
from cib_realestate.tblb1
where date_report = '2025-02-28' ;


-- export C1
select concat_ws('|','C1',`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`collateral_ID`,`owner_gender`,`owner_1st_name_(english)`,`owner 2nd_name_(english)`,`owner_surname_(english)`,`owner_1st_name_(lao)`,`owner_surname_(lao)`,`collateral_type`,`collateral_value`,`currency_code`,`collateral_status`,`date_time_updated`)
from cib_realestate.tblc1
where date_report = '2025-02-28' ;


-- export C2.1
select concat_ws('|','C2.1',`bank_customer_ID`,`branch_ID_code`,`loan_ID`,`collateral_ID`,`value`,`land_number`,`land_size`,`land_unit`,`land_mapcode`,`land_title_date`,`location_number_and_street_(english)`,`location_village_(english)`,`location_distrcit_(english)`,`location_number_and_street_(lao)`,`location_village_(lao)`,`location_distrcit_(lao)`,`location_province_code`)
from cib_realestate.`tblc2.1`
where date_report = '2025-02-28' ;




-- ________________________________________________________ User & Password ________________________________________________________
https://mf.lcic.com.la/
User: 951.1137.Chay
Password: 1234 >> 25101995

User: 951.1137.Lard
Password: 5678 >> 25101995

User: 951.1137.Seng
Password: 1122 >> 25101995





-- ________________________________________________________ update ________________________________________________________
create table `tblc2.1_copy` like cib_realestate.`tblc2.1`;
insert into `tblc2.1_copy` select * from cib_realestate.`tblc2.1`;


update cib_realestate.`tblc2.1` set location_number_and_street = ''