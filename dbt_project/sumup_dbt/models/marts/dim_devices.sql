{{ config(materialized='table') }}
with stg_devices as (select * from {{ ref('stg_devices') }})

SELECT DISTINCT
    id as device_id,
    store_id,
    type as device_type
FROM stg_devices
