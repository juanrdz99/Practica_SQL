CREATE OR REPLACE TABLE keepcoding.ivr_detail_final AS
SELECT
  calls_ivr_id,
  IF(COUNTIF(step_name = 'CUSTOMERINFOBYDNI.TX' AND step_result = 'OK') > 0, 1, 0) AS info_by_dni_lg
FROM
  keepcoding.ivr_detail
GROUP BY
  calls_ivr_id;
