{{ config(materialized='table') }}
with stg_transaction as (select * from {{ ref('stg_transactions') }} )

SELECT distinct
     SHA2(concat(product_name,product_sku,category_name)) as product_id
    ,t.product_name
    ,t.product_sku
    ,t.category_name as product_category
FROM stg_transaction t
