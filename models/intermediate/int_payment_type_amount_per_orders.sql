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

-- let's creat dynamic jinja sql

{# declaration of payment_type variable#. Add new variable type when introduced#}


-- {%- set payment_types = ['cash', 'credit', 'debit'] -%} 

-- -- or {%- set payment_types = get_payment_types() -%}

-- WITH 
--     payments AS (
--         SELECT * FROM {{ ref('stg_stripe_order_payments') }}
--     ),

--     pivot_and_aggregate_payment_data AS (
--         SELECT 
--             order_id,
--             {% for payment_type in payment_types -%}

--             SUM(
--                 CASE
--                     WHEN payment_type = '{{ payment_type }}' and 
--                          status = 'sucess'
--                     THEN amount
--                     ELSE 0
--                 END
--             ) as {{ payment_type }}_amount,
            
--             {%- endfor %}

--             SUM(
--                 CASE 
--                 WHEN status = 'success' THEN amount
--                 END
--             ) AS total_amount 

--         FROM paynments

--         GROUP BY 1
--     )

--     SELECT * FROM pivot_and_aggregate_payment_data
