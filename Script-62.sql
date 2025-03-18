



select datetime_sync 'Date', contract_no, str_to_date(neg_updated, '%Y-%m-%d') 'neg_date', visit_or_not, left(neg_with, locate(' -' ,neg_with)-1) `neg_with`, 
	concat(9, main_contact_no) 'customer phone' , rank_after_visited, last_nego_staff_no, last_nego_name
from dormant_and_existing  
where str_to_date(neg_updated, '%Y-%m-%d') >= '2024-11-01' and rank_after_visited != ''
-- where contract_no = '2067080'
-- where rank_after_visited = 'Z1 ບໍ່ມັກ Lalco'
order by id desc;




select  contract_no, str_to_date(neg_updated, '%Y-%m-%d') 'neg_date', visit_or_not, left(neg_with, locate(' -' ,neg_with)-1) `neg_with`, rank_after_visited, last_nego_staff_no, last_nego_name 
 from dormant_and_existing where left(neg_with, locate(' -' ,neg_with)-1) = 'Customer' and str_to_date(neg_updated, '%Y-%m-%d') >= '2024-11-01'
-- from dormant_and_existing where left(neg_with, locate(' -' ,neg_with)-1) = 'Guarantor' and str_to_date(neg_updated, '%Y-%m-%d') >= '2024-10-01'
-- from dormant_and_existing where left(neg_with, locate(' -' ,neg_with)-1) not in ('Customer', 'Guarantor') and str_to_date(neg_updated, '%Y-%m-%d') >= '2024-10-01'
order by id desc;



-- 7) Export from Server 172.16.11.30/ sme_salesresult/temp_sme_calldata_Dor_Inc to Server 13.250.153.252/_8abac9eed59bf169/`temp_sme_calldata_Dor_Inc` 
select * from temp_sme_calldata_Dor_Inc where contract_no = 2010125;



select distinct neg_method from dormant_and_existing


select * from dormant_and_existing where contract_no = 2010125 order by id desc;




-- ------------------------------------------------------------ "All DDT check payment history" -------------------------------------------------------------
-- https://docs.google.com/spreadsheets/d/12-L-kqOfd80RHTFrI_9mNF8rZJ5DRMIGvu4WU0Y5mx4/edit?gid=143595180#gid=143595180
select select c.contract_no, c.id 'contract_id', p.first_payment_date, null 'first_paymet_date_of_last_3months', p.last_payment_date,
	CASE c.status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement' WHEN 3 THEN 'Disbursement Approval'	
		WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled' WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
	END 'contract_status',	
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		then 1 end ) 'paid_times',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) <= 0 then 1 end) 'S_at_5th',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) > 0 and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) <= 5 then 1 end) 'A_at_10th',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) > 5 and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) <= 20 then 1 end) 'B_at_20th',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(day,pm.due_date, co.date_collected) > 20 and TIMESTAMPDIFF(month,pm.due_date, co.date_collected) = 0 then 1 end) 'C_at_31st',
	count(case when (( ((pm.type = 'interest' and pm.due_date != p.last_payment_date) or (pm.type = 'principal' and pm.due_date = p.last_payment_date) ) and p.payment_schedule_type = 2) or (pm.type = 'principal' and p.payment_schedule_type = 1) )	
		and TIMESTAMPDIFF(month,pm.due_date, co.date_collected) >= 1 then 1 end) 'F_after_1_month'
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblpayment pm on (c.id = pm.contract_id)
left join tblcollection co on (pm.collection_id = co.id)
left join 
where c.status in (4,6,7) and pm.status = 1 and co.status = 1 
	-- and c.contract_no in ()
group by c.contract_no ;


select * from sme_lock_down sld inner join tblcontract c on (sld.ncn = c.ncn)


select * from tblcontract where contract_no = 2063362 or id = 77614;


select * from tblpaymentschedule where prospect_id = 2063362;


select pm.id, pm.contract_id, pm.due_date, co.date_collected, pm.`type`, pm.amount, pm.status, co.status, pm.schedule_id 
from tblpayment pm 
left join tblcollection co on (pm.collection_id = co.id)
where pm.contract_id = 68466 order by pm.due_date ; -- 116921






-- 
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




-- data details
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




SELECT contract_no, target_month, seized_car, payment_status , date_created 
FROM sme_projectlist_collected spc 
WHERE target_month = '2024-11-05'


select * from sme_project_list spl where contract_no = 2087335



SELECT * FROM daily_work ;

SELECT * FROM `work` ;














