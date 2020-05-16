u = audioread('orch_str_warm_a.ogg');
% average RIGHT and LEFT channel data for MONO sound
u = (u(:,1) + u(:,2))/2; 
%plot(u);

%apu = audioplayer(u,44100);
%play(apu);


% sine wave example
%Ts=1e-3;
%u=sin(2*pi*3*[0:5000]*Ts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=length(u);
y=zeros(N,1);
for k=100:N
    y(k)=0.99*y(k-99)+0.99*u(k);
end
% for the sine wave example, comment out the next line
y=y/max(abs(y));
%plot(y);

apy = audioplayer(y,44100);
play(apy);