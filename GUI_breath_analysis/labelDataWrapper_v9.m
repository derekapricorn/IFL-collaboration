clear
filedir = uigetdir;
cd(filedir);
filetoRead = uigetfile('*.txt'); %get the filename

startTime = input('Please enter the time to start: ');
lightsOffTime = input('Please enter duration of lights off: ') + startTime;

bias = input('Bias: ');
min_intv = input('Minimum duration of each inspiratory event: '); %default 1
min_area = input('Minimum magnitude of inspiration: '); %default 500

addpath('C:\Users\zhid\Documents\Analysis\Codes\FlowLimitation\Saline_Flow\');

importfile(filetoRead); %function to import the file
%find sampling rate: this might bug out if sampling rate is recorded to a different precision
Fs = str2double(colheaders{2}(1:5));
numSamples = size(data,1);
startInd = round(startTime*Fs);
lastInd = round(lightsOffTime*Fs);
count = 0;

%assign data columns to variable names for clarity
time = linspace(0,numSamples*(1/Fs),size(data,1))';
nasalP = data(:,2);

%flip the nasalP signal
nasalP = nasalP * (-1)-bias; %correct the bias
chest = data(:,3);
abdomen = data(:,4);
sum = data(:,5);

%loop through analyze every 1000 data points
incr = 25000; %increment approximately 5 minutes (300 seconds)
           
for ii = startInd:incr:lastInd;
    count = count + 1;
    %Find zero-crossings for each subset - repeat of above but to lazy to
    %figure out indexing
    nasalPincr = nasalP(ii:ii+incr-1); %vector of nasalP window
    nasalP_g = smooth_fn(nasalPincr);
    
    %subtract the offset
    %nasalPincr = nasalPincr - mean(nasalPincr);
    
    nasalPsign =  nasalP_g > 0; %vector of 1s for nasalP > 0 and 0s for nasalP <= 0
    dif = nasalPsign(2:end)- nasalPsign(1:end-1); %find differences to identify transition from 0 to 1
    i_start = find(dif == 1); %dif = 1 is transition from neg to pos
    i_end = find(dif == -1); % dif = -1 is transition from pos to neg
    %error checking
    if i_start(1)>i_end(1)
        i_start = i_start(1:end-1);
        i_end = i_end(2:end);
    end
    %validation of zero-crossings
    [start_stamp, end_stamp] = event_capture(nasalP_g,i_start,i_end,Fs,min_intv,min_area);
    t_start = time(ii) + start_stamp/Fs;
    t_end = time(ii) + end_stamp/Fs;

    %plot 4 subplot - one for each signal on a single figure
%     figure;
%     ax(1)=subplot(2,1,1);
%     plot(time(ii:ii+incr-1),chest(ii:ii+incr-1)) %changed sum to chest
%     ylabel('CHEST','FontWeight','Bold')
%     ax(2)=subplot(2,1,2);
%     plot(time(ii:ii+incr-1),nasalP(ii:ii+incr-1)) %plot nasal pressure
%     ylabel('Nasal P','FontWeight','Bold')
%     linkaxes(ax,'x');

    plot(time(ii:ii+incr-1),nasalPincr,'b') %plot nasal pressure
    ylabel('NasalP orginal','FontWeight','Bold')
   
    hold on
    plot(time(ii:ii+incr-1),nasalP_g,'r','linewidth', 3)
     ylabel('NasalP smoothed','FontWeight','Bold')
     plot(t_start,zeros(size(t_start)),'rx','Color','k') %plot StartP
    plot(t_end,zeros(size(t_end)),'bo','Color','k') %plot EndP
    
    
   
    
    
    hline = refline(0,0); %plot reference line at 0.
    set(hline,'Color','k')
%   ylabel('Nasal P','FontWeight','Bold')
%     set(gca,'YLim',[-1500 1500], 'XLim',[time(ii-100) time(ii+incr-1+100)]);
% title(sprintf('%2.2f,%2.2f',mean(nasalP(ii:ii+incr-1)), mean(nasalP(ii:ii+incr-1))+std(nasalP(ii:ii+incr-1))))
% hold off
    axis tight
    
    
    
   
    
    %export to files
    title_start = strcat(num2str(count),'_start.txt');
    title_end = strcat(num2str(count),'_end.txt');
    dlmwrite(title_start,t_start,'precision', 7)
    dlmwrite(title_end,t_end,'precision', 7)
    
    
%     plot(time(ii:ii+incr-1),chest(ii:ii+incr-1)) %plot chest
%     ylabel('Chest','FontWeight','Bold')
%     hline = refline(0,mean(chest(ii:ii+incr-1))); %plot reference line at 0
%     set(hline,'Color','k')
%     set(gca,'YLim',[-0.4 0.4],'XLim',[time(ii-100) time(ii+incr-1+100)]);
    
    if count < 10
        saveas(gcf,[filetoRead(1:4),'_0',num2str(count)],'fig');
    else
        saveas(gcf,[filetoRead(1:4),'_',num2str(count)],'fig');
    end
   close all 
   
   
end