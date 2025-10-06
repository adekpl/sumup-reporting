{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('report_base') }}
),
ranked_txns AS (
    SELECT
        store_id,
        store_name,
        happened_at,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY happened_at) AS txn_rank
    FROM base
),
first5 AS (
    SELECT
        store_id,
        store_name,
        DATEDIFF(
            'minute',
            MIN(happened_at),
            MAX(happened_at)
        ) AS minutes_between_first_and_fifth
    FROM ranked_txns
    WHERE txn_rank <= 5
    GROUP BY store_id, store_name
)
SELECT
    store_id,
    store_name,
    minutes_between_first_and_fifth
FROM first5
ORDER BY minutes_between_first_and_fifth