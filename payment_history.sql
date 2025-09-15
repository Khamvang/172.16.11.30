
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



select * from update_schedule us where us.prospect_id  = 2101753; 

select * from sme_lock_down where contract_no = 2101753 and status IN ('ຜ່ານ', 'Accounting Approval')  -- order by id desc limit 1 


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
	NULL AS `id`,
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
WHERE 
	usc.id > (SELECT MAX(`no`) FROM sme_lock_down WHERE is_lockdown_file = 0)
	/*usc.status = 4
	-- AND usc.prospect_id = 2101753
	AND usc.start_date IS NOT NULL AND usc.start_date != '0000-00-00'
	AND FROM_UNIXTIME(usc.date_updated, '%Y-%m-%d') >= '2025-01-01'
-- WHERE usc.start_date IS NOT NULL AND usc.start_date != '0000-00-00' ; -- 1st time to import
*/
;




-- 5) update the contract_no and create INDEX

update sme_lock_down sld inner join tblcontract c on (sld.ncn = c.ncn)
set sld.contract_no = c.contract_no ;

SHOW INDEX FROM tblcollection;

CREATE INDEX idx_collection_id ON tblpayment(collection_id);
CREATE INDEX idx_status ON tblpaymentschedule(status);
CREATE INDEX idx_payment_date ON tblpaymentschedule(payment_date);
CREATE INDEX idx_date_collected ON tblcollection(date_collected);





-- 6) data details for checking

-- SChedule to check 
SELECT *
FROM 
	(SELECT 
		ps.prospect_id,
		ps.payment_date,
		co.date_collected,
		sld.start_date AS `new_start_date`,
		ps.payment_date >= sld.start_date `true`,
		TIMESTAMPDIFF(day, ps.payment_date, co.date_collected) AS `delay_days`,
		TIMESTAMPDIFF(MONTH, ps.payment_date, co.date_collected) AS `delay_month`,
		pm.`type`,
		ps.status,
		ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC, FIELD(pm.type, 'principal', 'interest', 'penalty') ) AS rn
	FROM tblpaymentschedule ps
	LEFT JOIN sme_lock_down sld on sld.id = (select id from sme_lock_down where contract_no = ps.prospect_id and status IN ('ຜ່ານ', 'Accounting Approval') order by id desc limit 1 )
	LEFT JOIN tblpayment pm ON (pm.schedule_id = ps.id)
	LEFT JOIN tblcollection co ON pm.collection_id = co.id
	WHERE ps.status = 1
		AND ps.prospect_id = 2111853 -- 2120956 -- 2101753 -- 2101714 -- 2101701 -- 2101694 -- 2101682 -- 2101687 -- 2101669
	) t
WHERE rn = 1
;


-- Calcualte
SELECT 
	prospect_id,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1
				THEN 1
			ELSE 0
		END
	) `total_no_of_paid`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND (delay_days <= 0 OR delay_days IS NULL)
				THEN 1
			ELSE 0
		END
	) `total_S_at_5th`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND delay_days > 0 AND delay_days <= 5
				THEN 1
			ELSE 0
		END
	) `total_A_at_10th`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND delay_days > 5 AND delay_days <= 15
				THEN 1
			ELSE 0
		END
	) `total_B_at_20th`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND delay_days > 15 AND delay_month <= 0
				THEN 1
			ELSE 0
		END
	) `total_C_at_31st`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND delay_month > 0
				THEN 1
			ELSE 0
		END
	) `total_F_after_1_month`,
-- 
-- Lasted contract 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND payment_date >= new_start_date
				THEN 1
			ELSE 0
		END
	) `lasted_contract_no_of_paid`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND payment_date >= new_start_date 
					AND (delay_days <= 0 OR delay_days IS NULL)
				THEN 1
			ELSE 0
		END
	) `lasted_contract_S_at_5th`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND payment_date >= new_start_date 
					AND delay_days > 0 AND delay_days <= 5
				THEN 1
			ELSE 0
		END
	) `lasted_contract_A_at_10th`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND payment_date >= new_start_date 
					AND delay_days > 5 AND delay_days <= 15
				THEN 1
			ELSE 0
		END
	) `lasted_contract_B_at_20th`,
