function generateFrequencyTable(data)::Dict
    # Create a dict to store the data
    dict = Dict()

    # Loop through all rows containing countries
    for row in eachrow(data[4:end, :])
        # The country is on row 2
        country = row[2]
        # The indicator name is on row 3
        IndicatorName = row[3]

        # Add the country to the dictionary if it does not exist    
        if !haskey(dict, country)
            counter = 0
            # Loop through all years starting from D
            for year in row[4:end]
                # Check if the year is missing
                if ismissing(year)
                    continue
                end
                # Add 1 to the counter
                counter += 1
            end
            dict[country] = counter
        end
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

function getYearsOfData(data)::Int
    return size(data[3, 4:end], 1)
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