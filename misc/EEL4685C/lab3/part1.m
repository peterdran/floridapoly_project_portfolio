%Author: Peter A. Dranishnikov
%Lab number: 3
%Course number, section: EEL4685C, 01
%Due time, date, semester: February 12th, 17:20, Spring of 2019
%Function that accepts the log file's filename as argument
%returns an array containing the data in
%columns: timestamp, elapsed time from previous sample, average of
%continuous readings
%example usage: readdatalog('datalog1.csv')

function [result] = part1(filename)
    
    TIME = 1;
    GEAR = 5;
    RPM = 7;
    
    f = fopen(filename,'r');
    
    junk = fgetl(f);  % remove header line w/o worrying about contents
    % Assume: Time (sec), Accel. Position (%), Boost (PSI), Fuel Economy (MPG), Gear Position (Gear), Engine RPM (RPM),	Vehicle Speed (mph)
    % read file, one data point per row
    data = reshape(fscanf(f,'%f, %f, %f, %f, %d, %d, %d'), 7,[])';
    disp(sprintf('%d data points read', size(data,1)));    %report how many points were read from file
    datalen = size(data, 1);
    result = [data(2:datalen,1), data(2:datalen,1)-data(1:datalen-1,1), (data(2:datalen,2:4)+data(1:datalen-1,2:4))/2, data(2:datalen,5), (data(2:datalen,6:7)+data(1:datalen-1,6:7))/2];
    fclose(f);    
end