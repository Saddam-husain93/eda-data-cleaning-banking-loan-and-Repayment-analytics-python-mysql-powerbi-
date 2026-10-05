# Banking Loan & Repayment Analytics

**Portfolio Project | Python/Pandas + SQL + Power BI/DAX**  
**Focus:** Lending, approval, credit risk, repayment behavior, and operational performance

---

## 1. Executive Summary

This project analyzes a relational banking dataset covering customers, branches, loan applications, loans, and repayment transactions.

The objective was not simply to create charts. The analysis was designed to follow a practical Data Analyst workflow:

**Understand the business problem → clean and validate data → explore the data → answer business questions with SQL → build KPIs in Power BI → cross-check results → communicate findings and decision areas.**

The project focuses on five management areas:

1. **Portfolio composition** — where lending volume and value are concentrated.
2. **Application performance** — which loan types have stronger approval rates and how long processing takes.
3. **Credit risk** — where defaults are concentrated across loan types and customer employment segments.
4. **Repayment performance** — how frequently payments are late and whether behavior differs by loan type or region.
5. **Operational performance** — branch-level lending activity and regional patterns.

---

# 2. Business Problem

A bank can have large volumes of customer, application, loan, and payment records, but raw transactional data does not directly answer management questions.

The analysis therefore asks:

- Which loan products generate the most lending volume and value?
- Which products are approved more frequently?
- Which products show relatively higher default rates?
- Does default behavior differ by employment segment?
- Which branches handle the greatest lending activity?
- How common are late payments?
- Does repayment behavior vary by loan type or region?
- How long does the application process take?
- Where should management focus further investigation?

The purpose is to convert transactional data into **decision-oriented metrics and evidence**.

---

# 3. Dataset & Data Model

The project contains five related tables.

| Table | Analytical role |
|---|---|
| `customers` | Customer profile, employment and income |
| `branches` | Branch and regional reference data |
| `loan_applications` | Applications, requested amounts and decisions |
| `loans` | Approved/disbursed loans and loan status |
| `payments` | Repayment transactions and payment timing |

### Final analytical row counts

| Table | Rows |
|---|---:|
| Customers | 12,000 |
| Branches | 25 |
| Loan applications | 19,991 |
| Loans | 14,480 |
| Payments | 193,737 |

The relationships allow analysis across the lending lifecycle:

**Customer → Application → Loan → Payment**

with branch information connected to applications and loans.

---

# 4. Phase 1 — Data Cleaning & Validation

Python/Pandas was used for the cleaning stage before business analysis.

### Main cleaning activities

- Converted date columns to datetime.
- Standardized inconsistent categorical values.
- Replaced missing categorical values with `Unknown` where the original value could not be reliably inferred.
- Filled missing monthly income using the median within employment type.
- Investigated invalid date sequences.
- Removed records with impossible chronology where appropriate.
- Removed non-positive loan amounts.
- Checked duplicate identifiers.
- Validated relationships between customers, applications, loans, branches and payments.
- Preserved legitimate missing payment dates for missed payments instead of fabricating dates.

### Important business-rule decisions

#### Payments

A missing `Payment_Date` was not automatically treated as a data error.

For missed payments, the data showed that:

- payment status indicated a missed payment,
- amount paid was zero,
- payment date was missing.

Therefore, the missing date was retained because it represented a meaningful business state.

#### Loan applications

Records with impossible decision chronology were excluded from the analytical dataset rather than allowing a decision date to occur before the application date.

#### Loans

Records with impossible approval/disbursement chronology and non-positive loan amounts were excluded from the analytical dataset.

### Relationship validation

Key relationship checks showed:

- Customer IDs missing from applications: **0**
- Branch IDs missing from applications: **0**
- Branch IDs missing from loans: **0**
- Customer IDs missing from loans: **0**
- Application IDs missing from loans: **4**
- Loan IDs without payment records: **237**

The 237 loans without payment records were retained because not every loan is required to have a payment transaction in the available data.

The four loans with unmatched application IDs were retained after inspection because their customer and loan information remained valid for the available analytical fields.

---

# 5. Phase 2 — Exploratory Data Analysis

EDA was kept separate from cleaning. The purpose of EDA was to understand distributions, compare business segments, identify concentration, and select meaningful metrics for the dashboard.

The EDA was intentionally focused on business questions rather than producing a large number of unrelated charts.

---

## 5.1 Loan Portfolio Composition

### Question

**Where is the bank's lending volume and value concentrated?**

