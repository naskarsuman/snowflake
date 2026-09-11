# Data Quality

This section shows a practical metadata-driven data quality pattern in Snowflake.

The main idea is simple: **keep the data quality rules in metadata and use the same process to run them.**

That means we do not need to build a completely new data quality process every time a new table is added.

## Problem Statement

Data comes from many systems such as ERP, APIs, files, and applications.

Before this data is used by reporting, analytics, or other downstream systems, we need to answer a few basic questions:

- Is required data missing?
- Is the data in the right format?
- Are values within the expected range?
- Are there duplicate records?
- Are values from an approved list?
- Which records failed?
- Can we trace when and why the check failed?

A simple collection of SQL checks works for a few tables, but it becomes difficult to maintain as the number of tables and rules grows.

## Business Goal

Build one reusable data quality process that can:

- Run checks for many tables
- Store rules as metadata
- Process only changed records where possible
- Record pass/fail results
- Keep failed records with error details
- Support retry and reprocessing
- Provide an audit trail
- Send alerts when a quality check fails

## Architecture

```text
Source Systems
     |
     v
Snowpipe / COPY INTO
     |
     v
RAW Tables
     |
     v
Streams  ----> captures INSERT / UPDATE / DELETE changes
     |
     v
Tasks    ----> starts processing when stream has data
     |
     v
DQ Stored Procedure
     |
     +---- Read DQ_TABLE_MASTER
     |
     +---- Read DQ_RULE_MASTER
     |
     +---- Run DQ Rules
     |
     +---- Write Results
     |
     +---- PASS ----------------> Integration / Downstream
     |
     +---- FAIL ----------------> Quarantine + Error Details
```

## Metadata Tables

### 1. DQ_TABLE_MASTER

Controls which tables are included in data quality processing.

Example information:

- Table name
- Stream name
- Whether DQ is enabled
- Frequency
- Owner team
- Notification group

### 2. DQ_RULE_MASTER

Stores the rules that should be applied to each table.

Example rules:

- NULL_CHECK
- DUPLICATE_CHECK
- REGEX_CHECK
- RANGE_CHECK
- DOMAIN_CHECK
- CUSTOM_SQL_CHECK
- ROW_COUNT_CHECK

### 3. DQ_EXECUTION_STATUS

Stores the result of each rule execution.

### 4. DQ_ERROR_DETAIL

Stores failed-record information so the problem can be investigated.

### 5. DQ_AUDIT_LOG

Stores the overall execution summary such as run ID, start/end time, status, total rows, passed rows, and failed rows.

## How the Process Works

### Step 1 — Load the RAW table

Data is loaded into a RAW table without changing the source data.

### Step 2 — Capture changes

A Snowflake Stream captures new changes from the RAW table.

This allows the DQ process to focus on changed data instead of checking the entire table every time.

### Step 3 — Start the task

A Snowflake Task checks whether the stream has data.

If there is new data, the task calls the DQ stored procedure.

### Step 4 — Read metadata

The procedure reads:

- Which tables are enabled
- Which rules are active
- What severity each rule has

### Step 5 — Run the rules

For example, a customer table may have these checks:

```sql
CUSTOMER_NAME IS NOT NULL
```

```sql
AGE >= 18
```

```sql
COUNTRY IN ('USA', 'India')
```

```sql
CREATED_DATE <= CURRENT_DATE()
```

### Step 6 — Record the result

The process records whether each rule passed or failed.

A run ID connects the execution summary, rule results, and failed records.

### Step 7 — Route the data

If the data passes the required checks, it can continue to the integration layer and downstream systems.

If it fails, the failed records can be moved to a quarantine area with the reason for failure.

### Step 8 — Alert the team

The same framework can be connected to email, Slack, Teams, webhooks, or Snowflake alert mechanisms.

## Simple Example

Suppose five customer records arrive.

One record has:

```text
AGE = -5
```

The range check fails.

Instead of allowing the bad record to continue, the framework can:

1. Record the failed rule
2. Store the failed record
3. Store the error message
4. Mark the run as FAIL
5. Route the record to quarantine
6. Alert the responsible team

The corrected record can then be reprocessed.

## Why Metadata-Driven?

Without metadata, we might write separate code like:

```text
customer_dq.sql
product_dq.sql
order_dq.sql
supplier_dq.sql
```

With metadata, the rules are stored as data and the processing logic can be reused.

When a new table is added, the goal is to add metadata and rules rather than copy and modify the whole framework.

## Code

The SQL example is available here:

- `01_rules_driven_data_quality.sql` — basic rule metadata example
- `02_metadata_driven_framework.sql` — stream + task + stored procedure + audit/error tables

## Important Production Considerations

The example is intentionally small so the design is easy to understand.

In a production implementation, I would also consider:

- Dynamic SQL for executing rules from metadata
- Rule versioning
- Rule severity such as ERROR / WARNING
- Table-level and rule-level thresholds
- Quarantine tables by subject area
- Retry and reprocessing logic
- Data retention for audit tables
- Role-based access to failed data
- Alert routing by owner team
- DQ scorecards and dashboards
- SLA monitoring
- Stream staleness monitoring
- Task failure monitoring

## Key Benefits

- **Reusable** — same framework can support many tables
- **Metadata driven** — rules are managed as data
- **Incremental** — streams help process changes
- **Auditable** — every run can have a run ID and execution history
- **Actionable** — failed records are kept with error details
- **Scalable** — new tables and rules can be added without rebuilding the whole process

## Repository

This example is part of my Snowflake architecture and engineering examples.

The complete data quality section is available in the GitHub repository under `05-data-quality`.
