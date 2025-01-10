# 🌍 Global CO2 Emissions Dashboard

![Snippet of the Dashboard](<images/dashboard snippet.png>) *Dashboard Snippet*
## 🚀 Introduction

Climate change is an undeniable global challenge, and addressing it starts with understanding the data. This project is a culmination of my passion for environmental sustainability and my skills in data analysis.

The CO2 Emissions Analysis Dashboard offers insights into global CO2 emissions, enabling users to explore trends, identify key contributors, and analyze actionable data. From cleaning raw datasets to visualizing compelling insights, this journey showcases how data analytics can empower sustainable decision-making.

This project is a testament to my commitment to sustainability and leveraging data to make a meaningful impact.

The dataset used in this project is sourced from Kaggle[ Co2 Data
](https://github.com/owid/co2-data?tab=readme-ov-file) which provides a foundation for my analysis, containing detailed information on CO2 emissions (annual, per capita, cumulative and consumption-based), other greenhouse gases, energy mix, and other relevant metrics. In this project, I focus on co2 emissions majorly.

# 🎯 Project Objectives
1. Highlight Global Emission Trends: Analyze emissions across years, regions, and sectors to identify patterns.
2. Sectoral Contribution: Break down emissions by coal, oil, gas, and other sources to focus on actionable targets.
3. Per Capita Insights: Ensure fair comparisons by incorporating population data into the analysis.
4. Dynamic Interaction: Enable users to filter, explore, and derive insights through an intuitive dashboard.
5. Advocacy for Change: Use data to create awareness and inspire sustainable actions.

# Tools I Used

For my deep dive into the Co2 Data , I harnessed the power of several key tools:

- **Excel:** For understanding the data, removing the columns I do not need for my analysis and initial cleaning up the dataset 
- **Python:** Used **Pandas** for further cleaning and transforming the data. Looked into missing values and removed further columns and rows that have missing co2 data required for analysis. 
- **Postresql:** The backbone of my analysis, allowing me to analyze the data and find critical insights. I performed calculations, aggregating and used window functions for my analysis.
- **Power BI:**  For visualizing the data and bringing the analysis to life. I used DAX for further calculations and made visuals using bar, line, map etc
- **Visual Studio Code:** My go-to for executing my Python scripts.
- **Git & GitHub:** Essential for version control and sharing my Python & SQL code and analysis, ensuring collaboration and project tracking.

# Data Cleaning & Prep

This section outlines the steps taken to prepare the data for analysis, ensuring accuracy and usability. I have used **Excel** for the initial cleaning and removing of unnecessary columns and then  **Python** for the further cleaning and transformations.The notebook with detailed steps here: [Data Cleaning](Data_cleaning.ipynb)

## Excel

Using Excel I identified the columns that I may not require in my analysis and removed them. I looked into the columns or rows having missing crictical data and then removed them. I checked for any inconsistencies in the data in the first outlook. The revised dataset can be found here : [Cleaned Dataset](dataset\Emission_data_cleaned.xlsx)

## Python - Advanced cleaning 

I stated by importing the cleaned dataset and checking the data using info, describe() etc to understand the data and the datatypes. I further looked into the missing and duplicated values and took care of it. 

I wanted to add a column for continent for the countries as part of my analysis. For that i used the **pycountry** and **pycountry_convert** libraries to map the countries in my data to the continents(Antartica is not included due to no data/lack of data), which is understandable since they doesmt seem to have that much of co2 emissions.

```python
# Function to map country to continent
def map_country_to_continent(country_name):
    try:
        country_alpha2 = country_name_to_country_alpha2(country_name)
        continent_code = country_alpha2_to_continent_code(country_alpha2)
        continent_mapping = {
            'AF': 'Africa',
            'AS': 'Asia',
            'EU': 'Europe',
            'NA': 'North America',
            'SA': 'South America',
            'OC': 'Oceania',
            'AN': 'Antarctica'
        }
        return continent_mapping.get(continent_code, None)
    except KeyError:
        return None

# Map countries to continents
data_cleaned['continent'] = data_cleaned['country'].apply(map_country_to_continent)

```
After mapping the countries and getting a new column for continent, I further looked into any mapping issues that may have occured and fixed those. I also removed several non country rows in the country columns (low income contries, high income countries, OECD , non OECD etc). 

After this data preparation , I got the final cleaned dataset ready for my SQL analysis. The full python code for the data cleaning and preparation can be found here : [Data Preparation](Data_cleaning.ipynb) and the final dataset here : [Final Cleaned Dataset](dataset\cleaned_data.csv) 

# SQL Analysis 

Now , the cleaned dataset i analysed further using SQL . In my project, I have used **PostgreSQL** in Visual code environment. I created the table using python **sqlalchemy** library . Then imported the data to the sql database through PgAdmin directly. 

After importing the data, I went on to do the analysis . some of them i have stated below and the entire sql can be found here : [Co2 Emisssion Analysis](https://github.com/nikitha108/Emission_project/blob/main/Co2%20emissions%20Analysis.sql)

1. Total Co2 Analysis per year to see how it changes over time


2.  Top 10 countries having the maximum emissions 

Here I wanted to see the top co2 emitting countries while also looking how population is also a major factor contributing to pollution. Below are the results of the query.


![alt text](images/image.png)

3. Co2 per capita Analysis

```sql
-- Query: CO2 Emissions per Capita by Country in 2023 with Ranking
SELECT 
    country, 
    continent,
    SUM(co2) / SUM(population)  AS CO2_per_Capita,
    RANK() OVER (ORDER BY SUM(co2) / SUM(population) DESC) AS CO2_per_Capita_Rank
FROM emissions_data
WHERE year = 2023
GROUP BY continent,country 
ORDER BY CO2_per_Capita_Rank;
```

Here I wanted to see what was the co2 per capita to compare emissions across countries with various population sizes. I could see that smaller , wealthier countries such as Qatar , Bahrain, UAE, Saudi Arabia etc have the highest per capita emissions while densely populated countries have low per capita values despite higher emissions. 

4. Co2 Emission Growth absolute and %

```sql
--  co2 emission growth % gives small developing nations since their base value is different 
SELECT
    country,
    continent,
    co2 AS co2_emissions,
    co2_growth_abs,
    co2_growth_prct
FROM emissions_data
WHERE year = 2023
ORDER BY co2_growth_prct DESC;

-- co2 absolute growth gives large developing nations since their base value is higher
SELECT
    country,
    continent,
    co2 AS co2_emissions,
    co2_growth_abs,
    co2_growth_prct
FROM emissions_data
WHERE year = 2023
ORDER BY co2_growth_abs DESC;
```
Here , I wanted to see how the co2 emissions are growing per year. I see that low developing countries with low baseline emissions have the highest growth % with low absolute growth while high developed countries with high emissions have low growth % but high absolute growth in emissions.

# Visualization Using Power BI

Power BI was used to bring the analysis to life using charts and other nice visuals . 

### The dashboard can be found here :  
 ### [Global CO2 Emissions Analysis Dashboard](https://github.com/nikitha108/Emission_project/blob/main/Global%20CO2%20Emissions%20Dashboard.pbix)

 Below is the snippet of the dashboard 

![alt text](<images/dashboard snippet.png>)

 ## 1. Importing Data Sources & Adding columns


 I imported the dataset through the PostgreSQL Server Database directly. I also added the other SQL queries through the advanced options by pasting the queries.

 I also wanted a column showing the emissions from other sources since there was data from coal, oil and flaring.

## 2. Visuals 

- Dynamic Map Visuals highlighting the co2 emissions with a gradient scale for visual clarity.

- Donut charts to show the share of emissions by Continent

- Area chart showing the Trend of CO2 Emissions over Time

- Bar charts showing the Top ten countries with the highest emissions

- Cards to show the Total co2 emissions, Yearly emissions with the Co2 growth % vs PY

## Custom Calculations Using DAX

I used DAX to perform several calculations such as current year and previous year emissions, calculating the growth % and creating a co2 summary showing growth vs py. I used DAX also for dynamic color codeing.


DAX for dynamic color coding for continent to visualize in a table
```DAX
Color Continent = 
    SWITCH(
        TRUE(),
        MAX('public emissions_data'[continent]) = "North America", "#C2272D",
       MAX('public emissions_data'[continent]) = "South America", "#3AB54A",
        MAX('public emissions_data'[continent]) = "Europe", "#2AABE2",
        MAX('public emissions_data'[continent]) = "Africa", "#F15A25",
        MAX('public emissions_data'[continent]) = "Asia", "#FBB03B",
        MAX('public emissions_data'[continent]) = "Oceania", "#2E3192"
    )
```
 DAX for CO2 growth & co2 summary

 ![alt text](image-2.png)

 ```dax
 CO2 Growth % = 
DIVIDE(
    ([Current Year Emissions] - [Previous Year Emissions]
    ),
    [Previous Year Emissions],
    0
)

Growth Summary = IF([CO2 Growth %] > 0, "▲", "▼") & 
IF( [CO2 Growth %] > 0 , "+", "") &
FORMAT([CO2 Growth %], "0.00%") &  " vs " & (MAX('public emissions_data'[year]) - 1)

Growth color = SWITCH(
    TRUE(),
    [CO2 Growth %] > 0 , "RED",
    [CO2 Growth %] < 0, "GREEN"
)
```

# Key Insights
- Rising Global Emissions: Despite sustainability efforts, emissions continue to rise globally.
- Coal's Dominance: Coal remains the largest contributor, highlighting the need for renewable energy alternatives.
- Per Capita Disparities:
High-income countries have significantly higher emissions per capita.
- Rapidly industrializing nations (China, USA , India etc)are emerging as hotspots.
- Regional Trends: Some regions esp Europe show promising declines, likely due to renewable energy adoption. This is something that could be leanred further and applied to reduce the emissions in the future
- In the past 15 years, only one year showed a decrease in CO2 Emissions and that is 2020. This shows that less activity overall had reduced emissions too.

# Challenges Faced
- Cleaning the Data: the data had 50k rows and 78 columns having data from all the countries in the world from 1970 to 2023. So, to clean the data and to filter out all the columns from 78 to the ones that i would need was indeed a daunting task but I learnt a lot.

- As i said, this was a vast dataset, and to decide on what i need to focus on was a difficult decision. I would love to analyse further into the other columns that I havent used here.

# My Passion for Sustainability
As someone deeply committed to environmental advocacy, this project is a personal mission to use data for good. It reflects my belief that data-driven decisions can empower humanity to combat climate change effectively.

# Conclusion
This project has been a rewarding journey that combined my technical skills with my dedication to sustainability. I hope this dashboard inspires others to take action and leverage data in the fight against climate change.

# Future Scope
- Add predictive analytics to forecast emissions trends.
- Integrate renewable energy data to track progress toward sustainability goals.
- Expand the analysis to include social and economic impacts of emissions.
- Take into account the land usage and deforestation factors that could aide the co2 emissions
- A comprehensice sector analysis 
