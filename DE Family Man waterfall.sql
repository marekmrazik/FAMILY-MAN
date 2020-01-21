
Select 1 as list_order, 'Z' as TVC,  cast( 'Total' as varchar(100)) as SEGMENT
,Count(distinct demo_user_id)  as init
, SUM(Case when user_site_id = 77  Then 1 else 0 end)  as INC_DE
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y'  Then 1 else 0 end)  as INC_CNFRMD
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y'  and RGSTRD_YN = 'Y' Then 1 else 0 end)  as INC_RGSTRD
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y' and RGSTRD_YN = 'Y' and FDBCK_YN ='Y' Then 1 else 0 end) as EXC_FDBCK
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y' and RGSTRD_YN = 'Y' and FDBCK_YN ='Y'  and CRM_GH_YN ='N' Then 1 else 0 end) as GLBL_HOLD_OUT
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y' and RGSTRD_YN = 'Y' and FDBCK_YN ='Y'  and CRM_GH_YN='N'  and B2C_SLR_YN ='N' Then 1 else 0 end) as B2C_SLR
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y' and RGSTRD_YN = 'Y' and FDBCK_YN ='Y'  and CRM_GH_YN='N'  and B2C_SLR_YN ='N' and RISK_YN  = 'N' Then 1 else 0 end) as RISK
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y' and RGSTRD_YN = 'Y' and FDBCK_YN ='Y'  and CRM_GH_YN='N'  and B2C_SLR_YN ='N' and RISK_YN  = 'N'  AND fiab.user_id is not null Then 1 else 0 end) as FIAB
, SUM(Case when user_site_id = 77  and CNFRMD_YN = 'Y' and RGSTRD_YN = 'Y' and FDBCK_YN ='Y'  and CRM_GH_YN='N'  and B2C_SLR_YN ='N' and RISK_YN  = 'N'  AND fiab.user_id is not null  AND plus.user_id is null Then 1 else 0 end) as RESPONDER
FROM P_DBM_INPUT_T.PLUS_FM_TRIAL_TARGETING stg
JOIN PRS_SECURE_V.MDM_USER_PII AS PII on STG.PRIMARY_USER_ID=PII.prmry_USER_ID
LEFT JOIN (SELECT USER_ID
FROM PRS_SECURE_V.MDM_USER_PII AS PII
WHERE 1=1
AND NOT EXISTS ( -- FiAB - REA + NUE
SELECT 1
FROM PRS_SECURE_V.USER_DNA AS DNA
WHERE DNA.USER_ID = PII.PRMRY_USER_ID
AND (
DNA.BUY_LST_DT BETWEEN CURRENT_DATE - (365*10) AND CURRENT_DATE - 300 + 14 -- REACT
OR (PII.USER_CRE_DT >= CURRENT_DATE - 365 AND DNA.BUY_LST_DT IS NULL) -- NUE
)
)) fiab
on pii.user_id=fiab.user_id
LEFT JOIN (
SELECT 							USER_ID
FROM								PRS_RESTRICTED_V.PLUS_RWRD_MBR a
INNER JOIN								( SELECT				distinct BUYER_ID
																						,EBYPLS_BUYER_STATUS_CD
																						FROM access_views.EBYPLS_BUYER_SBSCRPTN_HIST 
																						WHERE SITE_ID = 77
																						and EBYPLS_BUYER_STATUS_CD in (0,1)
																						and current_date-2 between BUYER_STATUS_START_DT and BUYER_STATUS_END_DT
																						) PLUS 
																						ON													A.USER_ID = PLUS.BUYER_ID
																						WHERE							A.STATUS = 1
																						AND									CURRENT_DATE BETWEEN A.STATUS_START_DT AND A.STATUS_END_DT	) PLUS
																					
	on PII.user_id=plus.user_id
where demo_user_id=pii.user_id
Group by 1,2,3


