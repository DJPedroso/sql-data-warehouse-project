# Data Warehouse and Analytics Project

This project demonstrates the design and implementation of a modern data warehouse using **PostgreSQL**. It follows the **Medallion Architecture (Bronze, Silver, and Gold layers)** to transform raw ERP and CRM data into a clean, integrated, and business-ready data model for analytics and reporting.

The project covers the complete data warehousing workflow, including data ingestion, ETL processes, data quality validation, dimensional modeling, and analytical reporting using SQL.

---

## Architecture

```text
               ERP (CSV)      CRM (CSV)
                    │             │
                    └──────┬──────┘
                           ▼
                    Staging Layer
                           │
                           ▼
                   Bronze (Raw Data)
                           │
                           ▼
           Silver (Cleaned & Integrated Data)
                           │
                           ▼
         Gold (Star Schema / Business-Ready Data Mart)
                           │
                           ▼
              SQL Analytics & BI Reporting
```

---

## Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/                         # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                             # Project documentation and architecture details
│   ├── data_architecture.png         # Overall data warehouse architecture
│   ├── data_catalog.md               # Documentation for Gold layer tables and columns
│   ├── data_flow.png                 # ETL workflow from source to Gold layer
│   ├── data_integration.png          # Relationships between source system tables
│   ├── data_model.png                # Star schema of the Gold layer
│   └── naming_conventions.md         # Standards for naming tables, columns, and procedures
│
├── scripts/                          # SQL scripts for ETL and transformations
│   ├── bronze/                       # Scripts for extracting and loading raw data
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver/                       # Scripts for cleaning and transforming data
│   │   ├── ddl_silver.sql
│   │   └── proc_load_silver.sql
│   │
│   └── gold/                         # Scripts for creating analytical models
│       └── ddl_gold.sql
│
├── tests/                            # Test scripts and quality files
│   ├── quality_checks_bronze.sql
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
├── README.md                         # Project overview and instructions
└── LICENSE                           # License information for the repository
```

---

## Project Overview

This project builds a PostgreSQL-based data warehouse that:

- Imports ERP and CRM data from CSV files.
- Cleans and standardizes raw data.
- Integrates multiple data sources into a unified analytical model.
- Organizes data using the Bronze, Silver, and Gold layers.
- Delivers a business-ready Star Schema for reporting and analytics.

---

## Project Workflow

1. Import ERP and CRM data into the Bronze layer.
2. Clean, standardize, and integrate data in the Silver layer.
3. Transform data into a Star Schema in the Gold layer.
4. Validate data quality using SQL quality checks.
5. Perform business analytics using SQL queries.

---

## Technologies Used

- PostgreSQL
- SQL
- Data Warehousing
- ETL
- Star Schema
- Git & GitHub

---

## Data Warehouse Design

### Bronze Layer

- Stores raw data imported from the source systems.
- Preserves the original structure of the source files.
- Serves as the landing zone for data ingestion.

### Silver Layer

- Cleanses, standardizes, and transforms raw data.
- Removes duplicates and resolves data quality issues.
- Produces integrated datasets ready for modeling.

### Gold Layer

- Organizes data into a Star Schema.
- Contains business-ready dimension and fact views.
- Optimized for reporting and analytical queries.

---

## Gold Layer Data Model

```text
               dim_customers
                     │
                     │
dim_products ─── fact_sales
```

---

## Data Quality

Quality checks are performed throughout the ETL pipeline, including:

- Duplicate detection
- NULL value validation
- Data standardization
- Invalid date validation
- Referential integrity checks
- Fact-to-dimension relationship validation

---

## Analytics

The Gold layer supports analytical queries for:

- Customer behavior
- Product performance
- Sales trends

These datasets are designed for dashboards, business intelligence, and ad hoc SQL analysis.

---

## Documentation

Additional project documentation:

- [Data Catalog](docs/data_catalog.md)
- [Naming Conventions](docs/naming_conventions.md)

---

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, & share this project with proper attribution.
