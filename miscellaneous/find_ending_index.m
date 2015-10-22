function [new_index_end] = find_ending_index(new_index_start,len_t_cell,p)
%create the ending indexes
new_index_end = zeros(len_t_cell,1);
for jj = 1:len_t_cell
    %find region where p is greater than each threshold
    abv_th = p > p(new_index_start(jj));
    %find the downhill zero crossings
    downhill_xing = find(diff(abv_th) == -1);
    %find the indexes of xings greater than the index of start
    temp = find(downhill_xing>new_index_start(jj));
    
    %error checking
    if numel(temp)~=0
        %offset
        end_temp = downhill_xing(temp(1));
        if abs(p(end_temp)-p(new_index_start(jj)))<abs(p(end_temp+1)-p(new_index_start(jj)))
            new_index_end(jj) = downhill_xing(temp(1));
        else
            new_index_end(jj) = downhill_xing(temp(1))+1;
        end
    else
        new_index_end(jj) = length(p);
    end   
end