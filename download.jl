println("Starting Downloader...")
println("Importing downloads package...")
try
    using Downloads
catch y
    println("Error: ", y)
    println("Please re-run the install.jl script, to update the packages")
    exit()
end

# Define a progress callback function that prints the percentage of completion
function show_progress(total::Integer, now::Integer)
    # Check if the total size is known
    if total > 0
        # Calculate the percentage
        percent = round(100 * now / total; digits=2)
        # Print the progress
        println("Downloaded $now of $total bytes ($percent%)")
    else
        # Print the downloaded bytes
        println("Downloading... ($now bytes)")
    end
end

println("Downloading the file...")
# Download the file and save it to a temporary path
tmpfile = Downloads.download("https://unstats.un.org/unsd/amaapi/api/file/2"; progress=show_progress)

# Rename the file
mv(tmpfile, "./data.xlsx"; force=true)
println("Download complete!")



