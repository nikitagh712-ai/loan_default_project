SELECT
    CASE
        WHEN rate_of_interest = 0  THEN '1. No Interest'
        WHEN rate_of_interest < 3  THEN '2. Below 3%'
        WHEN rate_of_interest < 4  THEN '3. 3% to 4%'
        WHEN rate_of_interest < 5  THEN '4. 4% to 5%'
        WHEN rate_of_interest < 6  THEN '5. 5% to 6%'
        ELSE  '6. Above 6%'
    END   AS interest_rate_band,
    COUNT(*)  AS total_loans,
    SUM(status)   AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(rate_of_interest), 2) AS avg_interest_rate,
    ROUND(AVG(income), 2)  AS avg_income,
    ROUND(AVG(loan_amount), 2)  AS avg_loan_amount,
    ROUND(AVG(credit_score), 2)  AS avg_credit_score
FROM loan_data
GROUP BY interest_rate_band
ORDER BY interest_rate_band;

-- QUERY 9: Default Rate By Region
SELECT
    region,
    COUNT(*)    AS total_loans,
    SUM(status) AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(income), 2)  AS avg_income,
    ROUND(AVG(credit_score), 2)  AS avg_credit_score,
    ROUND(AVG(ltv), 2)  AS avg_ltv,
    ROUND(SUM(loan_amount), 2) AS total_loan_exposure
FROM loan_data
GROUP BY region
ORDER BY default_rate_pct DESC;

-- Business Question:
-- Is the default situation getting better or worse over time?
-- QUERY 10: Year Wise Default Trend
SELECT
    year,
    COUNT(*)  AS total_loans,
    SUM(status)  AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(rate_of_interest), 2) AS avg_interest_rate,
    ROUND(SUM(loan_amount), 2)  AS total_loan_exposure
FROM loan_data
GROUP BY year
ORDER BY year ASC;

-- Business Question:
-- Which income group + loan type combination is most dangerous?

-- QUERY 11: Income Category vs Loan Type
-- Advanced combination analysis
SELECT
    income_category,
    loan_type,
    COUNT(*)  AS total_loans,
    SUM(status)  AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(loan_amount), 2)  AS avg_loan_amount,
    ROUND(AVG(ltv), 2)  AS avg_ltv
FROM loan_data
GROUP BY income_category, loan_type
ORDER BY default_rate_pct DESC
LIMIT 10;

-- Business Question:
-- Which LTV risk level + loan purpose combination creates most defaults?

-- QUERY 12: LTV Risk Category vs Loan Purpose
SELECT
    ltv_risk_category,
    loan_purpose,
    COUNT(*)  AS total_loans,
    SUM(status)   AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(loan_amount), 2)  AS avg_loan_amount,
    ROUND(AVG(income), 2)  AS avg_income,
    ROUND(AVG(ltv), 2)  AS avg_ltv
FROM loan_data
GROUP BY ltv_risk_category, loan_purpose
ORDER BY default_rate_pct DESC
LIMIT 10;