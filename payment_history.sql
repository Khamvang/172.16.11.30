
-- 1) create database
CREATE DATABASE `lalco_lms1`;


-- 2) Export and Import 
-- ____________________ Export via Mysql____________________
mysqldump -u Kham -pKhaml@l#3Et# -h 18.140.117.112 --port 3306 --single-transaction --column-statistics=0 lalco tblcontract tblprospect tblcustomer tblpayment tblcollection tblpaymentschedule tblcurrencyrate update_schedule tbluser > D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1_20250305.sql



-- ____________________ Export via MediaDB___________________
mysqldump -u Kham -pKhaml@l#3Et# -h 18.140.117.112 --port 3306 --single-transaction lalco tblcontract tblprospect tblcustomer tblpayment tblcollection tblpaymentschedule tblcurrencyrate update_schedule tbluser > D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1_20250304.sql




-- ____________________ Import ____________________
mysql -u kham -pKhm@431134 -h 172.16.11.30 --port 3306 lalco_lms1 < D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\lalco_portal\lalco_lms1_20250305.sql




-- 3) create table sme_lock_down to keep 
DROP TABLE IF EXISTS sme_lock_down;

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
  `monthly_interest_2nd` decimal(20,2) DEFAULT NULL,
  `monthly_interest_2nd_date` date DEFAULT NULL,
  `scenario` varchar(255) DEFAULT NULL,
  `remark` varchar(1000) DEFAULT NULL,
  `rank` varchar(255) DEFAULT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `input_date` varchar(255) DEFAULT NULL,
  `sale_staff_no` varchar(50) DEFAULT NULL,
  `sales_name` varchar(255) DEFAULT NULL,
  `contract_staff` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `is_lockdown_file` int NOT NULL DEFAULT '0' COMMENT 'is exist in lockdown file',
  PRIMARY KEY (`id`),
  KEY `idx_new_lastpayment_date` (`new_lastpayment_date`),
  KEY `idx_contract_no` (`contract_no`),
  KEY `idx_ncn` (`ncn`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`)
) ENGINE=InnoDB AUTO_INCREMENT=34159 DEFAULT CHARSET=utf8mb3;


SELECT * FROM update_schedule WHERE prospect_id = 2071250 ;

SELECT * FROM sme_lock_down sld WHERE contract_no = 2071250;


SELECT * 
FROM sme_lock_down sld 
LEFT JOIN update_schedule usc ON (sld.contract_no = usc.prospect_id )
WHERE usc.id IS NOT NULl 
	AND usc.status = 4
	AND usc.monthly_interest_2nd IS NOT NULL;


UPDATE sme_lock_down sld 
LEFT JOIN update_schedule usc ON (sld.contract_no = usc.prospect_id )
SET sld.monthly_interest_2nd  = usc.monthly_interest_2nd, sld.monthly_interest_2nd_date = usc.monthly_interest_2nd_date 
WHERE usc.id IS NOT NULl 
	AND usc.status = 4
	AND usc.monthly_interest_2nd IS NOT NULL;





-- 4) import the lockdown file to databses
-- Export from LMS 
INSERT INTO sme_lock_down

SELECT 
	usc.id AS `no`,
	1 AS `times`,
	usc.prospect_id AS `contract_no`, 
	c.ncn AS `ncn`, 
	usc.duration AS `duration_month`, 
	usc.start_date AS `start_date`, 
	usc.end_date AS `end_date`, 
	c.contract_date AS `contract_date`, 
	usc.first_payment_date AS `new_lastpayment_date`, 
	usc.monthly_interest_2nd,
	usc.monthly_interest_2nd_date,
	CASE 
		WHEN usc.schecule_updation_scenarios = 1 THEN 'Pay interest during covid affected'
		WHEN usc.schecule_updation_scenarios = 2 THEN 'No the payment during covid affected'
		WHEN usc.schecule_updation_scenarios = 3 THEN 'Pay interest during covid affected (DDT)'
		WHEN usc.schecule_updation_scenarios = 4 THEN 'No the payment during covid affected (DDT)'
		WHEN usc.schecule_updation_scenarios = 5 THEN 'Pay interest during covid affected (Normal)'
		WHEN usc.schecule_updation_scenarios = 6 THEN 'No the payment during covid affected (Normal)'
		ELSE NULL
	END AS `scenario`, 
	CONVERT(CAST(CONVERT( usc.created_by_notes USING latin1) AS binary) USING utf8) `remark`, 
	NULL AS `rank`, 
	REPLACE( CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo , " ", cu.customer_last_name_lo , " ", cu.company_name) using latin1) as binary) using utf8), '-', '') AS `customer_name`, 
	cu.main_contact_no AS `customer_phone`, 
	FROM_UNIXTIME(usc.date_created, '%Y-%m-%d') AS `input_date`, 
	us.staff_no AS `sale_staff_no`, 
	UPPER(us.nickname) AS `sales_name`, 
	UPPER(CONCAT(uc.staff_no, ' - ', uc.nickname) ) AS `contract_staff`, 
	CASE 
		WHEN usc.status = 0 THEN 'Rejected'
		WHEN usc.status = 1 THEN 'Sales Submit'
		WHEN usc.status = 2 THEN 'Credit Approval'
		WHEN usc.status = 3 THEN 'Contract Approval'
		WHEN usc.status = 4 THEN 'Accounting Approval'
	END AS `status`, 
	0 AS `is_lockdown_file`
FROM update_schedule usc
LEFT JOIN tblcontract c ON (c.prospect_id = usc.prospect_id)
LEFT JOIN tblcustomer cu ON (cu.id = c.customer_id)
LEFT JOIN tbluser us ON (us.id = usc.created_by_user_id)
LEFT JOIN tbluser uc ON (uc.id = usc.second_approved_by_user_id)
WHERE usc.id > (SELECT MAX(`no`) FROM sme_lock_down WHERE is_lockdown_file = 0)

-- WHERE usc.start_date IS NOT NULL AND usc.start_date != '0000-00-00' ; -- 1st time to import




-- 5) update the contract_no

update sme_lock_down sld inner join tblcontract c on (sld.ncn = c.ncn)
set sld.contract_no = c.contract_no ;

SELECT * FROM sme_lock_down;


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


-- 8) Query for generating the DDT sheet report
-- URL: https://docs.google.com/spreadsheets/d/12-L-kqOfd80RHTFrI_9mNF8rZJ5DRMIGvu4WU0Y5mx4/edit?gid=1260398977#gid=1260398977

/* -- Old query, don't use it, please check the new query
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
*/



-- Query for generating the DDT sheet report
-- URL: https://docs.google.com/spreadsheets/d/12-L-kqOfd80RHTFrI_9mNF8rZJ5DRMIGvu4WU0Y5mx4/edit?gid=1260398977#gid=1260398977

SELECT 
    -- Contract details
    c.contract_no,
    CASE p.contract_type 
        WHEN 1 THEN 'SME Car'
        WHEN 2 THEN 'SME Bike'
        WHEN 3 THEN 'Car Leasing'
        WHEN 4 THEN 'Bike Leasing'
        WHEN 5 THEN 'Real Estate'
        WHEN 6 THEN 'Trade Finance'
        ELSE NULL
    END AS contract_type,
    -- 
    -- Customer name (combined in English and Lao, properly encoded)
    CONVERT(CAST(CONVERT(
        CONCAT(cu.customer_first_name_en, ' ', cu.customer_last_name_en, '-', 
               cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) 
        USING latin1) AS binary) USING utf8) AS customer_name,
    cu.main_contact_no,
    -- 
    -- Payment schedule type
    CASE p.payment_schedule_type 
        WHEN '1' THEN 'Normal'
        WHEN '2' THEN 'Bullet'
        WHEN '3' THEN 'Bullet-MOU'
        ELSE ''
    END AS payment_schedule_type,
    -- 
    -- Loan and financial details
    p.loan_amount,
    p.trading_currency,
    p.monthly_interest,
    sld.monthly_interest_2nd,
    NULL AS due_for_next_installment,
    NULL AS total_principal_outstanding,
    NULL AS total_principal_outstanding_usd,
    NULL AS sale_person,
    -- 
    -- Contract status
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
    -- 
    -- Payment dates
    p.first_payment_date,
    sld.start_date AS first_payment_date_of_last_3months,
    p.last_payment_date,
    ps2.principal_amount AS last_installment_principal,
    -- 
    -- Payment structure type
    p.no_of_payment,
    CASE 
        WHEN p.payment_schedule_type = 1 THEN 'Normal'
        WHEN p.loan_amount = ps2.principal_amount THEN 'DDT'
        ELSE 'DDT+Installment'
    END AS ddt_installment,
    -- 
    -- Metrics for paid times and collection statuses
    CASE 
        WHEN sld.start_date IS NULL THEN COUNT(*)
        WHEN ps1.payment_date >= t.due_date THEN COUNT(CASE WHEN t.due_date >= sld.start_date THEN 1 END)
    END AS paid_times_of_last_contract,
    -- 
    -- Collection statuses at various milestones
    CASE 
        WHEN sld.start_date IS NULL THEN 
            COUNT(CASE 
                WHEN ps1.payment_date >= t.due_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0) THEN 1
                WHEN ps1.payment_date < t.due_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0 THEN 1
            END)
        ELSE
            COUNT(CASE 
                WHEN ps1.payment_date >= t.due_date AND t.due_date >= sld.start_date AND 
                     (t.date_collected IS NULL OR TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0) THEN 1
                WHEN ps1.payment_date < t.due_date AND t.due_date >= sld.start_date AND 
                     TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0 THEN 1
            END)
    END AS S_at_5th_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 0 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 5 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 0 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 5 THEN 1 END)
    END AS A_at_10th_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 5 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 20 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 5 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 20 THEN 1 END)
    END AS B_at_20th_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 20 AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) = 0 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 20 AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) = 0 THEN 1 END)
    END AS C_at_31st_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) >= 1 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) >= 1 THEN 1 END)
    END AS F_after_1_month_of_last_contract
    -- 
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblpaymentschedule ps1 ON ps1.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id AND status = 1 
    ORDER BY payment_date DESC LIMIT 1
)
LEFT JOIN tblpaymentschedule ps2 ON ps2.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id 
    ORDER BY payment_date DESC LIMIT 1
)
LEFT JOIN sme_lock_down sld ON sld.id = (
    SELECT id FROM sme_lock_down 
    WHERE contract_no = c.contract_no AND status IN ('ຜ່ານ', 'Accounting Approval')
    ORDER BY new_lastpayment_date DESC, start_date DESC LIMIT 1
)
LEFT JOIN (
    SELECT 
        pm.id, pm.schedule_id, pm.contract_id, pm.due_date, co.date_collected, pm.type, pm.amount,
        pm.status AS pm_status, co.status AS co_status, ps.status AS ps_status,
        ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC) AS rn
    FROM tblpayment pm
    LEFT JOIN tblcollection co ON pm.collection_id = co.id
    INNER JOIN tblpaymentschedule ps ON (ps.id = pm.schedule_id AND ps.status = 1)
) t ON (c.id = t.contract_id)
	-- 
WHERE t.rn = 1
  AND c.status IN (4, 6, 7)
GROUP BY c.contract_no;




-- For Morikawa
SELECT 
    -- Contract details
    c.contract_no,
    CASE p.contract_type 
        WHEN 1 THEN 'SME Car'
        WHEN 2 THEN 'SME Bike'
        WHEN 3 THEN 'Car Leasing'
        WHEN 4 THEN 'Bike Leasing'
        WHEN 5 THEN 'Real Estate'
        WHEN 6 THEN 'Trade Finance'
        ELSE NULL
    END AS contract_type,
    -- 
    -- Customer name (combined in English and Lao, properly encoded)
    CONVERT(CAST(CONVERT(
        CONCAT(cu.customer_first_name_en, ' ', cu.customer_last_name_en, '-', 
               cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) 
        USING latin1) AS binary) USING utf8) AS customer_name,
    cu.main_contact_no,
    -- 
    -- Payment schedule type
    CASE p.payment_schedule_type 
        WHEN '1' THEN 'Normal'
        WHEN '2' THEN 'Bullet'
        WHEN '3' THEN 'Bullet-MOU'
        ELSE ''
    END AS payment_schedule_type,
    -- 
    -- Loan and financial details
    p.loan_amount,
    p.trading_currency,
    NULL AS due_for_next_installment,
    NULL AS total_principal_outstanding,
    NULL AS total_principal_outstanding_usd,
    NULL AS sale_person,
    -- 
    -- Contract status
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
    -- 
    -- Payment dates
    p.first_payment_date,
    sld.start_date AS first_payment_date_of_last_3months,
    p.last_payment_date,
    ps2.principal_amount AS last_installment_principal,
    -- 
    -- Payment structure type
    p.no_of_payment,
    CASE 
        WHEN p.payment_schedule_type = 1 THEN 'Normal'
        WHEN p.loan_amount = ps2.principal_amount THEN 'DDT'
        ELSE 'DDT+Installment'
    END AS ddt_installment,
    -- 
    -- Metrics for paid times and collection statuses
    CASE 
        WHEN sld.start_date IS NULL THEN COUNT(*)
        WHEN ps1.payment_date >= t.due_date THEN COUNT(CASE WHEN t.due_date >= sld.start_date THEN 1 END)
    END AS paid_times_of_last_contract,
    -- 
    -- Collection statuses at various milestones
    CASE 
        WHEN sld.start_date IS NULL THEN 
            COUNT(CASE 
                WHEN ps1.payment_date >= t.due_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0) THEN 1
                WHEN ps1.payment_date < t.due_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0 THEN 1
            END)
        ELSE
            COUNT(CASE 
                WHEN ps1.payment_date >= t.due_date AND t.due_date >= sld.start_date AND 
                     (t.date_collected IS NULL OR TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0) THEN 1
                WHEN ps1.payment_date < t.due_date AND t.due_date >= sld.start_date AND 
                     TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0 THEN 1
            END)
    END AS S_at_5th_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 0 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 5 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 0 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 5 THEN 1 END)
    END AS A_at_10th_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 5 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 20 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 5 AND 
                            TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 20 THEN 1 END)
    END AS B_at_20th_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 20 AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) = 0 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 20 AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) = 0 THEN 1 END)
    END AS C_at_31st_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) <= 1 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) <= 1 THEN 1 END)
    END AS F_after_1_month_of_last_contract,
    -- 
    CASE 
        WHEN sld.start_date IS NULL THEN
            COUNT(CASE WHEN TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) >= 2 THEN 1 END)
        ELSE
            COUNT(CASE WHEN t.due_date >= sld.start_date AND 
                            TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) >= 2 THEN 1 END)
    END AS F_after_1_month_of_last_contract
    -- 
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblpaymentschedule ps1 ON ps1.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id AND status = 1 
    ORDER BY payment_date DESC LIMIT 1
)
LEFT JOIN tblpaymentschedule ps2 ON ps2.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id 
    ORDER BY payment_date DESC LIMIT 1
)
LEFT JOIN sme_lock_down sld ON sld.id = (
    SELECT id FROM sme_lock_down 
    WHERE contract_no = c.contract_no AND status IN ('ຜ່ານ', 'Accounting Approval')
    ORDER BY id DESC LIMIT 1
)
LEFT JOIN (
    SELECT 
        pm.id, pm.schedule_id, pm.contract_id, pm.due_date, co.date_collected, pm.type, pm.amount,
        pm.status AS pm_status, co.status AS co_status, ps.status AS ps_status,
        ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC) AS rn
    FROM tblpayment pm
    LEFT JOIN tblcollection co ON pm.collection_id = co.id
    INNER JOIN tblpaymentschedule ps ON (ps.id = pm.schedule_id AND ps.status = 1)
) t ON (c.id = t.contract_id)
	-- 
WHERE t.rn = 1
  AND c.status IN (4, 6, 7) 
GROUP BY c.contract_no;



-- Chat GPT
WITH latest_ps1 AS (
    SELECT *
    FROM (
        SELECT ps.*, 
               ROW_NUMBER() OVER (PARTITION BY ps.prospect_id ORDER BY ps.payment_date DESC) AS rn
        FROM tblpaymentschedule ps
        WHERE ps.status = 1
    ) sub
    WHERE rn = 1
),
latest_ps2 AS (
    SELECT *
    FROM (
        SELECT ps.*, 
               ROW_NUMBER() OVER (PARTITION BY ps.prospect_id ORDER BY ps.payment_date DESC) AS rn
        FROM tblpaymentschedule ps
    ) sub
    WHERE rn = 1
),
latest_sld AS (
    SELECT *
    FROM (
        SELECT sld.*, 
               ROW_NUMBER() OVER (PARTITION BY sld.contract_no ORDER BY sld.new_lastpayment_date DESC, sld.start_date DESC) AS rn
        FROM sme_lock_down sld
        WHERE sld.status IN ('ຜ່ານ', 'Accounting Approval')
    ) sub
    WHERE rn = 1
),
payment_data AS (
    SELECT * FROM (
        SELECT 
            pm.contract_id,
            pm.due_date, 
            co.date_collected,
            COUNT(*) OVER (PARTITION BY pm.contract_id) AS paid_times_of_last_contract,
            SUM(CASE 
                WHEN TIMESTAMPDIFF(DAY, pm.due_date, co.date_collected) <= 0 THEN 1 
                ELSE 0 
            END) OVER (PARTITION BY pm.contract_id) AS S_at_5th_of_last_contract,
            SUM(CASE 
                WHEN TIMESTAMPDIFF(DAY, pm.due_date, co.date_collected) > 0 
                     AND TIMESTAMPDIFF(DAY, pm.due_date, co.date_collected) <= 5 THEN 1 
                ELSE 0 
            END) OVER (PARTITION BY pm.contract_id) AS A_at_10th_of_last_contract,
            SUM(CASE 
                WHEN TIMESTAMPDIFF(DAY, pm.due_date, co.date_collected) > 5 
                     AND TIMESTAMPDIFF(DAY, pm.due_date, co.date_collected) <= 20 THEN 1 
                ELSE 0 
            END) OVER (PARTITION BY pm.contract_id) AS B_at_20th_of_last_contract,
            SUM(CASE 
                WHEN TIMESTAMPDIFF(DAY, pm.due_date, co.date_collected) > 20 
                     AND TIMESTAMPDIFF(MONTH, pm.due_date, co.date_collected) = 0 THEN 1 
                ELSE 0 
            END) OVER (PARTITION BY pm.contract_id) AS C_at_31st_of_last_contract,
            SUM(CASE 
                WHEN TIMESTAMPDIFF(MONTH, pm.due_date, co.date_collected) >= 1 THEN 1 
                ELSE 0 
            END) OVER (PARTITION BY pm.contract_id) AS F_after_1_month_of_last_contract,
            ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC) AS rn
        FROM tblpayment pm
        LEFT JOIN tblcollection co ON pm.collection_id = co.id
        INNER JOIN tblpaymentschedule ps ON pm.schedule_id = ps.id AND ps.status = 1
    ) sub
    WHERE rn = 1
)
SELECT 
    c.contract_no,
    CASE p.contract_type 
        WHEN 1 THEN 'SME Car'
        WHEN 2 THEN 'SME Bike'
        WHEN 3 THEN 'Car Leasing'
        WHEN 4 THEN 'Bike Leasing'
        WHEN 5 THEN 'Real Estate'
        WHEN 6 THEN 'Trade Finance'
        ELSE NULL
    END AS contract_type,
    CONVERT(CAST(CONVERT(
        CONCAT(cu.customer_first_name_en, ' ', cu.customer_last_name_en, '-', 
               cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) 
        USING latin1) AS binary) USING utf8) AS customer_name,
    cu.main_contact_no,
    CASE p.payment_schedule_type 
        WHEN '1' THEN 'Normal'
        WHEN '2' THEN 'Bullet'
        WHEN '3' THEN 'Bullet-MOU'
        ELSE ''
    END AS payment_schedule_type,
    p.loan_amount,
    p.trading_currency,
    p.monthly_interest,
    sld.monthly_interest_2nd,
    NULL AS due_for_next_installment,
    NULL AS total_principal_outstanding,
    NULL AS total_principal_outstanding_usd,
    NULL AS sale_person,
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
    sld.start_date AS first_payment_date_of_last_3months,
    p.last_payment_date,
    ps2.principal_amount AS last_installment_principal,
    p.no_of_payment,
    CASE 
        WHEN p.payment_schedule_type = 1 THEN 'Normal'
        WHEN p.loan_amount = ps2.principal_amount THEN 'DDT'
        ELSE 'DDT+Installment'
    END AS ddt_installment,
    pd.paid_times_of_last_contract,
    pd.S_at_5th_of_last_contract,
    pd.A_at_10th_of_last_contract,
    pd.B_at_20th_of_last_contract,
    pd.C_at_31st_of_last_contract,
    pd.F_after_1_month_of_last_contract
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON p.customer_id = cu.id
LEFT JOIN latest_ps1 ps1 ON ps1.prospect_id = c.prospect_id
LEFT JOIN latest_ps2 ps2 ON ps2.prospect_id = c.prospect_id
LEFT JOIN latest_sld sld ON sld.contract_no = c.contract_no
LEFT JOIN payment_data pd ON c.id = pd.contract_id
WHERE c.status IN (4, 6, 7);







-- Qwn2.5
SELECT 
    c.contract_no,
    CASE p.contract_type 
        WHEN 1 THEN 'SME Car'
        WHEN 2 THEN 'SME Bike'
        WHEN 3 THEN 'Car Leasing'
        WHEN 4 THEN 'Bike Leasing'
        WHEN 5 THEN 'Real Estate'
        WHEN 6 THEN 'Trade Finance'
        ELSE NULL
    END AS contract_type,
    CONVERT(CAST(CONVERT(
        CONCAT(cu.customer_first_name_en, ' ', cu.customer_last_name_en, '-', 
               cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) 
        USING latin1) AS binary) USING utf8) AS customer_name,
    cu.main_contact_no,
    CASE p.payment_schedule_type 
        WHEN '1' THEN 'Normal'
        WHEN '2' THEN 'Bullet'
        WHEN '3' THEN 'Bullet-MOU'
        ELSE ''
    END AS payment_schedule_type,
    p.loan_amount,
    p.trading_currency,
    p.monthly_interest,
    sld.monthly_interest_2nd,
    NULL AS due_for_next_installment,
    NULL AS total_principal_outstanding,
    NULL AS total_principal_outstanding_usd,
    NULL AS sale_person,
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
    sld.start_date AS first_payment_date_of_last_3months,
    p.last_payment_date,
    ps2.principal_amount AS last_installment_principal,
    p.no_of_payment,
    CASE 
        WHEN p.payment_schedule_type = 1 THEN 'Normal'
        WHEN p.loan_amount = ps2.principal_amount THEN 'DDT'
        ELSE 'DDT+Installment'
    END AS ddt_installment,
    agg.paid_times_of_last_contract,
    agg.S_at_5th_of_last_contract,
    agg.A_at_10th_of_last_contract,
    agg.B_at_20th_of_last_contract,
    agg.C_at_31st_of_last_contract,
    agg.F_after_1_month_of_last_contract
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON p.customer_id = cu.id
LEFT JOIN tblpaymentschedule ps1 ON ps1.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id AND status = 1 
    ORDER BY payment_date DESC LIMIT 1
)
LEFT JOIN tblpaymentschedule ps2 ON ps2.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id 
    ORDER BY payment_date DESC LIMIT 1
)
LEFT JOIN sme_lock_down sld ON sld.id = (
    SELECT id FROM sme_lock_down 
    WHERE contract_no = c.contract_no AND status IN ('ຜ່ານ', 'Accounting Approval')
    ORDER BY new_lastpayment_date DESC, start_date DESC LIMIT 1
)
LEFT JOIN (
    SELECT 
        contract_id,
        MAX(paid_times_of_last_contract) AS paid_times_of_last_contract,
        MAX(S_at_5th_of_last_contract) AS S_at_5th_of_last_contract,
        MAX(A_at_10th_of_last_contract) AS A_at_10th_of_last_contract,
        MAX(B_at_20th_of_last_contract) AS B_at_20th_of_last_contract,
        MAX(C_at_31st_of_last_contract) AS C_at_31st_of_last_contract,
        MAX(F_after_1_month_of_last_contract) AS F_after_1_month_of_last_contract
    FROM (
        SELECT 
            pm.contract_id,
            CASE 
                WHEN sld.start_date IS NULL THEN COUNT(*)
                WHEN pm.payment_date >= t.due_date THEN COUNT(CASE WHEN t.due_date >= sld.start_date THEN 1 END)
            END AS paid_times_of_last_contract,
            CASE 
                WHEN sld.start_date IS NULL THEN 
                    COUNT(CASE 
                        WHEN pm.payment_date >= t.due_date AND (t.date_collected IS NULL OR TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0) THEN 1
                        WHEN pm.payment_date < t.due_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0 THEN 1
                    END)
                ELSE
                    COUNT(CASE 
                        WHEN pm.payment_date >= t.due_date AND t.due_date >= sld.start_date AND 
                             (t.date_collected IS NULL OR TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0) THEN 1
                        WHEN pm.payment_date < t.due_date AND t.due_date >= sld.start_date AND 
                             TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 0 THEN 1
                    END)
            END AS S_at_5th_of_last_contract,
            CASE 
                WHEN sld.start_date IS NULL THEN
                    COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 0 AND 
                                    TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 5 THEN 1 END)
                ELSE
                    COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 0 AND 
                                    TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 5 THEN 1 END)
            END AS A_at_10th_of_last_contract,
            CASE 
                WHEN sld.start_date IS NULL THEN
                    COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 5 AND 
                                    TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 20 THEN 1 END)
                ELSE
                    COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 5 AND 
                                    TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) <= 20 THEN 1 END)
            END AS B_at_20th_of_last_contract,
            CASE 
                WHEN sld.start_date IS NULL THEN
                    COUNT(CASE WHEN TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 20 AND 
                                    TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) = 0 THEN 1 END)
                ELSE
                    COUNT(CASE WHEN t.due_date >= sld.start_date AND TIMESTAMPDIFF(DAY, t.due_date, t.date_collected) > 20 AND 
                                    TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) = 0 THEN 1 END)
            END AS C_at_31st_of_last_contract,
            CASE 
                WHEN sld.start_date IS NULL THEN
                    COUNT(CASE WHEN TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) >= 1 THEN 1 END)
                ELSE
                    COUNT(CASE WHEN t.due_date >= sld.start_date AND 
                                    TIMESTAMPDIFF(MONTH, t.due_date, t.date_collected) >= 1 THEN 1 END)
            END AS F_after_1_month_of_last_contract
        FROM tblpayment pm
        LEFT JOIN tblcollection co ON pm.collection_id = co.id
        INNER JOIN tblpaymentschedule ps ON (ps.id = pm.schedule_id AND ps.status = 1)
        WHERE pm.contract_id = c.id
    ) sub
    GROUP BY contract_id
) agg ON agg.contract_id = c.id
WHERE c.status IN (4, 6, 7);








