%Author: Peter A. Dranishnikov
%Lab number: 3
%Course number, section: EEL4685C, 01
%Due time, date, semester: February 12th, 17:20, Spring of 2019
%Function for weighted average of fuel econ and time difference
%returns a double of the resulting weighted average of the inputs
%also displays result to console
function [result] = part2(time_arr, fuel_econ)
    
    result = sum(fuel_econ .* time_arr)/sum(time_arr);
    
    disp(sprintf("The weighted mean of fuel economy is: %.2f mpg", result));
end