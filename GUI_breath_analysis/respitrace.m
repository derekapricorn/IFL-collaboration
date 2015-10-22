refunction [t,c,a] = respitrace(filetoRead)
%this function takes the filename of the data textfile and outputs the time
%chest and abdominal movement in form of vectors
%filetoRead = uigetfile('*.txt'); %get the filename
DELIMITER = '\t';
HEADERLINES = 2;

% Import the file
newData1 = importdata(filetoRead, DELIMITER, HEADERLINES);
% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

Fs = str2double(newData1.colheaders{2}(1:5));

%resample to 40Hz 
data_rs = resample(newData1.data,40*100,Fs*100);
numSamples = size(data_rs,1);
%assign data columns to variable names for clarity
time = linspace(0,numSamples/40,size(data_rs,1))';
chest = data_rs(:,3);
abdom = data_rs(:,4);

% startTime = input('type the start time: ');
% endTime = input('type the end time: ');

prompt = {'Enter the start time:','Enter the end time:'};
dlg_title = 'Input';
num_lines = 1;
% def = {'20','hsv'};
answer = inputdlg(prompt,dlg_title,num_lines);
startTime = str2double(answer(1));
endTime = str2double(answer(2));

startInd = round(startTime*40);
lastInd = round(endTime*40);
t = time(startInd:lastInd);
c = chest(startInd:lastInd);
a = abdom(startInd:lastInd);

plot(time(startInd:lastInd),chest(startInd:lastInd),'b',time(startInd:lastInd),abdom(startInd:lastInd),'k')
end
