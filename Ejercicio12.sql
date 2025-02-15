CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH base AS (
  SELECT
    calls_ivr_id,
    calls_phone_number,
    calls_ivr_result,
    vdn_aggregation,
    calls_start_date,
    calls_end_date,
    calls_total_duration,
    calls_customer_segment,
    calls_ivr_language,
    calls_steps_module,
    calls_module_aggregation,
    document_type,
    document_identification,
    customer_phone,
    billing_account_id,
    module_name,
    step_name,
    step_result
  FROM keepcoding.ivr_detail
),
phone_flags AS (
  SELECT
    a.calls_ivr_id,
    IF(
      (SELECT COUNT(*) FROM keepcoding.ivr_detail b
       WHERE b.calls_phone_number = a.calls_phone_number
         AND b.calls_ivr_id <> a.calls_ivr_id
         AND b.calls_start_date BETWEEN TIMESTAMP_SUB(a.calls_start_date, INTERVAL 24 HOUR) AND a.calls_start_date
      ) > 0, 1, 0) AS repeated_phone_24H,
    IF(
      (SELECT COUNT(*) FROM keepcoding.ivr_detail c
       WHERE c.calls_phone_number = a.calls_phone_number
         AND c.calls_ivr_id <> a.calls_ivr_id
         AND c.calls_start_date BETWEEN a.calls_start_date AND TIMESTAMP_ADD(a.calls_start_date, INTERVAL 24 HOUR)
      ) > 0, 1, 0) AS cause_recall_phone_24H
  FROM base a
)
SELECT
  b.calls_ivr_id AS ivr_id,
  ANY_VALUE(b.calls_phone_number) AS phone_number,
  ANY_VALUE(b.calls_ivr_result) AS ivr_result,
  ANY_VALUE(b.vdn_aggregation) AS vdn_aggregation,
  ANY_VALUE(b.calls_start_date) AS start_date,
  ANY_VALUE(b.calls_end_date) AS end_date,
  ANY_VALUE(b.calls_total_duration) AS total_duration,
  ANY_VALUE(b.calls_customer_segment) AS customer_segment,
  ANY_VALUE(b.calls_ivr_language) AS ivr_language,
  ANY_VALUE(b.calls_steps_module) AS steps_module,
  ANY_VALUE(b.calls_module_aggregation) AS module_aggregation,
  ANY_VALUE(b.document_type) AS document_type,
  ANY_VALUE(b.document_identification) AS document_identification,
  ANY_VALUE(b.customer_phone) AS customer_phone,
  ANY_VALUE(b.billing_account_id) AS billing_account_id,
  MAX(CASE WHEN b.module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg,
  MAX(CASE WHEN b.step_name = 'CUSTOMERINFOBYPHONE.TX' AND b.step_result = 'OK' THEN 1 ELSE 0 END) AS info_by_phone_lg,
  MAX(CASE WHEN b.step_name = 'CUSTOMERINFOBYDNI.TX' AND b.step_result = 'OK' THEN 1 ELSE 0 END) AS info_by_dni_lg,
  MAX(p.repeated_phone_24H) AS repeated_phone_24H,
  MAX(p.cause_recall_phone_24H) AS cause_recall_phone_24H
FROM base b
LEFT JOIN phone_flags p
  ON b.calls_ivr_id = p.calls_ivr_id
GROUP BY b.calls_ivr_id;