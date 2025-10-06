{{ config(materialized='table') }}
with stg_stores as (select * from {{ ref('stg_stores') }} )

SELECT DISTINCT
    id as store_id,
    customer_id,
    name as store_name,
    city,
    country,
    created_at,
    typology
FROM stg_stores 