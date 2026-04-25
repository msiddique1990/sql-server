SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [Dev_Foundation_DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_EH_Agents]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		SELECT *
			,CASE 
				--WHEN CHARINDEX('Manager ', teamNames) > 0 OR CHARINDEX('Daniel ', teamNames) > 0 THEN
				WHEN CHARINDEX('Manager ', teamNames) > 0
					THEN LTRIM(SUBSTRING(teamNames, CHARINDEX('Manager ', teamNames) + 8, CHARINDEX(',', teamNames + ',', CHARINDEX('Manager ', teamNames)) - (CHARINDEX('Manager ', teamNames) + 8)))
				ELSE NULL
				END AS ManagerName
			,CASE 
				WHEN CHARINDEX('Team ', teamNames) > 0
					THEN LTRIM(SUBSTRING(teamNames, CHARINDEX('Team ', teamNames) + 5, CHARINDEX(',', teamNames + ',', CHARINDEX('Team ', teamNames)) - (CHARINDEX('Team ', teamNames) + 5)))
				ELSE NULL
				END AS TeamLead
			,space(100) AgentType
			,space(100) PaymentTypes
		INTO #raw_agents
		FROM ehdb.[dbo].[Users]

		--drop table #raw_agents
		--select * from #raw_agents where usertype = 'agent'
		UPDATE a
		SET a.AgentType = CASE 
				WHEN a.allTags LIKE '%w2%'
					THEN 'Medicare w2'
				WHEN (a.allTags LIKE '%1099 Hourly%')
					THEN 'Medicare 1099 Hourly'
				WHEN (a.allTags LIKE '%1099 Hourly%')
					THEN 'Medicare 1099 Hourly'
				WHEN (a.allTags LIKE '%1099 Comp 200%')
					THEN 'Medicare 1099 Comp 200'
				WHEN (a.allTags LIKE '%1099 Comp 135%')
					THEN 'Medicare 1099 Comp 135'
				END
		FROM #raw_agents a

		UPDATE a
		SET a.PaymentTypes = CASE 
				WHEN a.allTags LIKE '%HEAP%'
					THEN 'Heap'
				WHEN (a.allTags LIKE '%As Earned%')
					THEN 'As Earned'
				END
		FROM #raw_agents a

		-------------Testing change ------------------
		--select * 
		--from #raw_agents where userid = 'YTrMVZ37vDVm9dDd2k31WnA1vx42'
		--update a set a.allTags = 'Manager DelVaglio, Team Ludington, W2, As Earned'
		--from #raw_agents a
		--where a.userid = 'YTrMVZ37vDVm9dDd2k31WnA1vx42'
		--select * 
		--from #raw_agents where userid = 'YTrMVZ37vDVm9dDd2k31WnA1vx42'
		--select * from [Dev_Foundation_DB].dbo.agents_archive
		INSERT INTO [Dev_Foundation_DB].dbo.eh_agents_archive (
			userId
			,agencyId
			,agencyName
			,firstName
			,lastName
			,email
			,npn
			,manager
			,teamlead
			,userType
			,allTags
			,teamNames
			,licensedStates
			,paymentType
			,allPersonalDids
			,enabledDids
			,AgentType
			,PaymentTypes
			,isActive
			,hasAccessFromParent
			,lastupdated
			)
		SELECT d.userId
			,d.agencyId
			,d.agencyName
			,d.firstName
			,d.lastName
			,d.email
			,d.npn
			,d.manager
			,d.teamlead
			,d.userType
			,d.allTags
			,d.teamNames
			,d.licensedStates
			,d.paymentType
			,d.allPersonalDids
			,d.enabledDids
			,d.AgentType
			,d.PaymentTypes
			,d.isActive
			,d.hasAccessFromParent
			,d.lastupdated
		--,CASE
		--	WHEN ISNULL(d.role_ids, '') <> ISNULL(s.role_ids, '') THEN 'ROLE Changed'
		--	WHEN ISNULL(d.status, '') <> ISNULL(s.status, '') AND ISNULL(s.status, '') = 'Inactive' THEN 'Termed'
		--	ELSE NULL 
		--END AS change_status
		FROM [Dev_Foundation_DB].dbo.EH_agents d
		INNER JOIN
			--select * from
			#raw_agents s
			ON d.userId = s.userId
		WHERE d.agencyId <> s.agencyId
			OR d.agencyName <> s.agencyName
			OR d.firstName <> s.firstName
			OR d.lastName <> s.lastName
			OR d.email <> s.email
			OR d.npn <> s.npn
			OR d.manager <> s.manager
			OR d.teamlead <> s.teamlead
			OR d.userType <> s.userType
			OR d.allTags <> s.allTags
			OR d.teamNames <> s.teamNames
			OR d.licensedStates <> s.licensedStates
			OR d.paymentType <> s.paymentType
			OR d.allPersonalDids <> s.allPersonalDids
			OR d.enabledDids <> s.enabledDids
			OR d.isActive <> s.isActive
			OR d.hasAccessFromParent <> s.hasAccessFromParent

		-- Step 2: Perform UPSERT with MERGE
		MERGE INTO [Dev_Foundation_DB].dbo.EH_Agents AS TARGET
		USING (
			SELECT *
			FROM #raw_agents
			) AS SOURCE
			ON TARGET.userid = SOURCE.userid
		WHEN MATCHED
			AND (
				TARGET.agencyId <> SOURCE.agencyId
				OR TARGET.agencyName <> SOURCE.agencyName
				OR TARGET.firstName <> SOURCE.firstName
				OR TARGET.lastName <> SOURCE.lastName
				OR TARGET.email <> SOURCE.email
				OR TARGET.npn <> SOURCE.npn
				OR TARGET.manager <> SOURCE.manager
				OR TARGET.teamlead <> SOURCE.teamlead
				OR TARGET.userType <> SOURCE.userType
				OR TARGET.allTags <> SOURCE.allTags
				OR TARGET.teamNames <> SOURCE.teamNames
				OR TARGET.licensedStates <> SOURCE.licensedStates
				OR TARGET.paymentType <> SOURCE.paymentType
				OR TARGET.allPersonalDids <> SOURCE.allPersonalDids
				OR TARGET.enabledDids <> SOURCE.enabledDids
				OR TARGET.isActive <> SOURCE.isActive
				OR TARGET.hasAccessFromParent <> SOURCE.hasAccessFromParent
				)
			THEN
				UPDATE
				SET TARGET.agencyId = SOURCE.agencyId
					,TARGET.agencyName = SOURCE.agencyName
					,TARGET.firstName = SOURCE.firstName
					,TARGET.lastName = SOURCE.lastName
					,TARGET.email = SOURCE.email
					,TARGET.npn = SOURCE.npn
					,TARGET.manager = SOURCE.manager
					,TARGET.teamlead = SOURCE.teamlead
					,TARGET.userType = SOURCE.userType
					,TARGET.allTags = SOURCE.allTags
					,TARGET.teamNames = SOURCE.teamNames
					,TARGET.licensedStates = SOURCE.licensedStates
					,TARGET.paymentType = SOURCE.paymentType
					,TARGET.allPersonalDids = SOURCE.allPersonalDids
					,TARGET.enabledDids = SOURCE.enabledDids
					,TARGET.isActive = SOURCE.isActive
					,TARGET.hasAccessFromParent = SOURCE.hasAccessFromParent
					,TARGET.lastUpdated = GETDATE()
					,TARGET.AgentType = SOURCE.AgentType
					,TARGET.PaymentTypes = SOURCE.PaymentTypes
		WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (
					userId
					,agencyId
					,agencyName
					,firstName
					,lastName
					,email
					,npn
					,manager
					,teamlead
					,userType
					,allTags
					,teamNames
					,licensedStates
					,paymentType
					,allPersonalDids
					,enabledDids
					,AgentType
					,PaymentTypes
					,isActive
					,hasAccessFromParent
					)
				VALUES (
					SOURCE.userId
					,SOURCE.agencyId
					,SOURCE.agencyName
					,SOURCE.firstName
					,SOURCE.lastName
					,SOURCE.email
					,SOURCE.npn
					,SOURCE.manager
					,SOURCE.teamlead
					,SOURCE.userType
					,SOURCE.allTags
					,SOURCE.teamNames
					,SOURCE.licensedStates
					,SOURCE.paymentType
					,SOURCE.allPersonalDids
					,SOURCE.enabledDids
					,SOURCE.AgentType
					,SOURCE.PaymentTypes
					,SOURCE.isActive
					,SOURCE.hasAccessFromParent
					);

		--drop table #agents, #raw_agents
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END