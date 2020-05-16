% This m-file is written as a callable function that accepts the log file's
%  filename as the input, and it has no return value (hence the empty []
% example usage: readdatalog('datalog1.csv')

function [] = readdatalog(filename)  % MUST be the first executable line of code in the file
    % note that MATLAB only cares about the name of the FILE!!!,  the name
    % used in the code above is mostly irrelevant...but PLEASE make them
    % match.

TIME = 1;
GEAR = 5;
RPM = 7;

f = fopen(filename,'r');

junk = fgetl(f);  % remove header line w/o worrying about contents
 % Assume: Time (sec),	Accel. Position (%),	Boost (PSI),	Fuel Economy (MPG),	Gear Position (Gear),	Engine RPM (RPM),	Vehicle Speed (mph)
data = reshape(fscanf(f,'%f, %f, %f, %f, %d, %d, %d'), 7,[])';   % read file, one data point per row
disp(sprintf('%d data points read', size(data,1)));    %report how many points were read from file

% example of a standard x-y line plot
step = 10;   % used to decrease the number of points to plot
subplot(2,1,1)     % two rows of graphs, 1 column of graphs, target graph number 1
plot(data(1:step:end,TIME),data(1:step:end,RPM))  % plotting 100,000+ points takes time, so for speed, only plot each step-th point
% give array of x values, array of y values
title('Speed vs. Sample Time')
xlabel('Time(sec)')
ylabel('Speed (mph)')

% Example of a bar graph 
subplot(2,1,2);  % two rows of graphs, 1 column of graphs, target graph number 2
bar([0:6],hist(data(:,5),7),1.0,'r') % [0:6] labels the x axis 0 through 6, the hist funtion creates 7 bins, exactly matching gears 0-6 (7 values), 1.0 makes the bars 1 unit wide so that
% they touch, 'r' makes the bars red
% Note that this does not account for the amount of time spent in each gear
title('Number of Samples in Each Gear')
xlabel('Gear')
ylabel('Number of Samples')
