
-- 1) create database
CREATE DATABASE `lalco_lms1`;


-- 2) Export and Import 
-- ____________________ Export ____________________
mysqldump -u Kham -pKhaml@l#3Et# -h 18.140.117.112 --port 3306 --single-transaction --column-statistics=0 lalco tblcontract tblprospect tblcustomer tblpayment tblcollection tblpaymentschedule tblcurrencyrate > D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1.sql



-- ____________________ Import ____________________
mysql -u kham -pKhm@431134 -h 172.16.11.30 --port 3306 lalco_lms1 < D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1.sql



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


-- 6) data details for checking
SELECT c.contract_no , p.first_payment_date, p.last_payment_date, sld.start_date `new_1st_payment_date`, sld.new_lastpayment_date,
	ps1.payment_date, t.due_date, t.date_collected 
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblpaymentschedule ps1 on ps1.id = (select id from tblpaymentschedule where prospect_id = c.prospect_id and status = 1 order by payment_date desc limit 1 )
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
	and c.status in (4,6,7)
;



--  Disable ONLY_FULL_GROUP_BY (Not Recommended)
/* You can temporarily disable ONLY_FULL_GROUP_BY by updating the SQL mode, but this is not recommended for production as it can lead to unpredictable query results. */

SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));


-- 7) Calculation
SELECT c.contract_no , p.first_payment_date, p.last_payment_date, sld.start_date `new_1st_payment_date`, sld.new_lastpayment_date,
	-- all in contract
	case when ps1.payment_date >= t.due_date then count(*) end 'paid_times', 
	COUNT( CASE WHEN ps1.payment_date >= t.due_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0) THEN 1
				WHEN ps1.payment_date < t.due_date AND TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0 THEN 1
		   END
	) AS 'S_at_5th',
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 0 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 5 then 1 end ) as 'A_at_10th',
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 5 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 20 then 1 end ) as 'B_at_20th',
	count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 20 and TIMESTAMPDIFF(month, t.due_date, t.date_collected) = 0 then 1 end ) as 'C_at_31st',
	count( case when TIMESTAMPDIFF(month, t.due_date, t.date_collected) >= 1 then 1 end ) as 'F_after_1_month',
	-- last contract
	case 
		when ps1.payment_date >= t.due_date then count(case when t.due_date >= sld.start_date then 1 end ) 
	end 'paid_times_of_last_contract',
	COUNT( 
		CASE WHEN ps1.payment_date >= t.due_date AND t.due_date >= sld.start_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0) THEN 1
				WHEN ps1.payment_date < t.due_date AND t.due_date >= sld.start_date AND TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0 THEN 1
		END
	) AS 'S_at_5th_of_last_contract',
	count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 0 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 5 then 1 end 
	) as 'A_at_10th_of_last_contract',
	count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 5 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 20 then 1 end ) as 'B_at_20th_of_last_contract',
	count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 20 and TIMESTAMPDIFF(month, t.due_date, t.date_collected) = 0 then 1 end ) as 'C_at_31st_of_last_contract',
	count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(month, t.due_date, t.date_collected) >= 1 then 1 end ) as 'F_after_1_month_of_last_contract'
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblpaymentschedule ps1 on ps1.id = (select id from tblpaymentschedule where prospect_id = c.prospect_id and status = 1 order by payment_date desc limit 1 )
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
	and c.status in (4,6,7)
group by contract_no ;


-- 8) DDT Delay 
SELECT c.contract_no , 
CASE p.contract_type 
        WHEN 1 THEN 'SME Car'
        WHEN 2 THEN 'SME Bike' 
        WHEN 3 THEN 'Car Leasing'
        WHEN 4 THEN 'Bike Leasing' 
        WHEN 5 THEN 'Real Estate'
        WHEN 6 THEN 'Trade Finance'
        ELSE NULL
    END AS contract_type,
CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_en, ' ', cu.customer_last_name_en , '-', cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
cu.main_contact_no,
    CASE p.payment_schedule_type 
        WHEN '1' THEN 'Normal' 
        WHEN '2' THEN 'Bullet' 
        WHEN '3' THEN 'Bullet-MOU'
        ELSE '' 
    END AS payment_schedule_type,
