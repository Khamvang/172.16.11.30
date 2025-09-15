
-- run on server 172.16.11.30
select @@global.sql_mode global, @@session.sql_mode session;
set sql_mode = '', global sql_mode = '';


create database BCEL;


create table `phone_number` (
	`id` int(11) not null auto_increment,
	`main_contact_no` varchar(255) default null,
	`phone_no` varchar(255) default null,
	 `datetime_update` datetime default current_timestamp on update current_timestamp,
	primary key (`id`)
)engine=InnoDB auto_increment=1 default CHARSET=utf8mb4;


create table `bpay_contract` (
	`id` int(11) not null auto_increment,
	`date_report` date not null,
	`agreement_no` varchar(255) not null,
	`lao_name` varchar(255) default null,
	`englis_name` varchar(255) default null,
	`amount` decimal(20,2) not null,
	`ccy` varchar(255) default null,
	`status` varchar(255) default null,
	`phone_no` varchar(255) default null,
	`detail1` varchar(255) default null,
	`detail2` varchar(255) default null,
	`contract_no` int(11) not null,
	`main_contact_no` varchar(255) default null,
	`contract_date` date not null,
	`date_disbursed` date default null,
	`date_closed` date default null,
	`datetime_sync` timestamp null default current_timestamp,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4;


-- Check old before add new from server 172.16.11.30 
select * from bpay_contract where date_report = date_format(now(), '%Y-%m-01');



-- 1) BCEL One import from LALCO server 18.140.117.112 to server 172.16.11.30 
-- from lalco to bpay_contract
 SELECT
 	date_format(now(), '%Y-%m-01') `date_report`,
    case when FROM_UNIXTIME(c.disbursed_datetime, '%Y-%m-%d') >= '2023-01-01' and length(c.ncn) != 7 then c.contract_no else c.ncn end `agreement_no`,	
	replace( CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ", cu.customer_last_name_lo , " ", cu.company_name) using latin1) as binary) using utf8), '-', '') as `lao_name`,
	replace( CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en , " ", cu.customer_last_name_en , " ", cu.company_name) using latin1) as binary) using utf8), '-', '') as `englis_name`,
	0 `amount`,
	p.trading_currency `ccy`,
	CASE c.status WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Pending Approval'
		WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'A' -- 'A' mean Active
		WHEN 5 THEN 'Cancelled'
		WHEN 6 THEN 'C' -- 'Refinance'
		WHEN 7 THEN 'C' -- 'C' mean Closed
		ELSE NULL
	END `status`,
	'' `phone_no`,
	CASE p.contract_type WHEN 1 THEN 'SME Car' WHEN 2 THEN 'SME Bike' WHEN 3 THEN 'Car Leasing' WHEN 4 THEN 'Bike Leasing' when 5 then 'Real estate' ELSE NULL END `detail1`, -- Contract_type
	CASE p.call_centre 
		WHEN 1 THEN '100 - Head Office'
		WHEN 2 THEN '200 - Savannakhet'
		WHEN 3 THEN '300 - Pakse - Champasack'
		WHEN 4 THEN '400 - Luangprabang'
		WHEN 5 THEN '500 - Oudomxay'
		WHEN 6 THEN '110 - Vientiane province'
		WHEN 7 THEN '210 - Xeno - Savanakhet'
		WHEN 8 THEN '310 - Sukhuma(PKS) - Champasack'
		WHEN 9 THEN '600 - Xainyabuli'
		WHEN 10 THEN '700 - Houaphan'
		WHEN 11 THEN '900 - Xiengkhouang'
		WHEN 12 THEN '800 - Paksan - Bolikhamxay'
		WHEN 13 THEN '220 - Paksong - Savanakhet'
		WHEN 14 THEN '230 - Thakek - Khammuane'
		WHEN 15 THEN '320 - Salavan'
		WHEN 16 THEN '330 - Attapeu'
		WHEN 17 THEN '910 - Kham - Xiengkhuang'
		WHEN 18 THEN '240 - Phin - Savanakhet'
		WHEN 21 THEN '999 - Other'
		WHEN 22 THEN '1000 - Luangnamtha'
		WHEN 24 THEN '120 - Dongdok - Vientiane Capital'
		WHEN 26 THEN '111 - Vangvieng - Vientiane province'
		WHEN 27 THEN '1300 - Bokeo'
		WHEN 28 THEN '1100 - Phongsaly'
		WHEN 29 THEN '1200 - Sekong'
		WHEN 30 THEN '1400 - Xaysomboun'
		WHEN 31 THEN '1500 - Hadxayfong - Vientiane Capital'
		WHEN 32 THEN '1600 - Naxaythong - Vientiane Capital'
		WHEN 33 THEN '1700 - Parkngum - Vientiane Capital'
		WHEN 34 THEN '1800 - Xaythany - Vientiane Capital'
		WHEN 35 THEN '1900 - Saysetha - Attapeu'
		WHEN 36 THEN '2000 - Khamkeut - Borikhamxay'
		WHEN 37 THEN '2100 - Paksong - Champasack'
		WHEN 38 THEN '2200 - Chongmeg - Champasack'
		WHEN 39 THEN '2300 - Nam Bak - Luangprabang'
		WHEN 40 THEN '2400 - Songkhone - Savanakhet'
		WHEN 41 THEN '2500 - Parklai - Xayaboury'
		WHEN 42 THEN '2600 - Sikhottabong - Vientiane Capital'
		WHEN 43 THEN '2700 - Xanakharm(VTP) - Vientiane Province'
		WHEN 44 THEN '2800 - Feuang(VTP) - Vientiane Province'
		WHEN 45 THEN '2900 - Thoulakhom(VTP) - Vientiane Province'
		WHEN 46 THEN '3000 - Khoune(XKH) - Xienkhuang'
		WHEN 47 THEN '3100 - Pakkading(PKN) - Borikhamxay'
		WHEN 48 THEN '3200 - Khong(PKS) - Champasack'
		WHEN 50 THEN '3300 - Khongxedone(SLV) - Saravane'
		WHEN 51 THEN '3400 - Atsaphangthong(SVK) - Savanakhet'
		WHEN 52 THEN '3500 - Nhommalth(TKK) - Khammuane'
		WHEN 53 THEN '3600 - Nane(LPB) - Luangprabang'
		WHEN 54 THEN '3700 - Hoon(ODX) - Oudomxay'
		WHEN 55 THEN '3800 - Hongsa(XYB) - Xayaboury'
		WHEN 56 THEN '3900 - Tonpherng(BKO) - Bokeo'
	END `detail2`, -- Branch 
	p.id `contract_no`,
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('03',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('030',REPLACE ( cu.main_contact_no, ' ', ''))
	    else CONCAT('020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	end `main_contact_no`,
	c.contract_date,
	FROM_UNIXTIME(c.disbursed_datetime, '%Y-%m-%d') `date_disbursed`,
	c.date_closed `date_closed`
from tblprospect p
left join tblcustomer cu on (p.customer_id = cu.id)
left join tblcontract c on (p.id = c.prospect_id)
where  ((c.status = 4 or c.status = 6 or c.status = 7) 
	and( (FROM_UNIXTIME(c.disbursed_datetime, '%Y-%m-%d') between DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 2 MONTH) and LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 0 MONTH)) ) 
		or ((c.status = 6 or c.status = 7) and c.date_closed between DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 12 MONTH) and LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 0 MONTH)) )
		) 
	)
