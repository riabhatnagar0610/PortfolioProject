select * 
from [Portfolio Project]..CovidDeaths
where continent is not null
order by 3,4

--Select data that we are going to be using
 select location, date, total_cases, new_cases, total_deaths, population
 from [Portfolio Project]..CovidDeaths
 where continent is not null
 order by 1,2

--looking at total cases vs total deaths
--likelihood of dying if you contract covid
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
 from [Portfolio Project]..CovidDeaths
 where location = 'india' and continent is not null
 order by 1,2

 --looking at total cases vs population
 --percentage of people who got covid
 select location, date, population, total_cases, (total_cases/population)*100 as infected_percentage
 from [Portfolio Project]..CovidDeaths
 where location = 'india' and continent is not null
 order by 1,2

 --finding out highest infected percentage wrt population
 select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as infected_percentage
 from [Portfolio Project]..CovidDeaths
 where continent is not null
 group by location, population
 order by infected_percentage desc

  --showing higest death count wrt location
 select location, max(cast(total_deaths as int)) as highest_death_count
 from [Portfolio Project]..CovidDeaths
 where continent is not null
 group by location
 order by highest_death_count desc

 --countries with highest death percentage wrt population
 select location, population, max(cast(total_deaths as int)) as highest_death_count, max((total_deaths/population)) as death_pop_percentage
 from [Portfolio Project]..CovidDeaths
 where continent is not null
 group by location, population
 order by death_pop_percentage desc

 --let's break it down to continents
 select location, max(cast(total_deaths as int)) as highest_death_count
 from [Portfolio Project]..CovidDeaths
 where continent is null
 group by location
 order by highest_death_count desc

 --showing global number of new cases and death percentage wrt each day
 select date, sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as global_death_percentage 
 from [Portfolio Project]..CovidDeaths
 where continent is not null
 group by date
 order by global_death_percentage asc

 --showing total cases and total deaths with the death percentage in the world
 select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as global_death_percentage 
 from [Portfolio Project]..CovidDeaths
 where continent is not null
 order by global_death_percentage asc



 --COVID VACCINATIONS
 --looking at total population vs vaccinations
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cast (cv.new_vaccinations as int)) over (partition by cd.location
order by cd.location, cd.date) as peopleVaccinated
from [Portfolio Project]..CovidDeaths cd
join [Portfolio Project]..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3

with PopVsVacc (continent, location, date, population, new_vaccinations, peopleVaccinated)
as
(select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cast (cv.new_vaccinations as int)) over (partition by cd.location
order by cd.location, cd.date) as peopleVaccinated
from [Portfolio Project]..CovidDeaths cd
join [Portfolio Project]..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
)
select *, (peopleVaccinated/population)*100 as vaccinated_percentage
from PopVsVacc

--create a temp table
drop table if exists #popVaccPercentage
create table #popVaccPercentage(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
peopleVaccinated numeric)

insert into #popVaccPercentage
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cast (cv.new_vaccinations as int)) over (partition by cd.location
order by cd.location, cd.date) as peopleVaccinated
from [Portfolio Project]..CovidDeaths cd
join [Portfolio Project]..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null

select *, (peopleVaccinated/population)*100 as vaccinated_percentage
from #popVaccPercentage

--creating views to store data for later data visualisations
create view PopVaccPercentage as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(cast (cv.new_vaccinations as int)) over (partition by cd.location
order by cd.location, cd.date) as peopleVaccinated
from [Portfolio Project]..CovidDeaths cd
join [Portfolio Project]..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null

select * from PopVaccPercentage