p.loan_amount, p.trading_currency, 
null as 'due_for_next_installment' , null as 'totoal_principal_outstanding' , null as 'totoal_principal_outstanding_usd' ,
null as 'sale_person',
CASE c.status 
        WHEN 0 THEN 'Pending' 
        WHEN 1 THEN 'Pending Approval'
        WHEN 2 THEN 'Pending Disbursement' 
        WHEN 3 THEN 'Disbursement Approval'
        WHEN 4 THEN 'Active' 
        WHEN 5 THEN 'Cancelled'
        WHEN 6 THEN 'Refinance' 
        WHEN 7 THEN 'Closed' 
        ELSE NULL
    END AS contract_status,
p.first_payment_date, 
sld.start_date as 'first_payment_date_of_last_3moths',
p.last_payment_date,
ps2.principal_amount as 'last_installment_principal',
p.no_of_payment, 
case When p.payment_schedule_type = 1 then 'Normal' when p.loan_amount = ps2.principal_amount then 'DDT' else 'DDT+Installment' end 'ddt_installment', 
-- sld.start_date `new_1st_payment_date`, sld.new_lastpayment_date,
	-- conbine if has lockdown then use last contract, if not then use that contract date
	CASE WHEN sld.start_date is null 
		THEN count(*)
		when ps1.payment_date >= t.due_date then count(case when t.due_date >= sld.start_date then 1 end ) 
	END AS 'paid_times_of_last_contract',
	-- S_at_5th
	CASE WHEN sld.start_date is null 
		THEN 
			COUNT( CASE WHEN ps1.payment_date >= t.due_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0) THEN 1
					WHEN ps1.payment_date < t.due_date AND TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0 THEN 1
			   END
			)
		ELSE
			COUNT( 
				CASE WHEN ps1.payment_date >= t.due_date AND t.due_date >= sld.start_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0) THEN 1
						WHEN ps1.payment_date < t.due_date AND t.due_date >= sld.start_date AND TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 0 THEN 1
				END
			) 
	END AS 'S_at_5th_of_last_contract',
	-- A_at_10th
	CASE WHEN sld.start_date is null 
		THEN
			count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 0 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 5 then 1 end )
		ELSE
			count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 0 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 5 then 1 end 
			) 
	END AS 'A_at_10th_of_last_contract',
	-- B_at_20th
	CASE WHEN sld.start_date is null 
		THEN
			count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 5 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 20 then 1 end )
		ELSE
			count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 5 and TIMESTAMPDIFF(day, t.due_date, t.date_collected) <= 20 then 1 end ) 
	END AS 'B_at_20th_of_last_contract',
	-- C_at_31st
	CASE WHEN sld.start_date is null 
		THEN
			count( case when TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 20 and TIMESTAMPDIFF(month, t.due_date, t.date_collected) = 0 then 1 end )
		ELSE
			count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(day, t.due_date, t.date_collected) > 20 and TIMESTAMPDIFF(month, t.due_date, t.date_collected) = 0 then 1 end ) 
	END AS 'C_at_31st_of_last_contract',
	-- F_after_1_month
	CASE WHEN sld.start_date is null 
		THEN
			count( case when TIMESTAMPDIFF(month, t.due_date, t.date_collected) >= 1 then 1 end )
		ELSE
			count( case when t.due_date >= sld.start_date and TIMESTAMPDIFF(month, t.due_date, t.date_collected) >= 1 then 1 end ) 
	END AS 'F_after_1_month_of_last_contract'
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblcustomer cu on (p.customer_id = cu.id)
left join tblpaymentschedule ps1 on ps1.id = (select id from tblpaymentschedule where prospect_id = c.prospect_id and status = 1 order by payment_date desc limit 1 )
left join tblpaymentschedule ps2 on ps2.id = (select id from tblpaymentschedule where prospect_id = c.prospect_id order by payment_date desc limit 1 )
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
	and c.status in (4,6,7)
group by contract_no;
