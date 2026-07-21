# Data Warehouse and Analytics Project

This project showcases the design and implementation of a modern data warehouse using PostgreSQL. It demonstrates the complete data warehousing workflow, including ETL processes, dimensional modeling, and analytical reporting.

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

## Project Requirements

### Building the Data Warehouse

### Objective
Develop a PostgreSQL-based data warehouse that integrates, transforms, and organizes data to support efficient business analytics and reporting.

### Specifications
- **Data Sources**: Import data from two source systems (ERP & CRM) provided as CSV files.
- **Data Quality**: Cleanse & resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focuses on the latest available dataset; historical data tracking is not included.
- **Documentation**: Provide clear documentation of the data model for business stakeholders and analytics teams.

---

### BI: Analytics & Reporting 

### Objective
Develop SQL-based analytics that provide detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights provide stakeholders with key business metrics to support strategic decision-making.

---

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, & share this project with proper attribution.
