function [ z] = GNURadioRead( filename )
%GNURADIOREAD Reads in binary sample files from GNURadio's file sink
%   Reads I/Q samples from GNUradio's file sink data format into a complex
%   vector.

fid = fopen(filename);

v = fread(fid, 'float32');

fclose(fid);

N = length(v)/2;

a = zeros(1,N);
b = zeros(1,N);

for n = 0:N-1
    a(n+1) = v(1+2*n);
    b(n+1) = v(2+2*n);
end

z = complex(a,b);

end
