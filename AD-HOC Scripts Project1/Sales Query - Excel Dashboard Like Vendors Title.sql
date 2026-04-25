
--------------------------Start here ------------------
--drop table #sales
        SELECT s.*, 
               l.referrer, 
               l.reference_id, 
               l.vendor_id,
			   --v.name,
               CASE WHEN v.name is null then s.lead_vendor_name else v.name end name,
			   l.tracking_id
			   , SPACE(100) DashboardName
			   into #sales
        FROM tld.[dbo].[TLD_Policies] s
        LEFT JOIN [TLD].dbo.[TLD_Leads] l 
            ON s.lead_id = l.lead_id
        LEFT JOIN datasyncerdb.[dbo].[TLD_LeadVendors_Staging] v 
            ON l.vendor_id = v.vendor_id
        WHERE CONVERT(date, s.date_sold) BETWEEN '2025-10-13' AND '2025-10-19'--convert(date,getdate())

		--select count(*) from
  --tld.[dbo].[TLD_Policies]  WHERE CONVERT(date, date_converted) BETWEEN '2025-07-24' AND '2025-07-24' and product_plan in ('MA','MAPD')

  --		select count(*) from
  --tld.[dbo].[TLD_Policies]  WHERE CONVERT(date, date_sold) BETWEEN '2025-07-24' AND '2025-07-24' and product_plan in ('MA','MAPD')

-------------- ACA Dashboard Name Update ------------------------------------------------------------
		update a set a.dashboardname = b.dashboard_name
		from #sales a
		inner join 
		--select * from 
		TestDB.dbo.list_names b
		on a.lead_vendor_name = b.vendor_name AND a.referrer = b.referrer and b.product = 'ACA' and a.product_plan in ('MM','ACA')

		update a set a.dashboardname = b.dashboard_name
		from #sales a
		inner join 
		--select * from 
		TestDB.dbo.list_names b
		on a.lead_vendor_name = b.vendor_name and b.product = 'ACA' and isnull(a.DashboardName, '') = '' and a.product_plan in ('MM','ACA')

-------------- ACA Dashboard Name Update ------------------------------------------------------------

-------------- MA Dashboard Name Update ------------------------------------------------------------

		update a set a.dashboardname = b.dashboard_name
		from #sales a
		inner join 
		--select * from 
		TestDB.dbo.list_names b
		on a.lead_vendor_name = b.vendor_name AND a.referrer = b.referrer and b.product = 'MA' and a.product_plan in ('MA','MAPD')

		update a set a.dashboardname = b.dashboard_name
		from #sales a
		inner join 
		--select * from 
		TestDB.dbo.list_names b
		on a.lead_vendor_name = b.vendor_name and b.product = 'MA' and isnull(a.DashboardName, '') = '' and a.product_plan in ('MA','MAPD')

-------------- MA Dashboard Name Update END------------------------------------------------------------

		select DashboardName, COUNT(*) ACA_Sales from #sales
		where  product_plan in ('MM','ACA')
		group by DashboardName

		select DashboardName, COUNT(*) MED_Sales from #sales
		where product_plan in ('MA','MAPD')
		group by DashboardName
		order by 1

		select carrier_name, count(*) ACA_Sales
		from #sales where product_plan in ('MM','ACA')
		group by carrier_name

		select carrier_name, count(*) MED_Sales from #sales 
		where  product_plan in ('MA','MAPD')
		group by carrier_name



		select RowId, policy_id, account_id, lead_id, agent_id, date_created, date_verified,
		date_cancelled, date_converted, date_sold,carrier_name, product_plan_name, lead_phone, referrer, reference_id, vendor_id, name, DashboardName
		--into testdb.dbo.temporarySales 
		--drop table testdb.dbo.temporarySales 
		from #sales

		-------------------- end here -------------------------
		
		select DATEPART(ww,date_sold) _week, dashboardname, COUNT(*) from #sales --where isnull(DashboardName,'') = ''
		group by DATEPART(ww,date_sold) , dashboardname

		--select policy_id, name, referrer, DashboardName from #sales where isnull(DashboardName,'') = 'Old Data or non-1 to 1' and product_plan in ('MM','ACA')
		select * from #sales where referrer like '%zeel%' order by date_sold and lead_vendor_name = 'Medicare Inbound Generic'
		--select * from #sales where isnull(DashboardName,'') <> '' and product_plan in ('MM','ACA')
		--select * from #sales where isnull(DashboardName,'') = '' and product_plan in ('MA','MAPD')
		select * from #sales where isnull(name,'') = 'fire' and product_plan in ('MA','MAPD')
	