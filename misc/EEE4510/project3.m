fo_vals = [20, 400, 1800, 5500, 10000];
n_vals = [10, 20];
for i = fo_vals
    % DDS project
    fs=44100;
    Ts=1/fs;
    signal_duration=2;
    kval=[0:signal_duration*fs];
    tval=kval*Ts;
    %fo=20001.8;
    fo=i; %20, 400, 1800, 5500, 10000
    % table
    ta = [-1 1];
    % alpha = fo/(fs/2)
    alpha = fo/(fs/2);
    % (-1)^POWER formula
    xdds=(-1).^round(alpha*kval);

    % Table/array based formula
    xdds1=ta(1 + mod(round(alpha*kval),2));

    % Integer arithmetic based formula
    % alpha = M/2^N
    for j = n_vals
        N=j;
        M=round(2^N*alpha);
        xdds2=ta(1 + mod(round((M/2^N)*kval),2));

        %sound(xdds, fs);

        figure; clf; hold on;
        xdds1=xdds1-mean(xdds1);
        plot(linspace(-fs/2,fs/2,length(xdds1)),abs(fftshift(fft(xdds1))),'b-')
        xdds2=xdds2-mean(xdds2);
        plot(linspace(-fs/2,fs/2,length(xdds2)),abs(fftshift(fft(xdds2))),'r-')
        xlabel('Freq');
        legend('Floating point','N-bit integer');
    end
end
