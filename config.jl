# Do you want to download the data file automatically? This will make requests to external servers.
config_download::Bool = false

# Do you want to update to the latest data file every time you run the script? Requires: config_download = true
config_update::Bool = false

# The path to the data file. Not requried if: config_download = true
config_data_file::String = "./data.xlsx"

# Enable logging of the result into the console
config_output_logging::Bool = false

# Output file for the result
config_output_file::String = "./output.xlsx"