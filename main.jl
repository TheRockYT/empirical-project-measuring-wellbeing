include("api.jl")

# Print the number of countries and years
countries_of_data = size(countries, 1)
years_of_data = size(years, 1)
println("The input contains data for ", countries_of_data, " countries over ", years_of_data, " years.")

println("Saving results to output.xlsx...")
# Write the results to a new excel file
XLSX.openxlsx(config_output_file, mode = "w") do xf
    # Use the default (first) sheet for a description.
    output_description = xf[1]
    XLSX.rename!(output_description, "description")
    output_description[1, 1] = "Description"
    output_description[2, 1] = "This sheet contains the output of the program: empirical project"

    output_description[4, 1] = "Exercise"
    output_description[4, 2] = "Sheet"
    output_description[5, 1] = "4.1.1"
    output_description[5, 2] = "frequency_table"
    output_description[6, 1] = "4.1.2"
    output_description[6, 2] = "net_exports"

    # 4.1.1
    output_frequency_table = XLSX.addsheet!(xf, "frequency_table")
    output_frequency_table[1, 1] = "Country"
    output_frequency_table[1, 2] = "Number of years of GDP data"
    frequency_table_countries_with_data = 0
    # Loop through the dict
    for (i, country) in enumerate(countries)
        # Get the number of years of data
        country_years = length(getIndicator(country, "Final consumption expenditure").values)
        # Add the country name
        output_frequency_table[i + 1, 1] = country.name
        output_frequency_table[i + 1, 2] = country_years
        # Check if the country has data for the entire period
        if country_years >= years_of_data
            frequency_table_countries_with_data += 1
        end
    end
    # Add number of countries with data over the entire period
    output_frequency_table[1, 4] = "Number of countries with data for the entire period"
    output_frequency_table[2, 4] = string(frequency_table_countries_with_data, " / ", countries_of_data, " (", round(frequency_table_countries_with_data / countries_of_data * 100, digits = 2), "%)")

    # 4.1.2
    output_net_exports = XLSX.addsheet!(xf, "net_exports")
    output_net_exports[1, 1] = "net exports"
    output_net_exports[2, 1] = "Country"
    # Save the years in the second row
    for (i, year) in enumerate(years)
        output_net_exports[2, i + 1] = year
    end
    for (i, country) in enumerate(countries)
        output_net_exports[i + 2, 1] = country.name
        country_imports = getIndicator(country, "Imports of goods and services")
        country_exports = getIndicator(country, "Exports of goods and services")
        if !ismissing(country_imports) && !ismissing(country_exports)
            country_imports_value = country_imports.values
            country_exports_value = country_exports.values
            for (j, year) in enumerate(years)
                if haskey(country_imports_value, year) && haskey(country_exports_value, year)
                    output_net_exports[i + 2, j + 1] = country_exports_value[year] - country_imports_value[year]
                end
            end
        else
            println("Warning: ", country.name, " does not have data for imports or exports.")
        end
    end
end

println("Done! See ya later!")


