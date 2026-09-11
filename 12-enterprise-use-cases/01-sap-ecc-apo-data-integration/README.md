# 01 — SAP ECC / APO Data Integration

## Interview Question
How would I bring SAP ECC and SAP APO supply-chain data into Snowflake for enterprise analytics while keeping the load reliable and efficient?

## Business Problem
Supply-chain data is held in SAP systems and is needed by many downstream teams. Full extracts can be large and create unnecessary load. The platform also needs to know what was loaded, what failed, and what can be safely reprocessed.

## Goal
Create a reliable path from SAP source systems into Snowflake RAW, validate the data, and make trusted data available to downstream models and analytics.

## Existing Systems
- SAP ECC
- SAP APO
- SAP BW / HANA
- SAP extractors and delta processing
- Snowflake
- dbt
- Tableau / Power BI / SAP BusinessObjects

## Architecture
```text
SAP ECC / APO
      |
 Extract / Delta
      |
Integration Layer
      |
      v
Snowflake RAW
      |
 Data Quality
      |
      v
Transformation / dbt
      |
      v
Snowflake PROD
      |
 +---- Tableau
 +---- Power BI
 +---- SAP BusinessObjects
```

## Main Challenges
- Large historical loads
- Incremental changes
- Source-to-target reconciliation
- SAP structure changes
- Restarting failed batches

## Snowflake Features
COPY INTO, Snowpipe where file-based loading is appropriate, Streams, Tasks, MERGE, Dynamic Tables where declarative processing fits, RBAC, and masking.

## Data Quality / Failure Handling
Check counts, keys, duplicates, dates, nulls, and rejected records. Track source system, batch ID, load timestamp, and record identifiers. A failed batch should be fixed and rerun without creating duplicates.

## Performance & Cost
Prefer incremental processing, avoid repeated full scans, and size warehouses from actual workload.

## Interview Answer
I would first understand the SAP objects, business keys, data volume, and latency requirement. I would separate the historical load from incremental processing, land data in RAW with audit metadata, validate it, and transform it into PROD. I would use the source delta mechanism together with Snowflake Streams, Tasks, or dbt based on where the processing logic belongs. Reconciliation, restartability, and monitoring would be part of the design from the beginning.
