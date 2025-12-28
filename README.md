# Cohort Retention Analysis (SQL Server, SSIS & Tableau)

### Project Overview
This project demonstrates a Time-Based Cohort Retention Analysis using Microsoft SQL Server (T-SQL / SSMS) for data processing, SSIS for ETL (data integration), and Tableau for interactive data visualization.
The goal of the analysis is to understand customer retention behavior over time, identify trends, and measure how many customers return after their first purchase.

### What is Cohort Analysis?
* Cohort: A group of customers who share a common characteristic (e.g., first purchase month).
* Cohort Analysis: An analytical technique that tracks cohorts over time to understand behavior, retention, and engagement patterns.

**Types of Cohort Analysis**
* Time-Based Cohort ✅ (Used in this project)
* Size-Based Cohort
* Segment-Based Cohort

### 🛠️ Tech Stack Used
| Tool | Purpose |
|------|--------|
| **Microsoft SQL Server (SSMS / T-SQL)** | Data cleaning, transformation, and cohort logic |
| **SSIS (SQL Server Integration Services)** | Data ingestion from local file source to SQL Server |
| **Tableau** | Interactive Cohort Retention Dashboard |

### 🔄 Data Pipeline (End-to-End Flow)
1. Source Data
   * Online Retail transactional dataset (local file)
2. ETL with SSIS
   * Load data from local source
   * Store cleaned data into SQL Server database
3. Data Processing with T-SQL
   * Remove null and invalid records
   * Filter out zero quantity and price values
   * Remove duplicate transactions
   * Build cohort tables and retention metrics
4. Visualization with Tableau
   * Cohort retention heatmap
   * Month-over-month retention trends

### 🧹 Data Cleaning & Preparation (SQL)
Key data preparation steps:
* Removed records with:
  * CustomerID = 0
  * Quantity <= 0
  * UnitPrice <= 0
* Removed duplicate transactions using ROW_NUMBER()
* Created temporary tables for clean and reusable datasets
* Final Clean Dataset Size: 392,667 records

### Cohort Logic (Time-Based)
**1️⃣ Cohort Date**
* Defined as the first purchase month of each customer
* Granularity: Year & Month (no daily split)
* SQL: datefromparts(year(MIN(invoicedate)), month(MIN(invoicedate)), 1)

**2️⃣ Cohort Index**
* Represents the number of months since a customer’s first purchase.
* Formula: Cohort_Index = (Year Difference × 12) + Month Difference + 1

**3️⃣ Cohort Retention Table**
* Pivoted data to show:
  * Rows → Cohort Month
  * Columns → Month Index (1, 2, 3, …)
  * Values → Count of returning customers
 
**4️⃣ Retention Rate Calculation**
* Retention rate is calculated as: Retention % = (Customers in Month N / Customers in Month 1) × 100
* This shows how many customers returned compared to the original cohort size.

### Tableau Dashboard
🔗 **Dashboard Link**  
👉 [Cohort Retention Dashboard (Tableau Public)](https://public.tableau.com/views/CohortRetentionDashboard_17669206022670/CohortRetentionDashboard?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)
Snapshot: <img width="1915" height="1116" alt="image" src="https://github.com/user-attachments/assets/e31a276a-769f-40ef-a351-3675ee3c5a92" />

### Dashboard Features
1. Cohort retention heatmap
2. Monthly retention trends
3. Easy comparison across cohorts
4. Visual identification of churn patterns

### Key Learnings & Insights
* SQL is highly effective for large-scale cohort analysis
* Data cleaning is critical before retention calculations
* Cohort analysis reveals:
  * Customer loyalty trends
  * Drop-off points
  * Long-term customer value patterns

### Contribution
Contributions, improvements, and suggestions are welcome!
* Fork the repository
* Create a feature branch
* Submit a pull request

### 📬 Contact
If you have questions or want to discuss data analytics, SQL, or Tableau: shreeramprajapati2@gmail.com
