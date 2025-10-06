{{ config(materialized='view') }}
with stores as (select * FROM {{ source('raw_data', 'stores') }} )

SELECT
    CAST("id" as INTEGER) as id,
    "name" as name,
    "address" as address,
    "city" as city,
    "country" as country,
    cast("created_at" as date) as created_at,
    "typology" as typology,
    cast("customer_id" as integer) as customer_id
from stores s