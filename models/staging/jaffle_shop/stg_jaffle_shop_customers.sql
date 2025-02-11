-- loading the customer table from the source

-- let us materialize our customer data as a table in dbt


SELECT 
    id AS customer_id,
    first_name,
    last_name
FROM {{ source("jaffle_shop", "customers") }}