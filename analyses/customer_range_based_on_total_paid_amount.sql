WITH fct_orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

dim_customers AS (
    SELECT * FROM {{ ref('dim_customers') }}
),

total_amount_per_customer_on_orders_complete AS (
    SELECT
        c.customer_id,
        c.first_name,
        SUM(total_amount) as global_paid_amount
    FROM fct_orders AS o 
    LEFT JOIN dim_customers AS c ON c.customer_id = o.customer_id
    WHERE o.is_order_completed = 1
    GROUP BY c.customer_id, first_name
),

customer_range_per_paid_amount AS (
    SELECT * FROM {{ ref('customer_range_per_paid_amount') }}
)

SELECT
    tc.customer_id,
    tc.first_name,
    tc.global_paid_amount,
    cr.classification
FROM total_amount_per_customer_on_orders_complete AS tc
LEFT JOIN customer_range_per_paid_amount AS cr 
ON tc.global_paid_amount >= cr.min_range AND tc.global_paid_amount <= cr.max_range