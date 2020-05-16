%Author: Peter A. Dranishnikov
%Lab number: 3
%Course number, section: EEL4685C, 01
%Due time, date, semester: February 12th, 17:20, Spring of 2019
%Function for per minute averaging with a filter
%Params: values (vector), weights (vector), timestamp (decimal time, in seconds,
%sorted vector), elim_factor (filter, vector)
%Returns a vector of the filtered weighted averages for each minute
%!!!!!!!!!!!!!!1
%NOTICE: if the input data does not have exact points that are evenly
%divisible by 60 or are floating point values, then the buckets may
%over or underextend by some amount of the error
function [result] = part4c(values, weights, timestamp, elim_factor)
    values(elim_factor == 0) = [];
    weights(elim_factor == 0) = [];
    timestamp(elim_factor == 0) = [];
    
    min_divs = mod(timestamp, 60.0) < mean(weights);
    time_vals = round(timestamp(min_divs));
    loc_min_divs = find(min_divs == 1);
    
    result = zeros(length(time_vals),1);
    for i = 2:length(time_vals)
        result(i-1) = sum(values(loc_min_divs(i-1):loc_min_divs(i)) .* weights(loc_min_divs(i-1):loc_min_divs(i))) / sum(weights(loc_min_divs(i-1):loc_min_divs(i)));
    end
end