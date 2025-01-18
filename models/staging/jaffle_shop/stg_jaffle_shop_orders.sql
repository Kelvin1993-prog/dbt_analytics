-- Loading and creating the orders table from the source

SELECT 
    id AS order_id,
    user_id AS customer_id,
    order_date,
    status,
    _etl_loaded_at
FROM dbt-tutorial.jaffle_shop.orders 