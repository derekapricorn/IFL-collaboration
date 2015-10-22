afunction [] = stage_finder()
%this is a routine to read the sleep stages in the event.txt file and look 
%for the time intervals for the designated stages within a certain range
%time is all in format of '12:08:56 PM'
%ss = 1:NREM1
%ss = 2:NREM2
%ss = 3:NREM3
%ss = 4:NREM4
%ss = 5:Wake
%ss = 6:not in use

filedir = uigetdir;
cd(filedir);
filetoRead = uigetfile('*.txt'); %get the filename
%get range and sleep stage
% st = input('Start Time:');
% et = input('End time:');
% lot = input('Lights-off time (eg. [12:08:56 PM]):');
ss = input('Sleep Stage:');
%addpath('C:\Users\zhid\Documents\Analysis\Codes\FlowLimitation\Saline_Flow\');

%this is to read the content into matlab
fid = fopen(filetoRead,'rt'); 
indata = textscan(fid, '%u%s%s%d', 'Delimiter', '\t','HeaderLines',14); 
fclose(fid); 
epoch = indata{1};
event = indata{2};
start_time = indata{3};
duration = indata{4};


%find the index of light off time
% count = 1;
% while ~strcmp(event{count},'Lights Off')
%     count = count + 1;
% end
t0 = start_time{1};
%find epoches corresponding to the specified stage
if ss == 1
    match = find(strcmp(event,'Stage 1'));
elseif ss == 2
    match = find(strcmp(event,'Stage 2'));
    %match = find(strcmp(event,'NREM 2')); %Stage 2 is renamed to NREM2 by the new system
elseif ss == 3
     match = find(strcmp(event,'Stage 3'));
elseif ss == 4
     match = find(strcmp(event,'Stage 4'));
elseif ss == 5
     match = find(strcmp(event,'Wake')); 
elseif ss == 6
     match = find(strcmp(event,'NOT IN USE')); 
end
%t_event is [n,2] matrix containing start and end ref time for each
%qualified stage
t_event = zeros(length(match),2);
for ii = 1:length(match)
    t_event(ii,1) = (datenum(start_time{match(ii)})-datenum(t0))*24*60*60;
    if duration(match(ii))~=0
        t_event(ii,2) = t_event(ii,1)+duration(match(ii));
    end
end
t_event = t_event((t_event(:,2)~=0),:);

%load and analyze the related annotations. the files to be read are in .mat
%format. have to make sure the data files are the only .mat files
fname = dir('*.mat');
counter = 0;
tot_counter = 0;
flat_count = 0;
int_count = 0;
for jj = 1:length(fname)
    load(fname(jj).name);
    for kk = 1:length(t_cell)
        temp = t_cell{kk}(1);%take only the start time
        flag = any(temp > t_event(:,1) & temp < t_event(:,2));
        if flag 
            if strcmp(type_cell{kk},'Flattened')
                flat_count = flat_count + 1;    
            elseif strcmp(type_cell{kk},'Intermediate')
                int_count = int_count + 1;
            end
            counter = counter + 1;
        end       
    end
     tot_counter = tot_counter + length(t_cell);
end

sprintf('Among the %d breaths analyzed, %d are in stage %d, %d are flattened, %d are intermediate',tot_counter,counter,ss,flat_count,int_count)


