-- create database
USE loan_default_db;

-- Recreate with CORRECT column order matching CSV exactly
CREATE TABLE loan_data (
    id                        INT,
    year                      INT,
    loan_limit                VARCHAR(50),
    gender                    VARCHAR(50),
    approv_in_adv             VARCHAR(50),
    loan_type                 VARCHAR(50),
    loan_purpose              VARCHAR(50),
    credit_worthiness         VARCHAR(50),
    open_credit               VARCHAR(50),
    business_or_commercial    VARCHAR(50),
    loan_amount               DECIMAL(15,2),
    rate_of_interest          DECIMAL(10,4),
    interest_rate_spread      DECIMAL(10,4),
    upfront_charges           DECIMAL(15,2),
    term                      DECIMAL(10,2),
    neg_ammortization         VARCHAR(50),
    interest_only             VARCHAR(50),
    lump_sum_payment          VARCHAR(50),
    property_value            DECIMAL(15,2),
    construction_type         VARCHAR(50),
    occupancy_type            VARCHAR(50),
    secured_by                VARCHAR(50),
    total_units               VARCHAR(50),
    income                    DECIMAL(15,2),
    credit_type               VARCHAR(50),
    credit_score              INT,
    co_applicant_credit_type  VARCHAR(50),
    age                       VARCHAR(20),
    submission_of_application VARCHAR(50),
    ltv                       DECIMAL(10,4),
    region                    VARCHAR(50),
    security_type             VARCHAR(50),
    status                    INT,
    dtir1                     DECIMAL(10,4),
    age_category              VARCHAR(50),
    credit_score_category     VARCHAR(50),
    ltv_risk_category         VARCHAR(50),
    loan_to_income            DECIMAL(10,4),
    loan_amount_category      VARCHAR(50),
    income_category           VARCHAR(50)
);

-- QUERY 1: Overall Dataset 
SELECT 
    COUNT(*)  AS total_loans,
    SUM(status) AS total_defaults,
    COUNT(*) - SUM(status)  AS total_non_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(loan_amount), 2)  AS avg_loan_amount,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(income), 2)   AS avg_income,
    ROUND(AVG(ltv), 2)  AS avg_ltv
FROM loan_data;

-- Age Group Analysis
-- Business Question:
-- "Which age group should the bank be most careful lending to?"

-- QUERY 1: Default Rate By Age Group
SELECT 
    age,
    age_category,
    COUNT(*) AS total_loans,
    SUM(status) AS total_defaults,
    COUNT(*) - SUM(status) AS total_paid_back,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(loan_amount), 2)  AS avg_loan_amount,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(income), 2) AS avg_income
FROM loan_data
GROUP BY age, age_category
ORDER BY default_rate_pct DESC;

-- Does gender affect loan default rate?

-- QUERY 2: Default Rate By Gender
SELECT
    gender,
    COUNT(*)  AS total_loans,
    SUM(status) AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(loan_amount), 2)  AS avg_loan_amount,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(income), 2)  AS avg_income
FROM loan_data
GROUP BY gender
ORDER BY default_rate_pct DESC;

-- Does credit score category actually predict default?"

-- QUERY 3: Default Rate By Credit Score Category
SELECT
    credit_score_category,
    COUNT(*)  AS total_loans,
    SUM(status)  AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(ltv), 2) AS avg_ltv
FROM loan_data
GROUP BY credit_score_category
ORDER BY default_rate_pct DESC;

-- Since income seems to matter more than credit score — let's prove it!

-- QUERY 4: Default Rate By Income Category
SELECT
    income_category,
    COUNT(*) AS total_loans,
    SUM(status)  AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(ltv), 2) AS avg_ltv
FROM loan_data
GROUP BY income_category
ORDER BY default_rate_pct DESC;


## Loan Type Analysis
-- Which loan type is the riskiest for the bank
-- QUERY 5: Default Rate By Loan Type
SELECT
    loan_type,
    COUNT(*)  AS total_loans,
    SUM(status)  AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2)  AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(rate_of_interest), 2) AS avg_interest_rate,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(ltv), 2) AS avg_ltv
FROM loan_data
GROUP BY loan_type
ORDER BY default_rate_pct DESC;

## Which loan purpose is riskiest — Home Purchase, Refinancing, Commercial or Home Improvement?

-- QUERY 6: Default Rate By Loan Purpose
SELECT
    loan_purpose,
    COUNT(*)  AS total_loans,
    SUM(status) AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(income), 2)   AS avg_income,
    ROUND(AVG(credit_score), 2)  AS avg_credit_score,
    ROUND(AVG(ltv), 2)  AS avg_ltv,
    ROUND(AVG(rate_of_interest), 2)    AS avg_interest_rate
FROM loan_data
GROUP BY loan_purpose
ORDER BY default_rate_pct DESC;

## Do bigger loans default more or less?

-- QUERY 7: Default Rate By Loan Amount Category
SELECT
    loan_amount_category,
    COUNT(*) AS total_loans,
    SUM(status) AS total_defaults,
    ROUND(SUM(status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    ROUND(AVG(ltv), 2)  AS avg_ltv,
    ROUND(AVG(loan_to_income), 2) AS avg_loan_to_income
FROM loan_data
GROUP BY loan_amount_category
ORDER BY default_rate_pct DESC;

## Do higher interest rates cause more defaults
-- QUERY 8: Default Rate By Interest Rate Bands
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








