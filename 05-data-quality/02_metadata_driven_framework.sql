-- Metadata-driven Data Quality Framework
-- Simple example of the pattern shown in the Medium article.
--
-- Flow:
--   RAW TABLE -> STREAM -> TASK -> DQ PROCEDURE -> PASS / QUARANTINE
--
-- The important idea is that table and rule information live in metadata.
-- The same procedure can then be reused for multiple tables.

USE DATABASE DB_PROD;
USE SCHEMA RAW_SCH;

-- 1. Metadata: which tables should be checked?
CREATE OR REPLACE TABLE DQ_TABLE_MASTER (
    TABLE_NAME STRING,
    STREAM_NAME STRING,
    DQ_ENABLED STRING,
    ACTIVE STRING,
    FREQUENCY STRING,
    OWNER_TEAM STRING,
    NOTIFICATION_GROUP STRING
);

-- 2. Metadata: which rules should be applied?
CREATE OR REPLACE TABLE DQ_RULE_MASTER (
    RULE_ID INTEGER,
    TABLE_NAME STRING,
    COLUMN_NAME STRING,
    RULE_TYPE STRING,
    RULE_DEFINITION STRING,
    SEVERITY STRING,
    IS_ACTIVE STRING,
    APPLICABLE_TO STRING
);

-- 3. Execution summary
CREATE OR REPLACE TABLE DQ_AUDIT_LOG (
    RUN_ID STRING,
    TABLE_NAME STRING,
    START_TIME TIMESTAMP_NTZ,
    END_TIME TIMESTAMP_NTZ,
    STATUS STRING,
    TOTAL_ROWS NUMBER,
    PASSED_ROWS NUMBER,
    FAILED_ROWS NUMBER,
    EXECUTED_BY STRING
);

-- 4. Rule-level results
CREATE OR REPLACE TABLE DQ_EXECUTION_STATUS (
    RUN_ID STRING,
    RULE_ID INTEGER,
    TABLE_NAME STRING,
    COLUMN_NAME STRING,
    STATUS STRING,
    ACTUAL_VALUE STRING,
    THRESHOLD_VALUE STRING,
    MESSAGE STRING,
    EXECUTION_TIME TIMESTAMP_NTZ
);

-- 5. Failed-record details
CREATE OR REPLACE TABLE DQ_ERROR_DETAIL (
    RUN_ID STRING,
    RULE_ID INTEGER,
    TABLE_NAME STRING,
    COLUMN_NAME STRING,
    RECORD_DATA VARIANT,
    ERROR_MESSAGE STRING,
    LOADED_AT TIMESTAMP_NTZ
);

-- Example business rules for CUSTOMER_RAW.
INSERT INTO DQ_TABLE_MASTER VALUES
('CUSTOMER_RAW', 'CUSTOMER_RAW_STREAM', 'Y', 'Y', 'MINUTE', 'DATA_QUALITY', 'DATA_QUALITY_ALERTS');

INSERT INTO DQ_RULE_MASTER VALUES
(1, 'CUSTOMER_RAW', 'CUSTOMER_NAME', 'NULL_CHECK', 'CUSTOMER_NAME IS NOT NULL', 'ERROR', 'Y', 'RAW'),
(2, 'CUSTOMER_RAW', 'EMAIL', 'DUPLICATE_CHECK', 'COUNT(*) BY EMAIL = 1', 'ERROR', 'Y', 'RAW'),
(3, 'CUSTOMER_RAW', 'EMAIL', 'REGEX_CHECK', 'VALID EMAIL FORMAT', 'ERROR', 'Y', 'RAW'),
(4, 'CUSTOMER_RAW', 'AGE', 'RANGE_CHECK', 'AGE >= 18', 'ERROR', 'Y', 'RAW'),
(5, 'CUSTOMER_RAW', 'COUNTRY', 'DOMAIN_CHECK', 'COUNTRY IN (USA, India)', 'ERROR', 'Y', 'RAW'),
(6, 'CUSTOMER_RAW', 'CREATED_DATE', 'RANGE_CHECK', 'CREATED_DATE <= CURRENT_DATE()', 'ERROR', 'Y', 'RAW');

