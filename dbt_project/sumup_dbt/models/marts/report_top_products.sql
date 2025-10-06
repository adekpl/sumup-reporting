{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('report_base') }}
)
SELECT
    date_trunc(month,happened_at::date) as happened_date,
    product_id,
    product_name,
    product_category,
    SUM(amount) AS total_sales,
    COUNT(*) AS total_transactions,
    RANK() OVER (PARTITION by happened_date ORDER BY SUM(amount) DESC) AS rank_product
FROM base
WHERE status = 'accepted'
GROUP BY happened_date,product_id, product_name, product_category
QUALIFY rank_product <= 10
ORDER BY rank_product
