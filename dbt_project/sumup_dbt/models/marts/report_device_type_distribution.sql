{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('report_base') }}
)

SELECT
    DATE_TRUNC('month', happened_at::date) AS month_date,
    device_type,
    COUNT(*) AS total_transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY DATE_TRUNC('month', happened_at::date)), 2)
        AS percentage_of_transactions
FROM base
WHERE status = 'SUCCESS'
GROUP BY
    DATE_TRUNC('month', happened_at::date),
    device_type
ORDER BY
    month_date,
    percentage_of_transactions DESC
