%feature extraction
load('tp_1')
normal = cell(2,10);
int = cell(2,10);
flattened = cell(2,10);
select = [26,42,43,47,52,53,55,58,61,67; ...
    8,9,10,18,19,20,22,31,40,44; ...
    5,6,32,39,59,77,80,84,85,92];
for ii = 1:10
    normal(1,ii) = t_cell(select(1,ii));
    normal(2,ii) = p_cell(select(1,ii));
    int(1,ii) = t_cell(select(2,ii));
    int(2,ii) = p_cell(select(2,ii));
    flattened(1,ii) = t_cell(select(3,ii));
    flattened(2,ii) = p_cell(select(3,ii));
end
%%
%1.kurtosis
kurt = zeros(30,1);
for ii = 1:10
    kurt(ii) = kurtosis(normal{2,ii});
    kurt(ii+10) = kurtosis(int{2,ii});
    kurt(ii+20) = kurtosis(flattened{2,ii});
end
    
%%
%2.skewness
skew = zeros(30,1);
for ii = 1:10
    skew(ii) = skewness(normal{2,ii});
    skew(ii+10) = skewness(int{2,ii});
    skew(ii+20) = skewness(flattened{2,ii});
end
%%
%3,4,5.tri-segment analysis
[summary] = seg_avg(normal);
temp = 0.5 * max((summary'));
a = summary./[temp',temp',temp'];
n_test = a > 1;
n_test = [n_test(:,1);n_test(:,2);n_test(:,3)];

[summary] = seg_avg(int);
temp = 0.5 * max((summary'));
a = summary./[temp',temp',temp'];
i_test = a > 1;
i_test = [i_test(:,1);i_test(:,2);i_test(:,3)];

[summary] = seg_avg(flattened);
temp = 0.5 * max((summary'));
a = summary./[temp',temp',temp'];
f_test = a > 1;
f_test = [f_test(:,1);f_test(:,2);f_test(:,3)];

%%    
%derivative analysis
%6.number of zero crossings and 7.percentage time in [-10,10]
zxing = zeros(10,3);
pct = zeros(10,3);
for ii = 1:10
    [zxing(ii,1),pct(ii,1)] = deriv(normal{1,ii},normal{2,ii});
    [zxing(ii,2),pct(ii,2)] = deriv(int{1,ii},int{2,ii});
    [zxing(ii,3),pct(ii,3)] = deriv(flattened{1,ii},flattened{2,ii});
end

zxing = [zxing(:,1); zxing(:,2); zxing(:,3)];
pct = [pct(:,1); pct(:,2); pct(:,3)];

%%
%8.duration of each inspiration
dur = zeros(30,1);
for ii = 1:10
    dur(ii) = length(normal{1,ii});
    dur(ii+10)= length(int{1,ii});
    dur(ii+20) = length(flattened{1,ii});
end  


%%
%9. mean
meanV = zeros(30,1);
for ii = 1:10
    meanV(ii) = mean(normal{2,ii});
    meanV(ii+10) = mean(int{2,ii});
    meanV(ii+20) = mean(flattened{2,ii});
end


%%
%10.median
medianV = zeros(30,1);
for ii = 1:10
    medianV(ii) = median(normal{2,ii});
    medianV(ii+10) = median(int{2,ii});
    medianV(ii+20) = median(flattened{2,ii});
end


%%
%11.mode
modeV = zeros(30,1);
for ii = 1:10
    modeV(ii) = mode(normal{2,ii});
    modeV(ii+10) = mode(int{2,ii});
    modeV(ii+20) = mode(flattened{2,ii});
end

%%
%12.variance
varV = zeros(30,1);
for ii = 1:10
    varV(ii) = var(normal{2,ii});
    varV(ii+10) = var(int{2,ii});
    varV(ii+20) = var(flattened{2,ii});
end
    
%%
%13.num of maximas 
peaksV = zeros(30,1);
for ii = 1:10
    peaksV(ii) = length(findpeaks(normal{2,ii}));
    peaksV(ii+10) = length(findpeaks(int{2,ii}));
    peaksV(ii+20) = length(findpeaks(flattened{2,ii}));
end

%%
%14.enclosed area
areaV = zeros(30,1);
for ii = 1:10
    areaV(ii) = sum(normal{2,ii});
    areaV(ii+10) = sum(int{2,ii});
    areaV(ii+20) = sum(flattened{2,ii});
end  


%%
%15.entropy
entrV = zeros(30,1);
for ii = 1:10
    entrV(ii) = entropy(normal{2,ii});
    entrV(ii+10) = entropy(int{2,ii});
    entrV(ii+20) = entropy(flattened{2,ii});
end


%%
%combining all the features
feature_sum = [kurt,skew,n_test,i_test,f_test,zxing,pct,dur,meanV,medianV,modeV,...
    varV,peaksV,areaV,entrV]

%% 
% y = normal{2,1};
% Fs = 40;
% Nsamps = length(y);
% t = (1:Nsamps)/Fs;
% y_fft = abs(fft(y));
% y_fft = y_fft(1:Nsamps/2);
% f = Fs*(0:Nsamps/2-1)/Nsamps; 
% 
% 
% 
% %Plot Sound File in Time Domain
% figure
% plot(t, y)
% xlabel('Time (s)')
% ylabel('Amplitude')
% title('Tuning Fork A4 in Time Domain')
% 
% %Plot Sound File in Frequency Domain
% figure
% plot(f, y_fft)
% xlim([0 1000])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude')
% title('Frequency Response of Tuning Fork A4')
% 
