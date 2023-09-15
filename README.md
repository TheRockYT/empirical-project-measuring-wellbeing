# empirical project: measuring wellbeing

**Important**: This project is not finished yet.

## Codespaces

Open this project in GitHub Codespaces for the fastest way to get started with this project.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/TheRockYT/empirical-project-measuring-wellbeing)

## Project description

This project was made for school and is my solution to [empirical project: measuring wellbeing](https://www.core-econ.org/doing-economics/book/text/04-01.html).

It was made in Julia.

## How to run

1. Install Julia
2. Automatic downloads are enabled by default. [See below for more information](#downloading-the-data-files)
3. Configure the config in the [config.jl](./config.jl) file
4. Run the script `run.jl` using Julia: `julia run.jl`
   1. This is the main script that runs the project.

### Downloading the data files

#### Automatic Download

> Warning: This will download the data files automatically from an external server. If you want to download the data files manually, [see below](#manual-download).
>
> See also: [Enable automatic downloads](#enable-automatic-downloads) and [Disable automatic downloads](#disable-automatic-downloads)

##### Enable automatic downloads

1. Set `config_download = true` in the [config.jl](./config.jl) file

##### Disable automatic downloads

1. Set `config_download = false` in the [config.jl](./config.jl) file

#### Manual Download

1. Go to the [United Nations’ National Accounts Main Aggregates Database](https://unstats.un.org/unsd/snaama/Index) website.
2. On the right-hand side of the page, under ‘Data Availability’, click ‘Downloads’.
3. Under the subheading ‘GDP and its breakdown at constant 2010 prices in US Dollars’, select the Excel file ‘All countries for all years – sorted alphabetically’.
4. Save it in an easily accessible location, such as a folder on your Desktop or in your personal folder.

> Source: [empirical project: measuring wellbeing](https://www.core-econ.org/doing-economics/book/text/04-02.html#part-41-gdp-and-its-components-as-a-measure-of-material-wellbeing:~:text=Go%20to%20the,your%20personal%20folder.)

## Important Scripts

- [install.jl](./install.jl): This is the script that installs the required packages.
- [config.jl](./config.jl): This is the config file for the project.
- [download.jl](./download.jl): This is the script that downloads the data files.
- [run.jl](./run.jl): This is the main script that runs the project. **Run this script to run the project.**
- [main.jl](./main.jl): This is the main script that runs the project.

##  API

### Getting started

1. Open the julia cli using `julia`
2. Include the api file `include("./api.jl")`
3. You now have access to the api

### Functions

#### Years

```julia
years # Get the list of years
size(years, 1) # Get the amount of years
```

#### Countries

```julia
countries # Get the list of countries
size(countries, 1) # Get the amount of countries

country = countries[1] # Get the first country

indicator = getIndicator(country, "Gross Domestic Product (GDP)") # Get the indicator for a country and year
```

#### Indicators

```julia
indicator.values # Get a dict of the values

indicator.values[2010] # Get the value for a year
# Note: The year must be an integer
```