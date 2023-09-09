function printFrequencyTable(df)::Dict
    # Create a dict to store the data
    dict = Dict()

    # Loop through all rows on df (cut before)
    for row in eachrow(df)
        # The country is on row 2
        country = row[2]
        # The indicator name is on row 3
        IndicatorName = row[3]

        # Add the country to the dictionary if it does not exist    
        if !haskey(dict, country)
            dict[country] = 0
            # Loop through all years starting from D
            for year in row[4:end]
                # Check if the year is missing
                if ismissing(year)
                    continue
                end
                # Add the country to the dictionary
                dict[country] += 1
            end
        end
    end
    return dict
end