WITH fct_orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
), 

dim_customers AS (
    SELECT * FROM {{ ref('dim_customers') }}
)

SELECT *
FROM
       ( SELECT
            c.customer_id,
            c.first_name,
            SUM(total_amount) AS global_paid_amount
        FROM fct_orders AS o
        LEFT JOIN dim_customers AS c ON o.customer_id = c.customer_id
        WHERE o.is_order_completed = 1
        GROUP BY c.customer_id, c.first_name
        ORDER BY global_paid_amount DESC) AS final_table
LIMIT 10  




