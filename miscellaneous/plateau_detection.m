function [flag] = plateau_detection(p,r_th,dur_th)
%find if the breath contains a plateau, output 1 if yes and 0 otherwise
%shift the signal to start from 0
%default: range threshold = 0.02; duration threshold = 10 samples
p = p - p(1);
max_p=max(p);
range_threshold = r_th;
dur_threshold = dur_th;
cutoff = (1-range_threshold)*max_p;
if is_continuous(p>cutoff)
    flag = sum(p>cutoff)>dur_threshold;
else
    flag = 0;
end
% for index = 3:length(p)-2
%     %find the angle of 3 adjacent poitns in radians
%     med_R = median(p(index+2)+p(index+1)+p(index));
%     med_L = median(p(index)+p(index-1)+p(index-2));
%     temp(index-2) = atan((med_R-med_L)/5);
% end
% %convert to degrees
% temp_deg = temp*180/pi;
% %find total number of points where they are considered flat, i.e. 2 degrees
% %plus minus
% total_flat = sum(abs(temp_deg) < 30);
% %if more than half of the points are considered flat, then raise the flag
% flag = total_flat/length(p) > 0.3;
% end