%Author: Peter A. Dranishnikov
%Lab number: 3
%Course number, section: EEL4685C, 01
%Due time, date, semester: February 12th, 17:20, Spring of 2019
%Function for bounded weighted average 
%Params: values (vector), weights (vector), paramvals (filter, vector),
%bupper (upper bound, numeric), blower (lower bound, numeric)
%Returns a double with the resulting weighted average within the filtered bounds
function [result] = part4a(values, weights, paramvals, bupper, blower)
    
    bool_arr = (paramvals >= bupper) & (paramvals < blower);
    values(bool_arr) = [];
    weights(bool_arr) = [];
    
    result = sum(values .* weights)/sum(weights);
end