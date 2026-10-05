# Banking Analytics — Schema

## Tables

### 1. customers

Customer-level information.

Key fields used in analysis:

- `Customer_ID`
- `Customer_Name`
- `Customer_Since`
- `City`
- `Employment_Type`
- `Monthly_Income`

Primary key:

`Customer_ID`

---

### 2. branches

Branch reference data.

Key fields:

- `Branch_ID`
- `Branch_Name`
- `City`
- `Region`
- `Branch_Open_Date`

Primary key:

`Branch_ID`

---

### 3. loan_applications

Loan application and decision information.

Key fields:

- `Application_ID`
- `Customer_ID`
- `Branch_ID`
- `Application_Date`
- `Decision_Date`
- `Loan_Type`
- `Requested_Amount`
- `Application_Status`

Primary key:

`Application_ID`

Relationships:

- Customer → Applications through `Customer_ID`
- Branch → Applications through `Branch_ID`

---

### 4. loans

Approved/disbursed loan information.

Key fields:

- `Loan_ID`
- `Application_ID`
- `Customer_ID`
- `Branch_ID`
- `Loan_Type`
- `Loan_Amount`
- `Approval_Date`
- `Disbursement_Date`
- `Interest_Rate`
- `Tenure_Months`
- `Loan_Status`

Primary key:

`Loan_ID`

Relationships:

- Application → Loan through `Application_ID`
- Customer → Loan through `Customer_ID`
- Branch → Loan through `Branch_ID`

---

### 5. payments

Loan repayment transactions.

Key fields:

- `Loan_ID`
- `Customer_ID`
- `Due_Date`
- `Payment_Date`
- `Amount_Due`
- `Amount_Paid`
- `Days_Late`
- `Payment_Status`

Relationships:

- Loan → Payments through `Loan_ID`
- Customer → Payments through `Customer_ID`

## Important Analytical Definition

For this project, a payment is considered **late when `Days_Late > 0`**.

Therefore, the late-payment rate is not simply the number of rows whose `Payment_Status` equals `Late`. A payment can have a positive `Days_Late` value even when its status is recorded as `Paid`.

This definition is used consistently in SQL and Power BI.
