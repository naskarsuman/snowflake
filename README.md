# Snowflake

A practical collection of Snowflake examples that I use to learn, build, and explain data engineering and data architecture concepts.

The goal of this repository is simple: show how I would use Snowflake to solve common data problems in a real project.

## What is covered

- Snowflake basics and setup
- Data loading and ingestion
- Streams, Tasks, and incremental processing
- Data modeling
- Data quality
- Security and governance
- Performance and cost
- Data sharing
- Enterprise data architecture
- AI-ready data
- Enterprise supply-chain architecture case studies
- End-to-end examples

## How I organize each example

For each topic, I try to answer a few simple questions:

1. What problem are we solving?
2. Why would I use this Snowflake feature?
3. How does it work?
4. What does the SQL look like?
5. When would I use it in a real project?
6. What should I watch out for?

For the enterprise use cases, I go one level deeper and explain the problem, existing systems, requirements, architecture options, design decision, implementation, data quality, security, failure handling, troubleshooting, performance, cost, and trade-offs.

## Repository structure

| Folder | What you will find |
|---|---|
| `01-foundations` | Databases, schemas, warehouses, and basic setup |
| `02-ingestion` | Loading data into Snowflake |
| `03-data-engineering` | Streams, Tasks, Dynamic Tables, and incremental processing |
| `04-data-modeling` | Dimensional modeling, Data Vault, and SCD patterns |
| `05-data-quality` | Data quality rules, validation, and monitoring |
| `06-governance-security` | RBAC, masking, row access, tags, and classification |
| `07-performance-cost` | Query tuning, warehouse sizing, and cost control |
| `08-data-sharing` | Secure data sharing patterns |
| `09-architecture` | Enterprise architecture and reference patterns |
| `10-ai-ready-data` | Data foundations for AI and search use cases |
| `11-enterprise-use-cases` | Enterprise supply-chain data architecture case studies |
| `11-end-to-end` | Complete business examples |

## Enterprise Supply Chain Case Studies

The `11-enterprise-use-cases` section uses a realistic enterprise supply-chain environment with SAP, databases, SharePoint, external data, integration tools, Snowflake, dbt, and business analytics platforms.

The use cases cover:

1. SAP ECC / APO Data Integration
2. Supply Chain Master Data
3. Procurement & Supplier Analytics
4. Inventory & Material Visibility
5. Manufacturing & Plant Analytics
6. Order Fulfillment & Delivery
7. External Data Integration
8. Enterprise CDC & Incremental Processing
9. Enterprise Snowflake Data Warehouse
10. Supply Chain Analytics & Control Tower

These are portfolio case studies. They do not contain company data, credentials, or confidential information.

## My approach

I prefer simple designs that are easy to understand, operate, and explain.

The examples are intentionally focused on the reason behind a design decision, not just the SQL syntax.

## Note

These examples are for learning and portfolio use. They do not contain company data, credentials, or other confidential information.
