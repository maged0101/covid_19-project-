select *
from [portfolio oroject]..CovidDeaths$
order by 3,4
select Location , date , total_cases , new_cases , total_Deaths , population
from [portfolio oroject]..CovidDeaths$
order by 1,2

select Location , date , total_cases ,(total_Deaths/total_cases )*100 as death_percentage
from [portfolio oroject]..CovidDeaths$
where location like '%states%'
order by 1,2

select Location , date , total_cases ,population , (total_cases/population )*100 as PercentofPopulationInfected
from [portfolio oroject]..CovidDeaths$
--where location like '%states%'
order by 1,2

--Looking at Countries with The Highest Infection Rate Compared with Population

select Location , population, MAX(total_cases ) as HighestPopulationCount, MAx((total_cases/population ))*100 as PercentofPopulationInfected
from [portfolio oroject]..CovidDeaths$
Group by location,population
order by PercentofPopulationInfected desc

--Showing Countries with the Highest death count per population

select location , MAX(cast(total_deaths as int )) as TotalDeathcount 
from [portfolio oroject]..CovidDeaths$
where continent is not null
Group by location
order by TotalDeathcount desc

--the Highest deathcount by continent 

select location , MAX(cast(total_deaths as int )) as TotalDeathcount 
from [portfolio oroject]..CovidDeaths$
where continent is null
Group by location
order by TotalDeathcount desc


select  sum(new_cases) as total_cases , sum(cast(new_deaths as int )) as total_deaths , 
sum(cast(new_deaths as int ))/sum(new_cases)*100 as Deathpercentage
from [portfolio oroject]..CovidDeaths$
where continent is not null
Group by date
order by 1,2


select sum(new_cases) as total_cases , sum(cast(new_deaths as int )) as total_deaths , 
sum(cast(new_deaths as int ))/sum(new_cases)*100 as Deathpercentage
from [portfolio oroject]..CovidDeaths$
where continent is not null
order by 1,2


select *
from [portfolio oroject]..CovidDeaths$ dea
join [portfolio oroject]..CovidVaccinations$ vac
   on dea.location = vac.location
   and    dea.date  = vac.date


   select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
from [portfolio oroject]..CovidDeaths$ dea
join [portfolio oroject]..CovidVaccinations$ vac
   on dea.location = vac.location
   and    dea.date  = vac.date
   where dea.continent is not null
   order by 2,3



   With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [portfolio oroject]..CovidDeaths$ dea
Join [portfolio oroject]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio oroject]..CovidDeaths$ dea
Join [portfolio oroject]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [portfolio oroject]..CovidDeaths$ dea
Join [portfolio oroject]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

