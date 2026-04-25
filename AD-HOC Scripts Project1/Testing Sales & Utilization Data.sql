
SELECT  
    DataDate,
    SUM(DATEDIFF(SECOND, 0, [Talk Time])) / 3600.0       AS TalkTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Wait Time])) / 3600.0       AS WaitTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Pause Time])) / 3600.0      AS PauseTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Wrap Up Time])) / 3600.0    AS WrapUpTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Non Pause time])) / 3600.0  AS NonPauseTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Total Time])) / 3600.0      AS TotalTimeHrs,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Talk Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS TalkTime_PCT,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Wait Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS WaitTime_PCT,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Pause Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS PauseTime_PCT,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Wrap Up Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS WrapUpTime_PCT
	into testdb.[dbo].[Agg_Agent_Success_ACA]
FROM testdb.[dbo].[Agent_Success_ACA]
GROUP BY DataDate  
ORDER BY DataDate;

select * from testdb.[dbo].[Agg_Agent_Success_ACA]
select * from testdb.[dbo].[Agg_Agent_Success_MA]

SELECT  
    DataDate,
    SUM(DATEDIFF(SECOND, 0, [Talk Time])) / 3600.0       AS TalkTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Wait Time])) / 3600.0       AS WaitTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Pause Time])) / 3600.0      AS PauseTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Wrap Up Time])) / 3600.0    AS WrapUpTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Non Pause time])) / 3600.0  AS NonPauseTimeHrs,  
    SUM(DATEDIFF(SECOND, 0, [Total Time])) / 3600.0      AS TotalTimeHrs,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Talk Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS TalkTime_PCT,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Wait Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS WaitTime_PCT,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Pause Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS PauseTime_PCT,  
    CAST(SUM(DATEDIFF(SECOND, 0, [Wrap Up Time])) * 100.0 / NULLIF(SUM(DATEDIFF(SECOND, 0, [Total Time])), 0) AS DECIMAL(10,2)) AS WrapUpTime_PCT
	into testdb.[dbo].[Agg_Agent_Success_MA]
FROM testdb.[dbo].[Agent_Success_MA]
GROUP BY DataDate  
ORDER BY DataDate;



select vendor_id,agency ,datepart(week, convert(date, call_date)) week, min(convert(date, call_date)) WeekStartDate,
count (case when call_direction = 'Inbound' and handled = 1 then phone_number end) 
select top 10 * 
from tld .. TLD_CallLogs where convert(date, call_date) between '01/01/2025' and '08/31/2025'
and vendor_id in (12209, 12208)
group by vendor_id, datepart(week, convert(date, call_date)),agency
order by 2


select top 100	convert(date,Left(Application_Creation_date2,10)) Application_Creation_date2,
				--ffm_App_id, 
				sum(convert(int,[MemberCount- LIVES])) OnlyLivesCount, 
				sum([Total Lives])
from FINDB.ACA.HS_PolicieswithBOBMatching a (nolock)
where	policy_status  like '%Effectuat%' 
and		Policy_CurrentStatus ='Active'
and convert(date,Left(Application_Creation_date2,10)) between '2025-06-01' and '2025-08-10'
group by convert(date,Left(Application_Creation_date2,10))
ORDER BY 1



select top 100	datepart(week, convert(date,Left(Application_Creation_date2,10))) Application_Creation_Week, min(convert(date,Left(Application_Creation_date2,10))) week_start,
				--ffm_App_id, 
				sum(convert(int,[MemberCount- LIVES])) OnlyLivesCount, 
				sum([Total Lives]) [Total Lives]
from FINDB.ACA.HS_PolicieswithBOBMatching a (nolock)
where	
--policy_status  like '%Effectuat%' 
--and		Policy_CurrentStatus ='Active'
--and 
convert(date,Left(Application_Creation_date2,10)) between '2025-06-01' and '2025-08-10'
group by datepart(week, convert(date,Left(Application_Creation_date2,10)))
ORDER BY 1;



with SalesData AS (
select convert(date,Left(Application_Creation_date2,10)) Creation_date,
				ffm_App_id, 
case when isnull([spouse_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_1_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_2_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_3_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_4_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_5_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_6_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_7_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_8_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_9_applying]	,'')='True' then 1 else 0 end +
							case when isnull([other_10_applying],'')='True' then 1 else 0 end Policy_Count,
							[Total Lives]
from [FinDB].[ACA].HS_PolicieswithBOBMatching a)
select datepart(week,Creation_date) week_num, min(Creation_date) week_start, sum(Policy_Count+[Total Lives]) from SalesData 
where Creation_date between '2025-06-01' and '2025-08-10'
group by datepart(week,Creation_date);


select * from testdb.[dbo].[live_sold] where convert(date,date) between '2025-06-01' and '2025-08-10'


