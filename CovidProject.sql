




Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
From CovidProject..CovidDeaths
Where location like '%poland%'
order by 1,2

Select Location, Population,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPrecentage
From CovidProject..CovidDeaths
Group by Location, Population
order by InfectedPrecentage desc




Select Location, Population,  MAX(cast(total_deaths as int))as HighestDeathCount
From CovidProject..CovidDeaths
Where continent is not null
Group by Location, Population
order by HighestDeathCount desc


--global numberzz

Select date, SUM(new_cases) as DailyInfected, SUM(cast(new_deaths as int)) as DailyDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsToInfectedPrecentage
From CovidProject..CovidDeaths
Where continent is not null
Group By date
order by DeathsToInfectedPrecentage desc



With PopcsVac (Continent, location, date, population, new_vaccinations, RollingPepoleVaccinated)
as
(
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPepoleVaccinated
    From CovidProject..CovidDeaths dea
    Join CovidProject..CovidVaccinations vac
        On dea.location = vac.location and dea.date = vac.date
    where dea.continent is not null
)
Select *, (RollingPepoleVaccinated/Population)*100
From PopcsVac



--create view 

Create view PrecentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPepoleVaccinated
    From CovidProject..CovidDeaths dea
    Join CovidProject..CovidVaccinations vac
        On dea.location = vac.location
		and dea.date = vac.date
    where dea.continent is not null


	Select *
	From PrecentPopulationVaccinated


	Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	From CovidProject..CovidDeaths 
	where continent is not null
	order by 1,2

	Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc
