# 03 — Procurement & Supplier Analytics

## Interview Question
How would I design a data platform that shows purchasing spend, supplier performance, material cost, purchase orders, receipts, and invoices across the enterprise?

## Business Problem
Procurement data is spread across purchasing, supplier, material, receipt, and invoice processes. Business users need consistent definitions for spend and supplier performance.

## Goal
Create a trusted procurement model for supplier performance, spend, price analysis, and PO/receipt/invoice analysis.

## Existing Systems
- SAP ECC / procurement data
- Supplier systems
- Material master
- Invoice and receipt data
- External reference data
- Snowflake

## Data Flow
```text
Source Systems -> RAW -> Standardize -> Quality Checks -> Procurement Model
                                                    |
                              +---------------------+----------------+
                              |                     |                |
                         Supplier Analytics   Spend Analytics   Price Analysis
```

## Data Model
A Kimball-style model fits this reporting use case.
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
Define grain before building facts. Example: one purchase-order fact row = one PO line.

## Main Challenges
Different supplier IDs, multiple PO lines, late receipts, invoice/receipt differences, currency and unit conversions, and historical changes.

## Data Quality / Troubleshooting
Validate keys, quantities, prices, dates, currencies, duplicate PO lines, and PO-to-receipt relationships. Trace incorrect spend from the dashboard to the production model, transformation, RAW record, and source batch.

## Performance & Cost
Use incremental transformations for large transaction tables. Optimize only when query patterns and volume justify it.

## Interview Answer
I would first define the business metrics and transaction grain. Then I would integrate supplier, material, plant, PO, receipt, and invoice data. I would create conformed dimensions and transaction facts, add reconciliation and quality checks, and use incremental processing where appropriate. The design should allow every reported number to be traced back to source data.
