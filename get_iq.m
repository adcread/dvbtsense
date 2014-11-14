function [IQ] = get_iq(workbookFile, sheetName, range)
%%% GET_IQ
% Usage of GET_IQ.m follows the format: [IQ] = get_iq('test_urban11.xlsx');
%
% You will need the spreadsheet of measurements to be located in the same
% directory as get_iq.m. This function performs no error checking. The
% output from get_iq.m is a matrix that contains frequency information in
% the first row. The columns are I and Q alternately. The rows are samples
% within the same frequency bin. For example, if you had 3 samples within
% the frequency range 470 - 472 MHz, with frequency bins of 1 MHZ, IQ would
% look like:
%
%    470     470    471     471     472     472
%    I1      Q1     I1      Q1      I1      Q1
%    I2      Q2     I2      Q2      I2      Q2
%    I3      Q3     I3      Q3      I3      Q3
%
% Typically, there will be 470 - 790 MHz span of frequency, and more than
% 1000 samples within each frequency bin.
%
% OJ Norman, 26/3/14.


%% Input handling

fprintf('Importing raw data...\n');

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If no range is specified, read all data
if nargin <= 2 || isempty(range)
    range = '';
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, range);

fprintf('Cleaning data...\n');

%% Replace non-numeric cells with 0.0
R = cellfun(@(x) ~isnumeric(x) || isnan(x),raw); % Find non-numeric cells
raw(R) = {0.0}; % Replace non-numeric cells

%% Create output variable
data = cell2mat(raw);

%% Strip off final column (guaranteed to contain empty string)
[M N] = size(data);
data(:,N) = [];

%% Strip off initial rows where headers used to be
[row col] = find(data,1,'first');
row = row - 2;
data(1:row,:) = [];

%% Strip off column of frequencies

N = N - 1;
frequencies = data(:,N);    % Move the frequency column into its own vector
row = find(frequencies,1,'last');
frequencies(row+1:length(frequencies)) = []; % Discard trialing zeroes
n = N - 1;
data(:,n:N) = [];           % Discard the columns where the frequencies used to be.
data = data(:,2:2:end);     % Discard all X_Value columns (junk)

fprintf('Converting data...\n');

%% Re-unite separated I and Q samples.
[M N] = size(data);
n = N/2;
I = data(:,1:n);
n = n + 1;
Q = data(:,n:end);
clear data;

% Interleave I and Q matrices by column
I = I';
Q = Q';
IQ = reshape([I(:) Q(:)]',2*size(I,1), [])';

% % Insert a blank row along the top
% [M N] = size(IQ);
% M = M + 1;
% % iq = zeros(M,N);
iq = zeros(2*length(frequencies));

% Transpose the frequencies and lay them along the top of the IQ matrix
iq(1,1:2:end) = frequencies';
iq(1,2:2:end) = frequencies';
iq_port = iq(1,:);

clear frequencies;
clear I;
clear Q;
clear M;
clear N;
clear n;
clear row;

IQ = [iq_port;IQ];

clear iq_port;

fprintf('Done.\n');
    
% At this point, have matrix structure:
%       470   470   471  471...
%       I1    Q1    I1   Q1
%       I2    Q2    I2   Q2
%       ...   ...   ...  ...
%       until # samples in freqency bin has been reached.



