% Author: Peter Dranishnikov
% Lab 4
% EEL 4685C Section 01
% Due: February 26th, Spring 2019
%lab 4 part 1a-d
function [result, result_filter] = part1(filename)
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
    %part a
    acc = [0;(-22/15)*((spd(2:1:dat_len) - spd(1:1:dat_len-1)) ./ time_diff)];
    
    subplot(3,1,1);
    plot(time,acc);
    title("Time versus Acceleration");
    xlabel("Time (seconds)");
    ylabel("Acceleration (ft/s^2)");
    
    %part b
    %i'm in dsp
    avg = (1/32).*ones(1,32);
    spd_window = filter(avg, 1, spd);
    acc_filter = [0; (-22/15)*((spd_window(2:1:dat_len) - spd_window(1:1:dat_len-1)) ./ time_diff)];
    subplot(3,1,2);
    plot(time, acc_filter);
    title("Time versus Acceleration, filtered");
    xlabel("Time (seconds)");
    ylabel("Acceleration (ft/s^2)");
    
    %part c
    subplot(3,1,3);
    perdiff = abs((acc - acc_filter)./acc_filter);
    perdiff(~isfinite(perdiff)) = 0;
    plot(time, perdiff);
    title("Time versus Acceleration error");
    xlabel("Time (seconds)");
    ylabel("Error (ft/s^2)");
    
    %part d
    result = acc;
    result_filter = acc_filter;
end