# Data Quality

This section shows how I check data before it is used by downstream systems.

## Topics

- Required field checks
- Format checks
- Range checks
- Domain checks
- Rule metadata
- Data quality results

## Simple idea

Instead of writing a separate check for every table, I can store the rules as data and run them in a repeatable way.

The first example starts with a small customer table and a set of rules. I will build this into a larger data quality pattern over time.