-- 
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND payment_date >= new_start_date 
					AND delay_days > 15 AND delay_month <= 0
				THEN 1
			ELSE 0
		END
	) `lasted_contract_C_at_31st`,
	SUM(
		CASE 
			WHEN status = 1 AND rn = 1 
					AND payment_date >= new_start_date 
					AND delay_month > 0
				THEN 1
			ELSE 0
		END
	) `lasted_contract_F_after_1_month`
FROM 
	(SELECT 
		ps.prospect_id,
		ps.payment_date,
		co.date_collected,
		sld.start_date AS `new_start_date`,
		TIMESTAMPDIFF(day, ps.payment_date, co.date_collected) AS `delay_days`,
		TIMESTAMPDIFF(MONTH, ps.payment_date, co.date_collected) AS `delay_month`,
		pm.`type`,
		ps.status,
		ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC, FIELD(pm.type, 'principal', 'interest', 'penalty') ) AS rn
	FROM tblpaymentschedule ps
	LEFT JOIN sme_lock_down sld on sld.id = (select id from sme_lock_down where contract_no = ps.prospect_id and status IN ('ຜ່ານ', 'Accounting Approval') order by id desc limit 1 )
	LEFT JOIN tblpayment pm ON (pm.schedule_id = ps.id)
	LEFT JOIN tblcollection co ON pm.collection_id = co.id
	WHERE ps.status = 1
		AND ps.prospect_id IN (2111853 , 2120956 , 2121626 , 2101753 , 2101714 , 2101701 , 2101694 , 2101682 , 2101687 , 2101669)
	) t
GROUP BY prospect_id
;








--  Disable ONLY_FULL_GROUP_BY (Not Recommended)
/* You can temporarily disable ONLY_FULL_GROUP_BY by updating the SQL mode, but this is not recommended for production as it can lead to unpredictable query results. */

SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));



