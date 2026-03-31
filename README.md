# E-commerce Sales Analytics Dashboard

A sales analytics dashboard built with PostgreSQL and Power BI, analyzing e-commerce sales data sourced from Kaggle to uncover trends in revenue, customer behavior, and product performance.

---

## Project Structure

```
├── sql/
│   ├── create_staging.sql          # Raw data staging table
│   ├── create_tables.sql           # Relational schema
│   ├── staging_to_relational.sql   # ETL transformation
│   └── queries.sql                 # Analysis queries
├── powerbi/
│   └── ecommerce_dashboard.pbix    # Power BI report file
└── images/
    └── dashboard_screenshots/      # Dashboard previews
```

---

## Dashboard Overview

This dashboard analyzes 9,994 orders and $2.26M in total sales across four years (2015–2018). It provides interactive filtering by category, customer segment, region, and date range.

**Key Insights:**
- Consumer segment drives 51% of total revenue, followed by Corporate (31%) and Home Office (19%)
- November is consistently the strongest sales month across all years, driven by holiday demand
- Technology is the highest revenue category, with Phones and Chairs as the top sub-categories overall
- The West region generates the most sales, while the South region lags significantly behind
- Standard Class is the most used shipping mode, accounting for nearly 60% of all orders
- Average shipping time is 3.96 days across all ship modes
- High discounts (above 20%) are strongly correlated with negative profit margins
- 2018 shows consistent year-over-year growth compared to 2017

---

## Data Source

Data sourced from [Kaggle — Superstore Sales Dataset](https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting).  
Contains order, customer, product, and location data across US e-commerce transactions from 2015 to 2018.

---

## Database Schema

The raw CSV was first loaded into a staging table, then transformed into a normalized relational schema:

| Table | Description |
|---|---|
| `customers` | Customer ID, name, and segment |
| `locations` | Postal code, city, state, region, and country |
| `products` | Product ID, name, category, and sub-category |
| `orders` | Order ID, dates, ship mode, and foreign keys |
| `order_items` | Order/product relationships and sales amounts |

---

## Setup

1. Run `create_staging.sql` to create the raw staging table
2. Import your CSV into the staging table
3. Run `create_tables.sql` to build the relational schema
4. Run `staging_to_relational.sql` to transform and load the data
5. Run `queries.sql` to explore and validate the data
6. Open `ecommerce_dashboard.pbix` in Power BI Desktop and update the data source connection to your PostgreSQL instance

> Note: Power BI Desktop (free) is required to open the `.pbix` file. Publishing to the web requires a Power BI Pro license.

---

## Dashboard Preview

### Full Dashboard (All Categories)
![Full Dashboard](images/dashboard_screenshots/dashboard_full.png)

### Furniture Category Filter Applied
![Furniture Filter](images/dashboard_screenshots/dashboard_furniture.png)

### Technology Category Filter Applied
![Technology Filter](images/dashboard_screenshots/dashboard_technology.png)

### Office Supplies Category Filter Applied
![Office Supplies Filter](images/dashboard_screenshots/dashboard_office_supplies.png)

---

## Tools Used

| Tool | Purpose |
|---|---|
| PostgreSQL | Data storage and transformation |
| Power BI Desktop | Dashboard and visualizations |
| SQL | ETL pipeline, schema design, and analysis queries |