| Loan Type | Loan Count | Total Loan Amount | Average Loan Amount |
|---|---:|---:|---:|
| Home Loan | 2,932 | 8.649B | 2.950M |
| Business Loan | 2,508 | 4.193B | 1.672M |
| Auto Loan | 2,709 | 2.360B | 0.871M |
| Personal Loan | 4,919 | 2.255B | 0.458M |
| Education Loan | 1,412 | 0.790B | 0.560M |

### Interpretation

Personal Loan has the highest number of loans, but Home Loan has the highest total lending value.

This is an important analytical distinction:

> **The product with the highest transaction volume is not necessarily the product with the highest financial exposure.**

### Business relevance

Management should therefore evaluate portfolio strategy using both:

- **loan count**, and
- **loan value/exposure**.

Looking at count alone could understate the importance of high-value products such as Home Loans.

---

## 5.2 Loan Status & Portfolio Risk

The cleaned loan portfolio contained:

- **8,856 Active loans**
- **4,587 Closed loans**
- **1,037 Default loans**

Overall default rate:

**7.16%**

### Interpretation

The default rate provides a portfolio-level risk KPI, while the distribution of Active/Closed/Default loans shows the current composition of the lending book.

This becomes more useful when segmented by loan type and customer characteristics.

---

## 5.3 Default Rate by Loan Type

| Loan Type | Loans | Default Loans | Default Rate |
|---|---:|---:|---:|
| Auto Loan | 2,709 | 203 | **7.49%** |
| Personal Loan | 4,919 | 359 | **7.30%** |
| Home Loan | 2,932 | 214 | **7.30%** |
| Business Loan | 2,508 | 174 | **6.94%** |
| Education Loan | 1,412 | 87 | **6.16%** |

### Interpretation

Auto Loans have the highest observed default rate at 7.49%, while Education Loans have the lowest at 6.16%.

The difference is approximately **1.33 percentage points**.

### Business relevance

This does **not** prove that one product causes more defaults. It identifies products where risk monitoring and deeper segmentation may be worthwhile.

A real credit-risk investigation would additionally consider variables such as credit score, debt-to-income ratio, collateral, interest rate and customer history.

---

## 5.4 Default Rate by Employment Type

| Employment Type | Loans | Default Loans | Default Rate |
|---|---:|---:|---:|
| Salaried | 6,872 | 506 | **7.36%** |
| Self-Employed | 3,135 | 205 | **6.54%** |
| Business Owner | 2,021 | 155 | **7.67%** |
| Retired | 1,504 | 102 | **6.78%** |
| Student | 855 | 62 | **7.25%** |
| Unknown | 93 | 7 | **7.53%** |

### Interpretation

Business Owners show the highest observed default rate at 7.67%, followed by the Unknown group at 7.53%.

Self-Employed customers show the lowest rate at 6.54%.

### Business relevance

Employment type can be used as a segmentation dimension for risk monitoring, but it should not be used alone for lending decisions.

The correct analyst conclusion is:

> **Employment segment differences are visible and can guide further investigation, but they are not sufficient evidence for a causal or underwriting decision.**

---

## 5.5 Branch Performance

Branch-level analysis compared:

- number of loans,
- total loan amount,
- average loan amount.

Examples of high-volume/high-value branches included:

| Branch | Loan Count | Total Loan Amount |
|---|---:|---:|
| B025 — Kanpur | 619 | 791.37M |
| B008 — Patna | 606 | 775.29M |
| B014 — Surat | 588 | 771.09M |
| B022 — Chennai | 618 | 770.31M |

### Interpretation

Branch performance is not adequately represented by loan count alone.

A branch can process many loans but have a different financial contribution depending on average loan size.

### Business relevance

This analysis supports branch-level monitoring of:

- lending activity,
- portfolio exposure,
- regional concentration,
- potential workload differences.

It can also help identify branches for deeper review rather than assuming that the highest-volume branch is automatically the strongest performer.

---

## 5.6 Application Approval Analysis

Approval rates by loan type:

| Loan Type | Applications | Approved | Rejected | Approval Rate |
|---|---:|---:|---:|---:|
| Home Loan | 3,942 | 3,195 | 747 | **81.05%** |
| Auto Loan | 3,658 | 2,952 | 706 | **80.70%** |
| Personal Loan | 6,790 | 5,399 | 1,391 | **79.51%** |
| Education Loan | 1,965 | 1,518 | 447 | **77.25%** |
| Business Loan | 3,636 | 2,757 | 879 | **75.83%** |

### Interpretation

Home Loans have the highest observed approval rate at 81.05%, while Business Loans have the lowest at 75.83%.

