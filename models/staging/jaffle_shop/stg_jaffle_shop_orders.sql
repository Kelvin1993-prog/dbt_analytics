-- Loading and creating the orders table from the source

SELECT 
    id AS order_id,
    user_id AS customer_id,
    order_date,
    status,
    _etl_loaded_at
FROM {{ source("jaffle_shop", "orders") }}

{% if is_incremental() %}

where _etl_loaded_at >= (SELECT MAX(_etl_loaded_at) from {{ this }})

{% endif %}