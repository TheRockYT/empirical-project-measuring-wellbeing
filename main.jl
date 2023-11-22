include("api.jl")

# Print the number of countries and years
countries_of_data = size(countries, 1)
years_of_data = size(years, 1)
println("The input contains data for ", countries_of_data, " countries over ", years_of_data, " years.")

if isdir("out")
    println("Removing old output...")
    rm("out", recursive=true)
end
mkdir("out")

println("Saving results to output.xlsx...")
# Write the results to a new excel file
XLSX.openxlsx(config_output_file, mode = "w") do xf
    # Add number format for the output
    num_fmt[] = XLSX.styles_add_numFmt(xf.workbook, string("#,##0"))
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
    output_description[7, 1] = "4.1.3"
    output_description[7, 2] = "components_of_gdp"
    output_description[8, 1] = "4.1.5"
    output_description[8, 2] = "gdp_for_2015_selected"

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
            println("Warning: ", country.name, " does not fulfill 4.1.2.")
        end
    end

    # 4.1.3 a
    num_fmt[] = XLSX.styles_add_numFmt(xf.workbook, string("0.00,,,"))

    output_components_of_gdp = XLSX.addsheet!(xf, "components_of_gdp")
    output_components_of_gdp[1, 1] = "components of GDP (in billion)"
    output_components_of_gdp[2, 1] = "Country"
    output_components_of_gdp[2, 2] = "Indicator"
    # Save the years in the second row
    for (i, year) in enumerate(years)
        output_components_of_gdp[2, i + 2] = year
    end
     for (i, country) in enumerate(countries)
        current_start = i + 2 + (i - 1) * 3
        output_components_of_gdp[current_start, 1] = country.name

        output_components_of_gdp[current_start + 0, 2] = "Household consumption expenditure (including Non-profit institutions serving households)"
        output_components_of_gdp[current_start + 1, 2] = "General government final consumption expenditure"
        output_components_of_gdp[current_start + 2, 2] = "Gross capital formation"
        output_components_of_gdp[current_start + 3, 2] = "Net exports"

        household_consumption_expenditure = getIndicator(country, "Household consumption expenditure (including Non-profit institutions serving households)")
        general_government_final_expenditure = getIndicator(country, "General government final consumption expenditure")
        gross_capital_formation = getIndicator(country, "Gross capital formation")
        country_imports = getIndicator(country, "Imports of goods and services")
        country_exports = getIndicator(country, "Exports of goods and services")

        if !ismissing(household_consumption_expenditure) && !ismissing(general_government_final_expenditure) && !ismissing(gross_capital_formation) && !ismissing(country_imports) && !ismissing(country_exports)
            household_consumption_expenditure_value = household_consumption_expenditure.values
            general_government_final_expenditure_value = general_government_final_expenditure.values
            gross_capital_formation_value = gross_capital_formation.values
            country_imports_value = country_imports.values
            country_exports_value = country_exports.values
            for (j, year) in enumerate(years)
                if haskey(household_consumption_expenditure_value, year)
                    output_components_of_gdp[current_start + 0, j + 2] = household_consumption_expenditure_value[year]
                end
                if haskey(general_government_final_expenditure_value, year)
                    output_components_of_gdp[current_start + 1, j + 2] = general_government_final_expenditure_value[year]
                end
                if haskey(gross_capital_formation_value, year)
                    output_components_of_gdp[current_start + 2, j + 2] = gross_capital_formation_value[year]
                end
                if haskey(country_imports_value, year) && haskey(country_exports_value, year)
                    output_components_of_gdp[current_start + 3, j + 2] = country_exports_value[year] - country_imports_value[year]
                end
            end
        else
            println("Warning: ", country.name, " does not fulfill 4.1.3 (a).")
        end
    end
    # 4.1.3 b
    if !config_skip_images
        for (i, country) in enumerate(countries)
            household_consumption_expenditure = getIndicator(country, "Household consumption expenditure (including Non-profit institutions serving households)")
            general_government_final_expenditure = getIndicator(country, "General government final consumption expenditure")
            gross_capital_formation = getIndicator(country, "Gross capital formation")
            country_imports = getIndicator(country, "Imports of goods and services")
            country_exports = getIndicator(country, "Exports of goods and services")
            if !ismissing(household_consumption_expenditure) && !ismissing(general_government_final_expenditure) && !ismissing(gross_capital_formation) && !ismissing(country_imports) && !ismissing(country_exports)
                household_consumption_expenditure_value = household_consumption_expenditure.values
                general_government_final_expenditure_value = general_government_final_expenditure.values
                gross_capital_formation_value = gross_capital_formation.values
                country_imports_value = country_imports.values
                country_exports_value = country_exports.values


                x = sort(collect(keys(household_consumption_expenditure.values)))
                household_consumption_expenditure_key(key) = round(household_consumption_expenditure_value[key] / 1000000000, digits = 2)
                general_government_final_expenditure_key(key) = round(general_government_final_expenditure_value[key] / 1000000000, digits = 2)
                gross_capital_formation_key(key) = round(gross_capital_formation_value[key] / 1000000000, digits = 2)
                net_exports_key(key) = round((country_exports_value[key] - country_imports_value[key]) / 1000000000, digits = 2)

                plot(x, [household_consumption_expenditure_key, general_government_final_expenditure_key, gross_capital_formation_key, net_exports_key], label=["Household consumption expenditure" "General government final consumption expenditure" "Gross capital formation" "Net exports"], title=country.name, xlabel="value in billion", ylabel="year")
                

                println("Saving plot for ", country.name, "...")
                savefig(string("out/", country.name, ".png"))
            else
                println("Warning: ", country.name, " does not fulfill 4.1.3 (b).")
            end
        end
    else
        println("Warning: Skipping images 4.1.3 (b)")
    end
    # 4.1.5 a
    num_fmt[] = XLSX.styles_add_numFmt(xf.workbook, string("#,##0"))
    output_gdp_for_2015 = XLSX.addsheet!(xf, "gdp_for_2015")
    output_gdp_for_2015[1, 1] = "components of GDP for 2015"
    output_gdp_for_2015[2, 1] = "Country"
    output_gdp_for_2015[2, 2] = "Household consumption expenditure (including Non-profit institutions serving households)"
    output_gdp_for_2015[2, 3] = "General government final consumption expenditure"
    output_gdp_for_2015[2, 4] = "Gross capital formation"
    output_gdp_for_2015[2, 5] = "Net exports"
    for (i, country) in enumerate(countries)
        current_start = i + 2
        output_gdp_for_2015[current_start, 1] = country.name

        household_consumption_expenditure = getIndicator(country, "Household consumption expenditure (including Non-profit institutions serving households)")
        general_government_final_expenditure = getIndicator(country, "General government final consumption expenditure")
        gross_capital_formation = getIndicator(country, "Gross capital formation")
        country_imports = getIndicator(country, "Imports of goods and services")
        country_exports = getIndicator(country, "Exports of goods and services")

        if !ismissing(household_consumption_expenditure) && !ismissing(general_government_final_expenditure) && !ismissing(gross_capital_formation) && !ismissing(country_imports) && !ismissing(country_exports)
            household_consumption_expenditure_value = household_consumption_expenditure.values
            general_government_final_expenditure_value = general_government_final_expenditure.values
            gross_capital_formation_value = gross_capital_formation.values
            country_imports_value = country_imports.values
            country_exports_value = country_exports.values
            year = 2015
            if haskey(household_consumption_expenditure_value, year)
                output_gdp_for_2015[current_start, 2] = household_consumption_expenditure_value[year]
            end
            if haskey(general_government_final_expenditure_value, year)
                output_gdp_for_2015[current_start, 3] = general_government_final_expenditure_value[year]
            end
            if haskey(gross_capital_formation_value, year)
                output_gdp_for_2015[current_start, 4] = gross_capital_formation_value[year]
            end
            if haskey(country_imports_value, year) && haskey(country_exports_value, year)
                output_gdp_for_2015[current_start, 5] = country_exports_value[year] - country_imports_value[year]
            end
        else
            println("Warning: ", country.name, " does not fulfill 4.1.5 (a).")
        end
    end
    output_gdp_for_2015_selected = XLSX.addsheet!(xf, "gdp_for_2015_selected")
    output_gdp_for_2015_selected[1, 1] = "components of GDP for 2015 for selected countries"
    output_gdp_for_2015_selected[2, 1] = "Country"
    output_gdp_for_2015_selected[2, 2] = "Household consumption expenditure (including Non-profit institutions serving households)"
    output_gdp_for_2015_selected[2, 3] = "General government final consumption expenditure"
    output_gdp_for_2015_selected[2, 4] = "Gross capital formation"
    output_gdp_for_2015_selected[2, 5] = "Net exports"
    n = 3
    for (i, country) in enumerate(countries)
        current_start = i + 2
        current_name = country.name
        if current_name == "Iceland" || current_name == "Finland" || current_name == "Netherlands"
            output_gdp_for_2015_selected[n, 1] = current_name
            household_consumption_expenditure = getIndicator(country, "Household consumption expenditure (including Non-profit institutions serving households)")
            general_government_final_expenditure = getIndicator(country, "General government final consumption expenditure")
            gross_capital_formation = getIndicator(country, "Gross capital formation")
            country_imports = getIndicator(country, "Imports of goods and services")
            country_exports = getIndicator(country, "Exports of goods and services")

            if !ismissing(household_consumption_expenditure) && !ismissing(general_government_final_expenditure) && !ismissing(gross_capital_formation) && !ismissing(country_imports) && !ismissing(country_exports)
                household_consumption_expenditure_value = household_consumption_expenditure.values
                general_government_final_expenditure_value = general_government_final_expenditure.values
                gross_capital_formation_value = gross_capital_formation.values
                country_imports_value = country_imports.values
                country_exports_value = country_exports.values
                year = 2015
                if haskey(household_consumption_expenditure_value, year)
                    output_gdp_for_2015_selected[n, 2] = household_consumption_expenditure_value[year]
                end
                if haskey(general_government_final_expenditure_value, year)
                    output_gdp_for_2015_selected[n, 3] = general_government_final_expenditure_value[year]
                end
                if haskey(gross_capital_formation_value, year)
                    output_gdp_for_2015_selected[n, 4] = gross_capital_formation_value[year]
                end
                if haskey(country_imports_value, year) && haskey(country_exports_value, year)
                    output_gdp_for_2015_selected[n, 5] = country_exports_value[year] - country_imports_value[year]
                end
            else
                println("Error: ", current_name, " does not fulfill 4.1.5 (b).")
            end
            n = n + 1
        end
    end
end

println("Done! See ya later!")


