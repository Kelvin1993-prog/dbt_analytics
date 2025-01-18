-- loading the orders table from the source data

select  
    id AS payment_id,
    orderid AS order_id,
    paymentmethod AS payment_method,
    CASE
        WHEN paymentmethod IN (
            'stripe',
            'paypal',
            'credit_card',
            'gift_card'

        )
        THEN 'credit'
        ELSE 'cash'
    END AS payment_type, -- creating both card and cash payment options
    status,
    amount,
    CASE 
        WHEN status = 'success'
        THEN true
        ELSE false
    END AS is_completed_payment,
    created as created_date
FROM dbt-tutorial.stripe.payment
