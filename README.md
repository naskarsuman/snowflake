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
- End-to-end examples
- Enterprise supply-chain architecture case studies

## How I organize each example

For normal examples, I try to answer:

1. What problem are we solving?
2. Why would I use this Snowflake feature?
3. How does it work?
4. What does the SQL look like?
5. When would I use it in a real project?
6. What should I watch out for?

For the enterprise case studies, I go deeper:

`Problem -> Goal -> Existing Systems -> Requirements -> Challenges -> Options -> Design -> Implementation -> Data Quality -> Security -> Failure Handling -> Troubleshooting -> Performance/Cost -> Trade-offs -> Interview Answer`

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
| `11-end-to-end` | Complete business examples |
| `12-enterprise-use-cases` | Enterprise supply-chain data architecture case studies |

## Enterprise Supply Chain Case Studies

The `12-enterprise-use-cases` section uses a realistic enterprise supply-chain environment with SAP, databases, SharePoint, external data, integration tools, Snowflake, dbt, and business analytics platforms.

The examples focus on how I would think about a real enterprise data architecture rather than showing isolated Snowflake features.

### Use Cases

| # | Use Case | Main Architecture Topic |
|---|---|---|
| 01 | SAP ECC / APO Data Integration | SAP ingestion and incremental loads |
| 02 | Supply Chain Master Data | Master data, mappings, and history |
| 03 | Procurement & Supplier Analytics | Procurement model and supplier performance |
| 04 | Inventory & Material Visibility | Inventory reconciliation and availability |
| 05 | Manufacturing & Plant Analytics | Production, yield, and downtime |
| 06 | Order Fulfillment & Delivery | End-to-end order visibility |
| 07 | External Data Integration | APIs, files, Python, Azure, and integration patterns |
| 08 | Enterprise CDC & Incremental Processing | CDC, Streams, Tasks, MERGE, and dbt |
| 09 | Enterprise Snowflake Data Warehouse | RawDB, ProdDB, modeling, and transformation |
| 10 | Supply Chain Analytics & Control Tower | Cross-domain analytics and business insights |

### Common Architecture

```text
Data Sources
  SAP ECC / APO / BW-HANA
  Oracle / SQL Server
  SharePoint / Excel / Files
  External Data / APIs
          |
          v
Data Integration
  Extractors / Delta
  Alteryx / Azure / Python
          |
          v
Snowflake
  RawDB -> Transformation -> ProdDB
                    |
                   dbt
                    |
          +---------+---------+
          |                   |
       Analytics          Business Users
   Tableau / Power BI    SAP BusinessObjects
```

These are portfolio case studies. They use generic and sample data and do not contain company data, credentials, or confidential information.

## My approach

I prefer simple designs that are easy to understand, operate, and explain.

The examples are focused on the reason behind a design decision, not just the SQL syntax.
