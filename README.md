# AtliQ-Hardware-Business-Model

## DOMAIN KNOWLEDGE
Understanding AtliQ HArdware - Consumer Goods Company
Atliq HArdware is a hardware company which sells pcs,mouse,printers and keyboards to customers like croma,best buy etc from where people can purchase 
enterprises like Croma and Best Buy are CUSTOMERS 
There are two types of customers(Platformns) :  Brick & Mortar , E-Commerce
Croma and Best Buy comes under BRick and Mortar while Amazon and Flipkart comes under E-Commerce
3 Channels : Retailer, Direct and Distributor
People buying from these enterprises are CONSUMERS

Understanding P & L Statements:

Gross Price : 30 ---------base price of a mouse
Pre-Invoice Deduction : 2(percent value) ----------------------AtliQ gives a fixed discount to Croma at the beginning of a financial year
Net Invoice Sales : 28
Promotional offers : ---------------Croma gives promotional offers on Diwali or Christmas 
Placement Fees : ------------------AtliQ asks Croma to place their mouse at a prime place to increase sales
Performance Rebate : --------------If Croma performs good then AtliQ will give discount at the end of a Quater/month/Year
These 3 things combined is called
Post-Invoice-Deductions : 3 (percent)
Net Sales : 25
NET SALES IS THE REVENUE OF AtliQ
COGS (Cost of goods sold) : 20 
                           COGS is ---------Manufacturing cost +
                                   ---------Freight(Transportation) +
                                   ---------Other Cost 
Gross Margin (Profit) : 5
(when you want GM in percent ,divide Gross margin by Net sales GM/NS)
Gross Margin % : 20 % 

Understanding the terms:
Every company has
Sales Software - Db
Customer Relationship Management - Db
Surveys - Excel,PDF formats
all these are taken care by Software Engineer

Query cannot be carried out directly into the sales software because it might slow the system(machine critical)
So these data is put into another place called DataWarehouse
Data Warehouses -----> could be MySQL, ORACLE or mongoDB
                      or
                      special Dataware house such as Amazon REDSHIFT or teradata

Now Queries can be carried out in these Data Warehouse by Data Analyst
To copy all the data from machine critical to data warehouse there is a process called ETL(Extract Transform Load)

What is ETL?
E-Extract the data
T-Transform the data ----->Currency Normalization--->converting US Dollars to Indian rupees
                     ----->Derived columns--->calculate profit with columns available
                     ----->Aggregation --->when u want the data to be in monthly or quaterly wise 
All these are done by Data Engineer

On the data warehouse developed by ETL ,data analysis is carried out

What os OLTP and OLAP?
Sales Software and CRM are OLTP (Online Transaction Processing)
ETL and Data analysis are OLAP (Online Analytical Processing) 

What is Data Catalog?
Contains information about the databases and the type od data stored in each
Contains DB server name,Table name,description and Database Admin name
                     




                                   
