SELECT  
    order_id,
    customer_id,
    cash_amount,
    total_amount,
    {{ dbt_utils.safe_divide('cash_amount', 'total_amount') }} AS per_total
FROM {{ ref('fct_orders') }}