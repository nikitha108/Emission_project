
-- Total CO2 Emissions year wise

SELECT 
    year,
    SUM(co2) AS Total_CO2_Emissions
FROM emissions_data
WHERE co2 IS NULL
GROUP BY year
ORDER BY year;


-- Top Ten countries by Total co2 emissions in 2022
 
SELECT 
    rank() OVER (ORDER BY SUM(co2) DESC) AS Country_rank_by_co2,
    rank() OVER (ORDER BY SUM(population) DESC) AS rank_by_population,
    country, 
    continent,
    SUM(co2) AS Total_co2_Emissions,
    sum(population) AS Total_population,
    sum(gdp) AS Total_gdp
FROM emissions_data
WHERE year = 2020
GROUP BY continent,country
ORDER BY Total_co2_Emissions DESC
LIMIT 10
;

-- Query: Total CO2 Emissions by Continent in 2023 with Ranking
SELECT 
    continent,
    SUM(co2) AS Total_co2_Emissions,
    RANK() OVER (ORDER BY SUM(co2) DESC) AS Continent_Rank
FROM emissions_data
WHERE year = 2023
GROUP BY continent
ORDER BY Continent_Rank;

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


-- Query: CO2 Emissions per GDP by Country in 2023 with Ranking
SELECT 
    country, 
    continent,
    SUM(co2) / SUM(COALESCE(gdp, 1)) AS CO2_perGDP,
    RANK() OVER (ORDER BY SUM(co2) / SUM(COALESCE(gdp, 1)) DESC) AS CO2_per_GDP_Rank
FROM emissions_data
WHERE year = 2023
GROUP BY continent, country
ORDER BY CO2_per_GDP_Rank;


-- Query: Cumulative CO2 Emissions by Country and Continent (up to 2023)
SELECT 
    country, 
    continent,
    SUM(cumulative_co2) AS Cumulative_CO2_Emissions
FROM emissions_data
WHERE year <= 2023
GROUP BY continent, country
ORDER BY Cumulative_CO2_Emissions DESC;


SELECT * FROM emissions_data;





-- Query: CO2 Emissions Growth (Absolute and Percentage) by Country in 2023
SELECT 
    country,
    continent,
    year,
    SUM(co2) AS Total_co2_Emissions,
    (SUM(co2) - LAG(SUM(co2), 1) OVER (PARTITION BY country ORDER BY year)) AS CO2_Growth_Absolute,
    ((SUM(co2) - LAG(SUM(co2), 1) OVER (PARTITION BY country ORDER BY year)) / 
    LAG(SUM(co2), 1) OVER (PARTITION BY country ORDER BY year)) * 100 AS CO2_Growth_Percentage
FROM emissions_data
WHERE year IN (2022,2023)
GROUP BY continent, country,year
ORDER BY CO2_Growth_Percentage DESC NULLS LAST;


-- Query: CO2 Emissions by Sector (Coal, Gas, Flaring) in 2023
SELECT 
    country, 
    continent,
    SUM(coal_co2) AS Total_Coal_CO2,
    SUM(gas_co2) AS Total_Gas_CO2,
    SUM(flaring_co2) AS Total_Flaring_CO2
FROM emissions_data
WHERE year = 2023
GROUP BY continent, country
ORDER BY Total_Coal_CO2 DESC NULLS LAST;

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

