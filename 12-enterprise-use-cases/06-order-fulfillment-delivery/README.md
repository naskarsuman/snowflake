# 06 — Order Fulfillment & Delivery

## Problem Statement
How would I create end-to-end visibility from customer order through inventory, fulfillment, shipment, and delivery?

## Business Goal
Create one analytical view of the order lifecycle and identify where delays occur.

```text
Order -> Allocation -> Picking -> Packing -> Shipment -> Delivery
```

## Existing Systems
ERP/order system, inventory, warehouse, transportation, customer data, Snowflake.

## Architecture
```text
Orders --------+
Inventory -----+
Warehouse -----+--> RAW --> Integration --> Order Model
Transportation-+
Customer ------+
```

## Main Challenges
One order can contain many lines or shipments. Events may arrive out of order. Systems may use different IDs. Delivery status can change. The business needs one definition of on-time delivery.

## Data Model
```text
DIM_CUSTOMER
DIM_MATERIAL
DIM_PLANT
DIM_LOCATION
DIM_DATE

FACT_ORDER_LINE
FACT_FULFILLMENT_EVENT
FACT_SHIPMENT
FACT_DELIVERY
```

Define table grain before joining data. Maintain cross-reference mappings for order, shipment, material, customer, plant, and location IDs.

## Data Quality / Failure Handling
Check missing IDs, duplicate lines, invalid status transitions, missing relationships, and invalid delivery dates. Record the last successful load and process delayed data when it arrives. Transformations must be safe to rerun.

## Interview Answer
I would build around the order lifecycle rather than one source system. I would integrate order, inventory, warehouse, transportation, and delivery events using common identifiers. I would define grain carefully, handle late and out-of-order events, and create cycle-time and on-time-delivery metrics. Users should be able to trace a late order to the event that caused the delay.
