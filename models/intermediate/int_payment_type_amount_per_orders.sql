WITH order_payment AS(
    SELECT * FROM {{ ref('stg_stripe_order_payments') }}
)

SELECT
    order_id,
    SUM(
        CASE 
            WHEN payment_type = 'cash' and 
                 status = 'success'
            THEN amount
            ELSE 0
        END
    ) AS cash_amount,
    SUM(
        CASE 
            WHEN payment_type = 'credit' and
                 status = 'success'
            THEN amount 
            ELSE 0
        END
    ) AS credit_amount,
    SUM(
        CASE 
            WHEN status = 'success' 
            THEN amount 
        END
    ) AS total_amount
FROM order_payment 
GROUP BY 1


