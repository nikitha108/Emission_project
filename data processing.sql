SELECT COUNT(*) FROM emissions_data;


-- Check for NULL values in key columns     
SELECT COUNT(*) FROM emissions_data
WHERE gdp IS NULL;

-- Population and co2 columns are non- null values while we have 916 gdp columns null