-- c.contract_no in (2123145) -- missed contract_no last time
order by c.contract_no ;




-- delete duplicate if has same report date on server 172.16.11.30
delete from bpay_contract where id in (
select id from ( 
		select id, row_number() over (partition by date_report, contract_no, status order by id asc) as row_numbers  
		from bpay_contract
	) as t1
where row_numbers > 1 
);




-- 2) insert phone data to table phone_number on server 172.16.11.30 
insert into phone_number (`main_contact_no`, `phone_no`)
select main_contact_no, 
	concat(left(main_contact_no, length(main_contact_no)-4 ), floor(rand()*(9999-1111+1)+1111) ) `phone_no`
from bpay_contract
where date_report = date_format(now(), '%Y-%m-01') or phone_no = '';



-- 3) check and remove duplicate on server 172.16.11.30 
delete from phone_number where id in (
select id from ( 
		select id, row_number() over (partition by main_contact_no order by id asc) as row_numbers  
		from phone_number
	) as t1
where row_numbers > 1 
);


/*
-- additional Add Indexes to help speed up joins and lookups. Ensure that both the bc.main_contact_no and ph.main_contact_no columns are indexed, as well as the bc.phone_no column.
CREATE INDEX idx_bc_main_contact_no ON bpay_contract (main_contact_no);
CREATE INDEX idx_ph_main_contact_no ON phone_number (main_contact_no);
CREATE INDEX idx_bc_phone_no ON bpay_contract (phone_no);

-- Use EXPLAIN Before running your query, use EXPLAIN to understand how the database executes it and see where bottlenecks might occur:
EXPLAIN UPDATE bpay_contract bc 
JOIN phone_number ph ON (bc.main_contact_no = ph.main_contact_no)
SET bc.phone_no = ph.phone_no 
WHERE bc.phone_no = '';
*/


