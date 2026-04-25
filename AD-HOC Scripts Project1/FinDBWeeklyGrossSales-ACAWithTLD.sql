SELECT *
INTO #tld_sales
FROM TLD.dbo.tld_policies
WHERE date_sold BETWEEN '2025-10-01' AND '2025-10-31'
	AND product_plan IN (
		'MM','ACA'
		)

--drop table #findb_sales
SELECT FFMid
	,
	--ffm_app_id,
	convert(DATE, saleDate) saleDate
	,SalesType
	,Carrier
	,livesCount
	,
	--application_creation_date2, 
	--BOB_policyNumber, 
	--agent, 
	--policy_AOR,
	CONVERT(VARCHAR(250), NULL) AS policy_id
	,CONVERT(VARCHAR(250), NULL) AS Agent_Id
	,CONVERT(VARCHAR(250), NULL) AS Agent_name
	,CONVERT(VARCHAR(250), NULL) AS application_number
	,CONVERT(VARCHAR(250), NULL) AS carrier_name
	,CONVERT(VARCHAR(250), NULL) AS lead_id
	,CONVERT(VARCHAR(250), NULL) AS lead_vendor_id
	,CONVERT(VARCHAR(250), NULL) AS lead_vendor_name
	,CONVERT(VARCHAR(250), NULL) AS tracking_id
	,CONVERT(VARCHAR(250), NULL) AS reference_id
	,CONVERT(VARCHAR(250), NULL) AS referrer
	,CONVERT(VARCHAR(250), NULL) AS List_Vendor_Name
	,CONVERT(VARCHAR(250), NULL) AS [page]
	,CONVERT(VARCHAR(250), NULL) AS Division
	,CONVERT(VARCHAR(250), NULL) AS STATE
	,CONVERT(VARCHAR(250), NULL) AS Lead_Phone
	,CONVERT(VARCHAR(250), NULL) AS Policy_Status
	,CONVERT(VARCHAR(250), NULL) AS [Product]
	,CONVERT(VARCHAR(250), NULL) AS product_description
	,CONVERT(VARCHAR(250), NULL) AS product_plan
	,CONVERT(VARCHAR(250), NULL) AS lead_state
	,CONVERT(VARCHAR(250), NULL) AS lead_zipcode
	,CONVERT(DATE, NULL) AS date_created
	,CONVERT(DATE, NULL) AS date_modified
	,CONVERT(DATE, NULL) AS date_converted
	,CONVERT(DATE, NULL) AS date_verified
	,CONVERT(DATE, NULL) AS date_sold
	,CONVERT(DATE, NULL) AS date_cancelled
	,CONVERT(DATE, NULL) AS date_reactivated
	,CONVERT(DATE, NULL) AS date_refused
	,CONVERT(DATE, NULL) AS date_effective
	,CONVERT(DATE, NULL) AS Lead_ImportDate
	,CONVERT(VARCHAR(250), NULL) AS VendorIDsCombined
	,CONVERT(VARCHAR(250), NULL) AS VendorsCombined
	,CONVERT(DATE, NULL) AS date_terminate
	,CONVERT(DATE, NULL) AS date_issued
	,CONVERT(DATE, NULL) AS date_inforce
	,CONVERT(DATE, NULL) AS date_posted
	,CONVERT(DATE, NULL) AS date_drafted
	,CONVERT(DATE, NULL) AS date_paid
	,CONVERT(DATE, NULL) AS VRSN_ST_DTS
	,CONVERT(DATE, NULL) AS VRSN_END_DTS
	,CONVERT(DATE, NULL) AS INSERT_DTS
	,CONVERT(VARCHAR(10), NULL) AS Islocated
INTO #findb_sales
--from FINDB.ACA.HS_PoliciesLog_Locked
FROM FINDB.ACA.[WeeklyGrossSubmittedNumbers]
--where application_creation_date2 between '2025-10-01' and '2025-10-31' 
WHERE convert(DATE, saleDate) BETWEEN '2025-10-01' AND '2025-10-31'

UPDATE tgt
SET tgt.policy_id = src.policy_id
	,tgt.agent_id = src.agent_id
	,tgt.Agent_name = src.agent_first_name + ' ' + src.agent_last_name
	,tgt.application_number = src.application_number
	,tgt.carrier_name = src.carrier_name
	,tgt.lead_id = src.lead_id
	,tgt.lead_vendor_id = src.lead_vendor_id
	,tgt.lead_vendor_name = src.lead_vendor_name
	,tgt.lead_phone = src.lead_phone
	,tgt.product = src.product
	,tgt.product_description = src.product_description
	,tgt.product_plan = src.product_plan
	,tgt.lead_state = src.lead_state
	,tgt.lead_zipcode = src.lead_zipcode
	,tgt.date_created = src.date_created
	,tgt.date_modified = src.date_modified
	,tgt.date_converted = src.date_converted
	,tgt.date_verified = src.date_verified
	,tgt.date_sold = src.date_sold
	,tgt.date_cancelled = src.date_cancelled
	,tgt.date_reactivated = src.date_reactivated
	,tgt.date_refused = src.date_refused
	,tgt.date_effective = src.date_effective
	,tgt.date_terminate = src.date_terminate
	,tgt.date_issued = src.date_issued
	,tgt.date_inforce = src.date_inforce
	,tgt.date_posted = src.date_posted
	,tgt.date_drafted = src.date_drafted
	,tgt.date_paid = src.date_paid
	,tgt.Islocated = CASE 
		WHEN src.ffm_id IS NOT NULL
			THEN 'located'
		ELSE NULL
		END
