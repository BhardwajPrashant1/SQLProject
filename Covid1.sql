select * from dbo.CovidDeaths
where continent is not null --as two column location and continent have Asia inside it
order by 3,4

--Select * from dbo.CovidVaccination$
--order by 3,4
select location,total_cases,new_cases,total_deaths,population
From CovidProject..CovidDeaths
where continent is not null
order by 1,2 ;

--Total Cases vs Total Deaths:
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 Death_Percentage
From CovidProject..CovidDeaths
where continent is not null 
and  location like '%India%'
order by 1,2 ;

--Total Cases vs Population
--It shows what percentage of population got Covid
select location,date,total_cases,population,(total_cases/population)*100 PercentagePeopleInfected
From CovidProject..CovidDeaths
where continent is not null 
and location like '%India%'
order by 1,2 ;


--Country with highest infection rate compared to Population:
select location,max(total_cases) HighestCases,population,max((total_cases/population)*100) PercentagePeopleInfected
From CovidProject..CovidDeaths
where continent is not null 
group by Location,population
order by PercentagePeopleInfected desc;

--Countries with Highest Death Counts
select location,max(cast(total_deaths as int)) TotalDeathCount  --total_deaths data type is nvarchar
From CovidProject..CovidDeaths
where continent is not null 
group by Location
order by TotalDeathCount desc; 

--EXPLORE THE DATA AS PER THE CONTINENTS

select continent,max(cast(total_deaths as int)) TotalDeathCount  --total_deaths data type is nvarchar
From CovidProject..CovidDeaths
where continent is not null 
group by continent
order by TotalDeathCount desc; 

--GLOBAL NUMBERS
select date,sum(new_cases) Totalcases,sum(cast(new_deaths as int)) TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 DeathPercentage --total_deaths data type is nvarchar
From CovidProject..CovidDeaths
where continent is not null 
group by date
order by date desc,DeathPercentage ; 

--Global Number of Deaths
select sum(new_cases) Totalcases,sum(cast(new_deaths as int)) TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 DeathPercentage --total_deaths data type is nvarchar
From CovidProject..CovidDeaths
where continent is not null 
order by 1,2 ; 


--Joining both the tables:
Select * 
from CovidProject..CovidVaccination a join CovidProject..CovidDeaths b
on a.location=b.location and a.date=b.date


--Total Population vs Vaccination

Select a.new_vaccinations,b.continent,b.location,b.date,b.population
from CovidProject..CovidVaccination a join CovidProject..CovidDeaths b
on a.location=b.location and a.date=b.date
where b.continent is not null
order by a.location,a.date,a.continent


Select b.continent,b.location,b.date,(a.new_vaccinations/b.population)*100 PeopleVaccinated
from CovidProject..CovidVaccination a join CovidProject..CovidDeaths b
on a.location=b.location and a.date=b.date
where b.continent is not null
order by PeopleVaccinated desc;




--Create Table Temp
--Select b.continent,b.location,b.date,(a.new_vaccinations/b.population)*100 PeopleVaccinated
--from CovidProject..CovidVaccination a join CovidProject..CovidDeaths b
--on a.location=b.location and a.date=b.date
--where b.continent is not null


--With Poyvac (Continent,Location,Date,PeopleVacccinated)
--as
--(
--Select b.continent,b.location,b.date,(a.new_vaccinations/b.population)*100 PeopleVaccinated
--from CovidProject..CovidVaccination a join CovidProject..CovidDeaths b
--on a.location=b.location 
-- and a.date=b.date
--where b.continent is not null  
--)

--With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From CovidProject..CovidDeaths dea
--Join CovidProject..CovidVaccination vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
--) 

--CREATING TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
--RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--SUM(cast(vac.new_vaccinations)as int) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select * from #PercentPopulationVaccinated;

--CREATING VIEW


Go
Create View Prashant2
as 
select sum(new_cases) Totalcases,sum(cast(new_deaths as int)) TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 DeathPercentage --total_deaths data type is nvarchar
From CovidProject..CovidDeaths
where continent is not null 
--order by 1,2 ;

Select * from Prashant2 ;





