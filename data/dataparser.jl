
# Include the structs
include("structs/Indicator.jl")
include("structs/Country.jl")
include("structs/InputData.jl")

# This function parses the spreadsheet data into a InputData object
function parseData(data)::InputData
    # Get the title from the spreadsheet
    title::String = data[1, 1]
    # Get the years from the spreadsheet
    years::Array{Int64,1} = data[3, 4:end]

    # Define an empty array to store the countries
    countries::Array{Country,1} = Array{Country,1}()
    # Loop through all rows containing countries
    for row in eachrow(data[4:end, :])

        # Parse the key values
        country_id = row[1]
        country_name = row[2]
        indicator_name = row[3]

        # Create a missing country object
        current_country = missing

        # Check if the country already exists
        for c in countries
            if c.name == country_name
                current_country = c
                break
            end
        end

        # Check if the country was found
        if ismissing(current_country)
            # Create a new country object
            current_country = Country(country_name, Array{Indicator,1}())
            # Add the country to the array
            push!(countries, current_country)
        end

        # Create a indicator object
        current_indicator = Indicator(indicator_name, Dict{Int64,Float64}())

        # Loop trough all years starting from D
        for (i, year) in enumerate(row[4:end])
            # Check if the year is missing
            if ismissing(year)
                continue
            end
            # Add the year to the indicator
            current_indicator.values[years[i]] = year
        end
        push!(current_country.indicators, current_indicator)
    end
    return InputData(title, years, countries)
end

