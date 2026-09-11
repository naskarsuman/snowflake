-- A simple metadata-driven data quality example.
-- The rules are stored as data so they can be reused and managed in one place.

USE DATABASE DB_PROD;
USE SCHEMA RAW_SCH;

CREATE OR REPLACE TABLE CUSTOMER_RAW (
    CUSTOMER_ID INTEGER,
    CUSTOMER_NAME STRING,
    EMAIL STRING,
    AGE INTEGER,
    COUNTRY STRING,
    CREATED_DATE DATE
);

INSERT INTO CUSTOMER_RAW VALUES
(1, 'John Doe', 'john@example.com', 30, 'USA', '2024-01-01'),
(2, NULL, 'mike@example.com', 17, 'USA', '2025-01-01'),
(3, 'Sara Smith', 'saraexample.com', 25, NULL, '2025-05-10'),
(4, 'Alex', NULL, NULL, 'India', NULL),
(5, 'Tom', 'tom@example.com', -5, 'USA', '2025-03-01');

CREATE OR REPLACE TABLE DATA_QUALITY_RULE (
    RULE_ID INTEGER,
    RULE_NAME STRING,
    TABLE_NAME STRING,
    COLUMN_NAME STRING,
    RULE_TYPE STRING,
    RULE_EXPRESSION STRING,
    SEVERITY STRING,
    ACTIVE_FLAG STRING
);

INSERT INTO DATA_QUALITY_RULE VALUES
(1, 'Customer Name Must Not Be Null', 'CUSTOMER_RAW', 'CUSTOMER_NAME', 'NOT_NULL',
 'CUSTOMER_NAME IS NOT NULL', 'ERROR', 'Y'),
(2, 'Email Must Not Be Null', 'CUSTOMER_RAW', 'EMAIL', 'NOT_NULL',
 'EMAIL IS NOT NULL', 'ERROR', 'Y'),
(3, 'Email Format Check', 'CUSTOMER_RAW', 'EMAIL', 'REGEX',
 'REGEXP_LIKE(EMAIL, ''^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'')', 'ERROR', 'Y'),
(4, 'Customer Must Be Adult', 'CUSTOMER_RAW', 'AGE', 'RANGE_CHECK',
 'AGE >= 18', 'ERROR', 'Y'),
(5, 'Age Cannot Be Negative', 'CUSTOMER_RAW', 'AGE', 'RANGE_CHECK',
 'AGE >= 0', 'ERROR', 'Y'),
(6, 'Country Must Be USA or India', 'CUSTOMER_RAW', 'COUNTRY', 'DOMAIN',
 'COUNTRY IN (''USA'', ''India'')', 'ERROR', 'Y'),
(7, 'Created Date Not Future', 'CUSTOMER_RAW', 'CREATED_DATE', 'RANGE_CHECK',
 'CREATED_DATE <= CURRENT_DATE()', 'ERROR', 'Y');

-- The next step is to build a reusable rule runner that records
-- which rows passed or failed each active rule.
