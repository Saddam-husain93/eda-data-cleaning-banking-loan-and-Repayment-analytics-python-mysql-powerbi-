# Banking Loan & Repayment Analytics

**Portfolio Project | Python/Pandas + SQL + Power BI/DAX**  
**Focus:** Lending, approval, credit risk, repayment behavior, and operational performance

## Project Overview

This project analyzes a relational banking dataset covering customers, branches, loan applications, loans, and repayment transactions.

The goal was to follow a practical **Data Analyst workflow**
**Raw relational data → Data cleaning → Validation → EDA → SQL business analysis → Power BI/DAX → Cross-validation → Business insights**

The analysis focuses on five areas:

- **Portfolio:** loan volume, value, and product mix
- **Applications:** approval patterns and processing time
- **Risk:** default rates by loan type and employment segment
- **Repayment:** late-payment behavior by loan type, region, and time
- **Operations:** branch activity and lending exposure

---

## Business Objective

The project answers practical questions a lending/operations team could ask:

1. Which loan types have the highest lending volume and value?
2. What is the overall portfolio status and default rate?
3. Which loan types have higher default rates?
4. How does default risk vary by employment type?
5. Which branches handle the highest loan volume and value?
6. What is the approval rate by loan type?
7. How long does the application process take?
8. How common are late payments?
9. Does late-payment behavior differ by loan type or region?
10. How does payment activity change over time?

---

## Dataset

The project contains five related tables:

| Table | Purpose | Final Rows |
|---|---|---:|
| `customers` | Customer profile, city, employment and income | 12,000 |
| `branches` | Branch and regional reference data | 25 |
| `loan_applications` | Applications, requested amounts and decisions | 19,991 |
| `loans` | Approved/disbursed loans and loan status | 14,480 |
| `payments` | Repayment transactions and payment timing | 193,737 |

The main analytical flow is:

**Customer → Application → Loan → Payment**

with branch information connected to applications and loans.

---

## Tools

- **Python / Pandas / NumPy** — data cleaning, validation and supporting analysis
- **SQL** — primary business-analysis layer
- **Power BI** — dashboard and management reporting
- **DAX** — KPIs and filter-context calculations

---

# Phase 1 — Data Cleaning & Validation

Python/Pandas was used before the business analysis stage.

Cleaning included:

- Converting date columns to proper datetime types
- Standardizing inconsistent categorical values
- Handling missing categorical values with `Unknown` where appropriate
- Filling missing monthly income using the median within employment type
- Identifying invalid date sequences
- Removing records with impossible chronology where appropriate
- Removing non-positive loan amounts
- Checking duplicate identifiers
- Validating customer, application, loan and branch relationships
- Preserving legitimate missing payment dates for missed payments rather than inventing dates

Raw data was retained separately from the analytical/cleaned data.

---

# Phase 2 — EDA & SQL Business Analysis

SQL was the **primary analytical layer**. The analysis was organized around business questions.

## SQL techniques used

The analysis demonstrates practical Data Analyst SQL including:

- `JOIN` for combining related tables
- `GROUP BY` for segment-level analysis
- `COUNT()` for volumes and transaction counts
- `SUM()` for loan exposure and default amounts
- `AVG()` for average loan size, processing time and late days
- `CASE WHEN` for conditional counts and amounts
- Conditional aggregation for approval/default/late-payment metrics
- `ROUND()` for readable KPI results
- `DATEDIFF()` for processing-time calculations
- `DATE_FORMAT()` for monthly trend analysis
- `WHERE` for filtering valid payment dates
- `ORDER BY` for ranking results

### How SQL answered the business questions

| Business Question | SQL Approach |
|---|---|
| Portfolio by loan type | `GROUP BY Loan_Type` + `COUNT`, `SUM`, `AVG` |
| Portfolio by status | `GROUP BY Loan_Status` + portfolio counts/value |
| Default rate by loan type | `CASE WHEN Loan_Status = 'Default'` + conditional aggregation |
| Default by employment type | `JOIN` loans to customers + `GROUP BY Employment_Type` |
| Branch performance | `GROUP BY Branch_ID` + loan count/value/average |
| Late-payment rate by loan type | `JOIN` payments to loans + `CASE WHEN Days_Late > 0` |
| Application decision time | `DATEDIFF(Decision_Date, Application_Date)` + `AVG` |
| Application-to-disbursement time | `JOIN` applications to loans + `DATEDIFF` + `AVG` |
| Approval rate by loan type | `CASE WHEN Application_Status = 'Approved'` + conditional aggregation |
| Monthly payment activity | `DATE_FORMAT(Payment_Date, '%Y-%m')` + `GROUP BY` |

This demonstrates how SQL was used to move from raw relational tables to **business KPIs and comparisons**.

---

## Key EDA Findings

### 1. Portfolio Composition

