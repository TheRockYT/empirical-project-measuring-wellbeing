function printAsciiName()
    # Open the file for reading
    file = open("ascii.txt", "r")

    # Read the contents of the file
    contents = read(file, String)

    # Print the contents to the console
    println(contents)

    # Close the file
    close(file)
end


printAsciiName()

println("Importing packages...")
try
    using XLSX, DataFrames
catch y
    println("Error: ", y)
    println("Try installing the package XLSX running the install.jl file")
    exit()
end
println("Packages imported successfully")

# Include config
include("config.jl")

# Include features
include("features/frequency_table.jl")

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

println("Getting number of countries with missing data from frequency table...")
frequency_table_missing_data = getMissingDataFromFrequencyTable(frequency_table_data, years_of_data)
println("Number of countries with missing data: ", frequency_table_missing_data)

println("Saving results to output.xlsx...")
# Write the results to a new excel file
XLSX.openxlsx(config_output_file, mode="w") do xf
    # 1.1.1
    output_frequency_table = xf[1]
    XLSX.rename!(output_frequency_table, "frequency_table")
    output_frequency_table[1, 1] = "Country"
    output_frequency_table[1, 2] = "Number of years of GDP data"
    # Loop through the dict
    for (i, (country, years)) in enumerate(sort(frequency_table_data, by=x -> x[1]))
        output_frequency_table[i+1, 1] = country
        output_frequency_table[i+1, 2] = years
    end
    # Add number of countries with missing data
    output_frequency_table[1, 4] = "Number of countries with missing data"
    output_frequency_table[2, 4] = string(frequency_table_missing_data, " / ", countries_of_data, " (", round(frequency_table_missing_data / countries_of_data * 100, digits=2), "%)")
end

println("Done! See ya later!")


