--
--SELECTING FROM DEATH TABLE
--select * 
--from dbo.CovidDeaths$
--where continent is not null
--order by 3,4;

--SELECTING FROM VACCINATION TABLE
--select * 
--from dbo.CovidVaccinations$
--order by 3,4;



--select location, date, total_cases, new_cases, total_deaths, population
--from dbo.CovidDeaths$
--order by 1,2


--COMPARING TOTAL CASES VS TOTAL DEATH IN CANADA
--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_Percentage
--from dbo.CovidDeaths$
--where location = 'Canada'
--order by 1,2

--TOTAL CASES VS POPULATION IN CANADA
--select location, date, population, total_cases, (total_cases/population)*100 AS population_Percentage
--from dbo.CovidDeaths$
--where location = 'Canada'
--order by 1,2

--COUNTRY WITH HIGHEST INFECTION RATE VS POPULATION
--select location, population, MAX(total_cases) AS HighInfectionRate, MAX((total_cases/population))*100 AS InfectedPopulation_Percentage
--from dbo.CovidDeaths$
----where location = 'Canada'
--group by location, Population
--order by InfectedPopulation_Percentage desc


--COUNTRY WITH HIGHEST DEATH RATE PER POPULATION
--select location, population, MAX(cast(total_deaths as int)) AS TotalDeathCount
--from dbo.CovidDeaths$
--where continent is not null and  location = 'Canada'
--group by location, Population
--order by TotalDeathCount desc



-- LOCATION AND CONTINENT WITH HIGHEST DEATH RATE 
--select location, Continent, MAX(cast(total_deaths as int)) AS TDeathCount
--from dbo.CovidDeaths$
--where continent is not null 
--group by location, continent
--order by TDeathCount desc


--BREAKING IT DOWN TO CONTINENTs WITH HIGHEST DEATH RATE
--select continent, MAX(cast(total_deaths as int)) AS TDeathCount
--from dbo.CovidDeaths$
--where continent is not null 
--group by  continent
--order by TDeathCount desc


--BREAKING IT DOWN TO CONTINENTS WITH HIGHEST DEATH RATE PER POPULATION
--select continent, population, MAX(cast(total_deaths as int)) AS TDeathCount
--from dbo.CovidDeaths$
--where continent is not null 
--group by  continent, population
--order by TDeathCount desc


--GLOBAL RESULTS BY DATE
--select date, SUM(new_cases) AS sum_cases, sum(cast(new_deaths as int)) as sum_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS death_Percentage
--from dbo.CovidDeaths$
----where location = 'Canada
--where continent is not null
--Group by date
--order by 1,2


--GLOBAL RESULTS WORLDWIDE
--select SUM(new_cases) AS sum_cases, sum(cast(new_deaths as int)) as sum_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS death_Percentage
--from dbo.CovidDeaths$
----where location = 'Canada
--where continent is not null
----Group by date
--order by 1,2





--TOTAL POPULATION VS VACCINATION

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--sum(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
--dea.Date) as RollingPeopleVaccinated
--from dbo.CovidDeaths$ dea
--JOIN dbo.CovidVaccinations$ vac 
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


--USE CTE

--With PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
--as
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--sum(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
--dea.Date) as RollingPeopleVaccinated
--from dbo.CovidDeaths$ dea
--JOIN dbo.CovidVaccinations$ vac 
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--)

--Select *, (RollingPeopleVaccinated/Population)*100
--From PopvsVac


--TEMP TABLE

--Create Table #PercentPopulationVaccinated1
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date DateTime,
--Population numeric,
--New_vaccination numeric,
--RollingPeopleVaccinated numeric
--)

--Insert into #PercentPopulationVaccinated1
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--sum(Convert(numeric, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
--dea.Date) as RollingPeopleVaccinated
--from dbo.CovidDeaths$ dea
--JOIN dbo.CovidVaccinations$ vac 
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null

--Select *, (RollingPeopleVaccinated/Population)*100
--From #PercentPopulationVaccinated1



--CREATING VIEW TO STORE DATA


Create view VPercentPopulationVaccinated1 as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(numeric, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.Date) as RollingPeopleVaccinated
from dbo.CovidDeaths$ dea
JOIN dbo.CovidVaccinations$ vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

select * 
From VPercentPopulationVaccinated1