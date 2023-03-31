#Creates the schema in MySQL that will hold the data loaded from the files as well as the views used for the API calls
CREATE DATABASE `Corteva` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE Corteva;

##########################################################################
# This section is for the staging tables.  The raw data is loaded into
# these tables from the files.  Once all raw data is loaded they are 
# processed into the dimension and fact tables
##########################################################################

##########################################################################
# NAME:			    CCC_STG_YIELD_DATA
# CREATED:			2023-03-28
# DESCRIPTION:		Staging table to load yield data from txt files
#					from the yld_data folder
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_STG_YIELD_DATA(
	  STG_YIELD_DATA_KEY INT AUTO_INCREMENT
	, YIELD_FILE_NAME VARCHAR(500) NOT NULL
	, YEAR_OF_YIELD	VARCHAR(500) NULL
	, YIELD_AMOUNT BIGINT NULL
    , PRIMARY KEY (STG_YIELD_DATA_KEY)
    , UNIQUE KEY STG_YIELD_DATA_KEY_UNIQUE (STG_YIELD_DATA_KEY)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

##########################################################################
# NAME:			    CCC_STG_WEATHER_STATION_DATA
# CREATED:			2023-03-28
# DESCRIPTION:		Staging Table for weather stations data to load into
#					from the wx_data folder
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_STG_WEATHER_STATION_DATA(
	  STG_WEATHER_STATION_DATA_KEY INT NOT NULL AUTO_INCREMENT
	, FILE_NAME VARCHAR(500) NOT NULL
    , DATE_OF_WEATHER VARCHAR(500)
    , MAX_DAILY_TEMP BIGINT NULL
    , MIN_DAILY_TEMP BIGINT NULL
    , DAILY_PRECIPITATION BIGINT NULL
    , PRIMARY KEY (STG_WEATHER_STATION_DATA_KEY)
    , UNIQUE KEY STG_WEATHER_STATION_DATA_KEY_UNIQUE (STG_WEATHER_STATION_DATA_KEY)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

##########################################################################
# This section is for the dimension tables.  The raw data is reviewed to
# validate all referenced dimensions exists before the fact tables are
# loaded
##########################################################################

##########################################################################
# NAME:			    CCC_DIM_DATE
# CREATED:			2023-03-28
# DESCRIPTION:		Dimension Table for dates
#					
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_DIM_DATE(
	  DATE_KEY INT AUTO_INCREMENT
	, THE_DATE	DATE
	, DAY_OF_YEAR INT
	, WEEK_OF_YEAR INT
	, THE_MONTH INT
	, MONTH_NAME VARCHAR(10)
	, THE_QUARTER INT
	, QUARTER_NAME VARCHAR(6)
	, THE_YEAR INT
	, DATE_SORT INT
    , PRIMARY KEY (DATE_KEY)
    , UNIQUE KEY DATE_KEY_UNIQUE (DATE_KEY)
    , UNIQUE KEY DATE_UNIQUE(THE_DATE)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

##########################################################################
# NAME:			    CCC_DIM_WEATHER_STATION
# CREATED:			2023-03-28
# DESCRIPTION:		Dimension Table for weather stations
#					
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_DIM_WEATHER_STATION(
	  WEATHER_STATION_KEY INT NOT NULL AUTO_INCREMENT
    , WEATHER_STATION_CODE VARCHAR(15) NOT NULL
    , WEATHER_STATION_NAME VARCHAR(500) NULL
    , PRIMARY KEY (WEATHER_STATION_KEY)
    , UNIQUE KEY WEATHER_STATION_KEY_UNIQUE (WEATHER_STATION_KEY)
    , UNIQUE KEY WEATHER_STATION_CODE_UNIQUE (WEATHER_STATION_CODE)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

##########################################################################
# NAME:			    CCC_DIM_YEAR
# CREATED:			2023-03-28
# DESCRIPTION:		Dimension Table for years
#					
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_DIM_YEAR(
	  YEAR_KEY INT AUTO_INCREMENT
	, THE_YEAR INT
	, YYYY VARCHAR(6)
	, PRIMARY KEY (YEAR_KEY)
    , UNIQUE KEY YEAR_KEY_UNIQUE (YEAR_KEY)
    , UNIQUE KEY YEAR_UNIQUE(THE_YEAR)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

##########################################################################
# This section is for the fact tables.  The raw data is processed 
#  and loaded and foreign keys are looked up as they load
#
##########################################################################

##########################################################################
# NAME:			    CCC_FACT_WEATHER
# CREATED:			2023-03-28
# DESCRIPTION:		Fact Table for weather stations temps and precipitation
#					values.
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_FACT_WEATHER(
	  WEATHER_KEY INT NOT NULL AUTO_INCREMENT
	, DATE_KEY INT NOT NULL
    , WEATHER_STATION_KEY INT NOT NULL
    , MAX_DAILY_TEMP INT NULL
    , MIN_DAILY_TEMP INT NULL
    , DAILY_PRECIPITATION INT NULL
    , PRIMARY KEY (WEATHER_KEY)
    , FOREIGN KEY (DATE_KEY) REFERENCES CCC_DIM_DATE(DATE_KEY)
    , FOREIGN KEY (WEATHER_STATION_KEY) REFERENCES CCC_DIM_WEATHER_STATION(WEATHER_STATION_KEY)
    , UNIQUE KEY WEATHER_KEY_UNIQUE (WEATHER_KEY)
    , UNIQUE KEY WEATHER_DATE_STATION_UNIQUE (DATE_KEY, WEATHER_STATION_KEY)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

##########################################################################
# NAME:			    CCC_FACT_CROP_YIELD
# CREATED:			2023-03-28
# DESCRIPTION:		Fact Table for crop yield values.
#					
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
CREATE TABLE IF NOT EXISTS CCC_FACT_CROP_YIELD(
	  CROP_YIELD_KEY INT NOT NULL AUTO_INCREMENT
	, YEAR_KEY INT NOT NULL
    , CROP_YIELD_AMOUNT INT NULL
    , PRIMARY KEY (CROP_YIELD_KEY)
    , FOREIGN KEY (YEAR_KEY) REFERENCES CCC_DIM_YEAR(YEAR_KEY)
    , UNIQUE KEY CROP_YIELD_KEY_UNIQUE (CROP_YIELD_KEY)
    , UNIQUE KEY YEAR_UNIQUE (YEAR_KEY)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


##########################################################################
# This section is for the fact tables that was added from the analysis 
#  section. This table is loaded with a database script included in another
#  file. A call with this script can be added to the load routines as needed.
##########################################################################

##########################################################################
# NAME:			    CCC_FACT_WEATHER_ROLLUP
# CREATED:			2023-03-28
# DESCRIPTION:		Fact Table for the average temps and total precipitation
#					by station and rolled up per year
# USED BY:			
# CHANGE HISTORY:
# DATE(MM-DD-YYYY)	AUTHOR\EMAIL ADDRESS		 DESCRIPTION    
##########################################################################
DROP TABLE CCC_FACT_WEATHER_ROLLUP;
CREATE TABLE CCC_FACT_WEATHER_ROLLUP(
	  WEATHER_ROLLUP_KEY INT NOT NULL AUTO_INCREMENT
	, YEAR_KEY INT NOT NULL
    , WEATHER_STATION_KEY INT NOT NULL
    , AVG_MAX_TEMP INT NULL
    , AVG_MIN_TEMP INT NULL
    , TOT_PRECIPITATION INT NULL
    , PRIMARY KEY (WEATHER_ROLLUP_KEY)
    , FOREIGN KEY (YEAR_KEY) REFERENCES CCC_DIM_YEAR(YEAR_KEY)
    , FOREIGN KEY (WEATHER_STATION_KEY) REFERENCES CCC_DIM_WEATHER_STATION(WEATHER_STATION_KEY)
    , UNIQUE KEY YEAR_STATION_UNIQUE (YEAR_KEY, WEATHER_STATION_KEY)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




