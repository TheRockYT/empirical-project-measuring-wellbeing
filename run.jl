println("Running the install script...")

# Install the packages
println("Checking / Installing packages...")

# Install packages
import Pkg

# XLSX package for reading excel files
Pkg.add("XLSX")
# DataFrames package for working with data
Pkg.add("DataFrames")
# Plots package for plotting
Pkg.add("Plots")
# Downloads package for downloading files
Pkg.add("Downloads")

println("All packages installed!")

println("Running the main script...")
println()

# Include the main script
include("./main.jl")
