function [ t_out,p_out ] = zero_pad(t_in,p_in,win_size,flag)
%This function takes the input t and p and flag(specifying if incrementing
%or decrementing. If necessary, i.e. the axis3 display is less than 30s, it
%zero-pads the remaining gaps so to make the plot look consistent
%flag = 1, going forward, thus pad the ends
%flag = -1, going backwards, thus pad the heads

%calculate the number of zeros to be filled
if (win_size*40) ~= numel(t_in);
    if flag == 1 
        t_end = t_in(1)+win_size;
        p_end = 0;
        t_out = [t_in; t_end];
        p_out = [p_in; p_end];
    else
        t_start = t_in(end) - win_size;
        p_start = 0;
        t_out = [t_start; t_in];
        p_out = [p_start; p_in];
    end 
else
    t_out = t_in;
    p_out = p_in;
end

