# 07 — External Data Integration

## Interview Question

How would I integrate supply-chain data when some sources provide APIs, some provide files, and some are maintained by business users?

## 1. Business Problem

Enterprise supply-chain data is not always available through one standard interface. Some data arrives through APIs, Excel files, SharePoint, flat files, or custom processes.

## 2. Goal

Create a controlled integration pattern that can accept different source types and still provide consistent data to Snowflake.

## 3. Existing Tools

- APIs
- SharePoint
- Excel / CSV / flat files
- Azure Functions
- Python
- Alteryx
- Other integration tools
- Snowflake stages and ingestion services

## 4. Architecture

```text
API -----------+
Files ---------+
SharePoint ----+
Python --------+--> Integration --> Snowflake RAW
Azure ---------+
Alteryx -------+
```

## 5. Main Challenges

- Files may change structure.
- APIs can fail or throttle requests.
- Business files may contain bad values.
- File names may not be reliable identifiers.
- Duplicate files may be delivered.
- Source owners may not provide consistent schedules.

## 6. Design Approach

I would standardize the landing process even if the source systems are different. Every load should have metadata such as source name, file name or request identifier, load timestamp, and batch ID.

## 7. Idempotency

The pipeline should recognize a file or API batch that was already processed. A retry should not create duplicate business records.

## 8. Data Quality

Validate schema, required fields, data types, business keys, row counts, and expected file frequency before publishing data to the production layer.

## 9. Failure Handling

Separate technical failures from data-quality failures. A failed API call is different from a successful file containing invalid business data. Both should be visible to the support team.

## 10. Interview Answer

I would not use the same ingestion method for every source. I would choose based on source capability, volume, latency, and operational ownership. Regardless of the source, I would land data in a controlled RAW layer with batch metadata, validate it, and make the processing idempotent. This gives the enterprise one operating pattern even when the source technologies are different.
