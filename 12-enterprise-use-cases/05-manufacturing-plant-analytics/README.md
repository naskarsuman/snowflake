# 05 — Manufacturing & Plant Analytics

## Interview Question
How would I create a common view of production performance across multiple manufacturing plants when plants provide data at different levels of detail and frequency?

## Business Problem
Production information may come from ERP, manufacturing systems, and plant-level sources. Plants may use different definitions and data formats.

## Goal
Create a common model for production volume, plan versus actual, yield, scrap, downtime, and other plant measures.

## Existing Systems
ERP, manufacturing/plant systems, material master, planning data, plant files, Snowflake.

## Architecture
```text
Plant Systems --+
ERP ------------+--> RAW --> Standardize --> Quality --> PROD
Planning -------+
Files ----------+
```

## Main Challenges
Different plant definitions, time zones or shift calendars, production grains, missing readings, duplicate events, late data, and plan/actual data from different sources.

## Data Model
```text
DIM_PLANT
DIM_MATERIAL
DIM_PRODUCTION_LINE
DIM_SHIFT
DIM_DATE

FACT_PRODUCTION
FACT_DOWNTIME
FACT_SCRAP
```

Define the grain before calculating metrics.

## Incremental Processing
For high-volume plant data, process new or changed records where possible. Select Streams/Tasks, Dynamic Tables, or incremental dbt models based on the requirement.

## Data Quality
Check plant and material keys, quantities, timestamps, negative values, missing shifts, duplicates, and plan-versus-actual relationships.

## Interview Answer
I would first standardize the business definitions across plants. Then I would define the production and event grain, land sources in RAW, and build a common production model. Plant-specific differences should be handled through mapping and reference data rather than hard-coded reporting logic. For high-volume data I would use incremental processing and retain source timestamps for troubleshooting.
