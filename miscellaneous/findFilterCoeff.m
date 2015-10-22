%%
%select the window for wakefulness breaths
clear all
close all
filedir = uigetdir;
cd(filedir);
filetoRead = uigetfile('*.txt'); %get the filename
startTime = input('Start time for the breaths during wakefulness: ');
endTime = input('End Time for the breaths during wakefulness: ');
bias = input('Bias: ');
min_intv = input('Minimum duration of each inspiratory event: '); %default 1
min_area = input('Minimum enclosed area: '); %default 300
addpath('C:\Users\zhid\Documents\Analysis\Codes\FlowLimitation\Saline_Flow\');
importfile(filetoRead); %function to import the file
%find sampling rate: this might bug out if sampling rate is recorded to a different precision
Fs = str2double(colheaders{2}(1:5));
%resample to 40Hz 
data_rs = resample(data,40*100,Fs*100);
numSamples = size(data_rs,1);
startInd = round(startTime*40);
lastInd = round(endTime*40);
time_stamps = startInd:lastInd-1;
count = 0;
%assign data columns to variable names for clarity
% time = linspace(0,numSamples/40,size(data_rs,1))';

nasalP = data_rs(:,2);
%flip the nasalP signal
nasalP = nasalP * (-1)-bias; %correct the bias
nasalPincr = nasalP(startInd:lastInd-1);


    % time = linspace(0,numSamples/40,size(data_rs,1))';
    % plot(time(startInd:lastInd-1),nasalPincr);
    % 
    % %%
%smooth with filter
win_sec = 0.3:0.05:0.6;
% overlap = 0.1:0.1:0.9;
fs = 40;
win_bin = fs * win_sec;
distances = zeros(size(win_sec));
pdfDiff = zeros(size(win_sec));
success_rates = zeros(size(win_sec));
BinNum = 50;


for ii = 1:length(win_sec)
        g = gausswin(win_bin(ii)); % <-- this value determines the width of %the smoothing window
        g = g/sum(g);
        nasalP_gauss = conv(nasalPincr, g, 'same');
        %capture each breath
        stamp_index = (nasalP_gauss > 0);
        dif = stamp_index(2:end)- stamp_index(1:end-1);
        i_start = find(dif == 1); %dif = 1 is transition from neg to pos
        i_end = find(dif == -1); % dif = -1 is transition from pos to neg
            
        %error checking
            %make sure i_start starts is before i_end
            if i_start(1)>i_end(1)
            i_start = i_start(1:end-1);
            i_end = i_end(2:end);
            end
            %filter out the faux data
            [i_start_filt,i_end_filt] = event_capture(nasalP_gauss, i_start, i_end, ...
                40, min_intv, min_area);
            
            %make sure they are of the same length
            index_length = min(length(i_start_filt),length(i_end_filt));
            i_start_filt = i_start_filt(1:index_length);
            i_end_filt = i_end_filt(1:index_length);
            
            

        num_success = 0;% number of success processing of breath
        
        %define a standard
        %gaussian model and later intrapolate the waveforms to it in order
        %to find the co-variance
        [i_ref,p_ref] = Gaussian_gen();
        
        %initiate sum of euclidean distance for each iteration
        dis_sum = 0;
        dpdf = 0;
        for jj = 1:index_length
            %find indices of each breath
            i_breath = i_start_filt(jj):i_end_filt(jj);
            %find each breath - orginial and gaussian
            nasalP_breath = nasalP_gauss(i_breath); 
            nasalP_orig = nasalPincr(i_breath);
                %find difference in pdf
                    BinV = linspace(0,1,BinNum);
                    N1 = hist(nasalP_orig,BinV); N1 = N1/sum(N1);
                    N2 = hist(nasalP_breath,BinV); N2 = N2/sum(N2);
                   dpdf = dpdf + dot(N1-N2, N1-N2)/sqrt(dot(N1,N1)*dot(N2,N2));
            %find the indices of the top half
            i_seg = find(nasalP_breath > 0.5);
            %normalize the signal
            [i_seg_n,nasalP_breath] = normalize_breath(i_seg,nasalP_breath);

            %if continuous, proceed; if not, neglect that breath
            if is_continuous(i_seg)
                nasalP_seg = nasalP_breath(i_seg);            
                nasalP_interp = interp1(i_seg_n,nasalP_seg,i_ref);                
                %compute the euclidean distane betwen the two vectors to find the
                %closeness 
%                 E = sum (nasalP_interp.^2);%compute energy
%                 dis_sum = dis_sum + (pdist2(nasalP_interp,p_ref,'euclidean'))/sqrt(E);
                dis_sum = dis_sum + dot(nasalP_interp-p_ref, nasalP_interp-p_ref)/...
                    sqrt(dot(nasalP_interp,nasalP_interp)*dot(p_ref,p_ref));
                num_success = num_success + 1;
            end    
        end
        distances(ii) = dis_sum/num_success;
        pdfDiff(ii) = dpdf/index_length; %averaged percent difference in pdf
        success_rates(ii) = num_success /index_length;

end

distances = (distances-min(distances))/(max(distances)-min(distances));
pdfDiff = (pdfDiff - min(pdfDiff))/(max(pdfDiff)-min(pdfDiff));
output = [win_sec;distances;pdfDiff;success_rates];


%*************************************************************
% %% proof that the strech results in similar contours
% t = linspace(-10,10,100);x1 = gaussmf(t,[1,0]);plot(t,x1,'r')
% hold on
% x2 = gaussmf(t,[0.5,0]);plot(t,x2,'b')
% x3 = gaussmf(t,[2,0]);plot(t,x3,'c')
% %find the 50% cut-off top region with the boundary and shape
% hline = refline(0,0.5); %plot reference line at 0.5
% set(hline,'Color','k')
% X = [x1;x2;x3];
% X_index = (X>=0.5);
% %%
% t1 = t(find(X_index(1,:)));
% t1_n = (t1 - min(t1))/(max(t1)-min(t1));
% x1_n = x1(find(X_index(1,:)));
% plot(t1_n,x1_n,'g');
% 
% hold on 
% 
% t2 = t(find(X_index(2,:)));
% t2_n = (t2 - min(t2))/(max(t2)-min(t2));
% x2_n = x2(find(X_index(2,:)));
% plot(t2_n,x2_n,'y');
% 
% 
% t3 = t(find(X_index(3,:)));
% t3_n = (t3 - min(t3))/(max(t3)-min(t3));
% x3_n = x3(find(X_index(3,:)));
% plot(t3_n,x3_n,'k');
% %%
% t_new = 0:100:1;
% % X_interp = zeros(3,100);
% X_interp = [interp1(t1_n,x1_n,t_new);...
%     interp1(t2_n,x2_n,t_new);...
%     interp1(t3_n,x3_n,t_new)];
% eval12 = pdist2(X_interp(1,:),X_interp(2,:),'euclidean');
% eval13 = pdist2(X_interp(1,:),X_interp(3,:),'euclidean');


