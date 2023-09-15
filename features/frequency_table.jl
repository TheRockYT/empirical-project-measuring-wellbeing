function generateFrequencyTable(data::InputData)::Dict
    # Create a dict to store the data
    dict = Dict()

    # Loop through all countries
    for country in data.countries
        # Get the indicator "Final consumption expenditure"
        indicator = getIndicator(country, "Final consumption expenditure")
        # Check if the indicator is missing
        if ismissing(indicator)
            println("Indicator not found for country: ", country.name)
            continue
        end
        dict[country.name] = length(indicator.values)
    end
    return dict
end

function getCountriesWithDataFromFrequencyTable(dict::Dict, max::Int)::Int
    # Define a counter
    counter = 0
    # Loop trough the dict
    for (i, (country, years)) in enumerate(frequency_table_data)
        # Check if the number of years is less than the max
        if (years >= max)
            # Add 1 to the counter
            counter += 1
        end
    end
    # Return the counter
    return counter
end

function getCountriesOfData(data)::Int
    # Create an array to store the list of countries
    countries = []

    # Loop through all rows on df (cut before)
    for row in eachrow(data[4:end, 2])
        # The country is on row 1 (becourse it is cut before, usally on row 2)
        country = row[1]
        # Add the country to the array if it does not exist
        if !(country in countries)
            push!(countries, country)
        end
    end
    return size(countries, 1)
end