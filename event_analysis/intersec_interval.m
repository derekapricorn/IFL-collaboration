function [ t_out ] = intersec_interval( t_ref,t_niu )
%The function takes two arrays of intervals and finds the intersection of 
%the two intervals
%in:[m*2],[n*2]
%out:[k*2]

temp = [];
for ii = 1:size(t_niu,1)
    if in_or_out(t_ref, t_niu(ii,:))%in_or_out determines if the niu event 
        %is within the NREM2 or not. If half of hte niu is within, then 
        %it is considered an event within NREM2
        temp = [temp;t_niu(ii,:)];
    end
end

t_out = temp;
end