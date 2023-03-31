CREATE OR REPLACE VIEW WEATHER_VW
AS
SELECT fw.weather_key, dd.the_date, dws.weather_station_name, dws.weather_station_code, max_daily_temp, min_daily_temp, daily_precipitation
FROM CCC_FACT_WEATHER fw 
JOIN CCC_DIM_DATE dd ON dd.date_key = fw.date_key 
JOIN CCC_DIM_WEATHER_STATION dws on dws.weather_station_key = fw.weather_station_key;

CREATE OR REPLACE VIEW WEATHER_STAT_VW
AS
SELECT fwr.weather_rollup_key, dy.yyyy as year, dws.weather_station_name, dws.weather_station_code, avg_max_temp, avg_min_temp, tot_precipitation
FROM CCC_FACT_WEATHER_ROLLUP fwr 
JOIN CCC_DIM_YEAR dy ON dy.year_key = fwr.year_key 
JOIN CCC_DIM_WEATHER_STATION dws on dws.weather_station_key = fwr.weather_station_key;

 