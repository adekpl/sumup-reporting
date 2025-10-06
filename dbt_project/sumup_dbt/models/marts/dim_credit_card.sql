{{ config(materialized='table') }}

SELECT distinct
     sha2(concat(card_number,cvv)) as credit_card_id
    ,t.card_number
    ,t.cvv
FROM {{ ref('stg_transactions') }} t
