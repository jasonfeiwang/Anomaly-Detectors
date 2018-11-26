## Data Pipeline Presentation

*We have not been able to evaluate the actual data we will be working with since our sponsor is working on anonymizing the datasets. However, we have been working with the public version of electricity consumption data from New York City Housing Authority (NYCHA) which will be similar in format to the actual data.

### Describe and quantify the available data

The raw data file from NYCHA includes monthly electricity consumption and cost data for buildings in New York City from January 2010 to June 2018. The complete dataset has 313147 rows and 27 columns. 

There are 13 variables used to identify building information:

| Column Name      | Description                                                                                                                                                                                                                                                                                                      | Expected Values                                                                                                                                |
|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| Development Name | Development name                                                                                                                                                                                                                                                                                                 | The name of the housing development as listed in the Development Data Book.                                                                    |
| Borough          | Borough                                                                                                                                                                                                                                                                                                          | Bronx, Brooklyn, Manhattan, Queens, or Staten Island.                                                                                          |
| Account Name     | Account Name of the building                                                                                                                                                                                                                                                                                     | The name of the account.                                                                                                                       |
| Location         | Building number. In order to run an analysis by building, you can use a combination of TDS and building number which gives a unique identifier for each building                                                                                                                                                 | The building number of the meter                                                                                                               |
| Meter AMR        | Is the meter Automatic Meter Reading (AMR), Interval or none                                                                                                                                                                                                                                                     | AMR, Interval, None                                                                                                                            |
| Meter Scope      | The buildings or areas the account and meter supply                                                                                                                                                                                                                                                              | Listing of the buildings/Areas                                                                                                                 |
| TDS #            | TDS (Tenant Data System) number is the unique identifier for all NCYHA developments. It is recommended to use it in order to run analysis by development. The TDS is also the unique link between NYCHA data sets.                                                                                               | Number.The non development facilities (as identified in the field Funding Source) don't have a TDS #. For these facilities use EDP or RC Code. |
| EDP              | NYCHA Electronic Data Processing. Number used to identify individual NYCHA developments. EDP is used by NYCHA only to link data issued from a different system (the energy management system that was used by NYCHA before 2010). It is recommended to use the TDS # as a unique identifier of each development. | Three digit number                                                                                                                             |
| RC Code          | NYCHA budget responsibility code.  Code representing a specific development.                                                                                                                                                                                                                                     | Letter indicating the borough and series of numbers.                                                                                           |
| Funding Source   | The development’s funding source including Federal,Mixed Finance, or an indication that the facility is a non development facility which means a non residential facility.                                                                                                                                       | Federal, Mixed Finance, or Non Development Facility                                                                                            |
| AMP number       | Abbreviation for Asset Management Project (AMP) numbers.  HUD Development asset tracking number.  An AMP number can consist of more than one development.                                                                                                                                                        | NY and a series of numbers                                                                                                                     |
| Vendor Name      | Utility vendor name                                                                                                                                                                                                                                                                                              | Vendor name                                                                                                                                    |
| Meter Number     | Meter number                                                                                                                                                                                                                                                                                                     | Meter number                                                                                                                                   |

There are 8 variables used to identify individual billing information:

| Column Name        | Description                                                                                                                                | Expected Values        |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------|------------------------|
| UMIS Bill ID       | Number associated with the bill                                                                                                            | 7 digits bill id       |
| Revenue Month      | Year and month of bill: 2016-01                                                                                                            | 2016-01                |
| Service Start Date | Bill start date                                                                                                                            | Date                   |
| Service End Date   | Bill end date                                                                                                                              | Date                   |
| number days        | Number of days on bill                                                                                                                     | Number of days on bill |
| Estimated          | Meter was not read for the time period. The consumption and cost are estimated. (Data is updated with actual reads once the meter is read) | Yes (Y)  or No (N)     |
| Rate Class         | The rate applied to the account.  Details about each rate (dollar value) are available on the vendor web site.                             | Rate code is listed.   |
| Bill Analyzed      | The bill was analyzed for billing errors by NYCHA's Utility Management system during the billing period                                    | Yes (Y)  or No (N)     |

There are 6 variables used to identify energy consumption and cost information:

| Column Name       | Description           | Expected Values |
|-------------------|-----------------------|-----------------|
| Current Charges   | Total costs           | Dollar value    |
| Consumption (KWH) | Total KWH consumption | KWH consumption |
| KWH Charges       | Total KWH charges     | Dollar value    |
| Consumption (KW)  | Total KW consumption  | KW consumption  |
| KW Charges        | Total KW charges      | Dollar value    |
| Other charges     | Total other charges   | Dollar value    |

### Address issues with the incoming data

* scaling, missing value imputation, erroneous data point:

1. General Data Cleaning

We cleaned the raw data to exclude rows with null account name and estimated electricity charges since they will not have accurate predictive value for our model.

We also cleaned data types of consumption and cost data from string to float so that we can generate distribution statistics from 

2. Create Unique identifier



3. Address Date inconsistency
Since the meter reading is done manually in many buildings in New York, the meter reading dates (service start date and service end date) are not consistent across all entries. However, the reading dates can be used to identify overlaps in billing period to detect overcharging due to double billing. 

* Challenges in data pipeline creation:

### Provide some additional insight to the data in the form of statistical or graphical analysis.

### Fully describe which features you will be using in your design


