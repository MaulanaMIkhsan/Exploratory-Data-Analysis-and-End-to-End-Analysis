# Exploratory-Data-Analysis

***

## Project Background

PT Garuda Indonesia (Persero) Tbk, established in 1949, is the national airline of Indonesia known for its premium service and international reach. This project focuses on strengthening the Agency Sales Channel Marketing, a key revenue source.

## Executive Summary

Agency Sales Analysis: Comparative analysis of the first quarter between 2023 and 2024 demonstrates revenue growth of approximately $4 million, with Jakarta region contributing 87% of total agency sales revenue. The CGK-DPS-CGK route represents the highest-performing revenue generator, producing around $16 million across both quarters. However, month-on-month analysis reveals concerning trends, showing declining growth and losses of approximately $1 million. Given that this route serves as the company's primary revenue source, PT Garuda Indonesia (Persero) Tbk should prioritize service improvements and expansion on this top-performing route while optimizing sales program participation from the highest-performing regional markets. These strategic initiatives will strengthen the company's position in the aviation industry and drive sustainable long-term growth.

![Table Model](https://github.com/user-attachments/assets/9c76096d-40fd-4866-8c32-fba87a28abcf)
Agency Sales Model Tables

## Insight Deep-Dive

### Quarter-on-Quarter Analysis

- Agency sales revenue averaged $67 million with 500,000 passengers transported per Q1.
- Revenue experienced 6% growth following the introduction of a new travel fair concept in 2023.
- Aircraft revitalization likely contributed to the 7% increase in passenger volume.

![Q-o-Q Analysis](https://github.com/user-attachments/assets/59a62ab6-bc80-45dc-93fb-cc3cd6272b17)
![Q-o-Q Chart](https://github.com/user-attachments/assets/209354c6-b8b5-4778-8ef8-63d835667c08)

### Month-on-Month Analysis and Revenue per Pax Analysis

- January 2024 recorded 25% revenue growth and 23% passenger volume growth compared to the previous year.
- Despite quarter-over-quarter growth, revenue declined by 5% and passenger volume decreased by 4% by March 2024.
- The highest revenue per passenger ratio in Q1 2023 reached $186 during the post-New Year travel period. However, the same month also recorded the lowest revenue per passenger at $115. 

![MoM Analysis](https://github.com/user-attachments/assets/14ba05e9-5984-4b85-9757-d53a1a509f79)
![MoM Chart](https://github.com/user-attachments/assets/f2b8436b-be6e-4c80-b4c5-928a9d91110d)
![Daily revenue per pax](https://github.com/user-attachments/assets/031b1fd6-5984-4022-8755-6069c892f906)

### Sales Program

- Bayu Buana, as the top-performing travel agent partner with $4.8 million in revenue generated during Q1 2023, should receive premium benefits including the highest tier incentive programs.
- Analysis of the 2nd through 6th ranked partners reveals a highly competitive market environment with narrow revenue margins of approximately $1 million between positions.
- The market segments targeted by the top ten travel agent partners demonstrate strong profitability for both the company and its partners.

![Top 10 chart](https://github.com/user-attachments/assets/1d3f9ee7-4f5c-435e-b17b-60ae5a07e7c3)

### Travel Agent Highest Growth Revenue

- HIS Travel, Golden Rama, and Avia Tour achieved over $1.4 million in revenue growth compared to other travel agent partners.
- Kuta Cemerlang Bali, Avia Tour, and Anggrek Wisata Indonesia Travel recorded revenue growth of 100% or higher, demonstrating that these partners successfully identified and captured the right market segments through their partnership with Garuda Indonesia within a one-year period.

![Top 10 analysis](https://github.com/user-attachments/assets/c733a3be-ed63-40c5-9792-0ba059820444)
![Highest growth chart](https://github.com/user-attachments/assets/ad812389-f449-4624-a4b5-51137ace0cf3)

### Region of Sales Highest Growth Revenue and Most Demanding Routes on Q1 2023 & 2024

- Jakarta, serving as the company's head office region, generated substantial revenue growth of $3 million independently.
- Despite DPS/Denpasar being one of Garuda Indonesia's most popular destinations, this sales region achieved only $460,000 in revenue growth, suggesting that geographical factors may significantly influence market performance or other reasons.
- UPG/Makassar experienced a $60,000 revenue decline while other regional markets posted positive growth, indicating reduced market demand and interest in this particular region.
- The CGK-MES and CGK-SIN routes, both high-demand destinations, demonstrated market stability, while the top two routes on the performance list experienced significant declines.

![Region growth and demanding routes](https://github.com/user-attachments/assets/a39423bc-9173-46bc-b13f-68133ab224ef)

## Recommendations

Maximize Product Portfolio and Service Offerings

- **Maintains and Expands New Travel Fair Concepts**: Given the positive growth achieved through the current travel fair format, the company should continue innovating and enhancing this concept to reach more diverse market segments.
- **Prioritize Aircraft Fleet Revitalization**: Considering the current growth trajectory, the company should optimize additional aircraft units for revitalization to attract new markets and generate increased revenue.

***

Enhance Operational Excellence and Service Delivery

- **Optimize First Quarter Performance**: During these times, the sales team should maximize opportunities across all market segments, analyze trends and patterns occurring in different countries and seasons, and establish strategic partnerships with other airlines through mutually beneficial agreements.
- **Implement Data-Driven Decision Making**: Continuously monitor key revenue metrics and use data insights to refine operational strategies, ensuring sustained business effectiveness and growth.

***

Leverage Strategic Travel Agent Partnerships

- **Maximize Travel Agent Market Potential**: The agency sales unit's advantage lies in leveraging travel agent partners to identify and cultivate their own customer bases rather than directly engaging end consumers. However, the agency sales unit must provide comprehensive support to these partners and help them maximize available market opportunities through strategic challenges and incentive programs. For example, during low-season periods, the agency sales unit could develop competitive sales programs targeting specific routes, where travel agents compete for rewards such as branded merchandise, complimentary tickets, enhanced commission rates, and other valuable incentives beyond standard compensation.

***

Optimize Regional Markets and Route Performance

- **Focus on High-Performing Revenue Generators**: The company should develop the capability to forecast, calculate, and make strategic decisions about discontinuing underperforming sales regions and routes that fail to meet established revenue standards. Rather than maintaining unprofitable operations, the company should concentrate resources on improving and innovating within higher-revenue regions and routes to maximize profitability and growth potential.

## Clarifying Questions, Assumptions, and Caveats

### Questions Prior to Project Advancement

- **All Columns in The Table**:
    - How is this data recorded?
    - Why there is no refund record in the database given?
    - What is the time frame for data collection - is this based on booking date, travel date, or payment date?
    - Are these figures based on gross bookings or net revenue after cancellations and changes?

### Assumptions and Caveats

- **Data Quality Assumptions**:
    - Revenue figures are assumed to be accurate and consistently measured across periods, but no refund data suggests potential overstatement of actual realized revenue.
    - Growth percentages assume like-for-like comparisons without accounting for changes in route mix, fare structures, or booking policies.
    - Passenger counts may not reflect actual flown passengers versus booked passengers.
- **Sampling and Scope Caveats**:
    - Analysis focuses only on Q1 data, which may not represent annual performance patterns.
    - Agency sales represent only one revenue channel, potentially missing direct booking trends.
    - Top 10 travel agent analysis may not reflect broader market dynamics.

***

- See the raw data I used for this project in the [CSV Files](Exploratory-Data-Analysis/Datasets).
- See my SQL queries in [SQL](Exploratory-Data-Analysis/Exploration).
- See the visualization in [Power BI Visual](Exploratory-Data-Analysis/Visualization).
