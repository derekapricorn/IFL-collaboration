function ned_1()
%negative effort dependence
%most obstructive point is defined as the point after peak that has slope
%of zero
%Process all the workspace files in one folder and calculate
%ned for each file; save variable: neg_eff_dep

filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';
k_threshold = 0; %to be defined
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        %find total number of inspirations
        index_len = size(new_index,1);
        neg_eff_dep = zeros(index_len,1);
        %find the floor of peak to rule out apneic breath
        peak_array = 0;
        for ii = 1:index_len
            peak_array = [peak_array max(p_cell{ii})];
        end
        median_peak = median(peak_array);%might bug out if the signal is very noisy
        peak_array = 0;
        
        %neg_eff_span = zeros(index_len,1);
        for jj = 1:index_len
            if new_index(jj,2)-new_index(jj,1)~=1 %if the breath isn't invalidated
                p_insp = p(new_index(jj,1):new_index(jj,2)); %airflow of each inspiration
                %find local maximum and its location
                maximum = max(p_insp);
                max_loc = find(p_insp==maximum);
                %all the peaks associate with each inspiration
                [pks,locs]= findpeaks(p_insp);
                %if the breaths is always below 10% of median peak or there
                %exists a plateau, the ned is coerced to "flattened"
                if maximum < 0.1 * median_peak || plateau_detection(p_insp,0.025,12)
                    neg_eff_dep(jj) = 0.99;
                else
                    if length(pks)==1
                        %if there is only one peak, find point b, if can find
                        %bending point
                        a = locs;
                        p_after_pk = p_insp(a:length(p_insp));
                        k_after_pk = diff(p_after_pk);
                        if max(diff(k_after_pk))>=k_threshold %used second derivative to capture the bending point
                            b = find(k_after_pk == max(k_after_pk))+ a; % b is the potential bending point
                            if b < 0.9 * length(p_insp)
                                neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/(maximum-p_insp(1));
                            else
                                neg_eff_dep(jj) = 0; %if b happens at the last 10% of the breath duration then ignore it
                            end
                        else
                            neg_eff_dep(jj) = 0; %normal breath;
                        end
                    elseif (length(pks)==2)
                        %when there are two peaks, if the first peak is greater
                        %than 30% of max
                        if pks(1)>0.3*maximum
                            a = locs(1);
                            p_after_pk = p_insp(a:length(p_insp));
                            k_after_pk = diff(p_after_pk);
                            temp = find(k_after_pk >=0);
                            b = temp(1)+a;
                            neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/(maximum-p_insp(1)); %ned = drop/peak of flow
                        else%if the first peak is smaller than 30% of the max
                            a = locs(2);
                            p_after_pk = p_insp(a:length(p_insp));
                            k_after_pk = diff(p_after_pk);
                            if max(diff(k_after_pk))>=k_threshold
                                b = find(k_after_pk == max(k_after_pk))+ a;
                                if b < 0.9 * length(p_insp)
                                    neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/(maximum-p_insp(1));
                                else
                                    neg_eff_dep(jj) = 0; %if b happens at the last 10% of the breath duration then ignore it
                                end
                            else
                                neg_eff_dep(jj) = 0; %normal breath;
                            end
                        end
                    elseif length(pks)==3
                        %if all peaks are greater than 70% max, then it's
                        %flattened
%                         if all(pks>0.7*maximum)|| find(pks==maximum)==3
                        if all(pks>0.7*maximum)
                            neg_eff_dep(jj) = 0.99;%ned = 0.99 if the three peaks are all greater than 70% of max
                        else
                            a = locs((pks==maximum));
                            p_after_pk = p_insp(a:length(p_insp));
                            k_after_pk = diff(p_after_pk);
                            temp = find(k_after_pk >=0);
                            if isempty(temp)
                                neg_eff_dep(jj) = NaN;
                            else
                                b = temp(1)+a;
                                if b < 0.9 * length(p_insp)
                                    neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/(maximum-p_insp(1));
                                else
                                neg_eff_dep(jj) = 0; %if b happens at the last 10% of the breath duration then ignore it
                                end
                            end
                        end
                    else
                        neg_eff_dep(jj)=NaN;%ned = NaN if the point is unknown or invalidated
                    end                    
                end
            else
                neg_eff_dep(jj)=NaN; %if the breath is invalidated
        end
        save(files{kk},'neg_eff_dep','-append');
    end
end
end

%         %so at this point i can find all the ned for that tp file
%         %next thing to do is stacking up the data
%         type_char = char(type_cell);
%         
%         %combine all the outlier indexes
%         index_remove = find(neg_eff_dep == 3 | neg_eff_dep == 4 |(strcmp(type_cell,'U'))');
%         lower_cutoff = 0.05;
%         upper_cutoff = 0.25;
%         for ii = 1:length(type_char)
%             if strcmp(type_char(ii),'I')
%                 if neg_eff_dep(ii) <= lower_cutoff
%                     type_char(ii) = 'N';
%                 elseif neg_eff_dep(ii) < 1 && neg_eff_dep(ii)>upper_cutoff
%                     type_char(ii) = 'F';
%                 end
%             end
%         end
%         type_char_updated = type_char;
%         save(files{kk},'neg_eff_dep','type_char_updated','index_remove','-append');
%     end


        