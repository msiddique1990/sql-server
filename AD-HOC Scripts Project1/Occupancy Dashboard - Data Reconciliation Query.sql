SELECT uniqueid
	,total_talk_sec
	,total_wait_sec
FROM DataSyncerDB.[dbo].[TLD_AgentLogs_Staging]
WHERE [user] = '34710'
	AND convert(DATE, event_time) = '04/07/2025'
	AND uniqueid > ''

SELECT TOP 100 *
FROM DataSyncerDB.[dbo].[TLD_CallLogs_Staging]
WHERE agent_id = '34710'
	AND convert(DATE, call_Date) = '04/07/2025'
	AND uniqueid IN (
		SELECT TOP 100 uniqueid
		FROM DataSyncerDB.[dbo].[TLD_AgentLogs_Staging]
		WHERE [user] = '34710'
			AND convert(DATE, event_time) = '04/07/2025'
			AND uniqueid > ''
		)
ORDER BY call_Date

SELECT [user]
	,convert(DATE, event_time) login_date
	,sum(convert(INT, total_active_sec)) / 3600.0 active_hours
	,sum(convert(INT, dispo_sec)) dispo_sec
	,sum(convert(INT, pause_sec)) pause_sec
	,sum(convert(INT, dead_sec)) dead_sec
	,RIGHT('0' + CAST(FLOOR(sum(convert(INT, total_active_sec)) / 3600.0) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(FLOOR((sum(convert(INT, total_active_sec)) / 3600.0 - FLOOR(sum(convert(INT, total_active_sec)) / 3600.0)) * 60) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(CAST((sum(convert(INT, total_active_sec)) / 3600.0 * 3600) AS INT) % 60 AS VARCHAR), 2) AS ActiveHrs
	,sum(convert(INT, total_work_sec)) / 3600.0 work_hours
	,RIGHT('0' + CAST(FLOOR(sum(convert(INT, total_work_sec)) / 3600.0) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(FLOOR((sum(convert(INT, total_work_sec)) / 3600.0 - FLOOR(sum(convert(INT, total_work_sec)) / 3600.0)) * 60) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(CAST((sum(convert(INT, total_work_sec)) / 3600.0 * 3600) AS INT) % 60 AS VARCHAR), 2) AS WorkHrs
	,sum(convert(INT, total_talk_sec)) total_talk_sec
	,RIGHT('0' + CAST(FLOOR(sum(convert(INT, total_talk_sec)) / 3600.0) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(FLOOR((sum(convert(INT, total_talk_sec)) / 3600.0 - FLOOR(sum(convert(INT, total_talk_sec)) / 3600.0)) * 60) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(CAST((sum(convert(INT, total_talk_sec)) / 3600.0 * 3600) AS INT) % 60 AS VARCHAR), 2) AS TalkHrs
	,sum(convert(INT, total_wait_sec)) total_wait_sec
	,RIGHT('0' + CAST(FLOOR(sum(convert(INT, total_wait_sec)) / 3600.0) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(FLOOR((sum(convert(INT, total_wait_sec)) / 3600.0 - FLOOR(sum(convert(INT, total_wait_sec)) / 3600.0)) * 60) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(CAST((sum(convert(INT, total_wait_sec)) / 3600.0 * 3600) AS INT) % 60 AS VARCHAR), 2) AS waitHrs
--select top 10 * 
FROM DataSyncerDB.[dbo].[TLD_AgentLogs_Staging]
WHERE --[user]='16125' and 
	convert(DATE, event_time) IN (
		'04/07/2025'
		,'04/08/2025'
		,'04/09/2025'
		,'04/10/2025'
		)
--and uniqueid > ''
GROUP BY [user]
	,convert(DATE, event_time)

--------------------------------------------------------------------------------------------------------------------------
SELECT agent_id
	,convert(DATE, call_date) login_date
	,sum(convert(INT, sec_talk)) total_talk_sec
	,RIGHT('0' + CAST(FLOOR(sum(convert(INT, sec_talk)) / 3600.0) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(FLOOR((sum(convert(INT, sec_talk)) / 3600.0 - FLOOR(sum(convert(INT, sec_talk)) / 3600.0)) * 60) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(CAST((sum(convert(INT, sec_talk)) / 3600.0 * 3600) AS INT) % 60 AS VARCHAR), 2) AS TalkHrs
	,sum(convert(INT, sec_wait)) total_wait_sec
	,RIGHT('0' + CAST(FLOOR(sum(convert(INT, sec_wait)) / 3600.0) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(FLOOR((sum(convert(INT, sec_wait)) / 3600.0 - FLOOR(sum(convert(INT, sec_wait)) / 3600.0)) * 60) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(CAST((sum(convert(INT, sec_wait)) / 3600.0 * 3600) AS INT) % 60 AS VARCHAR), 2) AS waitHrs
FROM DataSyncerDB.[dbo].[TLD_CallLogs_Staging]
WHERE --agent_id='34710' and 
	convert(DATE, call_date) = '04/07/2025'
	AND uniqueid <> ''
GROUP BY agent_id
	,convert(DATE, call_date)

---------------------- we are loading data into tables, let's say if a lead is being called, and its status is updated after some time, will the lead be loaded again with updated status? case is give
SELECT *
FROM DataSyncerDB.[dbo].[TLD_CallLogs_Staging]
WHERE uniqueid = 'A1-1744032614.162'

SELECT STATUS
	,status_name
	,COUNT(*)
FROM DataSyncerDB.[dbo].[TLD_CallLogs_Staging]
GROUP BY STATUS
	,status_name