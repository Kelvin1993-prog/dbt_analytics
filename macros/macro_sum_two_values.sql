{% macro sum(x, y) %}
    SElECT {{ x + y }}
{% endmacro %}


{% set x = 13 %}
{% set y = 89 %}

{{ sum(x, y) }}