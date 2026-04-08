 Project Overview
This project transforms raw transactional data from two sources into clean, well-documented, BI-ready dimensional models following dbt best practices.
Business context: The Jaffle Shop is a fictional e-commerce business. Customers place orders paid via Stripe. The models answer:

What is the total revenue per order, split by payment type (cash vs. credit)?
Which orders have been successfully completed?
How do we link orders back to customers for reporting?


 Architecture
models/
├── staging/
│   ├── jaffle_shop/
│   │   ├── stg_jaffle_shop_customers.sql    # Renames & cleans customer source
│   │   ├── stg_jaffle_shop_orders.sql       # Renames & cleans orders source
│   │   ├── _jaffle_shop_models.yml          # Column docs & schema tests
│   │   └── _jaffle_shop_sources.yml         # Source definitions
│   └── stripe/
│       ├── stg_stripe_order_payments.sql    # Classifies payments → cash/credit
│       └── _stripe_sources.yml              # Source definitions
├── intermediate/
│   └── int_payment_type_amount_per_orders.sql  # Pivots payment types per order
└── marts/
    ├── dim_customers.sql                    # Customer dimension (materialised as table)
    ├── fct_orders.sql                       # Orders fact table (materialised as table)
    ├── _core_models.yml                     # Full column docs & tests
    └── _code_docs.md                        # Extended Jinja doc blocks

 Materialisation Strategy
LayerMaterialisationReasonstagingviewLightweight wrappers; always reflects latest sourceintermediateviewReusable business logic; not exposed to BI toolsmartstableMaterialised for fast BI query performance

 Model Reference
Staging
stg_jaffle_shop_orders
Standardises the raw orders table:

id → order_id
user_id → customer_id
Preserves order_date, status, _etl_loaded_at

stg_stripe_order_payments
Cleans Stripe data and adds payment classification logic:

id → payment_id, orderid → order_id
Classifies payment methods:

Credit: stripe, paypal, credit_card, gift_card
Cash: all other methods


Adds is_completed_payment (boolean flag)


Intermediate
int_payment_type_amount_per_orders
Pivots payment rows into one row per order with amount breakdown:
sqlSELECT
    order_id,
    SUM(CASE WHEN payment_type = 'cash'   AND status = 'success' THEN amount ELSE 0 END) AS cash_amount,
    SUM(CASE WHEN payment_type = 'credit' AND status = 'success' THEN amount ELSE 0 END) AS credit_amount,
    SUM(CASE WHEN status = 'success' THEN amount END)                                     AS total_amount
FROM stg_stripe_order_payments
GROUP BY 1

Marts
fct_orders — Orders Fact Table
ColumnDescriptionorder_idPrimary keycustomer_idFK → dim_customersorder_dateDate order was placedcash_amountTotal successful cash payments on this ordercredit_amountTotal successful credit payments on this ordertotal_amountTotal successful payments (all methods)is_order_completed1 if status = 'completed', else 0
dim_customers — Customer Dimension
ColumnDescriptioncustomer_idPrimary keyfirst_nameCustomer first namelast_nameCustomer last name

 Testing
Test TypeApplied Tonot_nullAll PKs and FKsuniqueAll primary keysrelationshipsfct_orders.customer_id → dim_customers.customer_idSource freshnessRaw source tables

🛠️ Tech Stack
ToolPurposedbt Core 1.xTransformation frameworkBigQueryCloud data warehouseJinja2Dynamic SQL templatingYAMLDocs, tests, source configsGitVersion control

 Getting Started
1. Install dbt
bashpip install dbt-bigquery
2. Configure your profile (~/.dbt/profiles.yml)
yamlmy_new_project:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: your-gcp-project-id
      dataset: dbt_dev
      threads: 4
      timeout_seconds: 300
3. Run the project
bashgit clone https://github.com/Kelvin1993-prog/dbt_analytics.git
cd dbt_analytics

dbt debug           # Test connection
dbt run             # Build all models
dbt test            # Run all tests
dbt docs generate   # Generate docs site
dbt docs serve      # Browse at http://localhost:8080
