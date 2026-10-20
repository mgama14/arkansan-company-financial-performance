# Arkansan Company Financial Performance Analysis (2020-2025)

## Project Overview

After a recent move from my hometown New York City to Arkansas, I found myself intensely curious about my immediate surroundings. Life here was frightfully different, and I wanted to learn everything I could about my new home. Along the way, I made a few discoveries, one of which was that Arkansas is home to the corporate juggernaut Walmart (which we don't actually have in New York City!). This prompted me to look into other companies with Arkansan roots and inspired me to launch a project comparing three of them: Walmart, J.B. Hunt, and Tyson Foods. 

I decided to focus in on fiscal years 2020–2025 because the pandemic and its lingering effects have long been a point of interest for me. COVID-19 marked an enormous chapter in the global economy, disrupting supply chains, shifting consumer behavior, and changing how businesses operated. Its effects did not simply disappear when lockdowns lifted, and some of its long term consequences are still unfolding. I wanted to explore how this period of disruption and recovery appeared in the financial performance of these major Arkansan companies.

What began as an investigation into overall financial performance ultimately led me to some interesting insights that broadened my perspective on what a financially healthy company might look like. In particular, I became interested in the idea that revenue growth alone may not tell the whole story. By examining profitability and operating cash flow alongside revenue, I could begin to see how companies with very different business models performed across the same broad economic period.

## Tools and Technologies

• **Data source:** SEC.gov Company Facts API

• **Data extraction and transformation:** Python, Pandas

• **Database:** PostgreSQL

• **Querying and database design:** SQL

• **Visualization and analysis:** Power BI, DAX

• **Data format:** CSV

## Pipeline Architecture

SEC Company Facts API → Python/Pandas → CSV → PostgreSQL → Power BI

## Data Extraction and Transformation

Python was used to retrieve financial facts from the SEC Company Facts API to and extract relevant annual financial metrics. **It is important to note that for the scope of this project, I only extracted annual figures corresponding to each company's reported fiscal year.** This was done to give me a broad overview look at financial performance, but as such, the granularity of the project is limited to annual.

Pandas was used to select, organize, and combine the financial records into a structured company-year dataset before exporting the results to CSV. Metrics include revenue, operating income, net income, total assets, total equity, total liabilities, and operating cash flow.

One challenge I faced during this process was reconciling the available XBRL concepts with the financial figures I actually needed. While extracting Walmart's data, I was able to retrieve total assets, but I needed to calculate total liabilities myself. To do that, I first needed to identify the correct equity figure.

My initial attempt used the **StockholdersEquity** concept. I then applied the accounting equation:

Assets = Liabilities + Equity

Rearranged, this meant:

Total Liabilities = Total Assets - Total Equity

Unfortunately, using this approach, the resulting liabilities figures did not match Walmart's reported financial statements in its reported 10-K form. This lead me to re-investigate the available equity-related XBRL concepts. Eventually, I identified **StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest** (try saying that in one go). This broader measure includes equity attributable to non-controlling interests in addition to equity attributable to Walmart's stockholders. In other words, it was the equity measure I _actually_ needed for this calculation.

After grabbing that, I ran the calculations again, and I then validated the calculated figures against Walmart's official SEC Form 10-K to confirm that they reconciled with the reported financial statements.

This experience highlighted the importance of understanding the definitions behind financial data rather than relying on XBRL concepts alone. It also illustrated to me how important it was to actively be cross-checking my extractions against the actual financial reports put out by the compan#s I was investigating. Had I just assumed the initial numbers provided by using  **StockholdersEquity** were correct, Walmart's entire financial findings would be off, which would be devastating. 

[This roadbump is still visible in the Walmart extraction code, available here.](https://github.com/mgama14/arkansan-company-financial-performance/tree/main/python%20scripts)

## Database Design

<img width="1204" height="819" alt="image" src="https://github.com/user-attachments/assets/403e4d40-4e4d-4129-86ec-a68960a59c89" />

_The schema loaded into Power BI._

The prepared dataset was loaded into PostgreSQL through a staging table and transformed into a dimensional model.

The final model contains:

• **dim_company:** company dimension.

• **dim_fiscal_year:** fiscal-year dimension.

• **fact_financials:** financial measures for each company-year combination.

The fact table uses a composite primary key on company and fiscal year, with foreign keys linking it to the dimension tables.

[View database SQL here.](https://github.com/mgama14/arkansan-company-financial-performance/tree/main/database%20creation%20code)

## Power BI Analysis

#Executive Overview: 

<img width="1957" height="1100" alt="image" src="https://github.com/user-attachments/assets/7c2dad8f-8634-486a-842a-90b4b61a2571" />

_This page compares revenue growth, operating margins, and operating cash flow margins across the three companies._

#Financial Performance: 

<img width="1939" height="1091" alt="image" src="https://github.com/user-attachments/assets/9d337ec4-325f-40fe-ad7c-4dcd6b594acb" />

_This page provides a detailed six-year view of a selected company's revenue, profitability, cash flow margins, and financial position._

DAX measures include revenue growth, operating margin, net profit margin, operating cash flow margin, cumulative revenue growth, and average annual operating margin.

The report also includes fiscal-year filtering and drill-through navigation from the executive overview to the company-level financial performance page.

#**Key Findings:**

• **Walmart demonstrated the strongest cumulative revenue growth.** Across the three companies, Walmart's revenue grew by approximately 30% between fiscal years 2020 and 2025. It's the juggernaut! 

• **In 2023, J.B Hunt experiences an _extreme_ drop in revenue growth, with a drop of -13.39%.** This really caught my eye, because I believe it makes J.B Hunt an interesting case study into how declining revenue can coexist with other measures of financial performance. Despite the drop, J.B Hunt regularly leads in average annual operating margin and annual operating cash flow margin. From a high-level perspective, I assume it may be that 2022 was just being a _very_ profitable year for a transportation company due to unique economic factors associated with the pandemic. J. B Hunt not being able to carry that momentum into future years is relatively understandable.

• **Most importantly, revenue alone does not tell a full story**

## Limitations 

• It must be stated that these companies do operate in very different industries, which could help explain variance in revenue structures and, therefor, margins.

• Fiscal year end dates differ, so the reported fiscal years are not perfectly aligned calendar periods.

• As previously stated, the granularity of the report is limited, therefor quarter-by-quarter nuance is lost. This also limits forecast ability.

In the future, I would love to expand this so it does include quarter-by-quarter information and an in-depth date dimension. I would love to study the trajectory of these three companies. It would also allow a much broader financial analysis. For the scope of the project, however, I do think I have glimpsed an interesting, high-level view of my *new* hometown corporations. 
