function [metadata] = get_metadata(workbookFile, sheetName, range)
%%% GET_METADATA
% Usage of GET_METADATA.m follows the format: metadata = get_metadata('test_urban11.xlsx');
%
% Metadata is data about the data itself. For example, it consists of location, test
% site, and measurement parameter values. The metadata requires separate
% handling to the RF/IQ data within MATLAB, since it is non-numeric.
% You will need the spreadsheet of measurements to be located in the same
% directory as get_metadata.m. This function performs no error checking.
%
% OJ Norman, 26/3/14.
% 

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If no range is specified, read all data
if nargin <= 2 || isempty(range)
    range = '';
end

fprintf('The measurement file is large. Please wait...\n');

%% Import the data
[~, ~, data] = xlsread(workbookFile, sheetName, range);
data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),data)) = {''};

fprintf('File read-in. Converting...\n');

raw_import = data;
index = find(strcmp(raw_import, '***End_of_Header***'));
metadata = raw_import(1:index,1:2);

clear raw_import;
fprintf('Done.\n');

