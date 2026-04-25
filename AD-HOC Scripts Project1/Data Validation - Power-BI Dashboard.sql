
select VendorDescription, Type, sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-11' and '2025-08-17'
and Division = 'MA'
group by VendorDescription, Type

select sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-11' and '2025-08-17'
and Division = 'MA'




--MA Cost in Dashboard $337,118 
-- 1168 sales matches with the dashboard.

select VendorDescription, Type, sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-18' and '2025-08-24'
and Division = 'MA'
group by VendorDescription, Type

select sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-18' and '2025-08-24'
and Division = 'MA'



select DATEPART(ISO_WEEK, call_date) _week, min(call_date), max(call_date), sum(convert(float,TotalCost)) as labor_cost from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-05-12' and '2025-08-31'
and Division = 'MA'
group by DATEPART(ISO_WEEK, call_date)
order by 2



select DATEPART(ISO_WEEK, call_date) _week, min(call_date), max(call_date), sum(convert(float,leadcost)) as LEad_cost from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-05-12' and '2025-08-31'
and Division = 'MA'
group by DATEPART(ISO_WEEK, call_date)
order by 2


select sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-11' and '2025-08-17'
and Division = 'MA'

select sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-11' and '2025-08-17'
and Division = 'MA'

select sum(convert(float,leadcost))+sum(convert(float,Cost))+sum(convert(float,TotalCost)) from [TestDB].[dbo].Leads_Aggregate_By_Vendors
where --VendorDescription = 'Medicare Interactive Inbound' and 
call_date between '2025-08-11' and '2025-08-17'
and Division = 'MA'
