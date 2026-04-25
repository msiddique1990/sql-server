---------------------------------------------------- account id ------------------------------------------------------------------------------
SELECT COUNT(c.policy_id)
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     ( ISNULL(c.account_id, '') <> ISNULL(cs.account_id, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
---------------------------------------------------- lead id ------------------------------------------------------------------------------
SELECT COUNT(c.policy_id)
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     ( ISNULL(c.lead_id, '') <> ISNULL(cs.lead_id, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
---------------------------------------------------- agent id ------------------------------------------------------------------------------
SELECT c.policy_id, c.agent_id, cs.agent_id
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     ( ISNULL(c.agent_id, '') <> ISNULL(cs.agent_id, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
---------------------------------------------------- agent first name ------------------------------------------------------------------------------
SELECT c.policy_id, c.agent_first_name, cs.agent_first_name
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (  ISNULL(c.agent_first_name, '') <> ISNULL(cs.agent_first_name, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
---------------------------------------------------- agent last name ------------------------------------------------------------------------------
SELECT c.policy_id, c.agent_last_name, cs.agent_last_name
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (  ISNULL(c.agent_last_name, '') <> ISNULL(cs.agent_last_name, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  agent_npn ------------------------------------------------------------------------------
SELECT c.policy_id, c.agent_npn, cs.agent_npn
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (  ISNULL(c.agent_npn, '') <> ISNULL(cs.agent_npn, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  agent_username ------------------------------------------------------------------------------
SELECT c.policy_id, c.agent_username, cs.agent_username
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (  ISNULL(c.agent_username, '') <> ISNULL(cs.agent_username, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  fronter_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.fronter_id, cs.fronter_id
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (  ISNULL(c.fronter_id, '') <> ISNULL(cs.fronter_id, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  lead_vendor_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.lead_vendor_id, cs.lead_vendor_id
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (  ISNULL(c.lead_vendor_id, '') <> ISNULL(cs.lead_vendor_id, '')  )	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  date_created ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_created, cs.date_created
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (ISNULL(CONVERT(VARCHAR(20), c.date_created, 120), '') <> ISNULL(CONVERT(VARCHAR(20), TRY_CAST(cs.date_created AS DATETIME), 120), ''))	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  date_modified ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_modified, cs.date_modified
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (ISNULL(CONVERT(VARCHAR(20), c.date_modified, 120), '') <> ISNULL(CONVERT(VARCHAR(20), TRY_CAST(cs.date_modified AS DATETIME), 120), ''))	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  date_converted ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_converted, cs.date_converted
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (ISNULL(CONVERT(VARCHAR(20), c.date_converted, 120), '') <> ISNULL(CONVERT(VARCHAR(20), TRY_CAST(cs.date_converted AS DATETIME), 120), ''))	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  date_converted ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_verified, cs.date_verified
from TLD.dbo.TLD_Policies c
INNER JOIN 
    DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.Policy_id = cs.Policy_id
WHERE     (ISNULL(CONVERT(VARCHAR(20), c.date_verified, 120), '') <> ISNULL(CONVERT(VARCHAR(20), TRY_CAST(cs.date_verified AS DATETIME), 120), ''))	and CONVERT(date, c.date_sold) between '2025-01-01' and '2025-06-30'
----------------------------------------------------  date_sold ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_sold, cs.date_sold
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id 
WHERE ISNULL(CONVERT(date,CONVERT(VARCHAR(19), c.date_sold, 120)), '') <> ISNULL(CONVERT(date,CONVERT(VARCHAR(19), TRY_CAST(cs.date_sold AS DATETIME), 120)), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-06-30' AND '2025-07-06'
----------------------------------------------------  date_cancelled ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_cancelled, cs.date_cancelled
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_cancelled, 120), '')  <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_cancelled AS DATETIME), 120), '')AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_reactivated ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_reactivated, cs.date_reactivated
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_reactivated, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_reactivated AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_refused ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_refused, cs.date_refused
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_refused, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_refused AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_effective ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_effective, cs.date_effective
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(date,CONVERT(VARCHAR(19), c.date_effective, 120)), '') <> ISNULL(CONVERT(date,CONVERT(VARCHAR(19), TRY_CAST(cs.date_effective AS DATETIME), 120)), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_terminate ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_terminate, cs.date_terminate
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_terminate, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_terminate AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_issued ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_issued, cs.date_issued
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_issued, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_issued AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_inforce ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_inforce, cs.date_inforce
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_inforce, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_inforce AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_posted ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_posted, cs.date_posted
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_posted, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_posted AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_drafted ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_drafted, cs.date_drafted
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_drafted, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_drafted AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  date_paid ------------------------------------------------------------------------------
SELECT c.policy_id, c.date_paid, cs.date_paid
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(CONVERT(VARCHAR(19), c.date_paid, 120), '') <> ISNULL(CONVERT(VARCHAR(19), TRY_CAST(cs.date_paid AS DATETIME), 120), '') AND CONVERT(date, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';
----------------------------------------------------  application_number ------------------------------------------------------------------------------
SELECT c.policy_id, c.application_number, cs.application_number
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.application_number, '') <> ISNULL(cs.application_number, '')
  AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  lead_vendor_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.lead_vendor_name, cs.lead_vendor_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.lead_vendor_name, '') <> ISNULL(cs.lead_vendor_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  lead_first_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.lead_first_name, cs.lead_first_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.lead_first_name, '') <> ISNULL(cs.lead_first_name, '')  AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  lead_last_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.lead_last_name, cs.lead_last_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.lead_last_name, '') <> ISNULL(cs.lead_last_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  lead_state ------------------------------------------------------------------------------
SELECT c.policy_id, c.lead_state, cs.lead_state
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.lead_state, '') <> ISNULL(cs.lead_state, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  lead_zipcode ------------------------------------------------------------------------------
SELECT c.policy_id, c.lead_zipcode, cs.lead_zipcode
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.lead_zipcode, '') <> ISNULL(cs.lead_zipcode, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  ffm_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.ffm_id, cs.ffm_id
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.ffm_id, '') <> ISNULL(cs.ffm_id, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
---------------------------------------------------  subscriber_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.subscriber_id, cs.subscriber_id
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.subscriber_id, '') <> ISNULL(cs.subscriber_id, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  status_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.status_name, cs.status_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.status_name, '') <> ISNULL(cs.status_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  carrier_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.carrier_name, cs.carrier_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.carrier_name, '') <> ISNULL(cs.carrier_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  new_plan_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.new_plan_name, cs.new_plan_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.new_plan_name, '') <> ISNULL(cs.new_plan_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_plan_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_plan_name, cs.product_plan_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_plan_name, '') <> ISNULL(cs.product_plan_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_id, cs.product_id
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_id, '') <> ISNULL(cs.product_id, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_name, cs.product_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_name, '') <> ISNULL(cs.product_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product ------------------------------------------------------------------------------
SELECT c.policy_id, c.product, cs.product
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product, '') <> ISNULL(cs.product, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_account_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_account_id, cs.product_account_id
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_account_id, '') <> ISNULL(cs.product_account_id, '')
  AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_carrier ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_carrier, cs.product_carrier
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_carrier, '') <> ISNULL(cs.product_carrier, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_carrier_description ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_carrier_description, cs.product_carrier_description
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_carrier_description, '') <> ISNULL(cs.product_carrier_description, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
---------------------------------------------------  product_carrier_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_carrier_id, cs.product_carrier_id
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_carrier_id, '') <> ISNULL(cs.product_carrier_id, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_carrier_name ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_carrier_name, cs.product_carrier_name
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_carrier_name, '') <> ISNULL(cs.product_carrier_name, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_description ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_description, cs.product_description
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_description, '') <> ISNULL(cs.product_description, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_plan ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_plan, cs.product_plan
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_plan, '') <> ISNULL(cs.product_plan, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_plan_description ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_plan_description, cs.product_plan_description
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_plan_description, '') <> ISNULL(cs.product_plan_description, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_plan_id ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_plan_id, cs.product_plan_id
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_plan_id, '') <> ISNULL(cs.product_plan_id, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_public ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_public, cs.product_public
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_public, '') <> ISNULL(cs.product_public, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30'
----------------------------------------------------  product_type ------------------------------------------------------------------------------
SELECT c.policy_id, c.product_type, cs.product_type
FROM TLD.dbo.TLD_Policies c
INNER JOIN DataSyncerDB.dbo.TLD_Policies_Staging cs ON c.policy_id = cs.policy_id
WHERE ISNULL(c.product_type, '') <> ISNULL(cs.product_type, '') AND CONVERT(DATE, c.date_sold) BETWEEN '2025-01-01' AND '2025-06-30';



SELECT c.policy_id 
from TLD.dbo.TLD_Policies c
where c.policy_id not in (select cs.policy_id from  DataSyncerDB.dbo.TLD_Policies_Staging cs)

SELECT c.policy_id 
from DataSyncerDB.dbo.TLD_Policies_Staging c 
where c.policy_id not in (select cs.policy_id from  TLD.dbo.TLD_Policies cs)


select policy_id, count(*) from DataSyncerDB.dbo.TLD_Policies_Staging
group by policy_id
having count(policy_id)>1
