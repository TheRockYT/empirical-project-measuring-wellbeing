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


println("Importing packages...")
try
    using XLSX, DataFrames
catch y
    println("Error: ", y)
    println("Try installing the package XLSX running the install.jl file")
    exit()
end
println("Packages imported successfully")


printAsciiName()

# Include features
include("features/frequency_table.jl")

println("Reading the excel file...")

# Open the excel file
book = XLSX.readxlsx("./Download-GDPcurrent-USD-countries.xlsx")

# Select the sheet
sheet = book["Download-GDPcurrent-USD-countri"]

# Get the data as matrix
data = XLSX.getdata(sheet)

# Coutoff the first 3 rows
df = data[4:end, :]

println("Printing the frequency table... (4.1.1)")

frequency_table_data = printFrequencyTable(df)

# Print the dictionary
display(frequency_table_data)

println("Saving results to output.xlsx...")

# Write the results to a new excel file
XLSX.openxlsx("./output.xlsx", mode="w") do xf
    # 1.1.1
    output_frequency_table = xf[1]
    XLSX.rename!(output_frequency_table, "frequency_table")
    output_frequency_table[1, 1] = "Country"
    output_frequency_table[1, 2] = "Number of years of GDP data"
    # Loop through the dict
    for (i, (country, years)) in enumerate(frequency_table_data)
        output_frequency_table[i+1, 1] = country
        output_frequency_table[i+1, 2] = years
    end
end

println("Done! See ya later!")


