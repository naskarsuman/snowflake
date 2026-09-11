# 03 — Procurement & Supplier Analytics

## Interview Question

How would I design a data platform that shows purchasing spend, supplier performance, material cost, purchase orders, receipts, and invoices across the enterprise?

## 1. Business Problem

Procurement data is spread across purchasing, supplier, material, receipt, and invoice processes. Business users need to understand spend and supplier performance using consistent definitions.

## 2. Goal

Create a trusted procurement model that can answer questions such as:

- How much are we buying from each supplier?
- Which suppliers have delivery or quality problems?
- Where are material prices increasing?
- Are purchase orders being received as expected?

## 3. Existing Systems

- SAP ECC / procurement data
- Supplier systems
- Material master
- Invoice and receipt data
- External reference data
- Snowflake

## 4. Data Flow

```text
Source Systems
     |
     v
   RAW
     |
 Standardize
     |
 Quality Checks
     |
     v
 Procurement Model
     |
     +--> Supplier Analytics
     +--> Spend Analytics
     +--> Price Analysis
```

## 5. Data Model

A Kimball-style model is a good fit for this reporting use case.

```text
DIM_SUPPLIER
DIM_MATERIAL
DIM_PLANT
DIM_DATE
      |
      +---- FACT_PURCHASE_ORDER
      +---- FACT_RECEIPT
      +---- FACT_INVOICE
```

The grain must be defined before building the fact tables. For example, one row in a purchase-order fact could represent one purchase-order line.

## 6. Main Challenges

- Supplier identifiers differ across systems.
- Purchase orders can have multiple lines.
- Receipts can arrive after the PO.
- Invoice amounts may not exactly match receipts.
- Currency and unit-of-measure conversions may be required.
- Historical supplier or material changes must be handled correctly.

## 7. Data Quality

Validate supplier and material keys, quantities, prices, dates, currencies, duplicate PO lines, and PO-to-receipt relationships.

## 8. Performance & Cost

Use incremental transformations for large transaction tables and avoid unnecessary full refreshes. Cluster or optimize only when query patterns and data volume justify it.

## 9. Troubleshooting

When a spend number looks wrong, trace it from the dashboard to the production model, transformation, RAW record, and source batch. Reconciliation should be part of the design, not an afterthought.

## 10. Interview Answer

I would first define the business metrics and the grain of each transaction. Then I would integrate supplier, material, plant, PO, receipt, and invoice data into Snowflake. I would create conformed dimensions and transaction facts, add reconciliation and quality checks, and make the transformations incremental where appropriate. The design should make it possible to trace a reported number back to the source data.
