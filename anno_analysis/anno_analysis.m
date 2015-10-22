function anno_analysis()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
filedir = uigetdir;
cd(filedir);
load('event_time.mat')
fname = dir('*.mat');
[tot_count,stage_count,flat_count,norm_count,ls_count] = find_count(fname,t_event); 
[~,niu_count,niu_flat_count,niu_norm_count,niu_ls_count] = find_count(fname,t_intersec_event);
sprintf('Among the %d breaths analyzed, %d are in stage specified by event_time, %d are flattened, %d are normal, %d are low signal',tot_count,stage_count,flat_count,norm_count,ls_count)
sprintf('Among the %d in apnea/hypopnea within that stage, %d are flattened and %d are normal,%d are low signal',niu_count,niu_flat_count,niu_norm_count,niu_ls_count)
end

