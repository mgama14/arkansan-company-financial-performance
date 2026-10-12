CREATE TABLE dim_company (
    company_name TEXT PRIMARY KEY
);

CREATE TABLE dim_fiscal_year (
    fiscal_year INTEGER PRIMARY KEY
);

CREATE TABLE fact_financials (
    company_name TEXT REFERENCES dim_company(company_name),
    fiscal_year INTEGER REFERENCES dim_fiscal_year(fiscal_year),
    revenue NUMERIC,
    operating_income NUMERIC,
    net_income NUMERIC,
    total_assets NUMERIC,
    total_equity NUMERIC,
    total_liabilities NUMERIC,
    operating_cash_flow NUMERIC,

    PRIMARY KEY (company_name, fiscal_year)
);

-- this serves as the landing/staging table

CREATE TABLE staging_financials (
    fiscal_year INTEGER,
    revenue NUMERIC,
    operating_income NUMERIC,
    net_income NUMERIC,
    total_assets NUMERIC,
    total_equity NUMERIC,
    total_liabilities NUMERIC,
    operating_cash_flow NUMERIC,
    company TEXT
);