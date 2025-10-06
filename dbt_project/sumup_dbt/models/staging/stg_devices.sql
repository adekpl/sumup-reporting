
{{ config(materialized='view') }}
with devices as (select * from {{ source('raw_data', 'devices') }})

SELECT
    cast("store_id" as integer) as store_id,
    "type" as type,
    cast("id" as integer) as id
FROM devices