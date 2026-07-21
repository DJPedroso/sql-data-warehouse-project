/*
==================================================
CREATE DATABASE
==================================================
Script Purpose:
  Creates a new database named 'data_warehouse' after checking if it exists. 
  If the already database exists, it is dropped & recreated.

WARNING:
  Running this script will permanently delete the existing
  'data_warehouse' database, including all stored data.

  Ensure you have proper backups before executing this script.
*/

-- Drop the 'data_warehouse' database if it exists
DROP DATABASE IF EXISTS data_warehouse;

-- Creates the 'data_warehouse' database
CREATE DATABASE data_warehouse;