The gap is approximately **5.22 percentage points**.

### Business relevance

This comparison helps management identify products where approval/rejection patterns differ.

However, approval rate alone does not measure underwriting quality. A lower approval rate may reflect stricter risk controls rather than poor performance.

---

## 5.7 Application Processing Time

Average processing time by loan type was approximately:

- Application → Decision: **7.45–7.63 days**
- Application → Disbursement: **15.35–15.75 days**

### Interpretation

Processing times are relatively similar across products.

The analysis therefore does not support a claim that one loan type has a dramatically slower process.

### Business relevance

The useful KPI is the overall processing cycle, while product-level comparisons can identify whether a particular product needs deeper operational investigation.

---

## 5.8 Repayment & Late-Payment Analysis

For this project:

> A payment is considered late when `Days_Late > 0`.

This definition was used consistently in SQL and Power BI.

Overall:

- **Total payments:** approximately 194K
- **Late-payment rate:** **74.70%**
- **Average days late:** **5.92 days**

Late-payment rate by loan type:

| Loan Type | Late Payment Rate |
|---|---:|
| Auto Loan | **74.94%** |
| Personal Loan | **74.79%** |
| Business Loan | **74.63%** |
| Home Loan | **74.58%** |
| Education Loan | **74.33%** |

### Interpretation

Late-payment rates are high but remarkably similar across products, ranging only from 74.33% to 74.94%.

The spread is only about **0.61 percentage points**.

### Business relevance

This is an important finding because it suggests that late-payment behavior is **not strongly differentiated by loan type in this dataset**.

Therefore, management should not assume that one product alone explains late-payment behavior. Further segmentation by customer, region, payment history, income, loan tenure or other risk variables would be more informative.

---

## 5.9 Regional Repayment Analysis

The Power BI dashboard includes late-payment rate by region.

The purpose of this analysis is to determine whether repayment behavior is concentrated geographically.

### Business interpretation

If a region shows a materially different late-payment rate, it becomes a candidate for further investigation into:

- customer mix,
- branch practices,
- collection processes,
- payment channels,
- regional economic factors.

The dashboard is therefore designed to move from:

**overall KPI → product comparison → regional investigation.**

---

## 5.10 Payment Activity Over Time

Monthly payment activity was analyzed to identify changes in transaction volume over time.

The time trend is useful for:

- monitoring repayment activity,
- identifying unusual monthly changes,
- supporting operational planning,
- providing context for late-payment KPIs.

The analysis is intentionally descriptive; the available data does not establish why a monthly change occurred.

---

# 6. SQL Analysis — Why SQL Was the Primary Analytical Tool

SQL was used as the main business-analysis layer because the project contains relational data across five tables.

The SQL analysis demonstrates practical Data Analyst skills including:

- `JOIN`
- `GROUP BY`
- `CASE`
- conditional aggregation
- `COUNT`
- `SUM`
- `AVG`
- date calculations
- filtering
- ordering
- business metrics
- multi-table analysis

The queries were designed around business questions.

Examples:

### Portfolio analysis

Compare loan count and loan value by loan type.

### Risk analysis

Calculate default count and default rate by product.

### Approval analysis

Compare approved and rejected applications and calculate approval rate.

### Repayment analysis

Calculate late payments using `Days_Late > 0`.

### Processing analysis

Calculate the number of days between application, decision and disbursement.

---

# 7. Power BI Dashboard

The final report contains two pages.

## Page 1 — Executive Overview

Designed for management-level monitoring.

### Main KPIs

- Total Loans
- Total Loan Amount
- Approval Rate
- Default Rate

### Main visuals

- Portfolio by Loan Type
- Portfolio by Loan Status
- Applications by Loan Type

The page answers:

> **How large is the portfolio, how is it distributed, and what is the overall risk/approval picture?**

---

## Page 2 — Repayment & Risk Analysis

### Main KPIs

- Late Payment Rate
- Default Rate
- Average Days Late
- Total Payments

### Main visuals

- Late Payment Rate by Loan Type
- Late Payment Rate by Region
- Monthly Payment Activity

The page answers:

> **How is the loan book performing after disbursement, and where should repayment risk be investigated?**

---

# 8. DAX & Filter-Context Issue Resolved

During dashboard validation, the initial late-payment-rate visual by loan type produced nearly identical values across products.

The issue was not the underlying SQL result. It was the Power BI filter context and the inactive `Loan_ID` relationship between payments and loans.

The final calculation explicitly activated the appropriate relationship using `USERELATIONSHIP()`.

