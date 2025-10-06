{{ config(materialized='view') }}
with transactions as (select * from {{ source('raw_data', 'transactions') }} )
,first_cleaning as (
SELECT
     cast("id" as integer) as id
    ,cast("device_id" as integer) as device_id
    ,"product_name" as product_name
    ,"product_sku" as product_sku
    ,"category_name" as category_name
    ,cast("amount" as float) as amount
    ,"status" as status
    ,trim("card_number") as card_number
    ,"cvv" as cvv
    ,cast("created_at" as date) as created_at
    ,cast("happened_at" as date) as happened_at
FROM transactions)
,fix_product_sku as (
select
     id
    ,device_id
    ,product_name
    ,cast(replace(product_sku,'v','') as integer) as product_sku
    ,category_name
    ,amount
    ,status
    ,card_number
    ,cvv
    ,created_at
    ,happened_at
from first_cleaning

)
select * from fix_product_sku


				