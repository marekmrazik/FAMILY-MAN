--sel * from unica_temp.de_family_men;
insert into  unica_temp.de_family_men  

SELECT
  PII.ENCRYPTED_USER_ID, 
    PII.DEMO_USER_ID as user_id,
    SEG.SEGM_NAME AS  SEGMENT,
    CASE
            WHEN SOJLIB.SOJ_MD5_HASH_128 (PII.USER_ID, 'EXPT', AUD.CNTRL_HASH, 100) BETWEEN 00 AND 09 THEN 'C'
            WHEN SOJLIB.SOJ_MD5_HASH_128 (PII.USER_ID, 'EXPT', AUD.CNTRL_HASH, 100) BETWEEN 10 AND 99 THEN 'T' 
            ELSE 'ERROR' END as TC,
  PII.USER_SITE_ID,
  PII.USER_NAME,
  PII.USER_SLCTD_ID,
  PII.USER_FIRST_NAME,     
    (CASE
        WHEN    EMAIL_MAST_PREF_YN ='Y'  
             and RSPNDR_YN = 'Y' 
             and BLCKLST_YN='N' 
             and ACTV_YN ='Y' 
             and FAKE_EMAIL_YN = 'N' 
        THEN 'Y' ELSE 'N' 
    END) AS CH_EMAIL_YN,
  'Y' AS CH_MC_YN,
PII.EMAIL,
0 as DISCOUNT_AMOUNT
  
FROM
     P_DBM_INPUT_T.PLUS_FM_TRIAL_TARGETING stg
JOIN PRS_SECURE_V.MDM_USER_PII AS PII on STG.PRIMARY_USER_ID=PII.prmry_USER_ID
INNER JOIN  UNICA_TEMP.XMP_AUDIENCE AS AUD
      ON  AUD.AUD_NAME = 'DE_FAMILY_MEN' AND
          PII.USER_SITE_ID = AUD.SITE_ID AND
          CURRENT_DATE BETWEEN AUD.START_DATE-10 AND AUD.END_DATE
    
    INNER JOIN  UNICA_TEMP.XMP_SEGMENT AS SEG
      ON  SEG.AUD_ID = AUD.AUD_ID AND
          SEG.SEGM_NAME IN ('FAMILY_MEN') AND
          CURRENT_DATE BETWEEN SEG.START_DATE-10 AND SEG.END_DATE
        
      
            --RISK TEAM ISSUE 
      LEFT JOIN (
           SELECT USER_ID
         FROM access_views.dw_user_issue
         WHERE scenario_id IN (1, 248, 250, 265, 491, 534, 535, 566, 629)
         AND status_id = 0
         GROUP BY 1) RISK 
     ON PII.USER_ID = RISK.USER_ID
          
  WHERE 7=7
  and demo_user_id=pii.user_id
   AND user_site_id = 77  
   AND CNFRMD_YN = 'Y' 
   and RGSTRD_YN = 'Y' 
   and FDBCK_YN ='Y'  
   and CRM_GH_YN='N'  
   and B2C_SLR_YN ='N' 
   and RISK.USER_ID IS  NULL 

AND EMAIL_DOMAIN NOT LIKE '%.jp' -- additional exclusion
AND PII.USER_NAME NOT LIKE '%|%'
AND PII.USER_SLCTD_ID NOT LIKE '%|%'
AND PII.USER_FIRST_NAME NOT LIKE '%|%'
AND PII.EMAIL NOT LIKE '%|%' 
AND PII.EMAIL NOT LIKE '%.jp%'
AND PII.USER_NAME is not null
AND PII.USER_FIRST_NAME IS NOT NULL
      
GROUP BY
    1,2,3,4,5,6,7,8,9,10,11,12
 
 union all
 
 
SELECT
  PII.ENCRYPTED_USER_ID, 
  PII.DEMO_USER_ID as user_id,
  SEG.SEGM_NAME AS   SEGMENT,
  'T' as TC,
  PII.USER_SITE_ID,
  PII.USER_NAME,
  PII.USER_SLCTD_ID,
  PII.USER_FIRST_NAME,     
  'Y' AS CH_EMAIL_YN,
  'Y' AS CH_MC_YN,
PII.EMAIL,
0 as DISCOUNT_AMOUNT
  
FROM
PRS_SECURE_V.MDM_USER_PII   as PII      
INNER JOIN  UNICA_TEMP.XMP_AUDIENCE AS AUD
      ON  AUD.AUD_NAME = 'DE_FAMILY_MEN' AND
          PII.USER_SITE_ID = AUD.SITE_ID AND
          CURRENT_DATE BETWEEN AUD.START_DATE-10 AND AUD.END_DATE
    
    INNER JOIN  UNICA_TEMP.XMP_SEGMENT AS SEG
      ON  SEG.AUD_ID = AUD.AUD_ID AND
          SEG.SEGM_NAME IN ('FAMILY_MEN') AND
          CURRENT_DATE BETWEEN SEG.START_DATE-10 AND SEG.END_DATE
  WHERE 7=7
AND user_slctd_id in (
'mogucan',  --Gybasova, Kristina
'marieck_6',  --Eckert, Thomas
'sraudschus', --Peijan, Stefanie
'dmalhao', --Malhao, Diogo
'marekmk', --Marek Mrazik
'emnewman', --Newman, Emma
'mllewiwa', --(Kristin Wyrwa)
'the9280', -- (Theresa Thüs)
'sa-32439' , --(Sandy Kim)
'kathihartung832')   --(Kathleen Hoffmann)
AND EMAIL_DOMAIN NOT LIKE '%.jp' -- additional exclusion
AND PII.USER_NAME NOT LIKE '%|%'
AND PII.USER_SLCTD_ID NOT LIKE '%|%'
AND PII.USER_FIRST_NAME NOT LIKE '%|%'
AND PII.EMAIL NOT LIKE '%|%' 
AND PII.EMAIL NOT LIKE '%.jp%'
AND PII.USER_NAME is not null
AND PII.USER_FIRST_NAME IS NOT NULL
GROUP BY
    1,2,3,4,5,6,7,8,9,10,11,12
  
 ;