This produced Power BI results consistent with the SQL benchmark:

- Auto Loan: ~74.94%
- Personal Loan: ~74.79%
- Business Loan: ~74.63%
- Home Loan: ~74.58%
- Education Loan: ~74.33%

---

# 9. Key Findings

### Finding 1 — Portfolio concentration

Home Loans represent the largest lending value at approximately **8.65B**, while Personal Loans have the highest loan count at **4,919**.

**Meaning:** volume and financial exposure tell different stories.

### Finding 2 — Default risk differs modestly by product

Default rates range from **6.16% to 7.49%**.

**Meaning:** product-level differences exist, but the spread is relatively narrow.

### Finding 3 — Business Owners have the highest observed employment-segment default rate

Business Owners: **7.67%**.

**Meaning:** this segment may deserve additional risk analysis, but employment type alone should not drive credit decisions.

### Finding 4 — Home Loans have the highest approval rate

Home Loan approval rate: **81.05%**.

Business Loan approval rate: **75.83%**.

**Meaning:** approval patterns differ by product and can be monitored for underwriting/process investigation.

### Finding 5 — Late-payment behavior is high and similar across products

Overall late-payment rate: **74.70%**.

Product range: **74.33%–74.94%**.

**Meaning:** loan type alone does not explain much of the variation in late-payment behavior.

### Finding 6 — High loan volume does not automatically mean highest value

Personal Loans lead by count, while Home Loans lead by total amount.

**Meaning:** management should monitor both transaction volume and exposure.

### Finding 7 — Processing time is relatively consistent

Decision time is around **7.5 days**, and disbursement time around **15.5 days** across products.

**Meaning:** there is no evidence in this analysis of a major product-specific processing bottleneck.

---

# 10. Outcome / Analytical Gain

The main outcome of the project is **better visibility and decision support**

The project converted five raw relational datasets into a validated analytical model and a two-page management dashboard.

### What was gained analytically

**1. Portfolio visibility**

Management can see which products drive loan volume versus financial exposure.

**2. Risk visibility**

Default rate can be compared across loan products and employment segments rather than viewed only as one overall percentage.

**3. Repayment visibility**

Late-payment behavior can be monitored by product, region and time.

**4. Process visibility**

Application-to-decision and application-to-disbursement times provide a measurable view of lending operations.

**5. Consistent KPI definitions**

Metrics such as default rate and late-payment rate are explicitly defined and used consistently across SQL and Power BI.

**6. More reliable dashboard reporting**

SQL and Power BI outputs were cross-validated, and a filter-context problem was resolved using `USERELATIONSHIP()`.

---

# 11. Recommendations for Further Business Investigation

Based on the observed patterns, the following would be reasonable next steps:

1. **Investigate late payments beyond loan type** using customer-level payment history, income, tenure, region and other available risk variables.
2. **Review Business Loan approval patterns** because its approval rate is lower than other products.
3. **Monitor Auto Loan default rate** because it is the highest among the five products.
4. **Review Business Owner repayment/default behavior** before drawing conclusions about the segment.
5. **Monitor high-value Home Loan exposure** because portfolio value is much larger than its loan count ranking suggests.
6. **Investigate high-activity branches** for workload, exposure and regional concentration.
7. **Track processing time monthly** if operational teams need to detect emerging bottlenecks.

These are **investigation priorities**, not claims that a specific intervention will produce a specific percentage improvement.

---

# 12. Limitations

The dataset does not contain enough information to establish causal explanations for default, late payment or approval outcomes.

Important variables that could improve a real banking risk analysis include:

- credit score,
- debt-to-income ratio,
- collateral,
- interest rate,
- customer income history,
- credit history,
- collection activity,
- payment channel,
- branch staffing,
- underwriting policy,
- economic indicators.

---

# 13. Skills Demonstrated

### Python / Pandas

- Data loading
- Data profiling
- Missing-value handling
- Datetime conversion
- Text/category standardization
- Business-rule validation
- Relational validation
- Data cleaning

### SQL

- Multi-table joins
- Aggregations
- Conditional aggregation
- `CASE`
- Date calculations
- Grouping and filtering
- Business KPI calculations
- Risk and repayment analysis

### Power BI

- Data modeling
- KPI cards
- Bar charts
- Line charts
- Slicers/filter context
- Dashboard layout
- Business storytelling

### DAX

- `COUNTROWS`
- `SUM`
- `AVERAGE`
- `DIVIDE`
- `CALCULATE`
- `USERELATIONSHIP`

---