| Loan Type | Loan Count | Total Loan Amount | Avg Loan Amount |
|---|---:|---:|---:|
| Home Loan | 2,932 | 8.649B | 2.950M |
| Business Loan | 2,508 | 4.193B | 1.672M |
| Auto Loan | 2,709 | 2.360B | 0.871M |
| Personal Loan | 4,919 | 2.255B | 0.458M |
| Education Loan | 1,412 | 0.790B | 0.560M |

**Insight:** Personal Loans have the highest loan count, while Home Loans have the highest total lending value. This shows why both **volume and financial exposure** should be monitored.

### 2. Default Risk

- Overall default rate: **7.16%**
- Highest product default rate: **Auto Loan — 7.49%**
- Lowest product default rate: **Education Loan — 6.16%**

The product-level spread is about **1.33 percentage points**. This identifies areas for further risk investigation but does not establish causation.

### 3. Employment-Segment Risk

- Highest observed default rate: **Business Owner — 7.67%**
- Lowest observed rate: **Self-Employed — 6.54%**

Employment type is useful for segmentation, but it should not be treated as a standalone credit decision variable.

### 4. Approval Performance

- Highest approval rate: **Home Loan — 81.05%**
- Lowest approval rate: **Business Loan — 75.83%**
- Difference: approximately **5.22 percentage points**

The difference highlights product-level approval patterns for further underwriting/process investigation.

### 5. Processing Time

Average processing times were approximately:

- Application → Decision: **7.45–7.63 days**
- Application → Disbursement: **15.35–15.75 days**

Processing times were relatively similar across loan types, so the analysis does not indicate a major product-specific bottleneck.

### 6. Repayment Performance

For this project, a payment is considered **late when `Days_Late > 0`**.

Overall:

- Total payments: approximately **194K**
- Late-payment rate: **74.70%**
- Average days late: **5.92 days**

Late-payment rates by loan type ranged from **74.33% to 74.94%**, a spread of only about **0.61 percentage points**.

**Insight:** Late-payment behavior is high but very similar across products. Loan type alone therefore does not explain much of the observed variation, suggesting that customer history, region, income, tenure or other variables would be useful for deeper analysis.

---

# Power BI Dashboard

## Page 1 — Executive Overview

Management-level view of:

- Total loans
- Total loan amount
- Approval rate
- Default rate
- Portfolio by loan type/status
- Applications by loan type

**Purpose:** Quickly understand portfolio size, composition, approval performance and overall risk.

## Page 2 — Repayment & Risk Analysis

Monitoring view of:

- Late-payment rate
- Default rate
- Average days late
- Total payments
- Late-payment rate by loan type
- Late-payment rate by region
- Monthly payment activity

**Purpose:** Monitor repayment behavior and identify areas requiring further risk or collection investigation.

---


# Project Outcome / Analytical Gain

The measurable analytical gain is:

- **Portfolio visibility:** volume and financial exposure can be compared by product.
- **Risk visibility:** default rates can be segmented by loan type and employment type.
- **Repayment visibility:** late-payment behavior can be monitored by product, region and time.
- **Process visibility:** application-to-decision and disbursement times provide operational KPIs.
- **Reliable reporting:** SQL and Power BI results were cross-validated.
- **Better investigation priorities:** the analysis identifies products, segments and regions that deserve deeper business review.

The project therefore demonstrates the ability to turn **relational transactional data into validated business insights and management-ready reporting**.

---

# Important Analytical Limitations

The analysis identifies patterns in historical data; it does not establish causation.

For example:

- A higher default rate does not prove that the loan type causes higher defaults.
- A lower approval rate does not automatically mean poorer underwriting performance.
- A high late-payment rate does not identify its root cause.

A real banking engagement would require additional variables such as credit score, debt-to-income ratio, collateral, interest rate, credit history, collection activity and economic indicators.

---

# Skills Demonstrated

### Python / Pandas

Data loading, profiling, missing-value handling, datetime conversion, category standardization, business-rule validation and relational data validation.

### SQL

`JOIN`, `GROUP BY`, `CASE`, conditional aggregation, `COUNT`, `SUM`, `AVG`, `DATEDIFF`, `DATE_FORMAT`, `ROUND`, filtering and ranking.

### Power BI / DAX

Data modeling, KPI cards, categorical comparisons, time-series reporting, filter context, `CALCULATE`, `DIVIDE`, `COUNTROWS`, `AVERAGE`, `SUM` and `USERELATIONSHIP`.

---

# Repository Structure

```text
eda-data-cleaning-banking-loan-and-Repayment-analytics-python-mysql-powerbi
banking_project/
└── docs/
|    ├── PROJECT_DOCUMENTATION.md
|    ├── PROJECT_STRUCTURE.md
|    ├── requirements.txt
|
├── notebooks/
│   └── 01_data_cleanning_eda.ipynb
├── sql/
│   └── banking_analysis.sql
├── powerbi/
│   └── DAX_MEASURES.md
|    |__ banking_analysis_dashboard.pdf
|
├── README.md
├── SCHEMA.md
```

See `docs/PROJECT_DOCUMENTATION.md` for the detailed EDA, interpretations, recommendations.
