# Data Engineering

This section covers the Snowflake features I use to build and maintain data pipelines.

## Topics

- Streams
- Tasks
- Dynamic Tables
- Stored Procedures
- Snowpark
- Incremental processing

## Simple pipeline

```text
Source
  |
  v
Raw table
  |
  v
Stream
  |
  v
Task
  |
  v
Curated table
```

I use incremental processing when there is no need to rebuild the whole table every time new data arrives.

See [`01_streams_and_tasks.sql`](01_streams_and_tasks.sql) for a simple CDC example.

More examples will be added here.
