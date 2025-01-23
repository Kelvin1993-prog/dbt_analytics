{# Generic macro to give a column name and table outputs the distinct fields of the given column name #}

{% macro get_column_values(column_banme, table_name) %}

{% set relation_query %}
    SELECT 
        DISTINCT {{ column_name }}
    FROM {{ table_name }}
    ORDER BY 1 
{% endset %}

{% set results = run_query(relation_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.column[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}

{# Macro to get the distinct payment_types #}
{% macro get_payment_types() %}

{{ return(get_column_values('payment_type', ref('stg_stripe_order_payments'))) }}

{% endmacro %}

{# macro to get the distinct payment_methods #}
{% macro get_payment_methods() %}

{{ return(get_column_values('payment_method', ref('stg_stripe_order_payments'))) }}

{% endmacro %}