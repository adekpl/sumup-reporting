{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('report_base') }}
)
SELECT
    date_trunc(month,happened_at::date) as happened_date,
    store_id,
    store_name,
    city,
    country,
    SUM(amount) AS total_transacted_amount,
    RANK() OVER (PARTITION by happened_date ORDER BY SUM(amount) DESC) AS rank_store
FROM base
WHERE status = 'accepted'
GROUP BY happened_date,store_id, store_name, city, country
QUALIFY rank_store <= 10
ORDER BY rank_store