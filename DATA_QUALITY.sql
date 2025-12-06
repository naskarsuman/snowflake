--✅ 1. Your Snowflake Setup (Simple Explanation)
USE DATABASE DB_PROD;
USE SCHEMA RAW_SCH;

CREATE OR REPLACE TABLE CUSTOMER_RAW (
    CUSTOMER_ID    INTEGER,
    CUSTOMER_NAME  STRING,
    EMAIL          STRING,
    AGE            INTEGER,
    COUNTRY        STRING,
    CREATED_DATE   DATE
);
--✅ 2. Create Sample Table (Landing Zone Raw Data)
INSERT INTO CUSTOMER_RAW VALUES
(1, 'John Doe', 'john@example.com', 30, 'USA', '2024-01-01'),
(2, NULL, 'mike@example.com', 17, 'USA', '2025-01-01'),
(3, 'Sara Smith', 'saraexample.com', 25, NULL, '2025-05-10'),
(4, 'Alex', NULL, NULL, 'India', NULL),
(5, 'Tom', 'tom@example.com', -5, 'USA', '2025-03-01');

--✅ 3. Create Data Quality Rule Table (Industry Standard Rules)
CREATE OR REPLACE TABLE DATA_QUALITY_RULE (
    RULE_ID        INTEGER,
    RULE_NAME      STRING,
    TABLE_NAME     STRING,
    COLUMN_NAME    STRING,
    RULE_TYPE      STRING,     -- NOT_NULL, DATA_TYPE, RANGE_CHECK, REGEX, DOMAIN
    RULE_EXPRESSION STRING,    -- SQL condition returning TRUE/FALSE
    SEVERITY       STRING,     -- WARNING / ERROR
    ACTIVE_FLAG    STRING
);

INSERT INTO DATA_QUALITY_RULE VALUES
-- 1. Mandatory fields
(1, 'Customer Name Must Not Be Null', 'CUSTOMER_RAW', 'CUSTOMER_NAME', 'NOT_NULL',
    'CUSTOMER_NAME IS NOT NULL', 'ERROR', 'Y'),

(2, 'Email Must Not Be Null', 'CUSTOMER_RAW', 'EMAIL', 'NOT_NULL',
    'EMAIL IS NOT NULL', 'ERROR', 'Y'),

-- 2. Email format check
(3, 'Email Format Check', 'CUSTOMER_RAW', 'EMAIL', 'REGEX',
    'REGEXP_LIKE(EMAIL, ''^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'')',
    'ERROR', 'Y'),

-- 3. Age must be >= 18
(4, 'Customer Must Be Adult', 'CUSTOMER_RAW', 'AGE', 'RANGE_CHECK',
    'AGE >= 18', 'ERROR', 'Y'),

-- 4. Age cannot be negative
(5, 'Age Cannot Be Negative', 'CUSTOMER_RAW', 'AGE', 'RANGE_CHECK',
    'AGE >= 0', 'ERROR', 'Y'),

-- 5. COUNTRY must be valid
(6, 'Country must be USA or India', 'CUSTOMER_RAW', 'COUNTRY', 'DOMAIN',
    'COUNTRY IN (''USA'', ''India'')', 'ERROR', 'Y'),

-- 6. CREATED_DATE cannot be future date
(7, 'Created Date Not Future', 'CUSTOMER_RAW', 'CREATED_DATE', 'RANGE_CHECK',
    'CREATED_DATE <= CURRENT_DATE()', 'ERROR', 'Y');