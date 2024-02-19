select * from PortfolioProject..CovidDeaths2;

select * from PortfolioProject..CovidDeaths2
where continent is not null
order by 3,4;

--select date that we are going to be using
select location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject..CovidDeaths2;

-- looking at totale cases vs totale deaths
-- shows likelihood of deaths if you contract covid in your country

select location,date,total_cases,total_deaths, (total_deaths/nullif (total_cases,0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
where location like '%af%'
order by 1;

-- looking at totale cases vs Population
-- shows what percentage of population got Covid

select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths2
where location like '%af%'
order by 1,2;

--Looking at Country with Highest Infection Rate compared to population

select location,population,max(total_cases)as HighestInfection,max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths2
group by population,location
order by PercentPopulationInfected desc;

--Looking at Country with Highest Death count

select location,max(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths2
group by location
order by HighestDeathCount desc;

--let break thins down by continent

select continent,max(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths2
group by continent
order by HighestDeathCount desc;

--showing continents with the highest death count per population

select continent,max(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths2
where continent is not null
group by continent
order by HighestDeathCount desc;

-- Global Number

SELECT date, 
    SUM(new_cases) AS TotalNewCases, 
    SUM(new_deaths) AS TotalNewDeaths,
    SUM(new_deaths) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths2
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

SELECT  
    SUM(new_cases) AS TotalNewCases, 
    SUM(new_deaths) AS TotalNewDeaths,
    SUM(new_deaths) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths2
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;


------------------------------------------------------------------
--join this two table

select * 
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

--looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 2,3;

select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,Sum(vac.new_vaccinations) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeapleVaccination
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 2,3;


--Use CTE

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeapleVaccination)
as
(
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,Sum(vac.new_vaccinations) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeapleVaccination
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
--	ORDER BY 2,3
)
select *,(RollingPeapleVaccination/nullif (population,0))*100 as TotalPopulationVaccinated
from PopvsVac;

--Temp Table
drop table if exists #PercentPopulationVaccination
Create Table #PercentPopulationVaccination
(
	continent nvarchar (255),
	Location nvarchar(255),
	date datetime,
	population numeric,
	New_Vaccination numeric,
	RollingPeapleVaccination numeric
)

insert into #PercentPopulationVaccination
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,Sum(vac.new_vaccinations) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeapleVaccination
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--	WHERE dea.continent IS NOT NULL
--	ORDER BY 2,3

select *,(RollingPeapleVaccination/nullif (population,0))*100 as TotalPopulationVaccinated
from #PercentPopulationVaccination;

--Creating View To store Data for later Visualisation

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,Sum(vac.new_vaccinations) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeapleVaccination
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
--	ORDER BY 2,3

























































