# 07 — External Data Integration

## Interview Question
How would I integrate supply-chain data when some sources provide APIs, some provide files, and some are maintained by business users?

## Business Problem
Enterprise supply-chain data is not always available through one standard interface. Data may arrive through APIs, Excel, SharePoint, flat files, or custom processes.

## Goal
Create a controlled integration pattern that accepts different source types while providing consistent data to Snowflake.

## Existing Tools
- APIs
- SharePoint
- Excel / CSV / flat files
- Azure Functions
- Python
- Alteryx
- Other integration tools
- Snowflake stages and ingestion services

## Architecture
```text
API -----------+
Files ---------+
SharePoint ----+
Python --------+--> Integration --> Snowflake RAW
Azure ---------+
Alteryx -------+
```

## Main Challenges
Files may change structure. APIs may fail or throttle. Business files may contain bad values. File names may not be reliable identifiers. Duplicate files may arrive.

## Design Approach
Standardize the landing process even when source technologies differ. Record source name, file name or request ID, load timestamp, and batch ID.

## Idempotency
The pipeline should recognize a file or API batch already processed. A retry should not create duplicate business records.

## Data Quality / Failure Handling
Validate schema, required fields, types, business keys, row counts, and expected file frequency. Separate technical failures from data-quality failures and make both visible to support teams.

## Interview Answer
I would not use the same ingestion method for every source. I would choose based on source capability, volume, latency, and ownership. Regardless of the source, I would land data in a controlled RAW layer with batch metadata, validate it, and make processing idempotent.
