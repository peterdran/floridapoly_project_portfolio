% Plot of x(t)=cos(3t) for t between 0 and 5

% we need to choose some small dt value for computer generated plots
dt=1e-4;
% final time value
tf=5;

% computations and plots
t=[0:dt:tf];
x=cos(3*t);
figure(1);
plot(t,x);
grid;
xlabel('time (sec)');

% Now, we sample x(t)=cos(3t) for t between 0 and 5 
%
% We choose the sampling period as 0.1 sec, i.e. 
%    in every 0.1 sec we make a new measurement
% 
% The plot of our measurements will be

Ts=0.1;
n=[0:round(tf/Ts)];
t=n*Ts;
xd=cos(3*t);
figure(2);
stem(n,xd);
grid;
xlabel('n (measurement index/number)');


