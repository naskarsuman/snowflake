# 01 — SAP ECC / APO Data Integration

## Interview Question

How would I bring SAP ECC and SAP APO supply-chain data into Snowflake for enterprise analytics while keeping the load reliable and efficient?

## 1. Business Problem

Supply-chain data is held in SAP systems and is needed by many downstream teams. A full extract every time is expensive and creates unnecessary load. The platform also needs a clear way to know what was loaded, what failed, and what can be safely reprocessed.

## 2. Goal

Create a reliable path from SAP source systems into Snowflake RAW data, then make trusted data available to downstream models and analytics.

## 3. Existing Systems

- SAP ECC
- SAP APO
- SAP BW / HANA
- SAP extractors
- Delta processing / queues
- Snowflake
- dbt
- Tableau / Power BI / SAP BusinessObjects

## 4. Main Challenges

- Full loads can be large.
- SAP structures are not always analytics-friendly.
- Changes need to be captured correctly.
- Source and target counts must reconcile.
- Failed loads must be restartable.
- SAP source changes can affect downstream mappings.

## 5. Architecture

```text
SAP ECC / APO
      |
 Extract / Delta
      |
      v
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

## 6. Snowflake Features

- External stages where applicable
- COPY INTO
- Snowpipe for file-based continuous loading
- Streams for change tracking
- Tasks for scheduled or triggered processing
- MERGE for incremental upserts
- Dynamic Tables when a declarative transformation is a better fit
- RBAC and masking for protected data

## 7. Loading Strategy

I would normally separate the first historical load from ongoing incremental processing.

```text
Initial Load -> Historical RAW data
Incremental  -> New or changed records
```

Every load should carry useful audit information such as source system, load timestamp, batch ID, and source record identifiers.

## 8. Data Quality

Check source-to-target row counts, required keys, duplicate business keys, invalid dates, unexpected nulls, and rejected records.

## 9. Failure Handling

A failed batch should be identifiable by batch ID. I would keep the raw input available where possible, log the failure reason, fix the issue, and rerun only the affected processing rather than starting the whole pipeline again.

## 10. Performance & Cost

Prefer incremental processing when the source supports it. Avoid repeatedly scanning large RAW tables. Size warehouses based on workload and monitor long-running queries and unnecessary compute.

## 11. Trade-offs

The simplest architecture is not always the best one. If SAP already provides a trusted enterprise extraction path, I would reuse it instead of building a parallel extraction mechanism without a clear reason.

## 12. Interview Answer

I would first understand which SAP objects are required, their business keys, data volume, and expected latency. I would separate the initial historical load from incremental processing. Data would land in Snowflake RAW with audit metadata, then be validated and transformed into the production layer. For incremental changes I would use the appropriate source delta mechanism and Snowflake Streams, Tasks, or dbt depending on where the change logic belongs. I would also build reconciliation, error handling, and restartability into the pipeline so the solution is easy to operate.
