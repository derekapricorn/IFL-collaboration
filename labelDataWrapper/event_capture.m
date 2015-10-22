function [startP, endP] = event_capture(y, i_start, i_end, Fs, interval, threshold)
%Screen for the potential valid individual breath contour
startP = [];
endP = [];
sum = 0;
for ii=1:min(length(i_start),length(i_end))
    if (i_end(ii) - i_start(ii)) > Fs * interval
            for jj = i_start(ii):i_end(ii)
                sum = sum + y(jj);
            end
            if sum >= threshold
                startP = [startP;i_start(ii)];
                endP = [endP;i_end(ii)];
            end
            sum = 0;
     end
end
end


            
