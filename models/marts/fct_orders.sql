WITH orders AS (
    SELECT * FROM {{ ref("stg_jaffle_shop_orders") }}
),

payment_type_orders AS (
    SELECT * FROM {{ ref("int_payment_type_amount_per_orders") }}
)

SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    pt.cash_amount,
    pt.credit_amount,
    pt.total_amount,
    CASE 
        WHEN status = 'completed'
        THEN 1
        ELSE 0
    END AS is_order_completed
FROM orders AS o 
LEFT JOIN payment_type_orders AS pt
ON o.order_id = pt.order_id 

{#add macro check for current environment (dev or deploy or test)

-- {{-  limit_dataset_if_not_deploy_env('order_date', 3) -}}#}
