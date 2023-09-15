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

# Set the default number format
const num_fmt = Ref{Int64}(0)
XLSX.default_cell_format(ws::XLSX.Worksheet, ::Float64) = XLSX.get_num_style_index(ws, num_fmt[])

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