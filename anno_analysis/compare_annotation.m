%Jan 29, 2015
%compare two annoatation results
%SS17
clear
filedir = uigetdir;
cd(filedir);
fname = dir('*.mat');
type_temp = [];
for ii = 1:numel(fname)
   load(fname(ii).name);
   temp = strcmp(type_cell,'Unknown')+2*strcmp(type_cell,'Normal')+...
   3*strcmp(type_cell,'Intermediate')+4*strcmp(type_cell,'Flattened');
   type_temp = [type_temp temp];
end
 t1 = type_temp;
 
filedir = uigetdir;
cd(filedir);
fname = dir('*.mat');
name_list = fname.name;
type_temp = [];
for ii = 1:numel(fname)
   load(fname(ii).name);
   temp = strcmp(type_cell,'Unknown')+2*strcmp(type_cell,'Normal')+...
   3*strcmp(type_cell,'Intermediate')+4*strcmp(type_cell,'Flattened');
   type_temp = [type_temp temp];
end

t2 = type_temp;

sum(t1==t2)/numel(t1)