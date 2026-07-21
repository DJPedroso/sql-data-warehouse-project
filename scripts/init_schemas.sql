/*
==================================================
CREATE SCHEMAS
==================================================
Script Purpose:
  Creates the schemas used in the Medallion Architecture
  for the 'data_warehouse' database.

  - bronze : Stores raw data ingested from source systems.
  - silver : Stores cleansed, standardized, and integrated data.
  - gold   : Stores business-ready dimensional models for
             analytics and reporting.

Prerequisites:
  Ensure the 'data_warehouse' database has already been
  created and that this script is executed while connected
  to the 'data_warehouse' database.
==================================================
*/

-- Create Medallion Architecture schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
