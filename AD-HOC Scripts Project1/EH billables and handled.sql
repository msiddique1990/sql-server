SELECT *
	,convert(DATETIME, NULL) Lead_importDate
INTO #EnrollHere_Calls
FROM EHDB.dbo.CallLogs c
WHERE convert(DATE, createdAt) BETWEEN '2025-10-15' AND convert(DATE, getdate())

UPDATE c
SET Lead_importDate = p.created
FROM #EnrollHere_Calls c
INNER JOIN EHDB.[dbo].Leads p
	ON c.lead_id = p.lead_id

--select top 100 * from #EnrollHere_Calls
DECLARE @startDate DATE = '2025-10-15'
	,@EndDate DATE = convert(DATE, getdate())

SELECT convert(DATE, createdAt) Call_date
	,convert(DATE, Lead_importDate) Lead_Import_date
	,v.Queue_Id
	,v.Queue_Name VendorDescription
	,v.vendor
	,v.Division
	,[Type]
	,'Non-Data Leads' VendorType
	,count(CASE 
			WHEN wasconnected = 1
				AND v.type = 'vendor inbound'
				AND convert(INT, isnull(billable_isbillable, 0)) = 1
				THEN c.lead_phone
			ELSE NULL
			END) HandledInbound
	,count(DISTINCT CASE 
			WHEN wasconnected = 1
				AND v.type <> 'vendor inbound'
				AND c.direction = 'incoming'
				THEN c.lead_phone
			ELSE NULL
			END) HandledOther
	,sum(convert(INT, isnull(billable_isbillable, 0))) Billable
	,sum(isnull(billable_cost_total, 0)) Cost
INTO #IBCalls
-- select top 100 *
FROM #EnrollHere_Calls C
INNER JOIN dev_foundation_db.dbo.enrollHere_Queues v
	ON convert(DATE, C.createdAt) BETWEEN @startDate AND @EndDate
		AND convert(DATE, c.createdAt) BETWEEN v.date_Start AND cast(isnull(v.date_End, getdate()) AS DATE)
		AND c.Queue_Id = v.Queue_Id
GROUP BY convert(DATE, createdAt)
	,convert(DATE, Lead_importDate)
	,v.Queue_Id
	,v.Queue_Name
	,v.Division
	,[Type]
	,v.vendor
ORDER BY 1

SELECT Call_date
	,Queue_Id
	,sum(billable) leads
	,sum(HandledInbound) + sum(HandledOther) Handled
	,sum(HandledOther)
	,sum(HandledInbound)
	,sum(cost)
FROM #IBCalls
WHERE Queue_Id = '76vXjF9I72J1PjY68miN'
	AND Call_date = '2025-10-27'
GROUP BY Call_date
	,Queue_Id

--drop table #IBCalls
SELECT DISTINCT [Type]
	,queue_id
FROM #IBCalls
WHERE queue_id = '76vXjF9I72J1PjY68miN'
	AND CONVERT(DATE, Call_date) = '2025-10-27'
	AND direction = 'incoming'
	AND Division = 'MA'

SELECT count(DISTINCT lead_phone)
FROM #EnrollHere_Calls
WHERE queue_id = '76vXjF9I72J1PjY68miN'
	AND CONVERT(DATE, createdAt) = '2025-10-27'
	AND direction = 'incoming'
	AND wasConnected = 1

--select top 1000 * from Dev_Reporting_DB.dbo.Leads_Aggregate_By_Vendors
--where convert(date,call_date) = '10/15/2025' and Division = 'MA'
--and vendor_id = '1A2cquJ5NynEL2YsxTaq'
SELECT vendor_id
	,call_date
	,type
	,sum(leads) leads
	,sum(handled) handled
	,sum(leadcost) leadcost
	,sum(totalcost) totalcost
FROM Dev_Reporting_DB.dbo.Leads_Aggregate_By_Vendors
WHERE convert(DATE, call_date) >= '10/15/2025'
	AND Division = 'MA'
	AND vendor_id = '1A2cquJ5NynEL2YsxTaq'
GROUP BY vendor_id
	,call_date
	,type