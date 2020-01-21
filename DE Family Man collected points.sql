SELECT A.USER_ID ,
       
       NVL(POINTS_CNFRMD_NUM , 0) AS TOTAL_POINTS_BALANCE   ---only confirmed points
 
FROM PRS_RESTRICTED_V.PLUS_RWRD_MBR A
INNER JOIN Access_Views.EBYPLS_BUYER_SBSCRPTN_HIST hist ON hist.buyer_id = a.user_id
AND CURRENT_DATE-2 BETWEEN buyer_status_start_dt AND buyer_status_end_dt
AND ebypls_buyer_status_cd IN (0,
                               1)
AND hist.site_id = 77
 
LEFT JOIN PRS_RESTRICTED_V.PLUS_RWRD_POINTS_BLNC B ON A.USER_ID = B.USER_ID
AND CURRENT_DATE-2 BETWEEN B.status_start_dt and B.status_end_dt
 
WHERE A.STATUS = 1
  AND CURRENT_DATE -2 BETWEEN A.status_start_dt AND A.status_end_dt
QUALIFY ROW_NUMBER() OVER(PARTITION BY A.user_id, A.status_start_Dt ORDER BY A.status_end_dt desc) = 1;vvvvc