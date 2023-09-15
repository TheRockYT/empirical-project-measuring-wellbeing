function downloadDataFile()
    # Download the file and save it to a temporary path
    tmpfile = Downloads.download("https://unstats.un.org/unsd/amaapi/api/file/2"; progress=show_progress)

    # Rename the file
    mv(tmpfile, config_data_file; force=true)
end

# Define a progress callback function that prints the percentage of completion
function show_progress(total::Integer, now::Integer)
    # Check if the total size is known
    if total > 0
        # Calculate the percentage
        percent = round(100 * now / total; digits=2)
        # Print the progress
        println("Downloaded $percent% of $total bytes")
    else
        # Print the downloaded bytes
        println("Downloading... ($now bytes)")
    end
end

