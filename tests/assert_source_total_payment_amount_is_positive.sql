SELECT
    orderid as order_id,
    SUM(amount) as total_amount
FROM {{ source("stripe", "payment") }}
GROUP BY 1
HAVING total_amount < 0