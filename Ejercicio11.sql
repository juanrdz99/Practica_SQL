CREATE OR REPLACE TABLE keepcoding.ivr_detail_final AS
WITH base AS (
  SELECT
    calls_ivr_id,
    calls_phone_number,
    calls_start_date
  FROM keepcoding.ivr_detail
)
SELECT
  b.calls_ivr_id,
  b.calls_phone_number,
  b.calls_start_date,
  IF(
    (SELECT COUNT(*)
     FROM base AS bprev
     WHERE bprev.calls_phone_number = b.calls_phone_number
       AND bprev.calls_ivr_id <> b.calls_ivr_id
       AND bprev.calls_start_date BETWEEN TIMESTAMP_SUB(b.calls_start_date, INTERVAL 24 HOUR)
                                       AND b.calls_start_date
    ) > 0, 1, 0) AS repeated_phone_24H,
  IF(
    (SELECT COUNT(*)
     FROM base AS bnext
     WHERE bnext.calls_phone_number = b.calls_phone_number
       AND bnext.calls_ivr_id <> b.calls_ivr_id
       AND bnext.calls_start_date BETWEEN b.calls_start_date
                                       AND TIMESTAMP_ADD(b.calls_start_date, INTERVAL 24 HOUR)
    ) > 0, 1, 0) AS cause_recall_phone_24H
FROM base AS b;
