# This is the Struct for a Country
mutable struct Country
    name::String
    indicators::Array{Indicator,1}

end

# Lets you get a specific indicator by name
function getIndicator(country::Country, name::String)
    for i in country.indicators
         if i.name == name
            return i
         end
    end
    return missing
end