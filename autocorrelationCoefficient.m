function [ rho_ML, numberOfEstimates ] = autocorrelationCoefficient ( signal, sampleRate, T_d, M)
%AUTOCORRELATIONCOEFFICIENT Summary of this function goes here
%  Calculates the ML estimate of the Autocorrelation Coefficient of signal

sampleDuration = T_d * sampleRate;
numberOfBlocks = floor(length(signal) / sampleDuration);
numberOfEstimates = floor(numberOfBlocks / M);


rho_ML = zeros(1,numberOfEstimates);

for estimate = 1:numberOfEstimates
    j_start = 1 + (sampleDuration * M * (estimate-1));
    j_end = (sampleDuration * M * estimate);
%     z1 = unpackComplex(signal(j_start:j_end));
%     z2 = unpackComplex(signal((j_start+sampleDuration):(j_end+sampleDuration)));
    signalPower = 0;
    for t = j_start:(j_end+sampleDuration)
        signalPower = signalPower + (abs(signal(t)))^2;
    end
    signalPower = 1/(2 * sampleDuration * (M+1)) * signalPower;
%     rho_ML(estimate) = (1/(2 * M * sampleDuration) * (z1 * z2'))/signalPower;
    x1 = signal(j_start:j_end)';
    x2 = signal(j_start+sampleDuration:j_end+sampleDuration)';
    x3 = real(x1 * x2');
    rho_ML(estimate) = (x3/(2*M*sampleDuration)) / signalPower;
end

end

