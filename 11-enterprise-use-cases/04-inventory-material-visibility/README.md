# 04 — Inventory & Material Visibility

## Interview Question

How would I build one trusted view of inventory across plants, warehouses, and in-transit locations when the source systems update at different times?

## 1. Business Problem

Inventory information can come from ERP, warehouse systems, planning systems, and other sources. A planner may see different numbers depending on the system or report being used.

## 2. Goal

Create a common inventory view that clearly defines on-hand, allocated, available, and in-transit inventory.

```text
Available Inventory
= On Hand - Allocated + In Transit
```

The exact business formula should be agreed with the business before implementation.

## 3. Existing Systems

- ERP
- Planning / supply-chain systems
- Warehouse systems
- Material master
- External data
- Snowflake

## 4. Architecture

```text
ERP -----------+
Planning ------+
WMS -----------+--> RAW --> Quality --> Inventory Model
Master Data ---+
```

## 5. Main Challenges

- Different definitions of inventory
- Different update times
- Duplicate snapshots
- In-transit material
- Negative or unexpected quantities
- Unit-of-measure differences
- Late-arriving transactions

## 6. Design Approach

I would first agree on inventory definitions. Then I would standardize material, plant, warehouse, date, quantity, and unit-of-measure information. The curated model should keep enough source and timestamp information to explain where each inventory number came from.

## 7. Data Model

Possible model:

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

The grain of each fact should be documented separately.

## 8. Reconciliation

Compare inventory totals between source systems and Snowflake. Investigate differences instead of hiding them with transformations.

## 9. Performance & Cost

Inventory snapshots can become very large. Use incremental processing, appropriate pruning, and only retain detailed history for as long as the business requires.

## 10. Interview Answer

I would not start with the dashboard. I would first agree on what inventory means and which system owns each part of the calculation. Then I would bring the source data into RAW, standardize it, reconcile it, and build a common inventory model. I would keep source timestamps and audit information so planners can explain differences between systems.