SELECT 
	-- Contract details
	c.contract_no,
	CASE 
		p.contract_type 
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
	CASE 
		p.payment_schedule_type 
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
   pmh.monthly_interest_2nd,
	NULL AS total_principal_outstanding_usd,
	c.date_closed,
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
	pmh.new_start_date AS first_payment_date_of_last_3months,
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
	CASE 
		WHEN pmh.new_start_date IS NOT NULL THEN pmh.lasted_contract_no_of_paid
		ELSE pmh.total_no_of_paid
	END AS `no_of_paid`,
	CASE 
		WHEN pmh.new_start_date IS NOT NULL THEN pmh.lasted_contract_S_at_5th
		ELSE pmh.total_S_at_5th
	END AS `S_at_5th`,
	CASE 
		WHEN pmh.new_start_date IS NOT NULL THEN pmh.lasted_contract_A_at_10th
		ELSE pmh.total_A_at_10th
	END AS `A_at_10th`,
	CASE 
		WHEN pmh.new_start_date IS NOT NULL THEN pmh.lasted_contract_B_at_20th
		ELSE pmh.total_B_at_20th
	END AS `B_at_20th`,
	CASE 
		WHEN pmh.new_start_date IS NOT NULL THEN pmh.lasted_contract_C_at_31st
		ELSE pmh.total_C_at_31st
	END AS `C_at_31st`,
	CASE 
		WHEN pmh.new_start_date IS NOT NULL THEN pmh.lasted_contract_F_after_1_month
		ELSE pmh.total_F_after_1_month
	END AS `F_after_1_month`
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
LEFT JOIN tblpaymentschedule ps2 ON ps2.id = (
	SELECT id FROM tblpaymentschedule 
	WHERE prospect_id = c.prospect_id 
	ORDER BY payment_date DESC LIMIT 1
)
-- Calcualte
LEFT JOIN (
		SELECT 
			prospect_id,
			monthly_interest_2nd,
			new_start_date,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1
						THEN 1
					ELSE 0
				END
			) `total_no_of_paid`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND (delay_days <= 0 OR delay_days IS NULL)
						THEN 1
					ELSE 0
				END
			) `total_S_at_5th`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND delay_days > 0 AND delay_days <= 5
						THEN 1
					ELSE 0
				END
			) `total_A_at_10th`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND delay_days > 5 AND delay_days <= 15
						THEN 1
					ELSE 0
				END
			) `total_B_at_20th`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND delay_days > 15 AND delay_month <= 0
						THEN 1
					ELSE 0
				END
			) `total_C_at_31st`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND delay_month > 0
						THEN 1
					ELSE 0
				END
			) `total_F_after_1_month`,
		-- 
		-- Lasted contract 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND payment_date >= new_start_date
						THEN 1
					ELSE 0
				END
			) `lasted_contract_no_of_paid`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND payment_date >= new_start_date 
							AND (delay_days <= 0 OR delay_days IS NULL)
						THEN 1
					ELSE 0
				END
			) `lasted_contract_S_at_5th`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND payment_date >= new_start_date 
							AND delay_days > 0 AND delay_days <= 5
						THEN 1
					ELSE 0
				END
			) `lasted_contract_A_at_10th`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND payment_date >= new_start_date 
							AND delay_days > 5 AND delay_days <= 15
						THEN 1
					ELSE 0
				END
			) `lasted_contract_B_at_20th`,
		-- 
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND payment_date >= new_start_date 
							AND delay_days > 15 AND delay_month <= 0
						THEN 1
					ELSE 0
				END
			) `lasted_contract_C_at_31st`,
			SUM(
				CASE 
					WHEN status = 1 AND rn = 1 
							AND payment_date >= new_start_date 
							AND delay_month > 0
						THEN 1
					ELSE 0
				END
			) `lasted_contract_F_after_1_month`
		FROM 
			(SELECT 
				ps.prospect_id,
				ps.payment_date,
				co.date_collected,
				sld.start_date AS `new_start_date`,
				sld.monthly_interest_2nd,
				TIMESTAMPDIFF(day, ps.payment_date, co.date_collected) AS `delay_days`,
				TIMESTAMPDIFF(MONTH, ps.payment_date, co.date_collected) AS `delay_month`,
				pm.`type`,
				ps.status,
				ROW_NUMBER() OVER (PARTITION BY pm.contract_id, pm.due_date ORDER BY co.date_collected DESC, FIELD(pm.type, 'principal', 'interest', 'penalty') ) AS rn
			FROM tblpaymentschedule ps
			LEFT JOIN sme_lock_down sld on sld.id = (select id from sme_lock_down where contract_no = ps.prospect_id and status IN ('ຜ່ານ', 'Accounting Approval') order by id desc limit 1 )
			LEFT JOIN tblpayment pm ON (pm.schedule_id = ps.id)
			LEFT JOIN tblcollection co ON pm.collection_id = co.id
			WHERE ps.status = 1
			) t
		GROUP BY prospect_id
		) pmh ON pmh.prospect_id = c.prospect_id 
WHERE
	c.status IN (4, 6, 7)
	-- AND c.contract_no IN (2111853 , 2120956 , 2121626 , 2101753 , 2101714 , 2101701 , 2101694 , 2101682 , 2101687 , 2101669)
;











-- Not use
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
	NULL AS total_principal_outstanding_usd,
	c.date_closed,
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
	ORDER BY start_date DESC LIMIT 1
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


-- ____________________________________________ update ____________________________________________

-- Export the result 
SELECT 
	c.contract_no,
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
	END AS `contract_status`,
	CASE 
		WHEN p.loan_amount = ps2.principal_amount THEN 'DDT'
		WHEN p.loan_amount <> ps2.principal_amount THEN 'Normal'
		WHEN p.payment_schedule_type = 1 THEN 'Normal'
		ELSE 'DDT+Installment'
	END AS `ddt_installment`,
	usc.monthly_interest_2nd,
	p.trading_currency AS `currency`
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN update_schedule usc ON usc.id = (
	SELECT id FROM update_schedule
	WHERE prospect_id = c.prospect_id AND status IN (4)
	ORDER BY date_updated DESC LIMIT 0, 1
)
LEFT JOIN tblpaymentschedule ps2 ON ps2.id = (
	SELECT id FROM tblpaymentschedule 
	WHERE prospect_id = c.prospect_id 
	ORDER BY payment_date DESC LIMIT 0, 1
)
WHERE c.status IN (4, 6, 7)
	AND c.contract_no IN ()
;


































