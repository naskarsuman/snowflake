# 02 — Supply Chain Master Data

## Interview Question

How would I create a trusted view of materials, suppliers, plants, customers, and other supply-chain master data when information is maintained in multiple systems?

## 1. Business Problem

The same business object can appear in SAP, SharePoint, Excel, or another operational system with different IDs, descriptions, or attributes. Reporting becomes difficult when each team uses a different version.

## 2. Goal

Create a common master-data layer with agreed business keys, standard values, mappings, history, and data-quality rules.

## 3. Existing Systems

- SAP ECC / APO
- SharePoint
- Excel / flat files
- Oracle / SQL Server
- Business-maintained reference files
- Snowflake

## 4. Main Challenges

- Different source identifiers
- Duplicate records
- Different descriptions for the same material
- Business overrides maintained in files
- Missing attributes
- Historical changes
- Unclear source ownership

## 5. Architecture

```text
SAP / ERP ---------+
SharePoint --------+
Excel / Files -----+--> RAW --> Standardization --> Master Data --> PROD
Other Sources -----+
```

## 6. Design Approach

I would define the business key first. Then I would document source ownership and source precedence. For example, a material's core SAP attributes may come from SAP, while an approved business mapping may come from a controlled reference table.

## 7. Data Model

Example dimensions:

```text
DIM_MATERIAL
DIM_SUPPLIER
DIM_PLANT
DIM_CUSTOMER
DIM_LOCATION
DIM_DATE
```

The model should clearly document the grain and keys.

## 8. History

If the business needs to know what a value was in the past, I would use SCD Type 2. For simple corrections where history is not required, Type 1 may be enough.

## 9. Data Quality

Check duplicate business keys, missing required attributes, invalid mappings, unexpected new values, and conflicting source values.

## 10. Governance

Every important master-data attribute should have an owner, definition, source, and business rule. This makes the data easier to trust and maintain.

## 11. Failure Handling

Do not silently overwrite conflicting source values. Put rejected or unresolved records into an exception process so the business can review them.

## 12. Interview Answer

I would start with the business definition of the master object and its business key. Then I would identify which system owns each attribute and document source precedence. I would land all sources in RAW, standardize them, apply data-quality checks, and build a governed master-data layer. If historical changes matter, I would use SCD Type 2. I would also keep exception records visible so data problems are resolved instead of hidden.
