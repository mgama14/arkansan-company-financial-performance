INSERT INTO dim_company (company_name)
SELECT DISTINCT company
FROM staging_financials;

INSERT INTO dim_fiscal_year (fiscal_year)
SELECT DISTINCT fiscal_year
FROM staging_financials
ORDER BY fiscal_year;


INSERT INTO fact_financials (
    company_name,
    fiscal_year,
    revenue,
    operating_income,
    net_income,
    total_assets,
    total_equity,
    total_liabilities,
    operating_cash_flow
)
SELECT
    company,
    fiscal_year,
    revenue,
    operating_income,
    net_income,
    total_assets,
    total_equity,
    total_liabilities,
    operating_cash_flow
FROM staging_financials;