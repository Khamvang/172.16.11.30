


-- export all call rank
select datetime_sync 'Date', contract_no, str_to_date(neg_updated, '%Y-%m-%d') 'neg_date', visit_or_not, left(neg_with, locate(' -' ,neg_with)-1) `neg_with`, 
	concat(9, main_contact_no) 'customer phone' , rank_after_visited, last_nego_staff_no, last_nego_name
from dormant_and_existing  
 where str_to_date(neg_updated, '%Y-%m-%d') >= '2024-08-01' and rank_after_visited != ''
-- where rank_after_visited = 'Z1 ບໍ່ມັກ Lalco'
order by id desc;



-- export call rank of each negotiate with
select  contract_no, str_to_date(neg_updated, '%Y-%m-%d') 'neg_date', visit_or_not, left(neg_with, locate(' -' ,neg_with)-1) `neg_with`, rank_after_visited, last_nego_staff_no, last_nego_name 
 from dormant_and_existing where left(neg_with, locate(' -' ,neg_with)-1) = 'Customer' and str_to_date(neg_updated, '%Y-%m-%d') >= '2024-08-01'
-- from dormant_and_existing where left(neg_with, locate(' -' ,neg_with)-1) = 'Guarantor' and str_to_date(neg_updated, '%Y-%m-%d') >= '2024-07-01'
 from dormant_and_existing where left(neg_with, locate(' -' ,neg_with)-1) not in ('Customer', 'Guarantor') and str_to_date(neg_updated, '%Y-%m-%d') >= '2024-08-01'
order by id desc;




-- Run on lalco server 18.140.117.112
-- Dormant customer info address on LMS Province, City, Village
select c.id 'contract_id', c.contract_no, cu.id 'customer_id',
	convert(cast(convert(concat(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo, ' / ', cu.customer_first_name_en, ' ', cu.customer_last_name_en ) using latin1) as binary) using utf8) 'customer_name',
	cu.main_contact_no ,
	-- replace(convert(cast(convert(pr.province_name using latin1) as binary) using utf8), left(pr.province_name, locate('-', pr.province_name)+1), '') `province_name_lo`, 
	convert(cast(convert(pr.province_name using latin1) as binary) using utf8) `address_province`,
	convert(cast(convert(concat(ci.city_name , ' - ', ci.city_name_lao) using latin1) as binary) using utf8) `address_district`,
	ci.city_name `address_district_en`,
	CASE WHEN cu.address_village_id != 0 THEN convert(cast(convert(concat(vi.village_name, ' - ' , vi.village_name_lao) using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END `address_village`,
	vi.pvd_id , convert(cast(convert(concat(bt.code, ' ', bt.type) using latin1) as binary) using utf8) 'business_type',
	convert(cast(convert(cu.occupation using latin1) as binary) using utf8) 'company_name'
from tblcontract c left join tblprospect p on (c.prospect_id = p.id)
left join tblcustomer cu on (cu.id = p.customer_id)
left join tblprovince pr on (cu.address_province = pr.id)
left join tblcity ci on (ci.id = cu.address_city)
left join tblvillage vi on (vi.id = cu.address_village_id)
left join tblbusinesstype bt on (bt.code = cu.business_type)
where c.status in (4,6,7);


-- export Guarantor data
select g.id, g.prospect_id, 
	convert(cast(convert(concat( g.guarantor_first_name_en, ' ', g.guarantor_last_name_en) using latin1) as binary) using utf8) 'guarantor_name_en',
	convert(cast(convert(concat( g.guarantor_first_name_lo, ' ', g.guarantor_last_name_lo ) using latin1) as binary) using utf8) 'guarantor_name_lo',
	g.guarantor_contact_no, convert(cast(convert(g.guarantor_occupation using latin1) as binary) using utf8) 'guarantor_occupation'
from tblguarantor g
where g.prospect_id in ()



-- Run on lalco server 18.140.117.112
-- Dormant customer for Daa 22 and Phout 577
select c.contract_no, cu.id 'customer_id', p.loan_amount , p.trading_currency 'currency',
	c.contract_date, c.date_closed , u.staff_no , u.nickname , 
	CASE c.status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Pending Approval' WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval' WHEN 4 THEN 'Active' WHEN 5 THEN 'Cancelled'
		WHEN 6 THEN 'Refinance' WHEN 7 THEN 'Closed' ELSE NULL
	END 'contract_status',
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) 'customer_name',
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	end `contact_no`,
	case when left (right (REPLACE ( cu.sec_contact_no , ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.sec_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.sec_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.sec_contact_no, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( cu.sec_contact_no, ' ', '') , 8))
	end `contact_no2`,
	convert(cast(convert(pv.province_name using latin1) as binary) using utf8) 'customer_province',
	ci.city_name 'customer_district',
	case when cu.address_village_id != 0 and convert(cast(convert(v.village_name_lao using latin1) as binary) using utf8) is null then v.village_name 
		when cu.address_village_id != 0 then convert(cast(convert(v.village_name_lao using latin1) as binary) using utf8)
		else convert(cast(convert(cu.address_village using latin1) as binary) using utf8) 
	end 'customer_village',
	v.pvd_id ,
	convert(cast(convert(cu.occupation using latin1) as binary) using utf8) 'customer_occupation',
	convert(cast(convert(cu.`position` using latin1) as binary) using utf8) 'customer_position',
	p.customer_monthly_income , p.customer_monthly_expenditure ,
	car.car_make 'maker', car.car_model 'model', av.collateral_year 'year',
	CASE p.contract_type WHEN 1 THEN 'SME Car' WHEN 2 THEN 'SME Bike' WHEN 3 THEN 'Car Leasing'
		WHEN 4 THEN 'Bike Leasing' when 5 then 'Real estate' ELSE NULL
	END 'contract_type'
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tblcustomer cu on (cu.id = p.customer_id)
left join tbluser u on (u.id = p.salesperson_id)
left join tblprovince pv on (pv.id = cu.address_province)
left join tblcity ci on (ci.id = cu.address_city)
left join tblvillage v on (v.id = cu.address_village_id)
left join tblprospectasset pa on (pa.prospect_id = p.id)
left join tblassetvaluation av on (av.id = pa.assetvaluation_id)
left join tblcar car on (car.id = av.collateral_car_id)
where c.status in (7) and u.staff_no in ('22', '577');




