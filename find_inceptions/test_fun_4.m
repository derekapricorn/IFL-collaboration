function [new_index,type_cell] = test_fun_4(t,p,t_cell,p_cell,loop_count,r,t_c)
%new method
dp = diff(p);
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);
new_index_start(1) = find(t==t_cell{1}(1));
offset = 1;
% r = 1; %compression range
count = 1;
standiv = 0;
flag = 0;
while count <= loop_count
    %find new start index
    for ii = 2:len_t_cell
        t_vec = t_cell{ii}(1);
        ind = find(t==t_vec);%find the original index of inception
        orig_index(ii) = ind;%original index of inspiration
        
        p_temp = p_cell{ii};
        dp_temp = diff(p_temp);
        ind_ps = ind + find(dp_temp==max(dp_temp));%index @ peak slope
        
        %assuming ind>10
        segment = ind-10:ind_ps; %find the segment before the peak
        dp_seg = dp(segment); %find the derivative of the segment
        
        %find locations of all the zero crossings
        cross = find((abs(diff(sign(dp_seg)))== 2) | (abs(diff(sign(dp_seg)))== 1)); 
        %if there is no zero crossing, find the inflection point
        if isempty(cross)
            min_abs_slope = min(dp_seg); %find the mim absolute slope
            ind_ss = find(dp_seg==min_abs_slope); %find the loc of this point
            if length(ind_ss)>1
                ind_ss = ind_ss(end);
            end
        else
            %the index of outset should be the last zero crossing point
            ind_ss = cross(end);
        end
        %assume ind_ss
        ind_ss = ind_ss+ind-10+offset;%index @ steady-st slope
        ind_previous = new_index_start(ii-1);
        if flag == 1 && ind_previous < ind_ss;
            %make sure that the point is within the tolerance range
            
            %when point is below the lower bound
            while p(ind_ss)<p(ind_previous)-standiv*r
                ind_ss = ind_ss + 1;
            end
            %when point is above the upper bound
            while p(ind_ss)>p(ind_previous)+standiv*r
                ind_ss = ind_ss - 1;
            end
        end
        new_index_start(ii) = ind_ss;
    end
    
    %find std and use it as feedback
    standiv = std(p(new_index_start));
    count = count + 1;
    flag = 1;
end

% %create the ending indexes
new_index_end = find_ending_index(new_index_start,len_t_cell,p);
%form the indexes containing the start and end indexes of each inspirations
%updated
%guarantee minimum duration; remove the ones that do not meet the requirement
[new_index, type_cell] = gen_new_index(new_index_start,new_index_end,t_c,t,p);

end