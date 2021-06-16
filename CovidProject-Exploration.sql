/* PERSONAL PORTFOLIO PROJECT ON SQL 

BACKGROUND INFORMATION

This is the Exploration of Covid 19 Dataset
The Data is sourced from https://ourworldindata.org/covid-deaths
The original dataset came as a single csv file, but was splitted into two using Microsoft Excel for easier manipulation.
The two files are Covid with death and population on one side and Vaccination on another side
The exploration was done using Microsoft SQL Server and Microsoft SQL Server Management Studio


EXPLORATION PROCEDURE
1 Original dataset was downloaded as csv file from the source location
2 The csv file was opened in Microsoft Excel, the Population column was moved from column 45 to column 5
3 Two excel files were created as covidDeaths with the first 26 columns  and covidVaccinations with the remaining 37 columns, 
4 The first four columns are the same in both tables to enable us create relationships. 
5 Database was created for the project called CovidProject in Microsoft SQL Server Express Edition
6 The two excel files were imported into the SQL server as tables using SQL Server 2019 import and Export Data feature

SKILLS USED  
Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/
-- TASKS PERFORMED

-- Task 1 : cross check the imported files with the tables on the database and order it by location and date

select *
from CovidProject.dbo.covidDeaths$
Where continent is not null 
order by location, date

select *
from CovidProject.dbo.covidVaccinations$
Where continent is not null 
order by location,date
 
-- Task 2: Select the data we will use for exploration from covidDeaths and always keep your data organised
 
select location, date, total_cases, new_cases, total_deaths, population
from CovidProject.dbo.covidDeaths$
Where continent is not null 
order by location,date

-- Task 3: Compare total cases against Total death (To determine likelihood of death if covid is contracted in a country)

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject.dbo.covidDeaths$
Where continent is not null 
order by location,date

-- Task 4: Narrow task 3 down to countries using the WHERE CLAUSE
-- USA

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject.dbo.covidDeaths$
where location like '%states%'
order by location,date

-- NIGERIA

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject.dbo.covidDeaths$
where location like '%nigeria%'
order by location,date

-- ITALY

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject.dbo.covidDeaths$
where location like '%italy%'
order by location,date

-- Task 5: Compare total cases against the population (To show what percentage are infected with covid in a country)

select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
Where continent is not null 
order by location,date

-- Task 6: Narrow task 5 down to countries using the WHERE CLAUSE
-- USA

select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
where location like '%states%'
order by location,date

--NIGERIA

select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
where location like '%nigeria%'
order by location,date

-- ITALY

select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
where location like '%italy%'
order by location,date

-- Task 7: Determine countries with highest infection rate compared to her population

select location, population, max(total_cases) as HighestInfected, max((total_cases/population))*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
Where continent is not null 
group by location, population
order by PercentPopulationInfected desc

-- Task 8: Narrow task 7 down to countries using the WHERE CLAUSE
-- USA

select location, population, max(total_cases) as HighestInfected, max((total_cases/population))*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
where location like '%states%'
group by location, population
order by PercentPopulationInfected desc

-- NIGERIA

select location, population, max(total_cases) as HighestInfected, max((total_cases/population))*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
where location like '%nigeria%'
group by location, population
order by PercentPopulationInfected desc


-- ITALY

select location, population, max(total_cases) as HighestInfected, max((total_cases/population))*100 as PercentPopulationInfected
from CovidProject.dbo.covidDeaths$
where location like '%italy%'
group by location, population
order by PercentPopulationInfected desc


-- Task 8: Determine countries with highest Death count

select location, max(cast(total_deaths as int)) as HighestDeath
from CovidProject.dbo.covidDeaths$
where continent is not null
group by location
order by HighestDeath desc

-- CONTINENTAL PERSPECTIVE TO OUR DATASET

-- Task 9: Determine continent with highest Death count

select location, max(cast(total_deaths as int)) as HighestDeath
from CovidProject.dbo.covidDeaths$
where continent is null
group by location
order by HighestDeath desc


-- Task 10: Determine continent with highest infection rate

select location, max(cast(total_cases as int)) as HighestCasesReported
from CovidProject.dbo.covidDeaths$
where continent is null
group by location
order by HighestCasesReported desc


-- GLOBAL PERSPECTIVE TO OUR DATASET

-- Task 11: Determine DeathPercentage with respect to Total cases ordered by date

Select date, SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..covidDeaths$
where continent is not null 
group by date
order by total_cases, total_deaths desc


-- Task 12: Determine DeathPercentage with respect to Total cases Globally 

Select SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..covidDeaths$
where continent is not null 
order by total_cases, total_deaths


-- WORKING WITH THE TWO TABLES

-- Task 13: create alias for table names and join them on location and date

select *
from CovidProject..covidDeaths$ cdt
join CovidProject..covidVaccinations$ cva
on cdt.location = cva.location
and cdt.date = cva.date

-- Task 14: Determine the Total number of people vaccinated against the total population

select cdt.continent, cdt.location, cdt.date, cdt.population, cva.new_vaccinations
from CovidProject..covidDeaths$ cdt
join CovidProject..covidVaccinations$ cva
on cdt.location = cva.location
and cdt.date = cva.date
where cdt.continent is not null
order by continent, location

-- Task 15: Create a column to do summation of new cases of vaccination on daily basis, day1 = day1 and day2 = day1 + day2, day3 = day2 + day3 etc

select cdt.continent, cdt.location, cdt.date, cdt.population, cva.new_vaccinations,
sum(cast(cva.new_vaccinations as int)) Over (partition by cdt.location order by cdt.location, cdt.date) as VaccinationSummation
from CovidProject..covidDeaths$ cdt
join CovidProject..covidVaccinations$ cva
on cdt.location = cva.location
and cdt.date = cva.date
where cdt.continent is not null
order by location, date

-- Using CTE to perform Calculation on Partition of Query on Task 15
-- What is CTE: This is temporary result set that you can reference within another by using SELECT, INSERT, UPDATE, or DELETE statement

-- Task 16: what percentage of the population has been vaccinated, present answer with  summation of new percentage of vaccination on daily basis

with pop_vac (continent, location, date, population, new_vaccination, VaccinationSummation)

as 
(

select cdt.continent, cdt.location, cdt.date, cdt.population, cva.new_vaccinations,
sum(cast(cva.new_vaccinations as int)) Over (partition by cdt.location order by cdt.location, cdt.date) as VaccinationSummation
from CovidProject..covidDeaths$ cdt
join CovidProject..covidVaccinations$ cva
on cdt.location = cva.location
and cdt.date = cva.date
where cdt.continent is not null
-- order by location, date 
)
select *, (VaccinationSummation/population)*100 as  PercentageVaccinated
from pop_vac


-- Using TEMP Table to perform Calculation on Partition of Query on Task 15

-- What is Temp table: This is a temporary table that stores a subset of data from a normal table for a certain period of time

-- Task 17: Repeat task 16 using a Temp table

DROP Table if exists #PercentageVaccinated
Create Table #PercentageVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinationSummation numeric
)
insert into #PercentageVaccinated
select cdt.continent, cdt.location, cdt.date, cdt.population, cva.new_vaccinations,
sum(cast(cva.new_vaccinations as int)) Over (partition by cdt.location order by cdt.location, cdt.date) as VaccinationSummation
from CovidProject..covidDeaths$ cdt
join CovidProject..covidVaccinations$ cva
on cdt.location = cva.location
and cdt.date = cva.date
where cdt.continent is not null
-- order by location, date 

select *, (VaccinationSummation/population)*100 as  PercentageVaccinated
from #PercentageVaccinated


-- Task 18: Create a View to be used in Visualization project

create View  PercentageVaccinated as

select cdt.continent, cdt.location, cdt.date, cdt.population, cva.new_vaccinations,
sum(cast(cva.new_vaccinations as int)) Over (partition by cdt.location order by cdt.location, cdt.date) as VaccinationSummation
from CovidProject..covidDeaths$ cdt
join CovidProject..covidVaccinations$ cva
on cdt.location = cva.location
and cdt.date = cva.date
where cdt.continent is not null
--order by location, date




