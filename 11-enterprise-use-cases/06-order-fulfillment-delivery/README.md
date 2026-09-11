# 06 — Order Fulfillment & Delivery

## Interview Question

How would I create end-to-end visibility from customer order through inventory, fulfillment, shipment, and delivery?

## 1. Business Problem

An order often moves through several systems. When delivery is late, no single system may show the complete journey.

## 2. Goal

Create one analytical view of the order lifecycle and identify where delays occur.

```text
Order
  -> Allocation
  -> Picking
  -> Packing
  -> Shipment
  -> Delivery
```

## 3. Existing Systems

- ERP / order system
- Inventory systems
- Warehouse systems
- Transportation systems
- Customer data
- Snowflake

## 4. Architecture

```text
Orders --------+
Inventory -----+
Warehouse -----+--> RAW --> Integration --> Order Model
Transportation-+
Customer ------+
```

## 5. Main Challenges

- One order can contain many lines.
- One order can have multiple shipments.
- Events may arrive out of order.
- Different systems use different IDs.
- Delivery status can change after the first event.
- Business users need one definition of on-time delivery.

## 6. Data Model

Possible dimensions:

```text
DIM_CUSTOMER
DIM_MATERIAL
DIM_PLANT
DIM_LOCATION
DIM_DATE
```

Possible facts:

```text
FACT_ORDER_LINE
FACT_FULFILLMENT_EVENT
FACT_SHIPMENT
FACT_DELIVERY
```

## 7. Key Design Point

I would define the grain of each table before joining data. I would also maintain cross-reference mappings for order, shipment, material, customer, plant, and location identifiers.

## 8. Data Quality

Check missing order IDs, duplicate order lines, invalid status transitions, missing shipment relationships, and delivery dates that do not make business sense.

## 9. Failure Handling

If a source is delayed, the pipeline should record the last successful load and process the missing data when it arrives. The transformation should be safe to rerun.

## 10. Interview Answer

I would build the solution around the order lifecycle rather than around one source system. I would integrate order, inventory, warehouse, transportation, and delivery events using common business identifiers. I would define table grain carefully, handle late and out-of-order events, and create metrics such as cycle time and on-time delivery. The final model should also allow a business user to trace a late order back to the event that caused the delay.
