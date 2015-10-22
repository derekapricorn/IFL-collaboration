%%
%update the previous dataset
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';                      %'# file names

for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        dp = diff(p);
        %         dt = t(1:end-1); unused
        %slope threshold approach v2
        threshold = 6;
        len_t_cell = length(t_cell);
        orig_index = zeros(len_t_cell,1);
        new_index_start= zeros(len_t_cell,1);
        %find new start index
        for ii = 1:len_t_cell
            t_vec = t_cell{ii}(1);
            ind = find(t==t_vec);%find the original index of inception
            orig_index(ii) = ind;
            
            if dp(ind)<threshold
                i_start = ind;
            else
                i_start = ind-10;
            end
            
            while dp(i_start)<threshold
                i_start = i_start + 1;
            end
            
            new_index_start(ii) = i_start;
        end
        
        %find new end indexes; 
        baseline = p(new_index_start);
        %loop through all the start points
        %create the ending indexes
        new_index_end = zeros(len_t_cell,1);
        for jj = 1:len_t_cell
            %find region where p is greater than each threshold
            abv_th = p > baseline(jj);
            %find the downhill zero crossings
            downhill_xing = find(diff(abv_th) == -1);
            %find the indexes of xings greater than the index of start
            temp = find(downhill_xing>new_index_start(jj));
            if numel(temp)== 0
                %if the last inspiration is not complete, give the end of
                %the signal to be the end of the last inspiration
                new_index_end(jj) = length(p);
            else
                %offset
                new_index_end(jj) = downhill_xing(temp(1))+1;
            end
        end
        %form the indexes containing the start and end indexes of each inspirations
        %updated
        new_index = [new_index_start,new_index_end];
        
        clear 't_cell' 'p_cell';
        save(files{kk},'new_index','t','p','type_cell');
    end
end
%%
%filter the signal
Fstop = 0.01;
Fpass = 0.05;
Astop = 65;
Apass = 0.5;
Fs = 40;

d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
  'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
  'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');
%%
% fvtool(d)
pf = filtfilt(d,p);

dp = diff(pf);
% dt = t(1:end-1);
% ddp = diff(dp);
% ddt = dt(1:end-1);
%fs = 40;
figure
plot(t,pf)
hold on
plot(t,p,'g')
hline = refline(0,0); %plot reference line at 0
set(hline,'Color','k')

%%
%detrend the signal
detrend_p = detrend(p);
plot(t,detrend_p)
hold on
plot(t,p,'g')
%%

%% derivative analysis
% figure
% ha(1)=subplot(3,1,1);
% plot(t,p)
% 
% ha(2)=subplot(3,1,2);
% plot(dt,dp)
% 
% ha(3)=subplot(3,1,3);
% plot(ddt,ddp)
% linkaxes(ha, 'x');

% figure
% plot(t(2000:2500),p(2000:2500))
% figure
% plot(dt(2000:2500),dp(2000:2500))
% figure
% plot(ddt(2000:2500),ddp(2000:2500))
%%
%mean accruement approach
%transcribe the t instances to a vector
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
start_index= zeros(len_t_cell,1);
temp = zeros(20,1);

for ii = 1:len_t_cell
    t_vec = t_cell{ii}(1);
    t_ind = find(t==t_vec);%find the original index of inception: 
    orig_index(ii) = t_ind;
    %forward by 10 samples
    t_ind = t_ind - 20;
    %go through the range of 20 points and find the index of imbanlance of
    %all of them
    for jj = 1:20  
        temp(jj) = calc_imbalance(dt,dp,t_ind+jj);
    end
    start_index(ii) = find(temp==max(temp))+t_ind;
end

figure
plot(t,p)
hold on
plot(t(start_index),p(start_index),'-.or')
plot(t(orig_index),p(orig_index),'-.og')

%%
%derivative approach
%use the max slope as the indicator of inception
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);
for ii = 1:len_t_cell
    t_vec = t_cell{ii}(1);
    ind = find(t==t_vec);%find the original index of inception: 
    orig_index(ii) = ind;
    
    %for one second around the original start
    if ind > 20 && ind < length(p)
        i_start = ind - 20;
        i_end = ind + 20;
    
        %t_index is the reference time for index
        t_seg = dt(i_start:i_end);
        p_seg = dp(i_start:i_end);
        new_index_start(ii) = find(p_seg == max(p_seg))+ind-20;
    else
        new_index_start(ii) = ind;
    end
end

figure
plot(t,p)
hold on
plot(t(orig_index),p(orig_index),'-.og')
plot(t(new_index_start),p(new_index_start),'-.or')
    
%%
%slope threshold approach
threshold = 6;
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);
for ii = 1:len_t_cell
    t_vec = t_cell{ii}(1);
    ind = find(t==t_vec);%find the original index of inception: 
    orig_index(ii) = ind;
     if ind > 10 
        i_start = ind;
        while dp(i_start)<threshold 
            i_start = i_start + 1;
        end
        new_index_start(ii) = i_start;
     else
        new_index_start(ii) = ind;         
    end
 end
figure
plot(t,p)
hold on
plot(t(orig_index),p(orig_index),'-.og')
plot(t(new_index_start),p(new_index_start),'-.or')
%%
%slope threshold approach v2
threshold = 6;
len_t_cell = length(t_cell);  
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);

