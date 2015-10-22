function find_type(lower_cutoff, upper_cutoff)
%negative effort dependence
%most obstructive point is defined as the point after peak that has slope
%of zero
%Process all the workspace files in one folder and calculate
%ned for each file; save variable: neg_eff_dep

filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        ned_type = [];
        for ii = 1:length(type_cell)
%             %if the breath was previously marked as 
%             if type_cell{ii} == 'U'
%                 ned_type = [ned_type;'U'];
%             else
            if neg_eff_dep(ii) <= lower_cutoff
                ned_type = [ned_type;'N'];
            elseif neg_eff_dep(ii) <= upper_cutoff
                ned_type = [ned_type;'I'];
            elseif neg_eff_dep(ii) < 1
                ned_type = [ned_type;'F'];
            else %neg_eff_dep(ii) == 3
                ned_type = [ned_type;'U'];
            end
%             end
        end
        save(files{kk},'ned_type','-append');
    end    
end
end