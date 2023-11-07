# This is the Struct for an Indicator of a Country
mutable struct Indicator
    name::String
    values::Dict{Int64,Float64}
end
function getPeakYear(indicator::Indicator)
    peak_year = missing
    peak_value = missing
    for (year, value) in indicator.values
        if ismissing(peak_year) || value > peak_value
            peak_year = year
            peak_value = value
        end
    end
    return peak_year
end
function getBaseYear(indicator::Indicator)
    base_year = missing
    base_value = missing
    for (year, value) in indicator.values
        if ismissing(base_year) || value < base_value
            base_year = year
            base_value = value
        end
    end
    return base_year
end