for ii = 1:len_t_cell
    t_vec = t_cell{ii}(1);
    ind = find(t==t_vec);%find the original index of inception
    orig_index(ii) = ind;

    if dp(ind)<threshold
        i_start = ind;
    else
        i_start = ind-10;
    end
    
    while dp(i_start)<threshold
        i_start = i_start + 1;
    end
    
    new_index_start(ii) = i_start;
end

figure
plot(t,p)
hold on
plot(t(orig_index),p(orig_index),'-.og')
plot(t(new_index_start),p(new_index_start),'-.or')
%%
%find the start and end indexes; start is known
baseline = p(new_index_start);
%loop through all the start points
%create the ending indexes
new_index_end = zeros(len_t_cell,1);
for jj = 1:len_t_cell
    %find region where p is greater than each threshold
    abv_th = p > baseline(jj);
    %find the downhill zero crossings
    downhill_xing = find(diff(abv_th) == -1);
    %find the indexes of xings greater than the index of start
    temp = find(downhill_xing>new_index_start(jj));
    %offset
    new_index_end(jj) = downhill_xing(temp(1))+1;
end
%form the indexes containing the start and end indexes of each inspirations
%updated
new_index = [new_index_start,new_index_end];

% figure
% plot(t,p)
% hold on
% plot(t(new_index_start),p(new_index_start),'-.or')
% plot(t(new_index_end),p(new_index_end),'-.og')

%but there is still some problems with this approach. Because the sampling
%frequency is not high enough, sometimes the end point does not match
%perfectly with the start point

figure
plot(t,p)
hold on
hline = refline(0,0); %plot reference line at 0
set(hline,'Color','k')

plot(t(orig_index),p(orig_index),'-or')

hold on
plot(t(new_index(:,1)),p(new_index(:,1)),'-.or')
plot(t(new_index(:,2)),p(new_index(:,2)),'-.og')

%%
%new method
dp = diff(p);
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);
new_index_start(1) = find(t==t_cell{1}(1));
offset = 1;
r = 1; %compression ratio

    %find new start index
    for ii = 2:len_t_cell
        t_vec = t_cell{ii}(1);
        ind = find(t==t_vec);%find the original index of inception
        orig_index(ii) = ind;%original index of inspiration
        
        p_temp = p_cell{ii};
        dp_temp = diff(p_temp);
        ind_ps = ind + find(dp_temp==max(dp_temp));%index @ peak slope
        
        %assuming ind>10
        segment = ind-10:ind_ps;
        dp_seg = dp(segment);
        min_slope = min(dp_seg);
        ind_ss = find(dp_seg==min_slope);
        if length(ind_ss)>1
            ind_ss = ind_ss(end);
        end
        ind_ss = ind_ss+ind-10+offset;%index @ steady-st slope
        %make sure that the point is within the tolerance range
%         ind_previous = new_index_start(ii-1);
%         if abs(p(ind_ss)-p(ind_previous))<standiv*r
%             ind_ss = ind_ss+ind-10+offset;%index @ steady-st slope
%         elseif p(ind_ss)-p(ind_previous)<-standiv*r
%             while p(ind_ss)<p(ind_previous)-standiv*r
%                 ind_ss = ind_ss + 1;
%             end
%         else
%             while p(ind_ss)>p(ind_previous)+standiv*r
%                 ind_ss = ind_ss - 1;
%             end
%         end       
        new_index_start(ii) = ind_ss;
    end
    
    %find std and use it as feedback
    standiv = std(p(new_index_start))
    
plot(t,p,'b');
hold on
plot(t(new_index_start),p(new_index_start),'-or')
%%
%further decrease the std

dp = diff(p);
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);
new_index_start(1) = find(t==t_cell{1}(1));
offset = 1;
r = 4; %compression ratio

    %find new start index
    for ii = 2:len_t_cell
        t_vec = t_cell{ii}(1);
        ind = find(t==t_vec);%find the original index of inception
        orig_index(ii) = ind;%original index of inspiration
        
        p_temp = p_cell{ii};
        dp_temp = diff(p_temp);
        ind_ps = ind + find(dp_temp==max(dp_temp));%index @ peak slope
        
        %assuming ind>10
        segment = ind-10:ind_ps;
        dp_seg = dp(segment);
        min_slope = min(dp_seg);
        ind_ss = find(dp_seg==min_slope);
        if length(ind_ss)>1
            ind_ss = ind_ss(end);
        end
%       ind_ss = ind_ss+ind-10+offset;%index @ steady-st slope
        %make sure that the point is within the tolerance range
        ind_previous = new_index_start(ii-1);
        if abs(p(ind_ss)-p(ind_previous))<standiv*r
            ind_ss = ind_ss+ind-10+offset;%index @ steady-st slope
        elseif p(ind_ss)-p(ind_previous)<-standiv*r
            while p(ind_ss)<p(ind_previous)-standiv*r
                ind_ss = ind_ss + 1;
            end
        else
            while p(ind_ss)>p(ind_previous)+standiv*r
                ind_ss = ind_ss - 1;
            end
        end       
        new_index_start(ii) = ind_ss;
    end
    
    %find std and use it as feedback
    standiv = std(p(new_index_start))
    
plot(t,p,'b');
hold on
plot(t(new_index_start),p(new_index_start),'-or')

