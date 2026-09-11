# 08 — Enterprise CDC & Incremental Processing

## Interview Question
How would I process inserts, updates, and deletes from large operational systems without repeatedly reprocessing the entire source table?

## Business Problem
Operational tables can contain millions or hundreds of millions of records. Full processing for every change increases runtime and cost.

## Goal
Capture and process only changed data while keeping the pipeline reliable and restartable.

## Architecture
```text
Source / CDC -> Snowflake RAW -> Stream -> Task / dbt / Dynamic Table -> MERGE / Transform -> Snowflake PROD
```

## Main Challenges
INSERT/UPDATE/DELETE handling, duplicate events, out-of-order changes, failed jobs, reprocessing, stream behavior, schema changes, and large transaction volumes.

## Design Approach
Confirm what the source CDC mechanism provides. Preserve change metadata and apply changes using a stable business key or identifier.

## Streams vs Tasks vs Dynamic Tables vs dbt
- Streams capture row-level changes for supported objects.
- Tasks run scheduled or triggered processing.
- Dynamic Tables fit declarative transformations managed by freshness.
- dbt fits transformation logic, testing, documentation, and deployment managed through dbt.

The choice depends on the processing requirement.

## Idempotency
A rerun should produce the same final result as a successful first run. MERGE logic, stable keys, and batch/change metadata are important.

## Data Quality / Failure Handling
Check duplicate keys, missing change identifiers, invalid operations, unexpected deletes, and source-to-target counts. Record batch status and processing timestamps and recover without duplicating applied changes.

## Interview Answer
For a large operational source, I would avoid a full refresh unless there is a reason to use one. I would use the source CDC capability to identify changes, land them in RAW, and apply them with the appropriate Snowflake and transformation features. I would make the processing idempotent, add reconciliation and audit metadata, and design recovery before production.
