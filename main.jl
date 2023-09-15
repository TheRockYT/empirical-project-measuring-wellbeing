# Print the ascii art
include("ascii/ascii.jl")

println("Importing packages...")
try
    using XLSX, DataFrames, Plots
catch y
    println("Error: ", y)
    println("Please re-run the install.jl script, to update the packages")
    exit()
end
println("Packages imported successfully")

println("Loading config...")
# Include config
include("config.jl")

println("Loading data parser...")
# Include data parser
include("data/dataparser.jl")

# Check if the download feature is enabled
if config_download
    config_data_file = "./data.xlsx"
    # Check if the not file exists or update is enabled.
    if config_update || !isfile(config_data_file)
        println("Running the download script...")
        # Start the download of the file
        include("download.jl")
    else
        println("File already exists. Skipping download.")
    end
end

println("Reading the excel file...")
# Open the excel file
book = XLSX.readxlsx(config_data_file)
# Select the sheet
sheet = book["Download-GDPcurrent-USD-countri"]
# Get the data as matrix
data = XLSX.getdata(sheet)

println("Parsing the data...")
parsed_data = parseData(data)
countries = parsed_data.countries
years = parsed_data.years

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
end

println("Done! See ya later!")


