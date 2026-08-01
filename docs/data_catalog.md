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

---

### 2. **gold.dim_products**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| Column Name | Data Type | Description |
| :------ | :--- | :---------- |
| **product_key** | INT | Surrogate key uniquely identifying each product record in the product dimension table. |
| **product_id** | INT | Unique identifier assigned to the product for internal tracking and referencing. |
| **product_number** | VARCHAR | Structured alphanumeric code representing the product (used for categorization or inventory). |
| **product_name** | VARCHAR | Descriptive name of the product, including key details such as type, color, and size. |
| **category_id** | VARCHAR | Unique identifier for the product's category, linking to its high-level classification. |
| **category** | VARCHAR | Broader classification of the product (e.g. Bikes, Components) to group related items. |
| **subcategory** | VARCHAR | More detailed classification of the product within the category, such as product type. |
| **maintenance** | VARCHAR |  |
| **cost** | INT |  |
| **product_line** | VARCHAR | Specific product line or series to which the product belongs (e.g. Road, Mountain) |
| **start_date** | DATE | Unique identifier assigned to the product for internal tracking and referencing |

---

### 3. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes
- **Columns:**

| Column Name | Data Type | Description |
| :------ | :--- | :---------- |
| **order_number** | VARCHAR | Unique alphanumeric identifier for each sales order (e.g. 'SO54496'). |
| **product_key** | INT | Unique alphanumeric identifier for each sales order (e.g. 'SO54496'). |
| **customer_key** | INT | Unique alphanumeric identifier for each sales order (e.g. 'SO54496'). |
| **order_date** | DATE | Unique alphanumeric identifier for each sales order (e.g. 'SO54496'). |
| **shipping_date** | DATE | Unique alphanumeric identifier for each sales order (e.g. 'SO54496'). |
| **due_date** | DATE | Date when the order payment was due. |
| **sales_amount** | INT | Total monetary value of the sale for the line item, in whole currency units (e.g. 25). |
| **quantity** | INT | Number of units of the product ordered for the line item (e.g. 1) |
| **price** | INT | Price per unit of the product for the line item, in whole currency units (e.g. 25) |







