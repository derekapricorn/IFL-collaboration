%this script generates the workspace of time and pressure data for
%annotation
filedir = uigetdir;
cd(filedir);
filetoRead = uigetfile('*.txt'); %get the filename
importfile(filetoRead); %function to import the file
Fs = str2double(colheaders{2}(1:5));

bias = input('Bias: ');
min_intv = input('Minimum duration of each inspiratory event: '); %default 1
min_area = input('Minimum enclosed area: '); %default 300
%resample to 40Hz 
data_rs = resample(data,40*100,Fs*100);
numSamples = size(data_rs,1);
%assign data columns to variable names for clarity
time = linspace(0,numSamples/40,size(data_rs,1))';
nasalP = data_rs(:,2);
%flip the nasalP signal 
nasalP = nasalP * (-1)+bias; %correct the bias

load('event_time.mat')
count = 1;
for ii = 1:length(t_event)
    startTime = t_event(ii,1);
    lightsOffTime = t_event(ii,2);%should really just be endTime

    startInd = round(startTime*40);
    %coerce startInd to be 1 in case of starting from 0
    if startInd == 0 
        startInd = 1;
    end
    
    lastInd = round(lightsOffTime*40);

    %Find zero-crossings for each subset - repeat of above but to lazy to
    %figure out indexing
    nasalPincr = nasalP(startInd:lastInd); %vector of nasalP window
    nasalP_g = smooth_fn(nasalPincr,40);

    nasalPsign =  nasalP_g > bias; %vector of 1s for nasalP > 0 and 0s for nasalP <= 0
    dif = nasalPsign(2:end)- nasalPsign(1:end-1); %find differences to identify transition from 0 to 1
    i_start = find(dif == 1); %dif = 1 is transition from neg to pos
    i_end = find(dif == -1); % dif = -1 is transition from pos to neg
    %error checking

    if i_start(1)>i_end(1)
        i_start = i_start(1:end-1);
        i_end = i_end(2:end);
    end
    %validation of zero-crossings
    [start_stamp, end_stamp] = event_capture(nasalP_g,i_start,i_end,40,min_intv,min_area);
    t_start = time(startInd) + start_stamp/40;
    t_end = time(startInd) + end_stamp/40;

    %find individual breath for analysis in GUI
    capture_breath_test2(time(startInd:lastInd),nasalP_g, t_start, t_end, count);
    count = count + 1;
end
clearvars