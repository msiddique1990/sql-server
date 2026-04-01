
use DataSyncerDB


 --CREATE TABLE TestDB.dbo.Agents_archive (
-- CREATE TABLE TestDB.dbo.Agents(
--    -- Same schema as dim_agents
--	[RowId] [int] IDENTITY(1,1) NOT NULL,
--    user_id VARCHAR(100) NULL,
--    date_created DATETIME NULL,
--    date_modified DATETIME NULL,
--    date_activated DATETIME NULL,
--    date_deactivated DATETIME NULL,
--    date_email_verified DATETIME NULL, 
--    date_hired DATETIME NULL,
--    agency_id INT NULL,
--    username VARCHAR(100) NULL,
--    email VARCHAR(100) NULL,
--    email_verified VARCHAR(100) NULL,
--    first_name VARCHAR(100) NULL,
--    middle_name VARCHAR(500) NULL,
--    last_name VARCHAR(100) NULL,
--    full_name VARCHAR(250) NULL,
--    group_ids VARCHAR(70) NULL,
--    group_names VARCHAR(250) NULL,
--    group_descriptions VARCHAR(250) NULL,
--    leader_id VARCHAR(50) NULL,
--    leader_name VARCHAR(250) NULL,
--    leader_full_name VARCHAR(250) NULL,
--    status VARCHAR(20) NULL,
--    licensed_states VARCHAR(MAX) NULL,
--    ffm_id VARCHAR(20) NULL,
--    healthsherpa_user_id VARCHAR(20) NULL,
--    language VARCHAR(100) NULL,
--    npn INT NULL,
--    ein INT NULL,
--    enforce_ca_login VARCHAR(10) NULL,
--    personal_address VARCHAR(250) NULL,
--    personal_address2 VARCHAR(250) NULL,
--    personal_city VARCHAR(100) NULL,
--    personal_dob DATETIME NULL,
--    personal_email VARCHAR(100) NULL,
--    personal_phone VARCHAR(15) NULL,
--    personal_ssn VARCHAR(20) NULL,
--    personal_state VARCHAR(2) NULL, 
--    personal_zipcode VARCHAR(15) NULL,
--    sms_cid BIGINT NULL,
--    sms_enabled VARCHAR(5) NULL,
--    agency_name VARCHAR(10) NULL,
--    agency_description VARCHAR(10) NULL,
--    agency VARCHAR(10) NULL,
--    role_ids VARCHAR(100) NULL,  
--    role_names VARCHAR(250) NULL,
--    role_descriptions VARCHAR(250) NULL,
--    team_lead VARCHAR(250) NULL,
--    manager VARCHAR(250) NULL,
--    executive VARCHAR(250) NULL,
--    unassigned VARCHAR(250) NULL,
--    FetchDate DATETIME,
--    --ArchivedDate DATETIME DEFAULT GETDATE()

--PRIMARY KEY CLUSTERED 
--(
--	[RowId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO


--select * from TestDB.dbo.agents_archive


CREATE PROCEDURE Upsert_Agents
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

					select  *,
					case when group_name like '%Team%' then 'Team_Lead' end as team_lead,
					case when group_name like '%Managed%' then 'Manager' end as manager,
					case when group_name like '%Unassigned%' then 'Unassigned' end as Unassigned,
					case when group_name like '%executive%' then 'executive' end as executive
					into #agents
					from (
					select	u.[user_id],
							u.full_name,
							u.leader_id,
							g.[value] group_id,
							g2.[name] group_name,
							g2.leader_id Super_id,
							u2.full_name as SupOrManager,
							u2.group_names
					from	DataSyncerDB.dbo.TLD_Users_Staging u with (nolock)
							cross apply string_split(u.group_ids, ',') g
							inner join DataSyncerDB.dbo.TLD_Groups_Staging g2 with (nolock) on ltrim(rtrim(g.[value])) = ltrim(rtrim(g2.group_id))
							inner join DataSyncerDB.dbo.TLD_Users_Staging u2 with (nolock) on g2.leader_id = u2.[user_id]
					)tab

					select *, space(100) team_lead,space(100) manager,space(100) executive,space(100) unassigned into #raw_agents from DataSyncerDB.dbo.TLD_Users_Staging (nolock)
					--drop table #raw_agents
					--select * from #raw_agents
					update a set a.team_lead = b.SupOrManager
					from #raw_agents a
					inner join #agents b 
					on a.[user_id] = b.[user_id] and b.team_lead is not null

					update a set a.manager = b.SupOrManager
					from #raw_agents a
					inner join #agents b 
					on a.[user_id] = b.[user_id] and b.manager is not null

					update a set a.unassigned = b.SupOrManager
					from #raw_agents a
					inner join #agents b 
					on a.[user_id] = b.[user_id] and b.Unassigned is not null

					update a set a.executive = b.SupOrManager
					from #raw_agents a
					inner join #agents b 
					on a.[user_id] = b.[user_id] and b.executive is not null

        -- Step 1: Archive existing rows that are about to be updated
        INSERT INTO TestDB.dbo.agents_archive (
            [Id], [user_id], [date_created], [date_modified], [date_activated], [date_deactivated],
            [date_email_verified], [date_hired], [agency_id], [username], [email], [email_verified],
            [first_name], [middle_name], [last_name], [full_name], [group_ids], [group_names],
            [group_descriptions], [leader_id], [leader_name], [leader_full_name], [status],
            [licensed_states], [ffm_id], [healthsherpa_user_id], [language], [npn], [ein],
            [enforce_ca_login], [personal_address], [personal_address2], [personal_city], [personal_dob],
            [personal_email], [personal_phone], [personal_ssn], [personal_state], [personal_zipcode],
            [sms_cid], [sms_enabled], [agency_name], [agency_description], [agency],
            [role_ids], [role_names], [role_descriptions], [team_lead], [manager], [executive], [unassigned], [FetchDate], [ArchivedDate]
        )
        SELECT 
            d.*,
            GETDATE() AS ArchivedDate
        FROM TestDb.dbo.Agents d
        INNER JOIN 
		--select * from
		#raw_agents s ON d.user_id = s.user_id
        WHERE 
		       ISNULL(d.date_modified, '1900-01-01') < ISNULL(s.date_modified, '1900-01-01')
            OR ISNULL(d.date_activated, '1900-01-01') < ISNULL(s.date_activated, '1900-01-01')
            OR ISNULL(d.date_deactivated, '1900-01-01') < ISNULL(s.date_deactivated, '1900-01-01')
			OR ISNULL(d.full_name, '') <> ISNULL(s.full_name, '') 
			OR ISNULL(d.date_created, '') <> ISNULL(s.date_created, '') 
			OR ISNULL(d.date_modified, '') <> ISNULL(s.date_modified, '') 
			OR ISNULL(d.date_activated, '') <> ISNULL(s.date_activated, '') 
			OR ISNULL(d.date_deactivated, '') <> ISNULL(s.date_deactivated, '') 
			OR ISNULL(d.date_email_verified, '') <> ISNULL(s.date_email_verified, '') 
			OR ISNULL(d.date_hired, '') <> ISNULL(s.date_hired, '') 
			OR ISNULL(d.agency_id, '') <> ISNULL(s.agency_id, '') 
			OR ISNULL(d.username, '') <> ISNULL(s.username, '') 
			OR ISNULL(d.email, '') <> ISNULL(s.email, '') 
			OR ISNULL(d.email_verified, '') <> ISNULL(s.email_verified, '') 
			OR ISNULL(d.first_name, '') <> ISNULL(s.first_name, '') 
			OR ISNULL(d.middle_name, '') <> ISNULL(s.middle_name, '') 
			OR ISNULL(d.last_name, '') <> ISNULL(s.last_name, '') 
			OR ISNULL(d.group_ids, '') <> ISNULL(s.group_ids, '') 
			OR ISNULL(d.group_names, '') <> ISNULL(s.group_names, '') 
			OR ISNULL(d.group_descriptions, '') <> ISNULL(s.group_descriptions, '') 
			OR ISNULL(d.leader_id, '') <> ISNULL(s.leader_id, '') 
			OR ISNULL(d.leader_name, '') <> ISNULL(s.leader_name, '') 
			OR ISNULL(d.leader_full_name, '') <> ISNULL(s.leader_full_name, '') 
			OR ISNULL(d.status, '') <> ISNULL(s.status, '') 
			OR ISNULL(d.licensed_states, '') <> ISNULL(s.licensed_states, '') 
			OR ISNULL(d.ffm_id, '') <> ISNULL(s.ffm_id, '') 
			OR ISNULL(d.healthsherpa_user_id, '') <> ISNULL(s.healthsherpa_user_id, '') 
			OR ISNULL(d.language, '') <> ISNULL(s.language, '') 
			OR ISNULL(d.npn, '') <> ISNULL(s.npn, '') 
			OR ISNULL(d.ein, '') <> ISNULL(s.ein, '') 
			OR ISNULL(d.enforce_ca_login, '') <> ISNULL(s.enforce_ca_login, '') 
			OR ISNULL(d.personal_address, '') <> ISNULL(s.personal_address, '') 
			OR ISNULL(d.personal_address2, '') <> ISNULL(s.personal_address2, '') 
			OR ISNULL(d.personal_city, '') <> ISNULL(s.personal_city, '') 
			OR ISNULL(d.personal_dob, '') <> ISNULL(s.personal_dob, '') 
			OR ISNULL(d.personal_email, '') <> ISNULL(s.personal_email, '') 
			OR ISNULL(d.personal_phone, '') <> ISNULL(s.personal_phone, '') 
			OR ISNULL(d.personal_ssn, '') <> ISNULL(s.personal_ssn, '') 
			OR ISNULL(d.personal_state, '') <> ISNULL(s.personal_state, '') 
			OR ISNULL(d.personal_zipcode, '') <> ISNULL(s.personal_zipcode, '') 
			OR ISNULL(d.sms_cid, '') <> ISNULL(s.sms_cid, '') 
			OR ISNULL(d.sms_enabled, '') <> ISNULL(s.sms_enabled, '') 
			OR ISNULL(d.agency_name, '') <> ISNULL(s.agency_name, '') 
			OR ISNULL(d.agency_description, '') <> ISNULL(s.agency_description, '') 
			OR ISNULL(d.agency, '') <> ISNULL(s.agency, '') 
			OR ISNULL(d.role_ids, '') <> ISNULL(s.role_ids, '') 
			OR ISNULL(d.role_names, '') <> ISNULL(s.role_names, '') 
			OR ISNULL(d.role_descriptions, '') <> ISNULL(s.role_descriptions, '') 

        -- Step 2: Perform UPSERT with MERGE
        MERGE INTO TestDb.dbo.Agents AS TARGET
        USING (
            SELECT *
            FROM #raw_agents
        ) AS SOURCE
        ON TARGET.user_id = SOURCE.user_id

        WHEN MATCHED AND (
               ISNULL(TARGET.date_modified, '1900-01-01') < ISNULL(SOURCE.date_modified, '1900-01-01')
            OR ISNULL(TARGET.date_activated, '1900-01-01') < ISNULL(SOURCE.date_activated, '1900-01-01')
            OR ISNULL(TARGET.date_deactivated, '1900-01-01') < ISNULL(SOURCE.date_deactivated, '1900-01-01')
			OR ISNULL(TARGET.full_name, '') <> ISNULL(SOURCE.full_name, '') 
			OR ISNULL(TARGET.date_created, '') <> ISNULL(SOURCE.date_created, '') 
			OR ISNULL(TARGET.date_modified, '') <> ISNULL(SOURCE.date_modified, '') 
			OR ISNULL(TARGET.date_activated, '') <> ISNULL(SOURCE.date_activated, '') 
			OR ISNULL(TARGET.date_deactivated, '') <> ISNULL(SOURCE.date_deactivated, '') 
			OR ISNULL(TARGET.date_email_verified, '') <> ISNULL(SOURCE.date_email_verified, '') 
			OR ISNULL(TARGET.date_hired, '') <> ISNULL(SOURCE.date_hired, '') 
			OR ISNULL(TARGET.agency_id, '') <> ISNULL(SOURCE.agency_id, '') 
			OR ISNULL(TARGET.username, '') <> ISNULL(SOURCE.username, '') 
			OR ISNULL(TARGET.email, '') <> ISNULL(SOURCE.email, '') 
			OR ISNULL(TARGET.email_verified, '') <> ISNULL(SOURCE.email_verified, '') 
			OR ISNULL(TARGET.first_name, '') <> ISNULL(SOURCE.first_name, '') 
			OR ISNULL(TARGET.middle_name, '') <> ISNULL(SOURCE.middle_name, '') 
			OR ISNULL(TARGET.last_name, '') <> ISNULL(SOURCE.last_name, '') 
			OR ISNULL(TARGET.group_ids, '') <> ISNULL(SOURCE.group_ids, '') 
			OR ISNULL(TARGET.group_names, '') <> ISNULL(SOURCE.group_names, '') 
			OR ISNULL(TARGET.group_descriptions, '') <> ISNULL(SOURCE.group_descriptions, '') 
			OR ISNULL(TARGET.leader_id, '') <> ISNULL(SOURCE.leader_id, '') 
			OR ISNULL(TARGET.leader_name, '') <> ISNULL(SOURCE.leader_name, '') 
			OR ISNULL(TARGET.leader_full_name, '') <> ISNULL(SOURCE.leader_full_name, '') 
			OR ISNULL(TARGET.status, '') <> ISNULL(SOURCE.status, '') 
			OR ISNULL(TARGET.licensed_states, '') <> ISNULL(SOURCE.licensed_states, '') 
			OR ISNULL(TARGET.ffm_id, '') <> ISNULL(SOURCE.ffm_id, '') 
			OR ISNULL(TARGET.healthsherpa_user_id, '') <> ISNULL(SOURCE.healthsherpa_user_id, '') 
			OR ISNULL(TARGET.language, '') <> ISNULL(SOURCE.language, '') 
			OR ISNULL(TARGET.npn, '') <> ISNULL(SOURCE.npn, '') 
			OR ISNULL(TARGET.ein, '') <> ISNULL(SOURCE.ein, '') 
			OR ISNULL(TARGET.enforce_ca_login, '') <> ISNULL(SOURCE.enforce_ca_login, '') 
			OR ISNULL(TARGET.personal_address, '') <> ISNULL(SOURCE.personal_address, '') 
			OR ISNULL(TARGET.personal_address2, '') <> ISNULL(SOURCE.personal_address2, '') 
			OR ISNULL(TARGET.personal_city, '') <> ISNULL(SOURCE.personal_city, '') 
			OR ISNULL(TARGET.personal_dob, '') <> ISNULL(SOURCE.personal_dob, '') 
			OR ISNULL(TARGET.personal_email, '') <> ISNULL(SOURCE.personal_email, '') 
			OR ISNULL(TARGET.personal_phone, '') <> ISNULL(SOURCE.personal_phone, '') 
			OR ISNULL(TARGET.personal_ssn, '') <> ISNULL(SOURCE.personal_ssn, '') 
			OR ISNULL(TARGET.personal_state, '') <> ISNULL(SOURCE.personal_state, '') 
			OR ISNULL(TARGET.personal_zipcode, '') <> ISNULL(SOURCE.personal_zipcode, '') 
			OR ISNULL(TARGET.sms_cid, '') <> ISNULL(SOURCE.sms_cid, '') 
			OR ISNULL(TARGET.sms_enabled, '') <> ISNULL(SOURCE.sms_enabled, '') 
			OR ISNULL(TARGET.agency_name, '') <> ISNULL(SOURCE.agency_name, '') 
			OR ISNULL(TARGET.agency_description, '') <> ISNULL(SOURCE.agency_description, '') 
			OR ISNULL(TARGET.agency, '') <> ISNULL(SOURCE.agency, '') 
			OR ISNULL(TARGET.role_ids, '') <> ISNULL(SOURCE.role_ids, '') 
			OR ISNULL(TARGET.role_names, '') <> ISNULL(SOURCE.role_names, '') 
			OR ISNULL(TARGET.role_descriptions, '') <> ISNULL(SOURCE.role_descriptions, '') 
        )
        THEN
        UPDATE SET
            TARGET.date_created           = SOURCE.date_created,
            TARGET.date_modified          = SOURCE.date_modified,
            TARGET.date_activated         = SOURCE.date_activated,
            TARGET.date_deactivated       = SOURCE.date_deactivated,
            TARGET.date_email_verified    = SOURCE.date_email_verified,
            TARGET.date_hired             = SOURCE.date_hired,
            TARGET.agency_id              = SOURCE.agency_id,
            TARGET.username               = SOURCE.username,
            TARGET.email                  = SOURCE.email,
            TARGET.email_verified         = SOURCE.email_verified,
            TARGET.first_name             = SOURCE.first_name,
            TARGET.middle_name            = SOURCE.middle_name,
            TARGET.last_name              = SOURCE.last_name,
            TARGET.full_name              = SOURCE.full_name,
            TARGET.group_ids              = SOURCE.group_ids,
            TARGET.group_names            = SOURCE.group_names,
            TARGET.group_descriptions     = SOURCE.group_descriptions,
            TARGET.leader_id              = SOURCE.leader_id,
            TARGET.leader_name            = SOURCE.leader_name,
            TARGET.leader_full_name       = SOURCE.leader_full_name,
            TARGET.status                 = SOURCE.status,
            TARGET.licensed_states        = SOURCE.licensed_states,
            TARGET.ffm_id                 = SOURCE.ffm_id,
            TARGET.healthsherpa_user_id   = SOURCE.healthsherpa_user_id,
            TARGET.language               = SOURCE.language,
            TARGET.npn                    = SOURCE.npn,
            TARGET.ein                    = SOURCE.ein,
            TARGET.enforce_ca_login       = SOURCE.enforce_ca_login,
            TARGET.personal_address       = SOURCE.personal_address,
            TARGET.personal_address2      = SOURCE.personal_address2,
            TARGET.personal_city          = SOURCE.personal_city,
            TARGET.personal_dob           = SOURCE.personal_dob,
            TARGET.personal_email         = SOURCE.personal_email,
            TARGET.personal_phone         = SOURCE.personal_phone,
            TARGET.personal_ssn           = SOURCE.personal_ssn,
            TARGET.personal_state         = SOURCE.personal_state,
            TARGET.personal_zipcode       = SOURCE.personal_zipcode,
            TARGET.sms_cid                = SOURCE.sms_cid,
            TARGET.sms_enabled            = SOURCE.sms_enabled,
            TARGET.agency_name            = SOURCE.agency_name,
            TARGET.agency_description     = SOURCE.agency_description,
            TARGET.agency                 = SOURCE.agency,
            TARGET.role_ids               = SOURCE.role_ids,
            TARGET.role_names             = SOURCE.role_names,
            TARGET.role_descriptions      = SOURCE.role_descriptions,
            TARGET.team_lead			  = SOURCE.team_lead,
            TARGET.manager				  = SOURCE.manager,
            TARGET.executive			  = SOURCE.executive,
            TARGET.unassigned			  = SOURCE.unassigned,
            TARGET.FetchDate              = GETDATE()

        WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            [user_id], [date_created], [date_modified], [date_activated], [date_deactivated],
            [date_email_verified], [date_hired], [agency_id], [username], [email], [email_verified],
            [first_name], [middle_name], [last_name], [full_name], [group_ids], [group_names],
            [group_descriptions], [leader_id], [leader_name], [leader_full_name], [status],
            [licensed_states], [ffm_id], [healthsherpa_user_id], [language], [npn], [ein],
            [enforce_ca_login], [personal_address], [personal_address2], [personal_city], [personal_dob],
            [personal_email], [personal_phone], [personal_ssn], [personal_state], [personal_zipcode],
            [sms_cid], [sms_enabled], [agency_name], [agency_description], [agency],
            [role_ids], [role_names], [role_descriptions], [team_lead],[manager],[executive],[unassigned], [FetchDate]
        )
        VALUES (
            [user_id], [date_created], [date_modified], [date_activated], [date_deactivated],
            [date_email_verified], [date_hired], [agency_id], [username], [email], [email_verified],
            [first_name], [middle_name], [last_name], [full_name], [group_ids], [group_names],
            [group_descriptions], [leader_id], [leader_name], [leader_full_name], [status],
            [licensed_states], [ffm_id], [healthsherpa_user_id], [language], [npn], [ein],
            [enforce_ca_login], [personal_address], [personal_address2], [personal_city], [personal_dob],
            [personal_email], [personal_phone], [personal_ssn], [personal_state], [personal_zipcode],
            [sms_cid], [sms_enabled], [agency_name], [agency_description], [agency],
            [role_ids], [role_names], [role_descriptions], [team_lead],[manager],[executive],[unassigned], GETDATE()
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END


