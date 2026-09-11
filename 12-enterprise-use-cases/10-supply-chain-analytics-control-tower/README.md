# 10 — Supply Chain Analytics & Control Tower

## Problem Statement
How would I bring procurement, materials, inventory, manufacturing, orders, and transportation data together so business users have one view of supply-chain performance and risk?

## Business Goal
Create a cross-domain analytical layer that helps users understand supply-chain performance and investigate problems back to source data.

## Source Domains
Suppliers, procurement, materials, manufacturing, inventory, orders, warehouse, transportation, and external data.

## Architecture
```text
Enterprise Sources
       |
Data Integration
       |
Snowflake RAW
       |
Quality / Standardize
       |
Snowflake PROD
       |
Business Models / KPIs
       |
+----------+----------+
|          |          |
Tableau  Power BI  SAP BusinessObjects
```

## Business Questions
- Do we have enough material?
- Which suppliers are creating risk?
- Which plants are below plan?
- Where is inventory building up?
- Which shipments are delayed?
- Which customer orders are affected?

## Main Challenges
Different business definitions, source keys, data latency, conflicting values, large transaction volumes, historical analysis, and sensitive business data.

## Data Model
```text
DIM_MATERIAL
DIM_SUPPLIER
DIM_PLANT
DIM_CUSTOMER
DIM_LOCATION
DIM_DATE

FACT_PROCUREMENT
FACT_INVENTORY
FACT_PRODUCTION
FACT_ORDER
FACT_SHIPMENT
```

## Control Tower Metrics
Inventory availability, supplier on-time performance, production plan versus actual, order cycle time, on-time delivery, backorders, shipment delays, and material shortages.

## Data Quality / Security
Check missing keys, duplicate transactions, stale data, invalid dates, unexpected quantities, and reconciliation differences. Use RBAC and appropriate row and column security for sensitive data.

## Failure Handling
If a source is delayed, show data freshness instead of presenting stale data as current. Keep pipeline status and source timestamps available for investigation.

## Performance & Cost
Separate workloads when needed and build reusable business models instead of allowing every dashboard to process large RAW tables repeatedly.

## Trade-offs
Standardize important common dimensions first. Allow domain-specific structures where the business requirement is different.

## Interview Answer
I would treat the control tower as the consumption layer, not the starting point. First I would integrate the source domains, establish common keys and business definitions, and build trusted production models. Then I would create cross-domain metrics for inventory, suppliers, production, orders, and transportation. I would also show data freshness and quality status so users know whether a metric can be trusted. The architecture should allow a user to move from a high-level risk to the underlying transaction and source record.
