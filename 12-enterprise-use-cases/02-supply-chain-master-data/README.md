# 02 — Supply Chain Master Data

## Problem Statement
How would I create a trusted view of materials, suppliers, plants, customers, and other supply-chain master data when information is maintained in multiple systems?

## Business Goal
Create a common master-data layer with agreed business keys, standard values, mappings, history, and data-quality rules.

## Existing Systems
- SAP ECC / APO
- SharePoint
- Excel / flat files
- Oracle / SQL Server
- Business-maintained reference files
- Snowflake

## Architecture
```text
SAP / ERP ---------+
SharePoint --------+
Excel / Files -----+--> RAW --> Standardization --> Master Data --> PROD
Other Sources -----+
```

## Main Challenges
Different source identifiers, duplicate records, conflicting descriptions, business overrides, missing attributes, historical changes, and unclear ownership.

## Design Approach
Define the business key first. Document source ownership and source precedence. Land sources in RAW, standardize them, apply quality rules, and build the governed master-data layer.

## Data Model
```text
DIM_MATERIAL
DIM_SUPPLIER
DIM_PLANT
DIM_CUSTOMER
DIM_LOCATION
DIM_DATE
```

Use SCD Type 2 when the business needs history. Use Type 1 when history is not required.

## Data Quality / Governance
Check duplicate keys, missing attributes, invalid mappings, unexpected values, and conflicting sources. Give important attributes an owner, definition, source, and business rule.

## Failure Handling
Keep rejected or unresolved records visible for business review instead of silently overwriting conflicting values.

## Interview Answer
I would start with the business definition and business key. Then I would identify which system owns each attribute and document source precedence. I would land the sources in RAW, standardize them, apply quality checks, and build the governed master-data layer. If history matters, I would use SCD Type 2 and keep unresolved records visible for review.
