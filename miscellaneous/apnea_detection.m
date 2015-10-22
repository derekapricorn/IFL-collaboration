function [apnea,tot_breath] = apnea_detection(varagin)
%this function detects the apneic breaths and finds percent of FLB
%minimum distance to be 1s by default
min_dist = 1.2;
if nargin~=0
    min_dist = varagin{1};
end
[filename, pathname] = uigetfile('*.mat', 'Pick a segment');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       %initial setup
       cd(pathname);
       load(filename);
       plot(t,p)
       cutoff = input('cutoff = ');
       close(gcf)
       min_sample_dist = 40*min_dist;
       apnea = [];
       
       p_filt = medfilt1(p,10);
       p_inv = -p_filt;
       p_inv = (p_inv>0).*p_inv;
       [~,locs] = findpeaks(p_inv);
       index_retain = find(diff(locs)>min_sample_dist);
       locs = locs(index_retain);
       %         figure %visualizing the points
       %         plot(t,p_filt)
       %         hold on
       %         plot(t(locs),p_filt(locs),'or')
       loc_index = [locs(1:end-1),locs(2:end)];
       for ii = 1:length(locs)-1;
           temp = max(p_filt(loc_index(ii,1):loc_index(ii,2)));
%            ref = max(p_filt(locs(ii)),p_filt(locs(ii+1)));
           if temp < cutoff
              apnea  = [apnea;temp];
           end
       end
       apnea = length(apnea);
       tot_breath = length(locs)-1;
       save(filename,'apnea','tot_breath','-append')
       
    end

    %%
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';
a_count = 0;
tot_count = 0;
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        a_count = a_count + apnea;
        tot_count = tot_count + tot_breath;
    end
end
flb = a_count/tot_count
