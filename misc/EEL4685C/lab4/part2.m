% Author: Peter Dranishnikov
% Lab 4
% EEL 4685C Section 01
% Due: February 26th, Spring 2019
%lab 4 part 2
function [result] = part2(filename)
    f = fopen(filename,'r');
    
    junk = fgetl(f);  % remove header line w/o worrying about contents
    % Assume: Time (sec), Accel. Position (%), Boost (PSI), Fuel Economy (MPG), Gear Position (Gear), Engine RPM (RPM),	Vehicle Speed (mph)
    % read file, one data point per row
    data = reshape(fscanf(f,'%f, %f, %f, %f, %d, %d, %d'), 7,[])';
    disp(sprintf('%d data points read', size(data,1)));    %report how many points were read from file
        
    spd = data(:,7);
    time = data(:,1);
    gear_ratio = [0, 3.45, 1.95, 1.30, 0.97, 0.78, 0.67]; %add zero in front for easier concat
    rpm = data(:,6);
    gear = data(:,5) + 1;
    filt_spd = spd;
    filt_spd(gear > 1) = 0;
    
    corrected_ratio = gear_ratio(gear)' + filt_spd;
    
    spd_calc = (rpm .* (60 * pi * 25)) ./ ((5280 * 12 * 4.11) .* corrected_ratio);
    spd_calc(~isfinite(spd_calc)) = 0;
    
    spd_diff = spd_calc - spd;
    
    subplot(3,1,1);
    plot(time, spd);
    title("Time versus Speed, raw values");
    xlabel("Time (seconds)");
    ylabel("Speed (mph)");
    
    subplot(3,1,2);
    plot(time, spd_calc);
    title("Time versus Speed, calculated values");
    xlabel("Time (seconds)");
    ylabel("Speed (mph)");
    
    subplot(3,1,3);
    plot(time, spd_diff);
    title("Time versus Speed error difference");
    xlabel("Time (seconds)");
    ylabel("Error (mph)");
    
    result = spd_calc;
end