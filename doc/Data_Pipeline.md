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

* Scaling, missing value imputation, erroneous data point:

1. General Data Cleaning

First, we cleaned the raw data to exclude rows with null account name, duplicated values and estimated electricity charges since they will not have accurate predictive value for our model.

Secondly, we cleaned data types of consumption and cost data from string to float so that we can generate distribution statistics from these metrics.

Thirdly, we converted revenue month, service start data and service end date to datetime type in python for processing and analysis.

Lastly, after data quality checks, we removed rows where all values associated with consumption and charges are zero, since null values in these fields indicate the entry is not valid.

2. Create Unique identifier

We used the combination of 'TDS#' and 'Location' to create 'Building ID' as the unique identifier for each building. However, 'Building ID' alone is still not the primary key for each data entry, we are able to uniquely identify over 99.8% of the data entries by combining 'Building ID', 'Meter Number' and 'Revenue Month'.

3. Address Date inconsistency

Since the meter reading is done manually in many buildings in New York, the meter reading dates (service start date and service end date) are not consistent across all entries. However, the service dates can be used to both aggregate monthly billing and to identify overlaps in billing period to detect overcharging due to double billing. Therefore, we combined rows that have the same building id, meter number and revenue month to account for the service date inconsistency.

4. Adding new calculated metrics

After reviewing available metrics and consulting with domain expert, we decided to add two more calculated fields for our predicative model.

'Total Charges' is calculated by adding 'KW Charges' to 'KWH Charges', this field will provide a more comprehensive trend of total consumption cost.

'Total Energy Rate' is calculated by dividing 'Total Charges' by 'Consumption (KWH)', this field is the industry standard measure for evaluating consumption efficiency.

* Challenges in data pipeline creation:

### Provide some additional insight to the data in the form of statistical or graphical analysis

For the analysis below, we will be using the cleaned version of data where we added columns for unique identifier and calculated fields for total charges and total energy rate. 

The cleaned version of data has 252554 rows and 16 columns. Column variables are listed below:

| Variable Name      | Variable type |
|--------------------|---------------|
| Account Name       | string        |
| Location           | string        |
| Building ID        | string        |
| Meter Number       | string        |
| Revenue Month      | datetime64    |
| Service Start Date | datetime64    |
| Service End Date   | datetime64    |
| # days             | float         |
| Consumption (KW)   | float         |
| Consumption (KWH)  | float         |
| Current Charges    | float         |
| KW Charges         | float         |
| KWH Charges        | float         |
| Other charges      | float         |
| Total Charges      | float         |
| Total Energy Rate  | float         |

We first generated distribution statistics on all the numeric fields:

|       | Consumption (KW) | Consumption (KWH) | Current Charges | KWH Charges   | KW Charges   | Other charges | Total Charges | Total Energy Rate |
|-------|------------------|-------------------|-----------------|---------------|--------------|---------------|---------------|-------------------|
| count | 252554           | 252554            | 252554          | 252554        | 252554       | 252554        | 252554        | 252554            |
| mean  | 68.472229        | 33058.35          | 4568.972260     | 1698.409516   | 1088.141845  | 1699.030754   | 2786.551361   | inf               |
| std   | 121.695395       | 53707.28          | 6722.453061     | 2958.148067   | 1783.039027  | 3667.192281   | 3614.090060   | NaN               |
| min   | 0.000000         | 0.000000          | -243.150000     | 0.000000      | 0.000000     | -59396.430000 | 0.000000      | 0.000000          |
| 25%   | 0.000000         | 0.000000          | 421.240000      | 0.000000      | 0.000000     | 0.000000      | 825.390000    | 0.05486036        |
| 50%   | 32.400000        | 12160             | 2555.780000     | 594.000000    | 462.940000   | 910.270000    | 1722.690000   | 0.08328255        |
| 75%   | 99.200000        | 48800             | 6120.545000     | 2385.070000   | 1603.822500  | 2659.952500   | 3270.170000   | inf               |
| max   | 16135.460000     | 1779600           | 329800.370000   | 195575.860000 | 78782.960000 | 134224.510000 | 195575.860000 | inf               | 

From the statistics, we can see that more than 25% of the consumption (KWH) values are 0, which caused values in Total Energy Rate to be infinite and invalid for further evaluation. However, from the 50% quartile, we can get a sense of the valid energy rate range. We are also able to detect range from 50% quartile for other measures for consumption and charges, especially the fact that other charges have large range for positive and negative values. This will later be useful for setting criteria for anomaly detection.

### Fully describe which features you will be using in your design


