
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



-- 6)
SELECT c.contract_no , sld.new_lastpayment_date,
	count( case when c.status = 4 and t.date_collected is not null then 1 end) 'paid_times', 
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0 then 1 end ) + count( case when t.date_collected is null then 1 end) as'S_at_5th',
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 0 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 5 then 1 end ) as 'A_at_10th',
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 5 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 20 then 1 end ) as 'B_at_20th',
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 20 and TIMESTAMPDIFF(month, t.due_date, t.date_collected) = 0 then 1 end ) as 'C_at_31st',
	count( case when TIMESTAMPDIFF(month, t.due_date, t.date_collected) >= 1 then 1 end ) as 'F_after_1_month'
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join sme_lock_down sld on sld.id = (select id from sme_lock_down where contract_no = c.contract_no and status = 'ຜ່ານ' order by id desc limit 1 )
left join (
	SELECT pm.id, pm.schedule_id, pm.contract_id, pm.due_date, co.date_collected, pm.`type`, pm.amount, 
		pm.status AS pm_status, co.status AS co_status, ps.status as ps_status,
		ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC) AS rn
    FROM tblpayment pm
    LEFT JOIN tblcollection co ON pm.collection_id = co.id
    inner join tblpaymentschedule ps on (ps.id = pm.schedule_id and ps.status = 1 )
	) t on (c.id = t.contract_id)
WHERE t.rn = 1
	and c.contract_no = 2005042
group by contract_no ;





