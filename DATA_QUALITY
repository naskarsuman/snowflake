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

INSERT INTO CUSTOMER_RAW VALUES
(1, 'John Doe', 'john@example.com', 30, 'USA', '2024-01-01'),
(2, NULL, 'mike@example.com', 17, 'USA', '2025-01-01'),
(3, 'Sara Smith', 'saraexample.com', 25, NULL, '2025-05-10'),
(4, 'Alex', NULL, NULL, 'India', NULL),
(5, 'Tom', 'tom@example.com', -5, 'USA', '2025-03-01');
