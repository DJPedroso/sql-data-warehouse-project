# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support business reporting and analytical use cases. It consists of **dimension tables** and **fact tables** designed for analytics, reporting, and business intelligence.

---

### 1. **gold.dim_customers**
- **Purpose:** Stores customer details enriched with demographic & geographic data.
- **Columns:**

| Column Name | Data Type | Description |
| :------ | :--- | :---------- |
| **customer_key** | INT | Surrogate key uniquely identifying each customer record in the dimension table |
| **customer_id** | INT | Unique numerical identifier assigned to each customer. |
| **customer_number** | VARCHAR | Alphanumeric identifier representing the customer, used for tracking & referencing. |
| **first_name** | VARCHAR | Customer's first name, as recorded in the system. |
| **last_name** | VARCHAR | Customer's last name or family name. |
| **country** | VARCHAR | Customer's country of residence (e.g. 'Australia'). |
| **marital_status** | VARCHAR | Customer's marital status (e.g. 'Married', 'Single'). |
| **gender** | VARCHAR | Customer's gender (e.g. 'Male', 'Female', 'n/a'). |
| **birthdate** | DATE | Customer's date of birth (YYYY-MM-DD). |
| **create_date** | DATE | Date the customer record was created. |
