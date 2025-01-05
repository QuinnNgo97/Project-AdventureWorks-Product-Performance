# AdventureWorks Product Performance Dashboard
## Project Background

The Product Manager at AdventureWorks has requested a new approach to internet sales reporting, transitioning from static reports to dynamic, visual dashboards. They seeks a comprehensive understanding of product performance, including insights into product sales, regional preferences, and trends over time.

Key requirements include:

1. **Sales Overview Dashboard**: An interactive dashboard providing a summary of internet sales between June of 2012 and May of 2014.
2. **Performance**: Visualization of sales performance, with a focus on trends over the past two years.
3. **Product Insights**: A detailed view of internet sales by products, highlighting top/bottom sellers.
4. **Filtering Options**: The ability to filter data by product, region, and time (year or month).

An interactive PowerBI dashboard can be downloaded [here](https://github.com/QuinnNgo97/Project-AdventureWorks-Product-Performance/blob/aa0bdb879af258ac02c398a311af34279396772d/Adventureworks.pbix).

The SQL code utilized to clean, organize and prepare data for the dashboard can be found [here](https://github.com/QuinnNgo97/Project-AdventureWorks-Product-Performance/blob/0fb28c11813d3f4e15d8f50a3e3a5be9dcb877c5/AdventureWorks%20Products%20Analysis.sql).

The 2022 AdventureWorks dataset for perfoming this analysis can be found [here](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms).

# Data Structure & Initial Checks

Prior to beginning the analysis, a variety of checks were conducted for quality control and familiarization with the datasets. The SQL code utilized to inspect and perform quality checks can be found [here](https://github.com/QuinnNgo97/Project-AdventureWorks-Product-Performance/blob/0fb28c11813d3f4e15d8f50a3e3a5be9dcb877c5/AdventureWorks%20Products%20Analysis.sql).

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/e7f16b72fcbbbdf6ef68a6471e66e417ae3d7926/data%20structure.png">
</div>

# Excecutive summary

### Overview of Findings

Profits and Revenue have demonstrated a consistent upward trend, historical data showed that profit has been around $404,000/monthly. With 7 months left until the end of the year, 2014's Projected Profit is expected to be hit 95%, or an estimated $8.2Mil in profits for 2014.

However, a significant decline in profits was observed between May 2013 and August 2013.

Among the four product categories—Bikes, Accessories, Clothing, and Components—the Bikes category has consistently been the most profitable, while the other three categories have maintained relatively stable profit levels. This indicates that revenue growth has been primarily driven by the products in the Bikes category.

Below is the overview page from the PowerBI dashboard and more examples are included throughout the report. The more interactive dashboard can be downloaded [here](https://github.com/QuinnNgo97/Project-AdventureWorks-Product-Performance/blob/aa0bdb879af258ac02c398a311af34279396772d/Adventureworks.pbix).

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/d9e4da3a772846320ed705208d56afe7bdbe8fca/AWOVERVIEW.png">
</div>

### Company’s Negative Profit Between May and August 2013:

The declining profit observed from May to August 2013 was primarily attributed to a decrease in profitability within the Bikes category. Further analysis reveals that this was due to the launch of the Touring Bikes product line (which was introduced in May 2013), accompanied by a major sales promotion. While this campaign resulted in a temporary profit loss ($866.000 in net profit lost for the Touring Bikes after 4 months), the launch proved to be a significant success, as per the time of analysis (May 2014) the Touring Bike line has brought back over 1.1Mil USD in net profit gain, which is a 24.5% ROI after 1 year. 

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/0418302e16b89f38ac60c6aa29909a4b1d674db2/AWprofit.png">
</div>

### Top Performing Products:

While Bikes generate the 80% of annual profit(or $5.24Mil in the 12 months since report), the products with the highest order quantities are primarily from the Accessories and Clothing categories.

Among the Bikes category, Mountain Bikes and Road Bikes stand out as the most profitable product lines, contributing 55.7% and 21.7% to total company's profit, respectively, over the reporting period.

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/0b5f185e91ad859cae4c5ce45a13280483c6cf9f/AWProduct1.png">
</div>

### Bottom Performing Products:

Jerseys: Despite being the third most frequently sold item (20,656 units over the two-year period), Jerseys result in an annual net loss of approximately -$44,533. While they represent a financial loss, these items can be considered a strategic investment, as they help drive traffic to the company and attract new customers. It is worth noting that Jerseys are not manufactured in-house.

Touring Frames: With a relatively low sales volume (3,725 units over the two-year period), Touring Frames incur an annual net loss of approximately -$2,786. Given their limited sales performance and the availability of other high-volume products that at least break even, the company could consider removing Touring Frames from its product line or exploring ways to optimize production costs.

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/0418302e16b89f38ac60c6aa29909a4b1d674db2/AWprofit2.png">
</div>

While Road Bikes are the most popular product in most regions, Mountain Bikes generate the highest profit within the Bikes category, accounting for 70% of profits, with Road Bikes following at 27%.

A deeper analysis reveals that while Road Bikes are manufactured in-house, certain models, particularly three variants of the Road-650, incurred negative profits before May 2013. Post-May 2013, these products showed a relatively low trading volume but no further negative profits.

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/0418302e16b89f38ac60c6aa29909a4b1d674db2/AWquick%20notes.png">
</div>

### Regional Analysis:

Bikes are the most popular product line across all regions. Australia and the USA stand out as the top consumer markets for Bikes, with each region contributing approximately 30% of the company’s total profits.

<div align="center">
  <img src="https://github.com/QuinnNgo97/githubtest/blob/0418302e16b89f38ac60c6aa29909a4b1d674db2/AWRegion.png">
</div>

### Recommendations

- **For Low-Margin, High-Volume Products**:

Jerseys (Clothing line), Touring Frames, Road Frames, and Mountain Frames (Components): These products are already popular and do not require additional advertising investment. To improve profitability, the focus should be on cost reduction and supply chain optimization. Enhancing profit margins for these high-volume items can significantly impact overall profitability.

- **For High-Margin, Low-Volume Products**:

Bike Racks (Accessories): To capitalize on their high profit margins, an advertising campaign could be launched to boost sales. However, the advertising costs on profit margins should be carefully evaluated to ensure a favorable return on investment before proceeding with the campaign.

# Caveats and assumptions

- **Regarding Product Cost History**:
  
There are instances where a product will have the last cost update from 2011 and have it's price review deadline on May-2012 (before our analyzing period). This means that the while the product is still being sold, the product cost is not updated which leads to situations where product costs needs to be filled in from the last review date. We should take care to update the cost list when the EndDate arrive or change the EndDate to Null (and enter the change date whenever new cost is available).
  
- **Regarding 2014 Projected Profit**:
  
Projected profit is directly scaled to the missing months (7 months until the end of 2014). Please note that by comparison, 2013 Growth Rate was 50.95%.
