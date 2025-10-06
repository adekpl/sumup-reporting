{{ config(materialized='table') }}
with stg_transactions as (select * from {{ ref('stg_transactions') }})
,dim_devices as (select * from {{ ref('dim_devices') }} )
SELECT
     t.id as transaction_id
    ,t.device_id
    ,SHA2(concat(product_name,product_sku,category_name)) as product_id
    ,t.amount
    ,t.status
    ,sha2(concat(t.card_number,t.cvv)) as credit_card_id
    ,t.created_at
    ,t.happened_at
    ,d.store_id
FROM  stg_transactions t
left join dim_devices d on t.device_id = d.device_id
