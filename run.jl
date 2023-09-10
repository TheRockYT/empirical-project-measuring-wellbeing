println("Running the install script...")

# Install the packages
println("Checking / Installing packages...")

# Install packages
import Pkg

Pkg.add("XLSX")
Pkg.add("DataFrames")
Pkg.add("Plots")

println("All packages installed!")

println("Running the main script...")
println()

# Include the main script
include("./main.jl")
