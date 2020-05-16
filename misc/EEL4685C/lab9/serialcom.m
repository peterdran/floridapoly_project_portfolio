%Modified from assignment provided sources: 
%Author of modifications: Peter A. Dranishnikov
%Lab #: 9
%Course: EEL4685C
%Due date: April 23, Spring 2019


% SPEC:
% MATLAB must graph the X, Y, and Z components on a graph that updates in
% real time and displays (up to) the last 100 samples.
% Hint: serial ISR can grow an array unitl it reaches 100 samples, then it
% can use last 99 samples and newest sample for the next one. 
% The x-axis must be labeled with the number of samples
% (first_sample-last_sample)
clear all;
% You will need to change the number of the COM port to match the
% USB-to-Serial cable
%comport = 'COM4';
comport = '/dev/ttyUSB0'; %linux version
instrreset;
figure;

%graph setup


% This *should* set up the COM port the same way it was in PuTTY. 
sp = serial(comport);
% After the serial port object is created, you can click on it in the
% Workspace window, and MATLAB will show a configuration screen. This is a
% good way to see all the fields that can be modified.
sp.baudrate= 115200;
sp.databits=8;
sp.FlowControl = 'none';
sp.StopBits = 1.0;
sp.ReadAsyncMode = 'continuous';
sp.BytesAvailableFcn = @readport;  % This sets up an interrupt in MATLAB for receiving bytes on the serial port.
%  The @ symbol states that you are supply the name of the function.
sp.BytesAvailableFcnCount = 24;
sp.BytesAvailableFcnMode = 'byte';




fopen(sp);

char = '0';
% This is the main loop that repeats "forever"...or until the serial port
% dies.
while (sp.Status == 'open')
    fprintf(sp,char);
    if (char == '9')
        char = '0';
    else
        char = char+1;
    end
    pause(1);
end

% MATLAB allows multiple interrupts to call the same function. Normally,
% there are no arguments to an interrupt service routine, but since MATLAB
% is running on top of the OS and doesn't have direct access to the
% hardware, it cheats a little by passing a reference to the object that
% generated the interrupt and the type of interrupt that was triggered.
% Therefore, in the ISR below, "port" is a reference to the serial port
% object sp above. Note that this also allows the same ISR to be used for
% multiple devices (i.e. different serial ports could all point to this
% ISR.)
function readport(port,b)
% for a serial port, fread requires the handle to the serial port  and the
% number of bytes to read. The char() function converts the numerical bytes
% to integers.
    
    persistent da_plotx;
    persistent da_ploty;
    persistent da_plotz;
    persistent n_arr;
    
    
    if(isempty(n_arr)|n_arr < 1)

        da_plotx = animatedline('Color', 'red');
        da_ploty = animatedline('Color', 'blue');
        da_plotz = animatedline('Color', 'green');
        legend({'X-vector','Y-vector','Z-vector'});
        axis([0 100 -1.5 1.5])
        xlabel("Sample number");
        ylabel("Acceleration (g's)");
        
    end
    
    data = char(fread(port,24));
    x_val = str2double(data(1:7));
    y_val = str2double(data(9:15));
    z_val = str2double(data(17:23));
    
    if(isempty(n_arr) | isnan(n_arr))
        n_arr = [1];
    else
        n_arr = n_arr + 1;
    end
    
    addpoints(da_plotx, n_arr, x_val);
    addpoints(da_ploty, n_arr, y_val);
    da_plotz.addpoints(n_arr, z_val);
    
    if(n_arr > 100)
        axis([(n_arr-100) n_arr -1.5 1.5]);
    end
    drawnow();
    
    % Comment out the line above and enable the line below to see the difference that char() makes. 
    %data = dec2hex(fread(port,3))
    
end
