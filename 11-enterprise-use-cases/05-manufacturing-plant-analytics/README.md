# 05 — Manufacturing & Plant Analytics

## Interview Question

How would I create a common view of production performance across multiple manufacturing plants when plants provide data at different levels of detail and frequency?

## 1. Business Problem

Production information may come from ERP, manufacturing systems, and plant-level sources. Each plant may use different definitions or data formats.

## 2. Goal

Create a common analytical model for production volume, plan versus actual, yield, scrap, downtime, and other plant measures.

## 3. Existing Systems

- ERP
- Manufacturing / plant systems
- Material master
- Planning data
- External or plant files
- Snowflake

## 4. Architecture

```text
Plant Systems --+
ERP ------------+--> RAW --> Standardize --> Quality --> PROD
Planning -------+
Files ----------+
```

## 5. Main Challenges

- Different plant definitions
- Different time zones or shift calendars
- Different production grains
- Missing readings
- Duplicate events
- Late-arriving data
- Actual versus planned values coming from different sources

## 6. Data Model

Possible dimensions:

```text
DIM_PLANT
DIM_MATERIAL
DIM_PRODUCTION_LINE
DIM_SHIFT
DIM_DATE
```

Possible facts:

```text
FACT_PRODUCTION
FACT_DOWNTIME
FACT_SCRAP
```

The grain must be defined before metrics are calculated.

## 7. Incremental Processing

For high-volume plant data, process only new or changed records where possible. Streams and Tasks, Dynamic Tables, or incremental dbt models can be selected based on the processing requirement.

## 8. Data Quality

Check plant and material keys, production quantities, timestamps, negative values, missing shifts, duplicate events, and plan-versus-actual relationships.

## 9. Interview Answer

I would first standardize the business definitions across plants. Then I would identify the grain of production and event data, land the sources in RAW, and build a common production model. I would handle plant-specific differences through mapping and reference data rather than hard-coding every exception in the reporting layer. For high-volume data I would use incremental processing and keep source timestamps for troubleshooting.
