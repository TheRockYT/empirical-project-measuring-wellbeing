println("Running the install script...")

# Install the packages
println("Checking / Installing packages...")

# Include the install script
include("./install.jl")

println("All packages installed!")

println("Running the main script...")
println()

# Include the main script
include("./main.jl")
