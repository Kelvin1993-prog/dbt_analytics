SELECT
    order_id,
    SUM(total_amount) as total_amount
FROM {{ ref('int_payment_type_amount_per_orders') }}
GROUP BY order_id
HAVING total_amount < 0