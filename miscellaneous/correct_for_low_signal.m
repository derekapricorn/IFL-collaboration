filedir = uigetdir;
cd(filedir);
[ref, ~] = find_pk_ref(filedir);
fname = dir('*.mat');
for jj = 1:length(fname)
    if ~strcmp(fname(jj).name,'event_time.mat')
         load(fname(jj).name);
         for kk = 1:length(p_cell)
             if (max(p_cell{kk})<ref*0.1)&&(~strcmp(type_cell{kk},'Unknown'))
%                if (max(p_cell{kk})<ref*0.1)&&(strcmp(type_cell{kk},'Low signal'))
                 type_cell{kk} = 'Low signal';
             end
         end
         save(fname(jj).name,'t_cell','p_cell','t','p','type_cell');
    end
end
clearvars