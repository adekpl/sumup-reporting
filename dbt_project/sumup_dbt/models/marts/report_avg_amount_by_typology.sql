{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('report_base') }}
)

SELECT
    DATE_TRUNC('month', happened_at::date) AS month_date,
    country,
    typology,
    ROUND(AVG(amount), 2) AS avg_transaction_amount,
    COUNT(*) AS total_transactions
FROM base
WHERE status = 'accepted'
GROUP BY
    DATE_TRUNC('month', happened_at::date),
    country,
    typology
ORDER BY
    month_date,
    country,
    typology