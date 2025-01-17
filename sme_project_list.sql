
-- ------------------------------------ Create table collection ------------------------------------ 
-- 1. create table sme_project_list for save all data
CREATE TABLE sme_project_list (
	id INT AUTO_INCREMENT,
	debt_type VARCHAR(255) NOT NULL,
	target_month DATE DEFAULT NULL,
	first_payment_date DATE,
	last_payment_date DATE,
	contract_no VARCHAR(255) ,
	customer_name VARCHAR(255) NOT NULL,
	customer_tel VARCHAR(20),
	sale_staff VARCHAR(20),
	collection_staff VARCHAR(20),
	collection_cc_staff VARCHAR(20),
	now_amount_usd DECIMAL(15, 2),
	last_payment_rank varchar(50),
	call_to_whom VARCHAR(255),
	call_status VARCHAR(255),
	number_of_promised INT DEFAULT NULL,
	promised_date DATE DEFAULT NULL,
	gps_status VARCHAR(50) DEFAULT NULL,
	exceptional VARCHAR(255) DEFAULT NULL,
	seized_car VARCHAR(255) DEFAULT NULL,
	payment_status VARCHAR(255),
	payment_method VARCHAR(255),
	collected_date Date default null,
	date_created datetime NOT NULL DEFAULT current_timestamp(),
	date_updated datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 	PRIMARY KEY (`id`),
	KEY `idx_contract_no` (`contract_no`),
  	KEY `idx_target_month` (`target_month`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2. Create table target
CREATE TABLE sme_projectlist_target (
	id INT(11) NOT NULL AUTO_INCREMENT,	-- Unique identifier for each row
	contract_no VARCHAR(50) NOT NULL,	-- Contract number, max length of 50 characters
	target_month DATE NOT NULL,		-- Target month stored as a date
	now_amount_usd DECIMAL(15, 2), 		-- Amount in USD, with precision up to 2 decimal places
	date_created datetime NOT NULL DEFAULT current_timestamp(),
	date_updated datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (id),
	KEY `idx_contract_no` (`contract_no`),
	KEY `idx_target_month` (`target_month`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- 3. Create table collected
CREATE TABLE sme_projectlist_collected (
	id INT(11) not null auto_increment,
	target_id INT NOT NULL,
	contract_no VARCHAR(50),
	target_month DATE NOT NULL,
	ho_br VARCHAR(100),
	sales_gdept VARCHAR(100),
	sales_dept VARCHAR(100),
	sales_sec_branch VARCHAR(100),
	sales_unit VARCHAR(100),
	sales_staff VARCHAR(100),
	collection_staff VARCHAR(100),
	collection_cc_staff VARCHAR(100),
	seized_car VARCHAR(100),
	payment_status VARCHAR(50),
	payment_method VARCHAR(50),
	collected_date DATE,
	payment_rank VARCHAR(50),
	date_created datetime NOT NULL DEFAULT current_timestamp(),
	date_updated datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (id),
	KEY `idx_target_id` (`target_id`),
	KEY `idx_contract_no` (`contract_no`),
	KEY `idx_target_month` (`target_month`),
	KEY `idx_payment_status` (`payment_status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- 4. Create table sme_org
CREATE TABLE `sme_org` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`affiliation` varchar(255) DEFAULT NULL,
	`director` varchar(255) DEFAULT NULL,
	`g-dept_no` int(11) NOT NULL,
	`g-dept` varchar(255) DEFAULT NULL,
	`dept_no` int(11) NOT NULL,
	`dept` varchar(255) DEFAULT NULL,
	`sec_branch_no` int(11) NOT NULL,
	`sec_branch` varchar(255) DEFAULT NULL,
	`unit_no` int(11) NOT NULL,
	`unit` varchar(255) DEFAULT NULL,
	`m-unit_no` int(11) NOT NULL,
	`mini_unit` varchar(255) DEFAULT NULL,
	`sales_pair` varchar(255) DEFAULT NULL,
	`sales_cc` varchar(255) DEFAULT NULL,
	`staff_no` varchar(255) DEFAULT NULL,
	`staff_name` varchar(255) DEFAULT NULL,
	`gender` varchar(255) DEFAULT NULL,
	`former_job` varchar(255) DEFAULT NULL,
	`hire_date` date NOT NULL,
	`title` varchar(255) DEFAULT NULL,
	`h_b` varchar(255) DEFAULT NULL,
	`rank` int(11) NOT NULL,
	`retirement_date` date DEFAULT NULL,
	`datetime_update` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`id`),
	KEY `idx_staff_no` (`staff_no`),
	KEY `idx_unit_no` (`unit_no`),
	KEY `idx_rank` (`rank`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



-- 5. Create table Employees
CREATE TABLE `tabsme_Employees` (
	`name` varchar(140) NOT NULL,
	`creation` datetime(6) DEFAULT NULL,
	`modified` datetime(6) DEFAULT NULL,
	`modified_by` varchar(140) DEFAULT NULL,
	`owner` varchar(140) DEFAULT NULL,
	`docstatus` int(1) NOT NULL DEFAULT 0,
	`idx` int(8) NOT NULL DEFAULT 0,
	`staff_no` varchar(140) DEFAULT NULL,
	`staff_name` varchar(140) DEFAULT NULL,
	`gender` varchar(140) DEFAULT NULL,
	`first_name_lo` varchar(140) DEFAULT NULL,
	`last_name_lo` varchar(140) DEFAULT NULL,
	`first_name_en` varchar(140) DEFAULT NULL,
	`last_name_en` varchar(140) DEFAULT NULL,
	`branch` varchar(140) DEFAULT NULL,
	`department` varchar(140) DEFAULT NULL,
	`job_title` varchar(140) DEFAULT NULL,
	`_user_tags` text DEFAULT NULL,
	`_comments` text DEFAULT NULL,
	`_assign` text DEFAULT NULL,
	`_liked_by` text DEFAULT NULL,
	`parent` varchar(140) DEFAULT NULL,
	`parenttype` varchar(140) DEFAULT NULL,
	`parentfield` varchar(140) DEFAULT NULL,
	`staff_status` varchar(255) DEFAULT NULL,
	`main_contact` varchar(140) DEFAULT NULL,
	`assignee` varchar(140) DEFAULT NULL,
	`date_resigned` date DEFAULT NULL,
	`email` varchar(140) DEFAULT NULL,
	PRIMARY KEY (`name`),
	KEY `modified` (`modified`),
	KEY `idx_staff_no` (`staff_no`),
	KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;



show index from sme_project_list;
CREATE INDEX idx_contract_no ON sme_project_list (contract_no);
CREATE INDEX idx_target_month ON sme_project_list (target_month);


show index from sme_projectlist_target;
CREATE INDEX idx_contract_no ON sme_projectlist_target (contract_no);
CREATE INDEX idx_target_month ON sme_projectlist_target (target_month);


show index from sme_projectlist_collected;
CREATE INDEX idx_contract_no ON sme_projectlist_collected (contract_no);
CREATE INDEX idx_target_id ON sme_projectlist_collected (target_id);
CREATE INDEX idx_target_month ON sme_projectlist_collected (target_month);
CREATE INDEX idx_payment_status ON sme_projectlist_collected (payment_status);


ALTER TABLE sme_projectlist_target 
CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ------------------------------------ Workflow to update ------------------------------------


#=========== check and fix Reason: SQL Error [1292] [22001]: Data truncation: Incorrect date value: '0000-00-00' for column `test`.`tbl collection`.`transfer date` at row 1 ======
select @@global.sql_mode global, @@session.sql_mode session;
set sql_mode = '', global sql_mode = '';



-- 1 update sme_project list in spreadsheet Example: https://docs.google.com/spreadsheets/d/1iZIPNZDR4q5xnQMlXx8dc6W2nL2f9FMT5B2IikEZt_s/edit?gid=1031641098#gid=1031641098

-- sheet [For_Frappe]
-- then save csv file to table: sme_project_list
-- then run sql to update target: 




-- 2. After import 3 files as This month, Last month, 2 months delay

-- 2.1 sql for update target
INSERT INTO sme_projectlist_target (id, contract_no, target_month, now_amount_usd)
SELECT null AS 'id',spl.contract_no AS 'contract_no',spl.target_month AS 'target_month',spl.now_amount_usd AS 'now_amount_usd' 
FROM sme_project_list spl 
LEFT JOIN sme_projectlist_target spt on (spl.contract_no = spt.contract_no and spl.target_month = spt.target_month)
WHERE spl.target_month is not null
	and spt.id is null;


-- 2.2 for collected
INSERT INTO sme_projectlist_collected
SELECT
	NULL AS 'id',
	spt.id AS 'target_id',
	spt.contract_no AS 'contract_no',
	spt.target_month AS 'target_month',
	sorg.affiliation AS 'ho_br',
	sorg.`g-dept` AS 'sales_gdept',
	sorg.dept AS 'sales_dept',
	sorg.sec_branch AS 'sales_sec_branch',
	sorg.unit AS 'sales_unit',
	CONCAT(sorg.staff_no ," - ",sorg.staff_name) AS 'sales_staff',
	ep_c.name AS 'collection_staff',
	ep_cc.name AS collection_cc_staff,
	spl.seized_car  AS 'seized_car',
	spl.payment_status  AS 'payment_status',
	spl.payment_method AS 'payment_method',
	spl.collected_date AS 'collected_date',
	    CASE 
	        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') < DATE_FORMAT(spl.target_month,'2024-01-01') THEN '-'
		    WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-05') THEN 'S'
	        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-10') THEN 'A'
	        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-20') THEN 'B'
	        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-31') THEN 'C'
	        ELSE 'F'
	    END AS 'payment_rank',
	NOW() AS date_created,
	NOW() AS date_updated
	-- spc.target_id 
FROM sme_projectlist_target spt
LEFT JOIN sme_project_list spl on (spl.contract_no = spt.contract_no and spl.target_month = spt.target_month)
LEFT JOIN sme_projectlist_collected spc on (spt.contract_no = spc.contract_no and spt.id = spc.target_id)
LEFT JOIN sme_org sorg on (spl.sale_staff = sorg.staff_no)
LEFT JOIN tabsme_Employees ep_c on (ep_c.staff_no = spl.collection_staff)
LEFT JOIN tabsme_Employees ep_cc on (ep_cc.staff_no = spl.collection_cc_staff)
WHERE (spl.payment_status in ('already paid') or spl.seized_car  = 'Got car')
	AND spc.id IS NULL



-- 3. Check the issue 
-- 3.1 Main check
SELECT spl.target_month, COUNT(*) AS spl_target, 
	SUM(CASE WHEN spl.payment_status = 'already paid' THEN 1 ELSE 0 END) AS spl_already_paid,
	spt.spt_target , spc.spc_already_paid,
	COUNT(*) - spt.spt_target AS target_dff,
	SUM(CASE WHEN spl.payment_status = 'already paid' THEN 1 ELSE 0 END) - spc.spc_already_paid AS already_paid_dff
FROM sme_project_list spl
LEFT JOIN (SELECT target_month, COUNT(*) AS spt_target FROM sme_projectlist_target GROUP BY target_month
	) AS spt ON (spl.target_month = spt.target_month)
LEFT JOIN (SELECT target_month, COUNT(*) AS spc_already_paid FROM sme_projectlist_collected GROUP BY target_month
	) AS spc ON (spl.target_month = spc.target_month)
	WHERE spl.date_created >= '2025-01-15 19:00'
GROUP BY spl.target_month;
-- 
target_month|spl_target|spl_already_paid|spt_target|spc_already_paid|target_dff|already_paid_dff|
------------+----------+----------------+----------+----------------+----------+----------------+
            |      4425|             641|          |                |          |                |
  2024-11-05|      6179|            6154|      6179|            6171|         0|             -17|
  2024-12-05|      6225|            5906|      6225|            5915|         0|              -9|
  2025-01-05|      5475|            4376|      5475|            4376|         0|               0|


-- 3.2 sub1
SELECT spl.target_month, COUNT(*) AS spl_target, 
	SUM(CASE WHEN spl.payment_status = 'already paid' THEN 1 ELSE 0 END) AS spl_already_paid
FROM sme_project_list spl
WHERE spl.date_created >= '2025-01-14 18:00'
GROUP BY target_month;
-- 
target_month|spl_target|spl_already_paid|
------------+----------+----------------+
            |      4425|             641|
  2024-11-05|      6179|            6154|
  2024-12-05|      6225|            5906|
  2025-01-05|      5475|            4376|

-- 3.3 sub2
SELECT target_month, COUNT(*) AS spt_target FROM sme_projectlist_target GROUP BY target_month;
-- 
target_month|spt_target|
------------+----------+
  2024-11-05|      6179|
  2024-12-05|      6225|
  2025-01-05|      5516|

-- 3.4 sub3
SELECT target_month, COUNT(*) AS spc_already_paid FROM sme_projectlist_collected GROUP BY target_month;
-- 
target_month|spc_already_paid|
------------+----------------+
  2024-11-05|            6170|
  2024-12-05|            5913|
  2025-01-05|            4376|


-- Which contract number that is dff target
SELECT * 
FROM sme_projectlist_target spt 
WHERE spt.target_month = '2024-12-05' 
	AND spt.contract_no NOT IN ( 
		SELECT contract_no 
		FROM sme_project_list 
		WHERE target_month = '2024-12-05' AND date_created >= '2025-01-16 10:00' )
;
-- 
id  |contract_no|target_month|now_amount_usd|date_created       |date_updated       |
----+-----------+------------+--------------+-------------------+-------------------+
6709|2097765    |  2024-12-05|       1285.00|2025-01-15 11:29:04|2025-01-15 11:30:55|
9719|2110143    |  2024-12-05|      24110.00|2025-01-15 11:29:04|2025-01-15 11:30:55|



-- Which contract number that is dff already paid and seized car
SELECT * 
FROM sme_projectlist_collected spc 
WHERE spc.target_month = '2024-11-05' 
	AND spc.contract_no IN ( 
		SELECT contract_no
		FROM sme_project_list 
		WHERE target_month = '2024-11-05' AND date_created >= '2025-01-16 10:00' and (payment_status != 'already paid' and seized_car != 'Got car'))
;



-- 4. delete duplicate from sme_project_list
DELETE FROM sme_project_list WHERE `id` IN (
SELECT `id` FROM ( 
		SELECT `id`, contract_no, target_month, date_created ,
			ROW_NUMBER() OVER (
				PARTITION BY `contract_no` 
				ORDER BY DATE_FORMAT(date_created, '%Y-%m-%d') DESC,
					target_month DESC,
					id DESC
			) AS row_numbers  
		FROM sme_project_list
	) AS t1
WHERE row_numbers > 1 
);


-- 5 Check the different 
-- 5.1 check the target deduct or someone remove from today file
	SELECT spl.contract_no AS 'contract_no', 
		spl.target_month AS 'spl_target_month', spl.payment_status, spl.seized_car , spt.target_month AS 'spt_target_month',
		spl.now_amount_usd AS 'now_amount_usd' 
	FROM sme_project_list spl 
	LEFT JOIN sme_projectlist_target spt on (spl.contract_no = spt.contract_no )
	WHERE spl.target_month < spt.target_month OR (spl.target_month IS NULL AND spt.target_month IS NOT NULL)


-- 5.2 delete the different target
DELETE FROM sme_projectlist_target
WHERE id IN (
	SELECT spt.id
	FROM sme_project_list spl 
	LEFT JOIN sme_projectlist_target spt on (spl.contract_no = spt.contract_no )
	WHERE spl.target_month < spt.target_month OR (spl.target_month IS NULL AND spt.target_month IS NOT NULL)
	)
;



-- 5.3 check the already paid deduct or someone remove from today file (still not correct)
SELECT spl.contract_no AS 'contract_no',
	spl.target_month AS 'spl_target_month', spl.payment_status, spl.seized_car , spt.target_month AS 'spt_target_month',
	spl.now_amount_usd AS 'now_amount_usd' 
FROM sme_project_list spl 
LEFT JOIN sme_projectlist_target spt on (spl.contract_no = spt.contract_no )
LEFT JOIN sme_projectlist_collected spc ON (spt.id = spc.target_id)
WHERE spl.target_month < spt.target_month OR (spl.target_month IS NULL AND spt.target_month IS NOT NULL)






/*
-- delete duplicate from sme_project_list
DELETE FROM sme_projectlist_collected WHERE `id` IN (
SELECT `id` FROM ( 
		SELECT spt.`id`, ROW_NUMBER() OVER (PARTITION BY spt.`contract_no`, spt.target_month ORDER BY spt.target_month DESC, spt.`id` DESC) AS row_numbers  
		FROM sme_projectlist_target spt
		LEFT JOIN sme_projectlist_collected spc ON (spt.contract_no = spc.contract_no AND spt.id = spc.target_id)
	) AS t1
WHERE row_numbers > 1 
);
*/



-- Export to Sameera for Ticket https://redmine.lalco.la/issues/4170
SELECT contract_no, target_month, payment_status, null 'Partial amount'
FROM sme_project_list
WHERE target_month is not null
ORDER BY target_month DESC;


-- For Aiy Sai report to Morikawa
SELECT spl.contract_no, spl.seized_car, 
	spt1.target_month, spc1.payment_status, spc1.payment_method, 
	spt2.target_month, spc2.payment_status, spc2.payment_method, 
	spt3.target_month, spc3.payment_status, spc3.payment_method
FROM sme_project_list spl 
LEFT JOIN sme_projectlist_target spt1 ON (spl.contract_no = spt1.contract_no AND spt1.target_month = DATE_FORMAT(CURDATE(), '%Y-%m-05') )
LEFT JOIN sme_projectlist_target spt2 ON (spl.contract_no = spt2.contract_no AND spt2.target_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-05') )
LEFT JOIN sme_projectlist_target spt3 ON (spl.contract_no = spt3.contract_no AND spt3.target_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-05') )
LEFT JOIN sme_projectlist_collected spc1 ON (spl.contract_no = spc1.contract_no AND spc1.target_month = DATE_FORMAT(CURDATE(), '%Y-%m-05') )
LEFT JOIN sme_projectlist_collected spc2 ON (spl.contract_no = spc2.contract_no AND spc2.target_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-05') )
LEFT JOIN sme_projectlist_collected spc3 ON (spl.contract_no = spc3.contract_no AND spc3.target_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-05') );




-- ====================== this for prepare wa send to delay customer this month and last month ===================
CREATE TABLE wa_script (
    id INT PRIMARY KEY AUTO_INCREMENT,
    script_type VARCHAR(255),
    script_1 TEXT,
    script_2 TEXT,
    script_3 TEXT,
    script_4 TEXT,
    script_5 TEXT,
    script_6 TEXT,
    script_7 TEXT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ==================== This for export WA bulk mssg for send WA
SELECT 
    spl.contract_no AS 'WA',
    CONCAT(
        ws.script_1, "
", ws.script_2, spt.contract_no, ws.script_3, " ", spl.customer_name, "
", 
        ws.script_4, "
", ws.script_5, "
", ws.script_6," ",emc.staff_name," ",emc.main_contact, "
", ws.script_7, " ", ems.staff_name, " ", ems.main_contact
    ) AS 'BODY',
    spt.contract_no AS 'custom_id' 
FROM sme_projectlist_target spt
LEFT JOIN sme_project_list spl ON CAST(spt.contract_no AS CHAR) = CAST(spl.contract_no AS CHAR)
LEFT JOIN wa_script ws ON ws.script_type = 
-- 'Col_This_1-5'
-- 'Col_This_6-10'
-- 'Col_This_11-15'
-- 'Col_This_16-20'
-- 'Col_This_21-25'
-- 'Col_This_26-31'
-- 'Col_Last_1-5'
-- 'Col_Last_6-10'
-- 'Col_Last_11-15'
-- 'Col_Last_16-20'
-- 'Col_Last_21-25'
-- 'Col_Last_26-31'
LEFT JOIN tabsme_Employees emc ON CAST(spl.collection_cc_staff AS CHAR) = CAST(emc.staff_no AS CHAR)
LEFT JOIN tabsme_Employees ems ON CAST(spl.sale_staff AS CHAR) = CAST(ems.staff_no AS CHAR)
WHERE spt.id NOT IN ( SELECT CAST(target_id AS CHAR) FROM sme_projectlist_collected spc2)
and spl.target_month not in ('already paid')
and spl.target_month = '2025-01-05'
limit 10


-- == Ways 2
-- 2. export project list from LMS live project list by month
-- 3. then adjust like this, 1) insert col A for null. 2) insert now 2row then copy header from this link to check: https://docs.google.com/spreadsheets/d/1oD0r2ozGnW8-ejCaU8Bcm36x8DcvphfRf8UjYDCv0lo/edit?gid=1330890754#gid=1330890754
		-- 3) update date format 4 collumn and delete old header and the data type row. 4) save csv file
-- 4. truncate table: sme_collection_wa_msg by this sql

TRUNCATE TABLE sme_collection_wa_msg;

-- 5. import csv file to table: sme_collection_wa_msg
-- 6. run sql to export to table: sme_project_list
-- >> then start from 2 to 6 again about another month >> need to import 2month delay first then last month and this month

SELECT null as 'id',
 'month'
-- 'OA'
-- 'S'
-- 'No1 auto'
 as 'debt_type',
 '2024-12-05'
-- '2024-11-05'
 as 'target_month',
 null 'first_payment_date',
 null 'last_payment_date',
 scwm.contract_no as 'contract_no',
 scwm.customer_name as 'customer_name',
 scwm.customer_tel_1 as 'customer_tel',
 scwm.sales_no as 'sale_staff',
 scwm.collection_no as 'collection_staff',
 scwm.ccc_no as 'collection_cc_staff',
 scwm.now_amount_usd as 'now_amount_usd',
 scwm.`rank` as 'last_payment_rank',
 scwm.call_whom as 'call_to_whom',
 null as 'call_status',
 scwm.number_of_promise as 'number_of_promised',
 scwm.promise_date as 'promised_date',
 -- taoc.`date` as 'visit_date',
 scwm.gps_status as 'gps_status',
 scwm.exceptional as 'exceptional',
 scwm.seized_car as 'seized_car',
 scwm.paid_or_not as 'payment_status',
 scwm.payment_method as 'payment_method',
 scwm.date_of_pay as 'collected_date',
 CURRENT_DATE() as `datetime_update`
FROM sme_collection_wa_msg scwm 
left join tabActivity_of_collection taoc on taoc.name = (select name from tabActivity_of_collection where contract_no = scwm.contract_no and `date` >= DATE_FORMAT(NOW(),'%Y-%m-01') order by creation desc limit 1)
where scwm.target = 1;



