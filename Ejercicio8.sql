CREATE OR REPLACE TABLE keepcoding.ivr_detail_final AS
SELECT
  calls_ivr_id,
  IF(COUNTIF(module_name = 'AVERIA_MASIVA') > 0, 1, 0) AS masiva_lg
FROM
  keepcoding.ivr_detail
GROUP BY
  calls_ivr_id;
