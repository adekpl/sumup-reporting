{{ config(materialized='table') }}
with fact_transactions as (select * from {{ ref('fact_transactions') }}  )
,dim_stores as (select * from {{ ref('dim_stores') }}  )
,dim_devices as (select * from {{ ref('dim_devices') }}  )
,dim_product as (select * from {{ref('dim_product')}})
,base AS (
    SELECT
        f.transaction_id,
        f.device_id,
        f.product_id,
        p.product_sku,
        p.product_name,
        p.product_category,
        f.amount::FLOAT AS amount,
        f.status,
        f.credit_card_id,
        f.created_at,
        f.happened_at,
        s.store_id,
        s.store_name,
        s.city,
        s.country,
        s.typology,
        d.device_type
    FROM fact_transactions f
    LEFT JOIN dim_stores s ON f.store_id = s.store_id
    LEFT JOIN dim_devices d ON f.device_id = d.device_id
    left join dim_product p on f.product_id = p.product_id
)
select * from base