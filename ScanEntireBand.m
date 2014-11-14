if ismac                                                                    % Detect the platform and set up environment.
    addpath('/Volumes/USB KEY/University/Group Project/Sensing');
    measurementsPath = '/Volumes/USB KEY/University/Group Project/Measurements';
    addpath(measurementsPath);
elseif ispc    
    addpath('E:/University/Group Project/Sensing');
    measurementsPath = 'E:/University/Group Project/Measurements';
    addpath(measurementsPath);
end

channels = 21:59;

symbolDuration = 896e-6;
sampleRate = 2e6;
M = 5000;                                                                   % Length of estimation in OFDM blocks
P_fa = 1e-2;                                                                % Probability of False alarm sets the N-P detection threshold
site = 'university_gate';
timestamp = '141110';

Estimates = zeros(length(channels),1);

threshold = (1/sqrt(M)) * erfcinv(2*P_fa);

for channel = 21:59
    
    filename = strcat(measurementsPath,'/data_usbstick_',site,'/',timestamp,'_rtlcapture_channel',num2str(channel),'.dat');

    signal = RTLRadioRead(filename);
    
    [Estimates(channel,:), numberOfEstimates] = autocorrelationCoefficient(signal, sampleRate, symbolDuration, M);

    for x = 1:numberOfEstimates
        if Estimates(channel,x) > threshold
            detection(channel) = 1;
        else
            detection(channel) = 0;
        end
    end
end

figure;
plot(channels,Estimates(21:59));
figure;
plot(channels,detection(21:59));