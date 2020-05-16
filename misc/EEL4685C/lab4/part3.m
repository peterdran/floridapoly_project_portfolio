% Author: Peter Dranishnikov
% Lab 4
% EEL 4685C Section 01
% Due: February 26th, Spring 2019
%lab 4 part 3
function [result, result_2] = part3(filename)
    f = fopen(filename,'r');
    
    junk = fgetl(f);  % remove header line w/o worrying about contents
    % Assume: Time (sec), Accel. Position (%), Boost (PSI), Fuel Economy (MPG), Gear Position (Gear), Engine RPM (RPM),	Vehicle Speed (mph)
    % read file, one data point per row
    data = reshape(fscanf(f,'%f, %f, %f, %f, %d, %d, %d'), 7,[])';
    disp(sprintf('%d data points read', size(data,1)));    %report how many points were read from file
    
    dat_len = length(data);
    spd = data(:,7);
    time = data(:,1);
    time_diff = data(2:dat_len,1)-data(1:dat_len-1,1);
    
    dist_val = cumsum([0;(0.5 .* spd(2:dat_len) + 0.5 .* spd(1:dat_len-1)) .* (time_diff./3600)]);
    
    subplot(2,1,1);
    plot(time, dist_val);
    title("Time versus Distance traveled using measured speed");
    xlabel("Time (seconds)");
    ylabel("Distance (miles)");
    
    %copy and paste from part 2 to meet submission compliance
    gear_ratio = [0, 3.45, 1.95, 1.30, 0.97, 0.78, 0.67]; %add zero in front for easier concat
    rpm = data(:,6);
    gear = data(:,5) + 1;
    filt_spd = spd;
    filt_spd(gear > 1) = 0;
    
    corrected_ratio = gear_ratio(gear)' + filt_spd;
    spd_calc = (rpm .* (60 * pi * 25)) ./ ((5280 * 12 * 4.11) .* corrected_ratio);
    spd_calc(~isfinite(spd_calc)) = 0;
    
    dist_calc = cumsum([0;(0.5 .* spd_calc(2:dat_len) + 0.5 .* spd_calc(1:dat_len-1)) .* (time_diff./3600)]);
    
    subplot(2,1,2);
    plot(time, dist_calc);
    title("Time versus Distance traveled using calculated speed");
    xlabel("Time (seconds)");
    ylabel("Distance (miles)");
    
    result = dist_val;
    result_2 = dist_calc;
end