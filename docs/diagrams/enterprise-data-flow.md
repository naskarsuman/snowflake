# Simple Snowflake Data Flow

This is the basic flow used in the examples in this repository.

```text
Source Systems
      |
      v
Cloud Storage / Streaming
      |
      v
Snowflake Ingestion
      |
      v
Raw Data
      |
      v
Data Quality
      |
      v
Transformation
      |
      v
Curated Data
      |
      +------------------+
      |                  |
      v                  v
   Analytics         AI / Search
```

Security, governance, and monitoring should be applied across the platform.
