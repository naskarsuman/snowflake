# 08 — Enterprise CDC & Incremental Processing

## Interview Question

How would I process inserts, updates, and deletes from large operational systems without repeatedly reprocessing the entire source table?

## 1. Business Problem

Operational tables can contain millions or hundreds of millions of records. Reprocessing the full table for every change increases runtime and cost.

## 2. Goal

Capture and process only the data that changed while keeping the pipeline reliable and restartable.

## 3. Architecture

```text
Source / CDC
     |
     v
Snowflake RAW
     |
   Stream
     |
     v
 Task / dbt / Dynamic Table
     |
     v
  MERGE / Transform
     |
     v
Snowflake PROD
```

## 4. Main Challenges

- INSERT, UPDATE, and DELETE handling
- Duplicate change events
- Out-of-order changes
- Failed jobs
- Reprocessing
- Stream consumption behavior
- Schema changes
- Large transaction volumes

## 5. Design Approach

I would first confirm what the source CDC mechanism provides. Then I would preserve useful change metadata and apply changes to the target using a business key or another stable identifier.

## 6. Streams vs Tasks vs Dynamic Tables vs dbt

- **Streams:** capture row-level changes for supported objects.
- **Tasks:** run procedural or scheduled/triggered processing.
- **Dynamic Tables:** useful when the transformation can be expressed declaratively and managed by target freshness.
- **dbt:** useful when transformation logic, testing, documentation, and deployment are managed through dbt.

The choice depends on the type of processing rather than using one feature everywhere.

## 7. Idempotency

A rerun should produce the same final result as a successful first run. MERGE logic, stable keys, and batch/change metadata are important parts of this design.

## 8. Data Quality

Check duplicate keys, missing change identifiers, invalid operation types, unexpected deletes, and source-to-target counts.

## 9. Failure Handling

Record batch status and processing timestamps. If a transformation fails, identify the affected change range and recover without duplicating already-applied changes.

## 10. Interview Answer

For a large operational source, I would avoid a full refresh unless there is a specific reason to use one. I would use the source CDC capability to identify changes, land them in RAW, and then apply the changes to the target using the appropriate Snowflake and transformation features. I would make the processing idempotent, add reconciliation and audit metadata, and design recovery before putting the pipeline into production.
