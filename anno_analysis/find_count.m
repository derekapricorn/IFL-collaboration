function [tot_count,stage_count,flat_count,norm_count,low_signal_count] = find_count( fname, t_event )
%the function accepts an array of filenames of files under the same format;
%and outputs the total breath numbers, the numbers in specified stage and
%the number of flattened breaths within that stage
%input:[filename, t_event:n*2 doubles]
tot_count = 0;
stage_count = 0;
flat_count = 0;
low_signal_count = 0;
norm_count = 0;
if ~isempty(t_event)
    for jj = 1:length(fname)
        if ~strcmp(fname(jj).name,'event_time.mat')
            load(fname(jj).name);
            for kk = 1:length(t_cell)
                temp = t_cell{kk}(1);%take only the start time
                %check if the breath under analysis is in the stage of interest
                flag = any(temp > t_event(:,1) & temp < t_event(:,2));
                if flag 
                    if strcmp(type_cell{kk},'Flattened')
                        flat_count = flat_count + 1;    
                    elseif strcmp(type_cell{kk},'Normal')
                        norm_count = norm_count + 1;
                    elseif strcmp(type_cell{kk},'Low signal')
                        low_signal_count = low_signal_count + 1;
                    elseif strcmp(type_cell{kk},'Unknown') %in case of Unknown, neglect the breath

                    %in newer version e.g. ss26 the name has to be changed
                    %elseif strcmp(type_cell{kk},'Obstructive Hypopnea w/ Arousal')
                        %

                        tot_count = tot_count - 1;
                        stage_count = stage_count -1;
                    end
                    stage_count = stage_count + 1;
                end       
             end
             tot_count = tot_count + length(t_cell);
        end
    end
end
    

end