-- 4) update phone_no to table bpay_contract on server 172.16.11.30 
update bpay_contract bc join phone_number ph on (bc.main_contact_no = ph.main_contact_no)
set bc.phone_no = ph.phone_no 
where bc.phone_no = '';



-- 5) Download format from web on server 172.16.11.30 
Web link: https://www.bcel.com.la/billapp/login 
User: lalco
Password: Lalco@min2020 >> Lalco@min2024



-- 6) query and copy to Upload format Excel 97-2003 on server 172.16.11.30 
select null as `No`,
	agreement_no as `Agreement No`,
	lao_name as `Lao Name`,
	englis_name as `Englis Name`,
	amount as `Amount`,
	ccy as `CCY`,
	status as `Status`,
	phone_no as `Phone No`,
	detail1 as `Detail1`,
	detail2 as `Detail2`
from bpay_contract 
 WHERE date_report = date_format(now(), '%Y-%m-01') 
-- WHERE datetime_sync >= CURDATE()
-- AND contract_no IN (2123145)
; -- 28 contracts 










SELECT *
from bpay_contract 
where contract_no IN (2111205)


SELECT * -- GROUP_CONCAT(contract_no SEPARATOR ', ') 
FROM bpay_contract
WHERE agreement_no <> contract_no 
	AND length(agreement_no) = 7
	AND date_disbursed >= '2024-01-05'



UPDATE bpay_contract
SET agreement_no = contract_no 
WHERE contract_no IN (2112838, 2113392, 2113758, 2113941, 2113953, 2114487, 2112838, 2113392, 2113926, 2113953, 2114060, 2114108, 2114487, 2114807, 2115017, 2115339, 2115419, 2115423, 2113926, 2114108, 2114498, 2114807, 2115017, 2115339, 2115419, 2115423, 2115577, 2114498)
	AND agreement_no <> contract_no 
; -- 28 contracts


SELECT * -- GROUP_CONCAT(contract_no SEPARATOR ', ') 
FROM bpay_contract 
WHERE contract_no IN (2112838, 2113392, 2113758, 2113941, 2113953, 2114487, 2112838, 2113392, 2113926, 2113953, 2114060, 2114108, 2114487, 2114807, 2115017, 2115339, 2115419, 2115423, 2113926, 2114108, 2114498, 2114807, 2115017, 2115339, 2115419, 2115423, 2115577, 2114498)
; -- 28 contracts 