FROM #findb_sales AS tgt
INNER JOIN TLD.dbo.tld_policies AS src
	ON tgt.FFMId = src.ffm_id

UPDATE tgt
SET tgt.tracking_id = src2.tracking_id
	,tgt.reference_id = src2.reference_id
	,tgt.referrer = src2.referrer
FROM #findb_sales AS tgt
INNER JOIN tld.dbo.TLD_Leads src2
	ON tgt.lead_id = src2.lead_id

SELECT TOP 1000 *
FROM #findb_sales
WHERE Islocated = 'located'

SELECT *
INTO #t
FROM (
	SELECT convert(VARCHAR, ListId) ListId
		,ListName
		,Vendor
		,VendorCampaignId
		,'Data Leads' Type
		,Division
		,'Five9' Flag
		,convert(VARCHAR, ListId) + 'Data Leads' + Division _Key
	FROM Dev_Foundation_DB.dbo.Vendor_ListMapping
	UNION ALL --#(lf)
	SELECT convert(VARCHAR, Vendor_Id)
		,Name
		,Name
		,Name
		,Type
		,Division
		,'TLD' Flag
		,convert(VARCHAR, Vendor_Id) + Type + Division
	FROM Dev_Foundation_DB.dbo.LeadVendorDetails
	
	UNION ALL
	
	SELECT Queue_Id
		,Queue_Name
		,Vendor
		,Vendor
		,Type
		,Division
		,'EnrollHere' Flag
		,Queue_Id + Type + Division
	FROM Dev_Foundation_DB.[dbo].[enrollHere_Queues]
	) a

--update r set lead_vendor_name = c.Vendor
--from #findb_sales r
--inner join #t c on r.lead_vendor_id = c.ListId
--update r set List_Vendor_Name = c.[Vendor Name], reference_id = [List ID]
----select *
--from #findb_sales r
--inner join Dev_Foundation_DB.dbo.[Convoso Sources] c on r.referrer = c.[List Name]
UPDATE r
SET List_Vendor_Name = c.[Vendor]
	,reference_id = [ListID]
--select top 100 *
FROM #findb_sales r
INNER JOIN Dev_Foundation_DB.dbo.Vendor_ListMapping c
	ON r.referrer = c.VendorCampaignId
		AND List_Vendor_Name = ''

UPDATE p
SET Division = l.Division
	,Referrer = VendorCampaignId
--select p.reference_id --, l.ListId, *
FROM #findb_sales p
INNER JOIN Dev_Foundation_DB.dbo.Vendor_ListMapping l
	ON isnumeric(p.reference_id) = 1
		AND p.reference_id = l.ListId --and VendorType = 'Data Leads'
		AND lead_vendor_id IN (
			'25573'
			,'23618'
			,'27540'
			)

UPDATE p
SET Division = l.Division
	,p.reference_id = l.ListId
--select p.reference_id , l.ListId, *
FROM #findb_sales p
INNER JOIN #t l
	ON p.Referrer = l.VendorCampaignId --and VendorType = 'Data Leads'
		--and p.Division = ''  and l.Division > ''
		--and lead_vendor_id in ('25573','23618','27540')

UPDATE p
SET Division = l.Division
--select p.lead_vendor_id --, l.Vendor_Id, *
FROM #findb_sales p
INNER JOIN #t l
	ON p.lead_vendor_id = l.ListId --and VendorType = 'Non-Data Leads'
		--and p.Division = '' and l.Division > ''
		--and lead_vendor_id in ('25573','23618','27540')

SELECT *
FROM #t
WHERE Division = ''

UPDATE a
SET a.tld_table = b.ffm_id
FROM #findb_sales a
INNER JOIN TLD.dbo.tld_policies b
	ON a.ffm_app_id = b.ffm_id

SELECT Queue_Id
	,Queue_Name
	,Vendor
	,Vendor
	,Type
	,Division
	,'EnrollHere' Flag
	,Queue_Id + Type + Division
FROM Dev_Foundation_DB.[dbo].[enrollHere_Queues]

SELECT TOP 100 *
FROM #findb_sales
WHERE tld_table = ''

SELECT TOP 10 policy_id
	,Agent_Id
	,Agent_name
	,application_number
	,carrier_name
	,lead_id
	,lead_vendor_id
	,lead_vendor_name
	,tracking_id
	,reference_id
	,referrer
	,List_Vendor_Name
	,[page]
	,Division
	,STATE
	,Lead_Phone
	,Policy_Status
	,[Product]
	,product_description
	,product_plan
	,lead_state
	,lead_zipcode
	,date_created
	,date_modified
	,date_converted
	,date_verified
	,date_sold
	,date_cancelled
	,date_reactivated
	,date_refused
	,date_effective
	,Lead_ImportDate
	,VendorIDsCombined
	,VendorsCombined
	,date_terminate
	,date_issued
	,date_inforce
	,date_posted
	,date_drafted
	,date_paid
	,VRSN_ST_DTS
	,VRSN_END_DTS
	,INSERT_DTS
FROM Dev_Foundation_DB.dbo.PolicyDetails