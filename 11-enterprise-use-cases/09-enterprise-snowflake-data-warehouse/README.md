# 09 — Enterprise Snowflake Data Warehouse

## Interview Question

How would I design Snowflake as an enterprise data warehouse when data comes from SAP, databases, files, and external sources and is consumed by multiple analytics tools?

## 1. Business Problem

Data is spread across different systems and reporting tools. The warehouse needs clear layers, ownership, transformation rules, security, and a reliable path from source data to business reporting.

## 2. Goal

Create a simple, traceable warehouse architecture that separates raw source data from business-ready data.

## 3. Logical Layers

```text
Source Systems
      |
      v
Landing / Ingestion
      |
      v
RawDB
      |
      v
Staging / Transformation
      |
      v
ProdDB
      |
      v
Business Models / Marts
      |
      +---- Tableau
      +---- Power BI
      +---- SAP BusinessObjects
```

## 4. Why Raw and Production Layers?

RAW should preserve the source representation as much as practical and provide a traceable starting point for processing. Production data should contain standardized, governed, business-ready structures.

## 5. Transformation

Use dbt or Snowflake-native processing where it provides the clearest operating model. Transformation logic should be version controlled, tested, documented, and easy to trace.

## 6. Data Modeling

Different workloads may use different models:

- Kimball for analytics and reporting
- Data Vault for integrating and historizing enterprise sources
- Inmon / normalized structures where an enterprise normalized model is appropriate

The business requirement should drive the model.

## 7. Governance

Define ownership, data definitions, access roles, sensitive columns, lineage, and quality expectations. Security should be applied at the data platform rather than rebuilt separately in every dashboard.

## 8. Performance & Cost

Separate workloads when needed, size warehouses based on actual workload, use incremental processing for large transformations, and monitor expensive queries. Do not optimize based only on assumptions.

## 9. Failure Handling

Every major pipeline should have load status, timestamps, row counts, error details, and a clear recovery path.

## 10. Interview Answer

I would design Snowflake in layers so that ingestion, transformation, and business consumption have clear responsibilities. Raw data would provide traceability, while ProdDB would contain standardized and governed data. I would use dbt or Snowflake-native features based on the transformation needs, apply security centrally, and make the data available to the required analytics tools. The design would include quality checks, monitoring, reconciliation, and a recovery process from the beginning.
