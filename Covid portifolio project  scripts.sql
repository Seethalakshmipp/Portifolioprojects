select *
from portifolioo..CovidDeaths$
where continent is not null
order by 3,4

---select *
--from portifolioo..CovidVaccinations$
--order by 3,4

select Location, date, total_cases,new_cases, total_deaths,population
from portifolioo..CovidDeaths$
order by 1,2

--Looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from portifolioo..CovidDeaths$
Where location like '%states%'
and continent is not null
order by 1,2

--looking at total cases vs population
--shows what perecentage of population got covid

select Location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
from portifolioo..CovidDeaths$
Where location like '%states%'
order by 1,2

---looking at contries with higher infection rate compared to population
select Location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from portifolioo..CovidDeaths$
--Where location like '%states%'
Group by location,Population
order by PercentPopulationInfected desc


--showing countries with highest death count per population
select Location,MAX(cast(Total_deaths as int))as TotalDeathCount
from portifolioo..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by location
order by  TotalDeathCount desc

--LET's BREAK THINGS DONE BY CONTINENT





--showing continents with the highest count per population
select continent,MAX(cast(Total_deaths as int))as TotalDeathCount
from portifolioo..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by continent
order by  TotalDeathCount desc





--GLOBAL NUMBERS
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as Deathpercentage
from portifolioo..CovidDeaths$
--Where location like '%states%'
where continent is not null
--Group By date
order by 1,2



--looking at Total population vs vaccinations
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.Location order by dea.location,dea.Date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
FROM portifolioo..CovidDeaths$ dea
join  portifolioo..CovidVaccinations$ vac
      on dea.location = vac.location
      and dea.date = vac.date
where dea.continent is not null
order by 2,3




--USE CTE
with PopvsVac(Continent,Location,Date,Population, new_vaccinations, Rollingpeoplevaccinated)
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.Location order by dea.location,dea.Date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
FROM portifolioo..CovidDeaths$ dea
join  portifolioo..CovidVaccinations$ vac
      on dea.location = vac.location
      and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (Rollingpeoplevaccinated/Population)*100
From PopvsVac


--TEMP TABLE
DROP Table if exists #percentpopulationVaccinated

Create Table #percentPopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert #percentPopulationvaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.Location order by dea.location,dea.Date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
FROM portifolioo..CovidDeaths$ dea
join  portifolioo..CovidVaccinations$ vac
      on dea.location = vac.location
      and dea.date = vac.date
where dea.continent is not null
--order by 2,3
select*,(RollingpeopleVaccinated/population)*100
From #percentPopulationvaccinated



--creating  view to store data for later visualizations

Create View percentPopulationvaccinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations))OVER(partition by dea.Location order by dea.location,dea.Date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
FROM portifolioo..CovidDeaths$ dea
join  portifolioo..CovidVaccinations$ vac
      on dea.location = vac.location
      and dea.date = vac.date
where dea.continent is not null
--order by 2,3



Select*
From percentPopulationvaccinated















