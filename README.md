# AnomalyDetectors

## Project Background

Team Name: Anomaly Detectors
<br>
Team Member: Fei Wang, Yumeng Ding, Gautam Moogimane

In recent years, natural resource consumption and conservation have become major areas of focus across academic, industry and political debates. One of the big components of natural resource consumption comes from energy usage in commercial buildings. Therefore, the monitoring of energy usage trends and detection of abnormal activities in these public buildings are essential to a more efficient usage of these resources. Energy usage anomaly can come from many different sources, for example, error in manual data entry, broken infrastructure, seasonality of energy consumption and so on.

Our capstone project sponsor, Jones Lang LaSalle Americas, Inc. (JLL) is in charge of collecting energy usage data for properties under their management, to ensure the clients’ energy usage are compliant with local energy disclosure laws and measure progress towards sustainability goals. The key to success of this task relies on the accuracy of the monthly-reported utility data. More specifically, we need to distinguish true abnormal energy usage from the seemly-abnormal ones caused by data quality issues or other factors like broken infrastructure. This will help increase the productivity of the JLL’s analysts (i.e. time will be saved by targeting only the sites with anomalies for audits), lead to real cost savings (e.g. fixing building operation issues that are causing energy or water waste), and increase confidence in greenhouse gas sustainability reporting data. JLL has create a set of Data Quality Checking rules based on their experience with the data. Our team’s objective will be to evaluate existing anomaly detection rules, advise on their statistical validity, come up with five new rules based on data analysis and potentially make suggestions on how to pipeline the detection process.

## Guide to AnomalyDetector Project

There are four major folders in this repository, namely: **data**, **doc**, **output**, and **src**. (Please also refer to **Folder Structure** below for detailed structure.)

* **data** folder contains the original data we downloaded from New York City Housing Authority, it contains electricity consumption data from 2010 to 2018 on a monthly base for buildings in New York.

* **doc** folder contains artifacts we have generated during the capstone projects, from Data Pipeline, Project Proposal, Interim Presentation to Final Poster and Paper. 

* **output** folder houses the intermediate outputs we have generated through the project, mainly after cleaning the original dataset and prorating/imputating target metric on an account level.

* **src** folder holds all the codes in this project: users can use the Data_cleaning notebook to prepare any given dataset (e.g. detecting billing gaps, prorate bills to calendar months, and imputate missing values); all Demo notebooks are a guide to see the difference amongst the three different methods and a step by step guide of how each methods work on an example account; finally, the methods notebook provides a clean loop for users to run a given csv files through the method and output a dataframe with identification of the anomalous points detected.

## Project Framework

We followed the framework below throughout the project: solid boxes denote the methods we successfully implemented and the dashed boxes show the methods we tried but didn't work for our particular use case.

<img width="839" alt="Screen Shot 2019-03-16 at 4 07 40 PM" src="https://user-images.githubusercontent.com/32491507/54482755-bf1e9680-4805-11e9-928d-3858c52f6ed7.png">

## Folder Structure

```bash
Anomaly-Detectors
├── README.md
├── data
│   └── NYC\ Open\ Data\ -\ Electric_Consumption_And_Cost__2010_-__June_2018_.csv
├── doc
│   ├── AnomalyDetection_Poster.pdf
│   ├── Data_Pipeline.md
│   ├── Final_Report.pdf
│   ├── Interim_Presentation.pdf
│   ├── Problem_Statement.pdf
│   └── Project_Proposal.pdf
├── environment.yml
├── output
│   ├── NYCHA_Prorated_KWH
│   ├── NYCHA_Prorated_KWH.csv
│   ├── NYCHA_TS.csv
│   └── result_summary_plots
│       ├── Clustering.png
│       ├── Prophet.png
│       └── STL.png
└── src
    ├── Clustering.ipynb
    ├── Clustering_Demo.ipynb
    ├── Decomposition.ipynb
    ├── Decomposition_Demo.ipynb
    ├── NYCHA_Data_Cleaning.ipynb
    ├── Prophet.ipynb
    └── Prophet_Demo.ipynb

```

