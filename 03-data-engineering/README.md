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

Source → Raw table → Changes → Transformation → Curated table

I use incremental processing when there is no need to rebuild the whole table every time new data arrives.

More examples will be added here.