-- 6. Change-only processing with a stream.
-- A stream captures INSERT / UPDATE / DELETE changes from the source table.
CREATE OR REPLACE STREAM CUSTOMER_RAW_STREAM ON TABLE CUSTOMER_RAW;

-- 7. Reusable procedure.
-- The full enterprise version can read DQ_TABLE_MASTER and DQ_RULE_MASTER
-- and execute the active rules dynamically. This compact example keeps the
-- control flow easy to read and shows the main pass/fail decision.
CREATE OR REPLACE PROCEDURE RUN_DQ_CUSTOMER()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    RUN_ID STRING DEFAULT UUID_STRING();
    TOTAL_ROWS NUMBER;
    FAILED_ROWS NUMBER;
BEGIN
    SELECT COUNT(*) INTO :TOTAL_ROWS FROM CUSTOMER_RAW_STREAM;

    SELECT COUNT(*) INTO :FAILED_ROWS
    FROM CUSTOMER_RAW_STREAM
    WHERE CUSTOMER_NAME IS NULL
       OR EMAIL IS NULL
       OR NOT REGEXP_LIKE(EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
       OR AGE < 18
       OR COUNTRY NOT IN ('USA', 'India')
       OR CREATED_DATE > CURRENT_DATE();

    INSERT INTO DQ_AUDIT_LOG
    SELECT
        :RUN_ID,
        'CUSTOMER_RAW',
        CURRENT_TIMESTAMP(),
        CURRENT_TIMESTAMP(),
        IFF(:FAILED_ROWS = 0, 'PASS', 'FAIL'),
        :TOTAL_ROWS,
        :TOTAL_ROWS - :FAILED_ROWS,
        :FAILED_ROWS,
        CURRENT_USER();

    IF (:FAILED_ROWS = 0) THEN
        RETURN 'PASS - RUN_ID=' || :RUN_ID;
    ELSE
        INSERT INTO DQ_ERROR_DETAIL
        SELECT
            :RUN_ID,
            NULL,
            'CUSTOMER_RAW',
            NULL,
            OBJECT_CONSTRUCT_KEEP_NULL(*),
            'One or more DQ rules failed',
            CURRENT_TIMESTAMP()
        FROM CUSTOMER_RAW_STREAM
        WHERE CUSTOMER_NAME IS NULL
           OR EMAIL IS NULL
           OR NOT REGEXP_LIKE(EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
           OR AGE < 18
           OR COUNTRY NOT IN ('USA', 'India')
           OR CREATED_DATE > CURRENT_DATE();

        RETURN 'FAIL - RUN_ID=' || :RUN_ID;
    END IF;
END;
$$;

-- 8. Task: run when the stream has data.
CREATE OR REPLACE TASK RUN_CUSTOMER_DQ_TASK
    WAREHOUSE = <YOUR_WAREHOUSE>
    WHEN SYSTEM$STREAM_HAS_DATA('CUSTOMER_RAW_STREAM')
AS
    CALL RUN_DQ_CUSTOMER();

-- Start the task after the warehouse and objects are ready.
-- ALTER TASK RUN_CUSTOMER_DQ_TASK RESUME;

-- Monitoring examples:
-- SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY()) ORDER BY SCHEDULED_TIME DESC;
-- SELECT * FROM DQ_AUDIT_LOG ORDER BY START_TIME DESC;
-- SELECT * FROM DQ_ERROR_DETAIL ORDER BY LOADED_AT DESC;

-- Production extension ideas:
-- 1. Use dynamic SQL to run every active rule in DQ_RULE_MASTER.
-- 2. Route PASS rows to an integration schema.
-- 3. Route FAIL rows to a quarantine table with full error details.
-- 4. Add alerting through email, Slack/Teams, webhook, or Snowflake alerts.
-- 5. Add retry / reprocess logic for corrected failed records.
