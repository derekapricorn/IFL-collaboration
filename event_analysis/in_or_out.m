function [ flag ] = in_or_out( t_ref,t_temp )
%This function determiens if the t_temp belongs to t_ref
%flag = 1=>in; flag = 0 => out
%t_ref=[n*2]
%t_temp = [1*2]

cutoff1 = find (t_ref(:,1)<t_temp(1));
cutoff2 = find (t_ref(:,2)>t_temp(2));
if (isempty(cutoff1)||isempty(cutoff2));
    flag = 0;
    return;
end

dur_temp = t_temp(2)-t_temp(1);
pre = cutoff1(end);
post = cutoff2(1);

if pre == post %this is the case where the NIU event is inside the NREM2
    flag = 1;
elseif post - pre == 1
    % this is when NIU collides with post NREM2
    if t_ref(pre,2) < t_temp(1) && (t_temp(2)-t_ref(post,1))>(dur_temp/2) 
        flag = 1;
    % this is when NIU collides with previous NREM2
    elseif t_ref(pre,2) > t_temp(1) && (t_ref(pre,2)-t_temp(1))>(dur_temp/2)
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
    
end

