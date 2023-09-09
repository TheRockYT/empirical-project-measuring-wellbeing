println("Running the install script...")

# Install the packages
println("Checking / Installing packages...")

# Install packages
import Pkg

Pkg.add("XLSX")
Pkg.add("DataFrames")

println("All packages installed!")

println("Running the main script...")
println()

# Include the main script
include("./main.jl")

main()