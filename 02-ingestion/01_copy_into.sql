-- Load files from a stage into a Snowflake table.
-- This is a simple batch loading example.

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CREATE OR REPLACE TABLE CUSTOMER_RAW (
    CUSTOMER_ID INTEGER,
    CUSTOMER_NAME STRING,
    EMAIL STRING,
    CREATED_DATE DATE
);

-- Example stage. Replace the URL and storage integration for a real cloud setup.
-- CREATE STAGE CUSTOMER_STAGE
--   URL = 's3://my-bucket/customer/'
--   FILE_FORMAT = CSV_FORMAT
--   STORAGE_INTEGRATION = MY_S3_INTEGRATION;

-- Load the files.
-- COPY INTO CUSTOMER_RAW
-- FROM @CUSTOMER_STAGE
-- FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
-- ON_ERROR = 'CONTINUE';

-- Review loaded data.
SELECT *
FROM CUSTOMER_RAW;
