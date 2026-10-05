-- Banking Loan & Repayment Analytics
-- Primary analytical layer for the portfolio project.
-- Table names below refer to the cleaned analytical tables.

-- =========================================================
-- 1. LOAN PORTFOLIO BY LOAN TYPE
-- =========================================================

SELECT
    Loan_Type,
    COUNT(*) AS Loan_Count,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    AVG(Loan_Amount) AS Avg_Loan_Amount
FROM loans_clean
GROUP BY Loan_Type
ORDER BY Total_Loan_Amount DESC;


-- =========================================================
-- 2. LOAN PORTFOLIO BY STATUS
-- =========================================================

SELECT
    Loan_Status,
    COUNT(*) AS Loan_Count,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    AVG(Loan_Amount) AS Avg_Loan_Amount
FROM loans_clean
GROUP BY Loan_Status
ORDER BY Loan_Count DESC;


-- =========================================================
-- 3. DEFAULT RATE BY LOAN TYPE
-- =========================================================

SELECT
    Loan_Type,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Loan_Status = 'Default' THEN 1 ELSE 0 END) AS Default_Loans,
    ROUND(
        100.0 * SUM(CASE WHEN Loan_Status = 'Default' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Default_Rate,
    SUM(CASE WHEN Loan_Status = 'Default' THEN Loan_Amount ELSE 0 END)
        AS Default_Amount
FROM loans_clean
GROUP BY Loan_Type
ORDER BY Default_Rate DESC;


-- =========================================================
-- 4. DEFAULT RATE BY EMPLOYMENT TYPE
-- =========================================================

SELECT
    c.Employment_Type,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN l.Loan_Status = 'Default' THEN 1 ELSE 0 END)
        AS Default_Loans,
    ROUND(
        100.0 * SUM(CASE WHEN l.Loan_Status = 'Default' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Default_Rate
FROM loans_clean l
JOIN customers_clean c
    ON l.Customer_ID = c.Customer_ID
GROUP BY c.Employment_Type
ORDER BY Default_Rate DESC;


-- =========================================================
-- 5. BRANCH PERFORMANCE
-- =========================================================

SELECT
    Branch_ID,
    COUNT(*) AS Loan_Count,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    AVG(Loan_Amount) AS Avg_Loan_Amount
FROM loans_clean
GROUP BY Branch_ID
ORDER BY Total_Loan_Amount DESC;


-- =========================================================
-- 6. LATE-PAYMENT RATE BY LOAN TYPE
-- Definition: Days_Late > 0
-- =========================================================

SELECT
    l.Loan_Type,
    COUNT(*) AS Total_Payments,
    SUM(CASE WHEN p.Days_Late > 0 THEN 1 ELSE 0 END)
        AS Late_Payments,
    ROUND(
        100.0 * SUM(CASE WHEN p.Days_Late > 0 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Late_Payment_Rate,
    ROUND(
        AVG(CASE WHEN p.Days_Late > 0 THEN p.Days_Late END),
        2
    ) AS Avg_Days_Late
FROM payments_clean p
JOIN loans_clean l
    ON p.Loan_ID = l.Loan_ID
GROUP BY l.Loan_Type
ORDER BY Late_Payment_Rate DESC;


-- =========================================================
-- 7. APPLICATION PROCESSING TIME BY LOAN TYPE
-- =========================================================

SELECT
    Loan_Type,
    ROUND(AVG(DATEDIFF(Decision_Date, Application_Date)), 2)
        AS Avg_Decision_Days
FROM loan_applications_clean
GROUP BY Loan_Type
ORDER BY Avg_Decision_Days DESC;


-- =========================================================
-- 8. APPLICATION TO DISBURSEMENT TIME
-- =========================================================

SELECT
    a.Loan_Type,
    ROUND(
        AVG(DATEDIFF(l.Disbursement_Date, a.Application_Date)),
        2
    ) AS Avg_Disbursement_Days
FROM loan_applications_clean a
JOIN loans_clean l
    ON a.Application_ID = l.Application_ID
GROUP BY a.Loan_Type
ORDER BY Avg_Disbursement_Days DESC;


-- =========================================================
-- 9. APPROVAL RATE BY LOAN TYPE
-- =========================================================

SELECT
    Loan_Type,
    COUNT(*) AS Total_Applications,
    SUM(CASE WHEN Application_Status = 'Approved' THEN 1 ELSE 0 END)
        AS Approved_Applications,
    SUM(CASE WHEN Application_Status = 'Rejected' THEN 1 ELSE 0 END)
        AS Rejected_Applications,
    ROUND(
        100.0 * SUM(CASE WHEN Application_Status = 'Approved' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Approval_Rate
FROM loan_applications_clean
GROUP BY Loan_Type
ORDER BY Approval_Rate DESC;


-- =========================================================
-- 10. MONTHLY PAYMENT ACTIVITY
-- =========================================================

SELECT
    DATE_FORMAT(Payment_Date, '%Y-%m') AS Payment_Month,
    COUNT(*) AS Total_Payments,
    SUM(CASE WHEN Days_Late > 0 THEN 1 ELSE 0 END)
        AS Late_Payments
FROM payments_clean
WHERE Payment_Date IS NOT NULL
GROUP BY DATE_FORMAT(Payment_Date, '%Y-%m')
ORDER BY Payment_Month;
