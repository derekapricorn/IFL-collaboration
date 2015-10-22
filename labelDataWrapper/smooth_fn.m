function [nasalP_gauss] = smooth_fn (p,fs)
%smooth using Gaussian filter
%with window size == 0.4s equivalent

win_size = fs * 0.4;
g = gausswin(win_size); % <-- this value determines the width of %the smoothing window
g = g/sum(g);
nasalP_gauss = conv(p, g, 'same');

end


%%
% plot(time(ii:ii+incr-1),nasalPincr,'b') %plot nasal pressure
% ylabel('NasalP orginal','FontWeight','Bold')
% colours = ['y';'m';'c';'r';'g';'w';'k'];
% hold on
% fs = 40;
% for jj = 0.2:0.1:0.8
%         win_size = fs * jj;
%         g = gausswin(win_size); % <-- this value determines the width of %the smoothing window
%         g = g/sum(g);
%         nasalP_gauss = conv(nasalPincr, g, 'same');
%         plot(time(ii:ii+incr-1),nasalP_gauss,colours(int16((jj*10-1))))
%         
% end

 
%%
%smooth using hamming window
% win_size = 64;
% h = hamming(win_size);
% 
% nasalP_ham = conv(nasalP_temp,h,'same');
% plot(time_temp,nasalP_temp,'b',time_temp,nasalP_ham,'g');
% hline = refline(0,0); %plot reference line at 0.
% set(hline,'Color','k')
%     
%time domain filtering
% nasalP_temp = nasalP(ii:ii+incr-1);
% time_temp = time(ii:ii+incr-1);

%%
%smooth with smooth filter: too slow
% nasalP_smooth = smooth(time_temp,nasalP_temp,0.25,'rloess');
% plot(time_temp,nasalP_temp,'b',time_temp,nasalP_smooth,'r');
% 

    
 
% %%
% delay = (win_size - 1)/2;
% index = find(nasalP_avg<0);
% nasalP_avg(index) = 0;
% index = find(temp<0);
% temp(index) = 0;
% % plot(time(ii:ii+incr-1),temp,'b',time(ii:ii+incr-1)-delay/(45),nasalP_avg,'r');
% plot(time(ii:ii+incr-1)-delay/(60),nasalP_avg,'r');
% axis tight
% hline = refline(0,0); %plot reference line at 0.
%     set(hline,'Color','k')
% %%
% %weighted average
% h = [0.5 0.5];
% binomialCoeff = conv(h,h);
% for n = 1:4
%     binomialCoeff = conv(binomialCoeff,h);
% end
% 
% figure
% fDelay = (length(binomialCoeff)-1)/2;
% binomialMA = filter(binomialCoeff, 1, temp);
% plot(time(ii:ii+incr-1), temp, 'b', ...
%      time(ii:ii+incr-1)-fDelay/24,  binomialMA, 'g');
% axis tight;
% 
% 
% time(ii:ii+incr-1),temp,'b',
% 
% %%
% %frequency filtering
% temp = nasalP(ii:ii+incr-1);
% nasalP_temp = downsample(temp, 2);
% time_temp = downsample(time(ii:ii+incr-1),2);
% %plot(time_temp,nasalP_temp)
% %%
% b = fir1(10,0.5);
% nasalP_avg = filter2(b,1,nasalP_temp);
% plot(time_temp,nasalP_temp,'b',time_temp,nasalP_avg,'r');
% axis tight
% hline = refline(0,0); %plot reference line at 0.
%     set(hline,'Color','k')