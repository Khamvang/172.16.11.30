
SELECT * FROM sme_lock_down where contract_no is null

alter table sme_lock_down add is_lockdown_file int(11) not null default 0 comment 'is exist in lockdown file';
UPDATE sme_lock_down set is_lockdown_file = 1


update sme_lock_down sld inner join tblcontract c on (sld.ncn = c.ncn)
set sld.contract_no = c.contract_no ;


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






SELECT id FROM sme_lock_down 
		WHERE contract_no = 2084170 AND status IN ('ຜ່ານ', 'Accounting Approval')
		ORDER BY new_lastpayment_date DESC, start_date DESC LIMIT 1


drop database contact_data_db


drop table contact_for_202405_lcc;


show processlist


kill connection 5;
kill connection 7189;
kill connection 7191;
kill connection 7205;
kill connection 7459;
kill connection 7499;
kill connection 7513;
kill connection 7545;
kill connection 7546;
kill connection 7559;
kill connection 7567;
kill connection 7568;
kill connection 7570;



SELECT * FROM sme_lock_down WHERE `no` = 0 LIMIT 2;

INSERT INTO `sme_lock_down_2`
	(`no`, `times`, `contract_no`, `ncn`, `duration_month`, `start_date`, `end_date`, `contract_date`, `new_lastpayment_date`, `scenario`, 
	`remark`, `rank`, `customer_name`, `customer_phone`, `input_date`, `sale_staff_no`, `sales_name`, `contract_staff`, `status`, `is_lockdown_file`)
SELECT 
	`no`, `times`, `contract_no`, `ncn`, `duration_month`, `start_date`, `end_date`, `contract_date`, `new_lastpayment_date`, `scenario`, 
	`remark`, `rank`, `customer_name`, `customer_phone`, `input_date`, `sale_staff_no`, `sales_name`, `contract_staff`, `status`, `is_lockdown_file`
FROM sme_lock_down sld 
WHERE `no` = 0 
ORDER BY id DESC;


SELECT * FROM sme_lock_down_2

DELETE FROM sme_lock_down WHERE `no` = 0

ALTER TABLE lalco_lms1.sme_lock_down 
AUTO_INCREMENT=32250;


INSERT INTO `sme_lock_down`
	(`no`, `times`, `contract_no`, `ncn`, `duration_month`, `start_date`, `end_date`, `contract_date`, `new_lastpayment_date`, `scenario`, 
	`remark`, `rank`, `customer_name`, `customer_phone`, `input_date`, `sale_staff_no`, `sales_name`, `contract_staff`, `status`, `is_lockdown_file`)
SELECT 
	`no`, `times`, `contract_no`, `ncn`, `duration_month`, `start_date`, `end_date`, `contract_date`, `new_lastpayment_date`, `scenario`, 
	`remark`, `rank`, `customer_name`, `customer_phone`, `input_date`, `sale_staff_no`, `sales_name`, `contract_staff`, `status`, `is_lockdown_file`
FROM sme_lock_down_2


SELECT * FROM sme_lock_down WHERE `no` = 0



CREATE TABLE `sme_lock_down_2` (
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
	`is_lockdown_file` int NOT NULL DEFAULT '0' COMMENT 'is exist in lockdown file',
	PRIMARY KEY (`id`),
	KEY `idx_new_lastpayment_date` (`new_lastpayment_date`),
	KEY `idx_contract_no` (`contract_no`),
	KEY `idx_ncn` (`ncn`),
	KEY `idx_status` (`status`),
	KEY `idx_start_date` (`start_date`)
) ENGINE=InnoDB AUTO_INCREMENT=32250 DEFAULT CHARSET=utf8mb3;



ALTER TABLE sme_lock_down MODIFY remark VARCHAR(1000);






