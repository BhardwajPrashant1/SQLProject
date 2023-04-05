/*
The dataset provides us with information about Indian startups, including their founding year, the city they are based in, their 
industries, the number of employees they have, and the funding they have received. 
Analyzing this data can provide us with valuable insights into the Indian startup ecosystem.
*/

Select *
from IndianStartUps..Startups

--Let's drop column F1 as we don't want additional Index in our Dataset
Alter Table IndianStartUps..Startups
Drop Column F1

--Table description
sp_help[IndianStartUps..Startups]

--Check column data types only
Select COLUMN_NAME,DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Startups'

--Lets see if there is some  missing row in Company Column
Select Sum(Case when Company is Null then 1 else 0 END) as Missing
from IndianStartUps..Startups

--Count the number of startups in each city
Select City,count(Company) TotalStartup
from IndianStartUps..Startups
group by City
order by TotalStartup DESC

--Which city has the most startups?
Select City,count(Company) TotalStartup
from IndianStartUps..Startups
group by City
order by TotalStartup DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

--Which year had the most startup launches?
Select Top 1 [Starting Year],count(Company) TotalStartup
from IndianStartUps..Startups
group by [Starting Year] 
order by TotalStartup DESC

--Which are the most common industries for startups in India?
Select Top 3 Industries,Count(Company) TotalStartup
from IndianStartUps..Startups
group by Industries
order by TotalStartup DESC

--Average Numnber of Employees in Startups
SELECT AVG(CAST(SUBSTRING([No# of Employees], 1, CHARINDEX('-', [No# of Employees]) - 1) AS INT) +
           CAST(SUBSTRING([No# of Employees], CHARINDEX('-', [No# of Employees]) + 1, LEN([No# of Employees])) AS INT)) AS AvgEmployees
FROM IndianStartUps..Startups
WHERE [No# of Employees] NOT LIKE '%[^0-9-]%'


Alter Table IndianStartUps..Startups
Add  AverageEmp VARCHAR(50)


UPDATE s
SET s.AverageEmp = e.AvgEmployees
FROM IndianStartUps..Startups s
INNER JOIN (
  SELECT Company, AVG(CAST(SUBSTRING([No# of Employees], 1, CHARINDEX('-', [No# of Employees]) - 1) AS INT) +
           CAST(SUBSTRING([No# of Employees], CHARINDEX('-', [No# of Employees]) + 1, LEN([No# of Employees])) AS INT)) AS AvgEmployees
  FROM IndianStartUps..Startups
  WHERE [No# of Employees] NOT LIKE '%[^0-9-]%'
  GROUP BY Company
) e ON s.Company = e.Company

--What is the average funding amount received by startups in India?
Select Avg([Funding Amount in $]) as AverageFunding
FROM IndianStartUps..Startups

--Which startup has received the highest amount of funding in India?
Select Top 1 Company as StartupWithHighestFunding,max([Funding Amount in $]) as FundingAmount
FROM IndianStartUps..Startups
group by Company
order by FundingAmount DESC

--What is the average number of funding rounds for Indian startups?
Select avg([Funding Round]) AverageFundingRound
FROM IndianStartUps..Startups

--Which Indian startups have the highest number of investors?
Select Top 1 Company,[No# of Investors]
FROM IndianStartUps..Startups
order by [No# of Investors] DESC



