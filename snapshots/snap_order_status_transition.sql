{% snapshot orders_status_snapshot %}

{{
    config(
        target_schema= 'snapshots',
        unique_key= 'id',

        strategy= 'timestamp',
        updated_at= '_etl_loaded_at'
    )
}}

SELECT * FROM {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}