# code_challenge
# Corteva Code Challenge

## Solution response Document
A solution response document has been provided that outlines the answer ro each problem.  It is intended as a summary document and is supported by additional data in this readmme files that is spcific to set and execution of the solution.

## Problem #1 - Data Model
### Summary of Solution
    MySQL Database (8.0.32)
    MySQL Workbench (8.0)
    Dimension Model with staging tables

### Setup Requirements
    MySQL database instance access.  Scripts provided to create the database and objects in the database for the entire challenge.
    
    Configuration to the database can be updated in the corteva.ini file to provide the host and database name.  The default port for MySQL is used.  The username and password have been placed in environment variables named DBUSER / DBPASS.

## Problem #2 - Data Ingestion
### Summary of Solution
    Data ingestion is accomplished using a Python from a Jupyter Notebook.  Microsoft Visual Code provided code linter and formatting.  Details of the code are captured in the notebook and covers the details of each step.

### Setup Requirements
    MySQL Connector – pip install mysql-connector-python
    Pandas – pip install pandas
    Config Parser – pip install configparser
    Logging and os should be part of Python base install.

    NOTE: Update the corteva.ini file with the appropriate values based on your setup.
    
    If you wish to review the notebook file without installing Juypter notebook you can use https://nbviewer.org/github/tamckean/code_challenge/blob/main/src/data_ingestion/DataIngestion.ipynb
    

## Problem #3 - Data Analysis
### Summary of Solution
    For the analysis problem the data from the fact tables was used along with functions available in MySQL to roll the data up to yearly numbers.  Conversions were made to convert tenths of degrees to degrees and tenths of millimeters to centimeters.  The values not available that were provided as -9999 values were converted to nulls.  The functions in MySQL handle dealing with those values when calculating averages.

### Setup Requirements
Solution is part of the Notebook for problem #2

## Problem #4 - REST API
### Summary of Solution
    For the REST API Flask was used along with SQLAlchemy to create a local API.  The flasgger module was used to create Swagger documentation for the two APIs.


### Setup Requirements
    Flask
    flask_sqlalchemy
    flask_marshmallow
    flask_restful
    flasgger
    pymysql[rsa]
    cryptography


## Inventory 

Source Code for database -> src/DatabaseScripts
Source Code for Data Ingestion -> src/data_ingestion
Source Code for API -> src/corteva (Python file main.py in env folder along with the yml files)

Completed log file -> logs/corteva.log



