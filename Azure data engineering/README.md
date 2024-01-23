# Data migration, transformation and reporting using Azure 

## Setup of MS SQL server 
Database to be migrated is Adventureworks database provided by Microsoft for learning and exploration. User.sql file codes were used to setup a userID and password to be used to access the database and read access to the db was provided to the user ID.
Created an Azure keyvault. Added MS SQL server password as a secret to the keyvault.

## Azure data factory pipeline - Ingestion
Create an Azure Data Factory (ADF) resource. 
Create a Self hosted integration runtime to connect to on premise SQL server database.
Create a linked service for SQL server database on premise. Create a linked service to pick password from keyvault. Provide permissions for ADF to access secrets from keyvault.
Created a pipeline with copy data activity to copy SalesLT.Address table from SQL server to Azure datalae Gen2 container. Created a linked service to on premise SQL Server. Dataset for table in on premise server. Created a linked service to azure key vault in order to pick the on premise server password from keyvault. In order to do this, setup RBAC for ADF as keyvault administrator. Created linked service to Azure data lake gen2 storage account and dataset for parquet file in bronze container. 
Executed pipeline. It failed first time due to jre and jdk requirements not satisfied in self hosted IR environment. Pipeline succeeded for csv file. Hence installed jre-8 and setup environment variable (Microsoft documentation). Now the pipeline executed successfully for parquet file.
Published all changes in ADF

## Azure databricks - Transformation
Create Azure databricks account with Premium. Create cluster in databricks workspace with ADLS credential passthrough option enabled in order to access data in datalake storage account.
Mounted bronze, silver and gold containers using python code(Reference: Microsoft documentation)
Create secret scope using url https://<databricks-instance>#secrets/createScope (microsoft doc)
Create a notebook with logic for transformation of bronze data to silver data by changing all columns with datetime format to date format. The data was clean otherwise so no further cleaning was required. 
Wrote logic for transformation of Silver data to Gold data. In this case, standardized the column names. Wrote the output data to Gold folder in Azure Data Lake Storage (ADLS) gen2.
Added an activity in ADF pipeline to execute databricks notebook to execute the databricks notebook to transform bronze data to silver and gold and update this in ADLS. 
Authentication details are accessed through keyvault.


## Azure synapse analytics - Loading
Created Synapse analytics workspace with ADLS - gold container as primary storage. Added a serverless SQL database. Created a parameterized stored procedure to create a view of files in gold database - address, customer etc. 
Created a pipeline to get metadata of the files in gold foder, read the file name for each file and execute stored procedure to create view of each file. Executed the pipeline to create views.

## Power BI - Reporting
In Power BI desktop, connected to get data from azure synapse analytics SQL source with the SQL server endpoints, golddb database using Microsoft credentials. Imported data and tables from golddb in synapse.
Designed a report to analyse orders and products per country and category.


## Security 
To provice controlled access to resources for multiple users, create a security group in Microsoft Entra ID (Azure Active Directory) -> groups -> New group. 
In IAM of resource group, add role assignment and assign contributor access to the new security group. Any new users can be added to this group to provide access to the resources in this group.

## End to end testing 
Created a schedule trigger on ADF pipeline to schedule the pipeline once a day.
Added 2 new records to the Product table. The pipeline executed. Refresh powerbi report. The changes will be reflected in the report.
