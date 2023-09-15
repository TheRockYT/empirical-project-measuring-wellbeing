# Print the ascii art
include("ascii/ascii.jl")

println("Importing packages...")
try
    using XLSX, DataFrames, Plots
catch y
    println("Error: ", y)
    println("Please re-run the run.jl script, to update the packages")
    exit()
end
println("Packages imported successfully")

# Include config
include("config.jl")

# Include features
include("features/frequency_table.jl")

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

# Get the number of countries
println("Getting countries of data...")
countries_of_data = getCountriesOfData(data)
println("The input contains data for ", countries_of_data, " countries")

# Get the number of years in the data
println("Getting years of data...")
years_of_data = getYearsOfData(data)
println("The input contains data for ", years_of_data, " years")

# Get the frequency table
println("Generating frequency table... (4.1.1)")
frequency_table_data = generateFrequencyTable(data)
if config_output_logging
    # Print the dictionary
    display(frequency_table_data)
end

println("Getting number of countries with data over the entire period from frequency table...")
frequency_table_countries_with_data = getCountriesWithDataFromFrequencyTable(frequency_table_data, years_of_data)
println("Number of countries with data over the entire period: ", frequency_table_countries_with_data)

println("Saving results to output.xlsx...")
# Write the results to a new excel file
XLSX.openxlsx(config_output_file, mode="w") do xf
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
    # Loop through the dict
    for (i, (country, years)) in enumerate(sort(frequency_table_data, by=x -> x[1]))
        output_frequency_table[i+1, 1] = country
        output_frequency_table[i+1, 2] = years
    end
    # Add number of countries with data over the entire period
    output_frequency_table[1, 4] = "Number of countries with data for the entire period"
    output_frequency_table[2, 4] = string(frequency_table_countries_with_data, " / ", countries_of_data, " (", round(frequency_table_countries_with_data / countries_of_data * 100, digits=2), "%)")
end

println("Done! See ya later!")


