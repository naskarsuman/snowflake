# 10 — Supply Chain Analytics & Control Tower

## Interview Question

How would I bring procurement, materials, inventory, manufacturing, orders, and transportation data together so business users have one view of supply-chain performance and risk?

## 1. Business Problem

Each business area can have its own system and report. A planner may know that inventory is low, while another team knows that a supplier is late or a shipment is delayed. The business needs these signals connected.

## 2. Goal

Create a cross-domain analytical layer that helps users understand the current state of the supply chain and investigate problems back to source data.

## 3. Source Domains

```text
Suppliers
Procurement
Materials
Manufacturing
Inventory
Orders
Warehouse
Transportation
External Data
```

## 4. Architecture

```text
                  Enterprise Sources
                         |
                         v
                  Data Integration
                         |
                         v
                    Snowflake RAW
                         |
                  Quality / Standardize
                         |
                         v
                    Snowflake PROD
                         |
              +----------+----------+
              |                     |
         Business Models       Supply Chain
              |                 Metrics / KPIs
              +----------+----------+
                         |
             +-----------+-----------+
             |           |           |
          Tableau     Power BI    SAP BO
```

## 5. Business Questions

- Do we have enough material?
- Which suppliers are creating risk?
- Which plants are below plan?
- Where is inventory building up?
- Which shipments are delayed?
- Which customer orders are affected?

## 6. Main Architecture Challenges

- Different business definitions
- Different source systems and keys
- Different data latency
- Conflicting source values
- Large transaction volumes
- Need for historical analysis
- Sensitive business data

## 7. Data Model

The platform can use conformed dimensions and facts for reporting while retaining source-level data for traceability.

Example domains:

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

## 8. Control Tower Metrics

Examples include:

- Inventory availability
- Supplier on-time performance
- Production plan versus actual
- Order fulfillment cycle time
- On-time delivery
- Backorders
- Shipment delays
- Material shortages

## 9. Data Quality

A control tower is only useful if the underlying data is trustworthy. Add checks for missing keys, duplicate transactions, stale source data, invalid dates, unexpected quantities, and reconciliation differences.

## 10. Security

Use RBAC and appropriate row and column security for sensitive data. Access should follow business responsibility and data ownership.

## 11. Failure Handling

If one source is delayed, clearly show the data freshness state instead of presenting stale data as current. Keep pipeline status and source timestamps available for investigation.

## 12. Performance & Cost

Separate operational ingestion from analytical workloads when needed. Build reusable business models instead of allowing every dashboard to repeatedly process large raw tables.

## 13. Trade-offs

A single enterprise model does not mean every source must be forced into one structure immediately. I would standardize the important common dimensions first and allow domain-specific structures where the business requirement is different.

## 14. Interview Answer

I would treat the control tower as the consumption layer, not the starting point. First I would integrate the source domains, establish common keys and business definitions, and build trusted production models. Then I would create cross-domain metrics for inventory, suppliers, production, orders, and transportation. I would also show data freshness and quality status so users know whether a metric can be trusted. The architecture should allow a user to move from a high-level risk to the underlying transaction and source record.
