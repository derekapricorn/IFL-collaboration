function [i_s, i_e, c_s, c_e] = axis3_indexes(t,current,window,t_c,flag)
%find the start and end indexes of the new plot 
%t is the total time(not necessarily 5 minutes); current is the current breath number
%according to the t_cell;window is the length of each window in seconds
%t_c is t_cell; flag is as follows:
%flag = 0, initial plot
%flag = 1, next plot
%flag = -1, previous plot

if flag ==0 %initialization
    ii = 1;
    %find the first window, but the data might be shorter than 30s
    %in case of a short window (<30s)
    if t_c{end}(end) - t_c{1}(1)<30
        temp = find(t >= t_c{end}(end));
        ii = numel(t_c);
    else
        %in case of a long window (>30s)
        while t_c{ii}(end) - t_c{1}(1)< window 
            ii = ii + 1;
        end
        %go back to the last wave in the 30s range
        ii = ii -1;
        temp = find(t >= t_c{ii}(end));
    end
    %specify the indix and counter numbers
    i_e = temp(1);
    temp = find(t >= t_c{1}(1)); %find the start and end indices
    i_s = temp(1);
    c_s = 1;
    c_e = ii;
    
elseif flag ==1 %next plot
    jj = current;
    if jj > numel(t_c)
        ME = MException('This is the end already, try something else');
        throw(ME);
    end
    while t_c{jj}(end)- t_c{current}(1) < window && jj < length(t_c) %while shorter than the window and within the range
        jj = jj + 1;
    end
    temp = find(t >= t_c{current}(1));
    i_s = temp(1);
    temp = find(t >= t_c{jj}(end));
    i_e = temp(1);
    c_s = current;
    c_e = jj;
    
elseif flag == -1 %previous plot
    kk = current;
    while t_c{current}(end) - t_c{kk}(1) < window && kk > 1
        kk = kk - 1;
    end
    temp = find(t >= t_c{kk}(1));
    i_s = temp(1);
    temp = find(t >= t_c{current}(end));
    i_e = temp(1);
    c_e = current;
    c_s = kk;
end
    

end

