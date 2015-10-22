function [ ref, ylim ] = find_pk_ref_new(filedir)
%This function finds the top miu+2std (3%) of the peak inspiratory signal 
%from the designated subject as the reference for later annotation. and 
%miu+std (84%) is used for the reference line

%filedir = uigetdir;
cd(filedir);
fname = dir('*.mat');
maximas = [];
%find all the maximas throughout all the study
for jj = 1:length(fname)
    if ~strcmp(fname(jj).name,'event_time.mat')
        load(fname(jj).name);
        for kk = 1:length(type_cell)
          maximas = [maximas;max(p(new_index(kk,1):new_index(kk,2)))];
%            maximas = [maximas;max(p_cell{kk})]; original
        end
    end
end
%if not normal distribution, transform the distribution to be normal and
%find the corresponding ref and ylim
if adtest(maximas)
    s = 1;
    rank = rank_transform(maximas);
    %regress through the error epsilon
    ref = NaN;
    ylim = NaN;
    e = 0.0001;
    while isnan(ref*ylim)
        ref = mean(maximas(find(abs(rank)<e)));%ref to be mu+1std
        ylim = mean(maximas(find(abs(rank-2*s)<e)));%ylim to be mu+2std
        e = e * 10;
    end
else
    [mu,s,~,~] = normfit(maximas,100);
    %reduce the cut-off to mu*0.1
    ref = mu;
    ylim = mu+2*s;
end

end
%%
% implement this filtering script so that any peak that's lower than 10% of
% the reference peak will be denied

% pk_ref = 1031.3;
% fname = dir('*.mat');
% count = 0;
% for jj = 1:length(fname)
%     load(fname(jj).name);
%      for kk = 1:length(p_cell)
%          if max(p_cell{kk})  < 0.1*pk_ref && ~strcmp(type_cell{kk},'Unknown')
%              fname(jj).name;
%              type_cell{kk} = 'Low signal';
%              count = count + 1;
%          end         
%      end
%      fn = strcat('tp_',num2str(jj),'.mat');
%      save(fn,'t_cell','p_cell','t','p','type_cell');
% end
% count
