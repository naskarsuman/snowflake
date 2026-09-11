# Data Ingestion

This section shows different ways to bring data into Snowflake.

## Topics

- Internal and external stages
- File formats
- COPY INTO
- Snowpipe
- Snowpipe Streaming
- AWS integration

## Simple flow

```text
Source data
    |
    v
Stage
    |
    v
Snowflake table
```

### Batch

Use batch loading when files arrive on a schedule and the business does not need every change immediately.

See [`01_copy_into.sql`](01_copy_into.sql) for a simple example.

More examples will be added as the repository grows.
