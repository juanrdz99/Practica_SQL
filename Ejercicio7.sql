CREATE OR REPLACE TABLE keepcoding.ivr_detail_final AS
WITH base AS (
  SELECT
    calls_ivr_id,
    calls_phone_number,
    calls_ivr_result,
    calls_vdn_label,
    vdn_aggregation,
    calls_start_date,
    calls_start_date_id,
    calls_end_date,
    calls_end_date_id,
    calls_total_duration,
    calls_customer_segment,
    calls_ivr_language,
    calls_steps_module,
    calls_module_aggregation,
    module_sequence,
    module_name,
    module_duration,
    module_result,
    step_sequence,
    step_name,
    step_result,
    step_description_error,
    document_type,
    document_identification,
    customer_phone,
    billing_account_id
  FROM keepcoding.ivr_detail
)
SELECT
  calls_ivr_id,
  ANY_VALUE(calls_phone_number) AS calls_phone_number,
  ANY_VALUE(calls_ivr_result) AS calls_ivr_result,
  ANY_VALUE(calls_vdn_label) AS calls_vdn_label,
  ANY_VALUE(vdn_aggregation) AS vdn_aggregation,
  ANY_VALUE(calls_start_date) AS calls_start_date,
  ANY_VALUE(calls_start_date_id) AS calls_start_date_id,
  ANY_VALUE(calls_end_date) AS calls_end_date,
  ANY_VALUE(calls_end_date_id) AS calls_end_date_id,
  ANY_VALUE(calls_total_duration) AS calls_total_duration,
  ANY_VALUE(calls_customer_segment) AS calls_customer_segment,
  ANY_VALUE(calls_ivr_language) AS calls_ivr_language,
  ANY_VALUE(calls_steps_module) AS calls_steps_module,
  ANY_VALUE(calls_module_aggregation) AS calls_module_aggregation,
  ANY_VALUE(module_sequence) AS module_sequence,
  ANY_VALUE(module_name) AS module_name,
  ANY_VALUE(module_duration) AS module_duration,
  ANY_VALUE(module_result) AS module_result,
  ANY_VALUE(step_sequence) AS step_sequence,
  ANY_VALUE(step_name) AS step_name,
  ANY_VALUE(step_result) AS step_result,
  ANY_VALUE(step_description_error) AS step_description_error,
  ANY_VALUE(document_type) AS document_type,
  ANY_VALUE(document_identification) AS document_identification,
  ANY_VALUE(customer_phone) AS customer_phone,
  ARRAY_AGG(billing_account_id IGNORE NULLS LIMIT 1)[OFFSET(0)] AS billing_account_id
FROM base
GROUP BY calls_ivr_id;
