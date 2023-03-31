# code_challenge
Corteva Code Challenge

Problem #1 - Data Model
Summary of Solution
    MySQL Database (8.0.32)
    MySQL Workbench (8.0)
    Dimension Model with staging tables

Justification of Solution
    MySQL was chosen for its easy ability to lift and shift to a cloud vendor or to an inhouse deployment with little configuration needed.  This database was readily available with an open license.

    MySQL Workbench provided simple and fast way to interact with the MySQL database and code formatter for the scripts developed for the objects.

    Dimensional model was chosen for this data to allow for a simple and easy model to understand and support analysis and the APIs in problem number 4.  Stage tables were added to align with best practices for loading data.  It allows for the data to be load and reloaded without having data issues.

Alternatives Considered
    SQLAlchemy was considered to create, load, and manage the data model.  This would have been a viable option but would require a long delivery time.

Setup Requirements
    MySQL database instance access.  Configuration can be updated in the corteva.ini file to provide the host and database name.  The default port for MySQL is used.  The username and password have been placed in environment variables named DBUSER / DBPASS.

Problem #2 - Data Ingestion
Summary of Solution
    Data ingestion is accomplished using a Python from a Jupyter Notebook.  Microsoft Visual Code provided code linter and formatting.  Details of the code are captured in the notebook and covers the details of each step.

Justification of Solution
    A Notebook was used in order to provide an easy way to document the code in detail with formatted text.

Alternatives Considered
    SQLAlchemy was considered for this problem but the time to setup the definitions would have extended the development time.

Setup Requirements
    MySQL Connector – pip install mysql-connector-python
    Pandas – pip install pandas
    Config Parser – pip install configparser
    Logging and os should be part of Python base install.

    NOTE: Update the corteva.ini file with the appropriate values based on your setup.

Problem #3 - Data Analysis
Summary of Solution
    For the analysis problem the data from the fact tables was used along with functions available in MySQL to roll the data up to yearly numbers.  Conversions were made to convert tenths of degrees to degrees and tenths of millimeters to centimeters.  The values not available that were provided as -9999 values were converted to nulls.  The functions in MySQL handle dealing with those values when calculating averages.

Problem #4 - REST API
Summary of Solution
    For the REST API Flask was used along with SQLAlchemy to create a local API.  The flasgger module was used to create Swagger documentation for the two APIs.

Justification of Solution
    The solution used provided for an easy and simple way to provide the API calls along with query and pagination. Views were established to point the SQLAlchemy to so the definition was simple to implement.

Alternatives Considered
    The first attempted used Flask and pymysql.  The API were easy to develop but when it came time to add pagination the functionality was limited.  Bases on this SQLAlchemy was used to replace the original API code and pagination became much easier to manage and add to the response.

Setup Requirements
    Flask
    flask_sqlalchemy
    flask_marshmallow
    flask_restful
    flasgger


AWS Deployment
This solution would easily migrate into an AWS environment.  Some modifications would allow the completed architecture would look like the following:

The API could be placed on the AWS API Gateway.  The configuration from the current API could be reconfigured on the gateway.  This allows for a more robust scaling based on the load of the API.

The Jupyter notebook load code could be rewritten using PySpark and managed by AWS Glue. This would provide high availablity, scaling, monitoring, and fail-over in the event of an outage.

The database could be moved the AWS RDS service for MySQL, or it could be converted to PostgreSQL or SQL Server.  RDS provides scaling and options for avialiabilty.  In the event that performance becomes an issue there are plenty of options at AWS to grow into.


