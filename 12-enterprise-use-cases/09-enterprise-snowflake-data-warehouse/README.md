# 09 — Enterprise Snowflake Data Warehouse

## Problem Statement
How would I design Snowflake as an enterprise data warehouse when data comes from SAP, databases, files, and external sources and is consumed by multiple analytics tools?

## Business Goal
Create a simple, traceable warehouse architecture that separates raw source data from business-ready data.

## Logical Layers
```text
Source Systems
      |
Landing / Ingestion
      |
RawDB
      |
Staging / Transformation
      |
ProdDB
      |
Business Models / Marts
      |
+---- Tableau
+---- Power BI
+---- SAP BusinessObjects
```

## Why Raw and Production Layers?
RAW preserves the source representation as much as practical and provides traceability. PROD contains standardized, governed, business-ready structures.

## Transformation
Use dbt or Snowflake-native processing where it provides the clearest operating model. Logic should be version controlled, tested, documented, and traceable.

## Data Modeling
- Kimball for analytics and reporting
- Data Vault for integrating and historizing enterprise sources
- Inmon / normalized structures where appropriate

The business requirement should drive the model.

## Governance
Define ownership, data definitions, access roles, sensitive columns, lineage, and quality expectations. Apply security at the data platform rather than rebuilding it in every dashboard.

## Performance & Cost
Separate workloads when needed, size warehouses from actual workload, use incremental processing for large transformations, and monitor expensive queries.

## Failure Handling
Major pipelines should have load status, timestamps, row counts, error details, and a clear recovery path.

## Interview Answer
I would design Snowflake in layers so ingestion, transformation, and consumption have clear responsibilities. RAW provides traceability and PROD contains standardized, governed data. I would use dbt or Snowflake-native features based on the transformation needs, apply security centrally, and make data available to the required analytics tools. Quality, monitoring, reconciliation, and recovery would be designed from the beginning.
