%Answer the questions with proposal and code
%1: Is it possible to use more cycles to make the cross correlation curve smoother,
%and reduce the ambiguity in peak location? 
%2: Is it possible to do multiple measurements and average these measurements? 

%part 1

vals = [5:5:30];
est_sampleDiff = [];
est_phase = [];
for i = vals
    % ADC speed
    Fs=50e6;
    Ts=1/Fs;

    % sine freq
    fo=10e3;
    To=1/fo;

    % number of cycles
    Nc=i;

    % time values
    tv=[0:Ts:Nc*To];

    % Measurement noise max
    AN=1.0;

    % RX signal ampl.
    AR=0.3;

    % Generate the first signal
    x_Tx=sin(2*pi*fo*tv);

    % add some extra zeros
    x_Tx=[x_Tx zeros(1,length(x_Tx))];

    % add some noise
    n1=(AN)*(2*rand(1,length(x_Tx))-1);
    x_Tx=x_Tx+n1;

    % Plot
    figure; clf; hold on;
    plot(x_Tx);
    xlabel('samples');

    % phase shift (degrees)
    diff_phase=20.3;
    ph = diff_phase * pi/180; % deg to radians

    % Generate the second signal
    x_Rx=(AR)*sin(2*pi*fo*tv-ph);

    % add some extra zeros
    x_Rx=[x_Rx zeros(1,length(x_Rx))];

    % add some noise
    n2=(AN)*(2*rand(1,length(x_Rx))-1);
    x_Rx=x_Rx+n2;
    plot(x_Rx);
    xlabel('samples');

    % cross correlation
    [cor,lags]=xcorr(x_Rx, x_Tx);

    % Plot
    figure; clf;
    plot(lags,cor);
    xlabel('shift amount (in samples)');

    % find peak location and corresponding lag
    [mx,ix]=max(cor);
    est_sampleDiff = [est_sampleDiff, (lags(ix))];
    est_phase = [est_phase, (est_sampleDiff * 360 / (Fs/fo))];

end
est_sampleDiff
mean(est_sampleDiff)
est_phase
mean(est_phase)

%part 2

vals = [1:1000:5000]; % a few hours in total
est_sampleDiff = [];
est_phase = [];
for i = vals
    % ADC speed
    Fs=50e6;
    Ts=1/Fs;

    % sine freq
    fo=10e3;
    To=1/fo;

    % number of cycles
    Nc=5;

    % time values
    tv=[0:Ts:Nc*To];

    % Measurement noise max
    AN=1.0;

    % RX signal ampl.
    AR=0.3;

    % Generate the first signal
    x_Tx=sin(2*pi*fo*tv);

    % add some extra zeros
    x_Tx=[x_Tx zeros(1,length(x_Tx))];

    % add some noise
    n1=(AN)*(2*rand(1,length(x_Tx))-1);
    x_Tx=x_Tx+n1;

    % Plot
    figure; clf; hold on;
    plot(x_Tx);
    xlabel('samples');

    % phase shift (degrees)
    diff_phase=20.3;
    ph = diff_phase * pi/180; % deg to radians

    % Generate the second signal
    x_Rx=(AR)*sin(2*pi*fo*tv-ph);

    % add some extra zeros
    x_Rx=[x_Rx zeros(1,length(x_Rx))];

    % add some noise
    n2=(AN)*(2*rand(1,length(x_Rx))-1);
    x_Rx=x_Rx+n2;
    plot(x_Rx);
    xlabel('samples');

    % cross correlation
    [cor,lags]=xcorr(x_Rx, x_Tx);

    % Plot
    figure; clf;
    plot(lags,cor);
    xlabel('shift amount (in samples)');

    % find peak location and corresponding lag
    [mx,ix]=max(cor);
    est_sampleDiff = [est_sampleDiff, (lags(ix))];
    est_phase = [est_phase, (est_sampleDiff * 360 / (Fs/fo))];
    
    pause(i);

end
est_sampleDiff
mean(est_sampleDiff)
est_phase
mean(est_phase)