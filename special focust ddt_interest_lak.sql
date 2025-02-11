-- ########### for inport the forcust case to frappe ###################
   
-- 1. import to frappe (basic information the focus coditions such as LAK, Special Interest, DDT)
-- 2. update the payment
-- 3. update the new condition change

   -- # update begining of month
contract_no
customer_name
customer_tel
first_payment_date
old_last_payment_date
old_payment_type
old_interest_rate
old_currency

	-- # daily update
contract_status -- need to update with payment status every day
sales -- need to update everyday refer payment file
collection_cc -- need to update everyday refer payment file
collection -- need to update everyday refer payment file
last_target -- need to update everyday refer payment file
payment_status -- need to update everyday refer payment file
payment_grade -- need to update everyday refer lms payment
delay_status -- need to recalculate everyday refer lms
s -- s_at_5th need to recalculate everyday refer lms
a -- a_at_10th need to recalculate everyday refer lms
b -- b_at_20th need to recalculate everyday refer lms
c -- c_at_30th need to recalculate everyday refer lms
f -- f_after_1_month need to recalculate everyday refer lms
date_change -- need to check and update by sales first if empty refer and update by lms
new_payment_type -- need to add by sales then will check and update refer lms
new_interest_rate -- need to add by sales then will check and update refer lms
new_currency -- need to add by sales then will check and update refer lms
new_contract_no -- need to add by sales then will check and update refer lms
start_date -- need to add by sales then will check and update refer lms > update schedule
end_date -- need to add by sales then will check and update refer lms > update schedule


-- begining of month

SELECT p.id as 'contract_no',
CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) 
AS 'customer_name',
    CASE 
        WHEN LEFT(RIGHT(REPLACE(cu.main_contact_no, ' ', ''), 8), 1) = '0' THEN CONCAT('03', RIGHT(REPLACE(cu.main_contact_no, ' ', ''), 8))
        WHEN LENGTH(REPLACE(cu.main_contact_no, ' ', '')) = 7 THEN CONCAT('030', REPLACE(cu.main_contact_no, ' ', ''))
        ELSE CONCAT('020', RIGHT(REPLACE(cu.main_contact_no, ' ', ''), 8))
    END AS 'customer_tel',
    CASE p.payment_schedule_type 
        WHEN '1' THEN 'Normal' 
        WHEN '2' THEN 'Bullet' 
        WHEN '3' THEN 'Bullet-MOU'
        ELSE '' 
    END as 'old_payment_type',
p.no_of_payment,
p.first_payment_date,
p.last_payment_date as 'old_last_payment_date',
p.monthly_interest as 'old_interest_rate',
p.trading_currency as 'old_currency'
FROM tblcontract c
left join tblprospect p on (c.prospect_id = p.id)
LEFT JOIN tblcustomer cu on (p.customer_id = cu.id)
WHERE c.status in (4) 
 and p.trading_currency in ('LAK') -- use for LAK currency only
-- and p.payment_schedule_type in (2) -- use for DDT
-- and p.monthly_interest in (1.29, 1.99) and p.initial_date >= '2024-01-02' -- use for special interest

 
-- #### update everyday

 SELECT c.contract_no,
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
    pl.sale_staff ,
    pl.collection_cc_staff ,
    pl.collection_staff ,
    pl.target_month as 'last_target',
    pl.now_amount_usd as 'now_amount_usd',
    pl.payment_status,
    null as 'payment_grade',
    null as 'delay_status',
count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		then 1 end ) 'paid_times',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) <= 0 then 1 end) as 's' -- 'S_at_5th',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) > 0 and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) <= 5 then 1 end) as 'a' -- 'A_at_10th',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) > 5 and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) <= 20 then 1 end) as 'b' --  'B_at_20th',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) > 20 and TIMESTAMPDIFF(month,pm.due_date, co.date_collected) = 0 then 1 end) as 'c' -- 'C_at_31st',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(month,pm.due_date, co.date_collected) >= 1 then 1 end) as 'f' -- 'F_after_1_month' 
	p.payment_schedule_type as 'new_payment_type',
	p.monthly_interest as 'new_interest_rate',
	p.trading_currency as 'new_currency',
	null as 'start_date',
	null as 'end_date'
 FROM tblcontract c 
 left join tblprospect p on (c.prospect_id = c.id)
 LEFT join tblpayment pm on (c.id = pm.contract_id)
 left JOIN tblcollection co on (co.contract_id  = c.id)
 LEFT JOIN sme_project_list pl on (pl.contract_no = c.prospect_id)
