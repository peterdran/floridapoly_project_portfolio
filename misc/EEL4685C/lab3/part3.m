%Author: Peter A. Dranishnikov
%Lab number: 3
%Course number, section: EEL4685C, 01
%Due time, date, semester: February 12th, 17:20, Spring of 2019
%Function for weighted average excluding zero speed values
%Params: time_arr (values, vector), fuel_econ (weights, vector), speed
%(filter/mask, vector)
%Returns a double with the resulting weighted, filtered average
%also displays result to console
function [result] = part3(time_arr, fuel_econ, speed)
    
    time_arr(speed == 0) = [];
    fuel_econ(speed == 0) = [];
    
    result = sum(fuel_econ .* time_arr)/sum(time_arr);
    
    disp(sprintf("The weighted mean of fuel economy considering speed is: %.2f mpg", result));
end