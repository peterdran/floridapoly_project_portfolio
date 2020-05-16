disp("Part 1:");
syms s z;
sample_freq = 400;
sample_period = 1 / sample_freq; 
disp("The math below is being done symbolically");
transfer_function_s = (6.2832*s) / (s^2 + 6.2832*s + 986.9604)
transfer_function_z = subs(transfer_function_s, s, (2/sample_period)*((z-1)/(z+1)))
[big_x, big_y] = numden(transfer_function_z)
y_coeffs = fliplr(coeffs(big_y));
x_coeffs = fliplr(coeffs(expand(big_x)));
fprintf("The difference equation is: %f y[n] + %f y[n-1] + %f y[n-2] = %f x[n] + %f x[n-2]\n", y_coeffs(1),y_coeffs(2),y_coeffs(3),x_coeffs(1),x_coeffs(2))
fprintf("y[n] = - %f y[n-1] - %f y[n-2] + %f x[n] + %f x[n-2]\n", y_coeffs(2)/y_coeffs(1),y_coeffs(3)/y_coeffs(1),x_coeffs(1)/y_coeffs(1),x_coeffs(2)/y_coeffs(1))
%matlab transfer function
disp("Alternatively, using the tf and c2d commands:");
tf_s = tf([6.2832,0],[1,6.2832,986.9604])
tf_z = c2d(tf_s, sample_period, 'tustin') %tustin is another name for bilinear transform
isstable(tf_z)

disp("Part 2:");
disp("The roots of the denominator of the discrete transfer function are");
y_roots = vpa(roots(y_coeffs))
y_roots = abs(y_roots);
disp("And is the magnitude of the roots less than 1?");
logical(y_roots < 1)
disp("If all above values are true (==1), then the system is BIBO stable");

disp("Part 3:");
%read 10us, write 10us, mult 5us, add 1us, overhead 30us
%fast enough? 
%3 delays, 4 mults, 3 adds, write, read, and overhead
disp("The amount of time to complete all tasks in seconds is:");
completion_time = (10 + 10 + 5*4 + 3 + 30)*10e-6
logical(completion_time < sample_period)

disp("Part 4:");
%Maximum sampling frequency?
disp("The maximum sampling frequency (in Hz) is simply the inverse of the total computation time of the difference equation");
max_freq = 1/completion_time
disp("Since the bilinear transform requires a sample period parameter, the entire transform must be recalculated.");

disp("Part 5:");
disp("A frequency response plot for both transfer functions is being drawn, please wait...");
%plot comparison of continuous and discrete transfer functions over
%frequency, overlapping
syms f;
freqs = linspace(1,20,sample_freq);
freq_resp_s = abs(subs(transfer_function_s, s, j*2*pi*f));
freq_resp_z = abs(subs(transfer_function_z, z, exp(j*2*pi*f*sample_period)));
plot(freqs, subs(freq_resp_s, f, freqs));
hold on;grid on;
plot(freqs, subs(freq_resp_z, f, freqs));
legend("Analog","Digital");
xlabel("Frequency (Hz)");
ylabel("Filter gain (3db)");
