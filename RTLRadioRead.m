function [ outputStream ] = RTLRadioRead( RTLfile )
%RTLRADIOREAD Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(RTLfile,'rb');
outputStream = fread(fid,'uint8=>double');

outputStream = outputStream - 127;
outputStream = outputStream(1:2:end) + (1i * outputStream(2:2:end));
fclose(fid);

end

