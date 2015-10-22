function [output_vec,type_cell] = gen_new_index(start_vec,end_vec,t_c,t,p)
%generate a [n*2) matrix consisting the start and end indexes for the new
%zero-xings
outlier3 = [];
outlier4 = [];
outlier5 = [];
outlier6 = [];
outlier_sum = [];
count_ascending = 0;
count_overlapping = 0;
count_threshold = 0;
%check if is ascending
if ~(issorted(start_vec)&&issorted(end_vec))
%     warndlg('Warning: data not sorted!!')
    outlier1 = find(diff(start_vec)<0)+1;
    outlier2 = find(diff(end_vec)<0)+1;
    outlier3 = mergesorted(outlier1,outlier2);
    count_ascending = length(outlier3);
end
%check no overlapping between ins and exp
outlier4 = find((start_vec(2:end)-end_vec(1:end-1))<0);
if any(outlier4)
%     warndlg('Warning: overlapping inspiration and expiration!!')
count_overlapping = length(outlier4);
end

%minimum duration: 1s used as threshold; any pairs less apart are removed
threshold = 1;
outlier5 = find(t(end_vec)-t(start_vec)<threshold);
if any(outlier5)
%     warndlg('Warning: min duration exeeds 1s!!')
count_threshold = length(outlier5);
end

%newly implemented feature
%check the start is indeed the lowest pressure point 
%leave a 10-sample margin in case P_end is lower than P_start
for ii = 1:length(start_vec)
    if min(p(start_vec(ii)+1:end_vec(ii)-10))<p(start_vec(ii))
        outlier6 = [outlier6 ii];
    end
end

%find the indexs with errors
outlier_sum = mergesorted(mergesorted(mergesorted(outlier3,outlier4),outlier5),outlier6);

if any(outlier_sum)
    %chop off the duplicates and last entry
    [~,index] = unique(outlier_sum,'first');        %# Capture the index, ignore the actual values
    outlier_sum = outlier_sum(sort(index));
    end_vec(outlier_sum) = start_vec(outlier_sum)+1;
    for ii = 1:length(outlier_sum)
        t_c{outlier_sum(ii)} = 'U';
    end
end
type_cell = t_c;
output_vec = [start_vec end_vec];
disp('ascending error/overlapping error/duration error:')
[count_ascending,count_overlapping,count_threshold]
end
