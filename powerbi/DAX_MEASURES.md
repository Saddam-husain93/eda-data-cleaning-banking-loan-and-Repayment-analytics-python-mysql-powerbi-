# Power BI DAX Measures

## Core Loan Measures

```DAX
Total Loans =
COUNTROWS(loans_clean)
```

```DAX
Total Loan Amount =
SUM(loans_clean[Loan_Amount])
```

```DAX
Average Loan Amount =
AVERAGE(loans_clean[Loan_Amount])
```

## Application Measures

```DAX
Total applications =
COUNTROWS(loan_applications_clean)
```

```DAX
Approved Applications =
CALCULATE(
    COUNTROWS(loan_applications_clean),
    loan_applications_clean[Application_Status] = "Approved"
)
```

```DAX
Approval Rate =
DIVIDE(
    [Approved Applications],
    [Total applications],
    0
)
```

## Default Measures

```DAX
Default Loans =
CALCULATE(
    COUNTROWS(loans_clean),
    loans_clean[Loan_Status] = "Default"
)
```

```DAX
Default Amount =
CALCULATE(
    SUM(loans_clean[Loan_Amount]),
    loans_clean[Loan_Status] = "Default"
)
```

```DAX
Default Rate =
DIVIDE(
    [Default Loans],
    [Total Loans],
    0
)
```

## Payment Measures

The project defines a late payment as `Days_Late > 0`.

```DAX
Total Payments =
COUNTROWS(payments_clean)
```

```DAX
Late Payments =
CALCULATE(
    COUNTROWS(payments_clean),
    payments_clean[Days_Late] > 0
)
```

```DAX
Late Payment Rate =
DIVIDE(
    [Late Payments],
    [Total Payments],
    0
)
```

```DAX
Average Days Late =
CALCULATE(
    AVERAGE(payments_clean[Days_Late]),
    payments_clean[Days_Late] > 0
)
```

## Loan-Type Payment Measures

These measures use the Loan_ID relationship specifically for the loan-type visual.

```DAX
Late Payments by Loan Type =
CALCULATE(
    COUNTROWS(payments_clean),
    payments_clean[Days_Late] > 0,
    USERELATIONSHIP(
        payments_clean[Loan_ID],
        loans_clean[Loan_ID]
    )
)
```

```DAX
Total Payments by Loan Type =
CALCULATE(
    COUNTROWS(payments_clean),
    USERELATIONSHIP(
        payments_clean[Loan_ID],
        loans_clean[Loan_ID]
    )
)
```

```DAX
Late Payment Rate by Loan Type =
DIVIDE(
    [Late Payments by Loan Type],
    [Total Payments by Loan Type],
    0
)
```

Format `Late Payment Rate`, `Default Rate`, `Approval Rate`, and `Late Payment Rate by Loan Type` as percentages.
