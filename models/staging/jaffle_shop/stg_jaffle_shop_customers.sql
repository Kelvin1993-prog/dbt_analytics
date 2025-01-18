-- loading the customer table from the source

-- let us materialize our customer data as a table in dbt

{{
    config(
        materialized = 'table'
    )
}}

SELECT 
    id AS customer_id,
    first_name,
    last_name,
FROM dbt-tutorial.jaffle_shop.customers