# This is the Struct for the InputData
struct InputData
    title::String
    years::Array{Int64,1}
    countries::Array{Country,1}
end

# Lets you get a specific country by name
function getCountry(data::InputData, name::String)::Country
    for c in data.countries
        if c.name == name
            return c
        end
    end
    return missing
end