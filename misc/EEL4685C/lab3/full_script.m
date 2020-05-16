%Author: Peter A. Dranishnikov
%Lab number: 3
%Course number, section: EEL4685C, 01
%Due time, date, semester: February 12th, 17:20, Spring of 2019
%This script runs all parts of the lab assignment over all datalogs provided
for i = [1:7]
    %Part 1-3
    data = part1(sprintf('datalog%d.csv',i));
    part2(data(:,2), data(:,5));
    part3(data(:,2), data(:,5), data(:,8));
    %Part 4 start here
    %4a
    figure;
    subplot(2,1,1);
    gen_arr = [0:5:100];
    groups = zeros(length(gen_arr)-1,1);
    for i = 1:length(gen_arr)-1
        groups(i) = part4a(data(:,5), data(:,2), data(:,8), gen_arr(i), gen_arr(i+1));
    end
    gen_arr(gen_arr == 100) = [];%remove unused category (>=100 mph)
    bar(gen_arr, groups);
    title("Weighted mean of fuel economy per speed category");
    xlabel("Speed (mph, buckets of unit 5)");
    ylabel("Weighted mean of Fuel economy (mpg)");
    %4b
    subplot(2,2,3);
    minutes = part4b(data(:,5), data(:,2), data(:,1));
    bar(minutes);
    title("Weighted mean of fuel economy per minute category");
    xlabel("Time (minutes, buckets of unit 1)");
    ylabel("Weighted mean of Fuel economy (mpg)");
    %4c
    subplot(2,2,4); %assignment says lower left, but so does the previous part, so lower right is what's left
    speeding = part4c(data(:,5), data(:,2), data(:,1), data(:,8));
    bar(speeding);
    title("Weighted mean of fuel economy per minute category considering speed");
    xlabel("Time (minutes, buckets of unit 1)");
    ylabel("Weighted mean of Fuel economy (mpg)");
end
