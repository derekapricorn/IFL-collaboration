function [] = timetable ()
%this function looks at all the intervals of the tp.mat files and
%genereates a timetable txt file to contain all the intervals
filedir = uigetdir;
cd(filedir);
fname = dir('*.mat');
list = [];
for jj = 1:length(fname)
    if ~strcmp(fname(jj).name,'event_time.mat')
        load(fname(jj).name);
        list = [list;int16(t(1)),int16(t(end))];
    end
end

T = table(list);
writetable(T,'Timetable.txt','Delimiter',' ')
end