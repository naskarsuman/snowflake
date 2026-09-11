# 04 — Inventory & Material Visibility

## Problem Statement
How would I build one trusted view of inventory across plants, warehouses, and in-transit locations when source systems update at different times?

## Business Goal
Create a common inventory view with clear definitions for on-hand, allocated, available, and in-transit inventory.

```text
Available Inventory = On Hand - Allocated + In Transit
```

The exact formula must be agreed with the business.

## Existing Systems
ERP, planning/supply-chain systems, warehouse systems, material master, external data, Snowflake.

## Architecture
```text
ERP -----------+
Planning ------+
WMS -----------+--> RAW --> Quality --> Inventory Model
Master Data ---+
```

## Main Challenges
Different inventory definitions, update times, duplicate snapshots, in-transit material, negative quantities, unit-of-measure differences, and late transactions.

## Design Approach
Agree on inventory definitions first. Standardize material, plant, location, date, quantity, and unit of measure. Keep source and timestamp information so differences can be explained.

## Data Model
```text
DIM_MATERIAL
DIM_PLANT
DIM_LOCATION
DIM_DATE
       |
       +---- FACT_INVENTORY_SNAPSHOT
       +---- FACT_INVENTORY_TRANSACTION
       +---- FACT_IN_TRANSIT
```

Document the grain of every fact.

## Reconciliation
Compare source totals with Snowflake totals and investigate differences rather than hiding them.

## Performance & Cost
Inventory snapshots can become large. Use incremental processing, pruning, and an agreed history-retention policy.

## Interview Answer
I would first agree on what inventory means and which system owns each calculation. Then I would land source data in RAW, standardize and reconcile it, and build a common inventory model. Source timestamps and audit information would remain available for troubleshooting.
