# AdventureWorks Product Performance Dashboard
## Project Background

The Product Manager at AdventureWorks has requested a new approach to internet sales reporting, transitioning from static reports to dynamic, visual dashboards. They seeks a comprehensive understanding of product performance, including insights into product sales, regional preferences, and trends over time.

Key requirements include:

1. **Sales Overview Dashboard**: An interactive dashboard providing a summary of internet sales between June of 2012 and May of 2014.
2. **Performance**: Visualization of sales performance, with a focus on trends over the past two years.
3. **Product Insights**: A detailed view of internet sales by products, highlighting top/bottom sellers.
4. **Filtering Options**: The ability to filter data by product, region, and time (year or month).

An interactive PowerBI dashboard can be downloaded [here]().

The SQL code utilized to clean, organize and prepare data for the dashboard can be found [here](https://github.com/QuinnNgo97/Project-AdventureWorks-Sales-Performance/blob/51f055ad11856f4aa0e4d5948b10530b33932f65/AdventureWorks%20Products%20Analysis.sql).

The 2022 AdventureWorks dataset for perfoming this analysis can be found [here](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms).

# Data Structure & Initial Checks

Prior to beginning the analysis, a variety of checks were conducted for quality control and familiarization with the datasets. The Python code utilized to inspect and perform quality checks can be found [here](https://github.com/QuinnNgo97/Project-AdventureWorks-Sales-Performance/blob/51f055ad11856f4aa0e4d5948b10530b33932f65/AdventureWorks%20Products%20Analysis.sql).

# Excecutive summary

### Overview of Findings

Profits have shown a steady upward trend, with an average monthly growth rate of approximately 39%, equating to $387,000 per month. However, a notable decline in profits occurred between April 2013 and August 2013.

Among the four product categories—Bikes, Accessories, Clothing, and Components—the Bikes category demonstrated a significant breakthrough in profitability, contributing 80% of the company’s total profit during the period from June 2012 to June 2014. This surge in revenue, observed from July 2013 onwards, indicates that the Bikes category was the primary driver of overall profit growth, while the other three categories maintained relatively stable profit levels.

It is worth noting that the Bikes category also incurred negative profits from May to July 2012, highlighting a challenging period prior to its later success.

Below is the overview page from the PowerBI dashboard and more examples are included throughout the report. The more interactive dashboard can be downloaded [here]().

<div align="center">
  <img src="">
</div>

Profits have demonstrated a consistent upward trend, with an average monthly growth rate of approximately 39%, equivalent to $387,000 per month. However, a significant decline in profits was observed between April 2013 and August 2013.

Among the four product categories—Bikes, Accessories, Clothing, and Components—the Bikes category has consistently been the most profitable, while the other three categories have maintained relatively stable profit levels. This indicates that revenue growth has been primarily driven by the Bikes category.

It is also noteworthy that the Bikes category experienced negative profits during the period from May 2013 to July 2013, marking a challenging phase within the reporting period.

###Company’s Negative Profit Between May and July 2013:

The decline in profit during the period from May to July 2013 was primarily attributed to a decrease in profitability within the Bikes category. Further analysis reveals that this was due to the launch of the Touring Bikes product line, accompanied by a major sales promotion. While this initial period resulted in a temporary loss in profit, the launch proved to be a significant success, as Touring Bikes subsequently contributed approximately 15% of the company’s annual revenue.

###Product Insights:

While Bikes generate the highest overall profit and revenue, the products with the highest order quantities are primarily from the Accessories and Clothing categories.

Among the Bikes category, Mountain Bikes and Road Bikes stand out as the most profitable product lines, contributing 55.7% and 21.7% of total profit, respectively, over the reporting period.

##Negative Profit Products:

Jerseys: Despite being the third most frequently sold item (20,656 units over the two-year period), Jerseys result in an annual net loss of approximately $44,533. While they represent a financial loss, these items can be considered a strategic investment, as they help drive traffic to the company and attract new customers. It is worth noting that Jerseys are not manufactured in-house.

Touring Frames: With a relatively low sales volume (3,725 units over the two-year period), Touring Frames incur an annual net loss of approximately $2,786. Given their limited sales performance and the availability of other high-volume products that at least break even, the company could consider removing Touring Frames from its product line or exploring ways to optimize production costs.

###Regional Analysis:

Bikes are the most popular product line across all regions. Australia and the USA stand out as the top consumer markets for Bikes, with each region contributing approximately 30% of the company’s total profits.

While Road Bikes are the most popular subcategory in most regions, Mountain Bikes generate the highest profit within the Bikes category, accounting for 70% of profits, with Road Bikes following at 27%.

A deeper analysis reveals that while Road Bikes are manufactured in-house, certain models, particularly three variants of the Road-650, incurred negative profits before May 2013. Post-May 2013, these products showed a relatively low trading volume but no further negative profits.
### Recommendations

Low-Margin, High-Volume Products:

Jerseys (Clothing line), Touring Frames, Road Frames, and Mountain Frames (Components): These products are already popular and do not require additional advertising investment. To improve profitability, the focus should be on cost reduction and supply chain optimization. Enhancing profit margins for these high-volume items can significantly impact overall profitability.
High-Margin, Low-Volume Products:

Bike Racks (Accessories): To capitalize on their high profit margins, an advertising campaign could be launched to boost sales. However, the impact of advertising costs on profit margins should be carefully evaluated to ensure a favorable return on investment before proceeding with the campaign.

# Caveats and assumptions

