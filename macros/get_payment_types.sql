{% macro get_payment_types1() -%}

    {% set payment_type_query %}
        SELECT 
            DISTINCT payment_type 
        FROM {{ ref('stg_stripe_order_payments') }}
        ORDER BY 1
    {% endset %}

    {% set results = run_query(payment_type_query) %}

    {% if execute %}
    {# Return the first column #}
    {% set results_list = results.column[0].values() %}
    {% else %}
    {% set results_list = [] %}
    {% endif %}


    {{ return(results_list) }}

{% endmacro %}