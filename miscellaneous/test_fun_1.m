function test_fun_2()
%new method
dp = diff(p);
len_t_cell = length(t_cell);
orig_index = zeros(len_t_cell,1);
new_index_start= zeros(len_t_cell,1);
new_index_start(1) = find(t==t_cell{1}(1));
offset = 1;
r = 1; %compression ratio
count = 1;
standiv = 0;

while (standiv>1 || count == 1) && count < 5
    %find new start index
    for ii = 2:len_t_cell
        t_vec = t_cell{ii}(1);
        ind = find(t==t_vec);%find the original index of inception
        orig_index(ii) = ind;%original index of inspiration
        
        p_temp = p_cell{ii};
        dp_temp = diff(p_temp);
        ind_ps = ind + find(dp_temp==max(dp_temp));%index @ peak slope
        
        %assuming ind>10
        segment = ind-10:ind_ps;
        dp_seg = dp(segment);
        min_slope = min(dp_seg);
        ind_ss = find(dp_seg==min_slope);
        if length(ind_ss)>1
            ind_ss = ind_ss(end);
        end
        
        %make sure that the point is within the tolerance range
        ind_previous = new_index_start(ii-1);
        if abs(p(ind_ss)-p(ind_previous))<standiv*r
            ind_ss = ind_ss+ind-10+offset;%index @ steady-st slope
        elseif p(ind_ss)-p(ind_previous)<-standiv*r
            while p(ind_ss)<p(ind_previous)-standiv*r
                ind_ss = ind_ss + 1;
            end
        else
            while p(ind_ss)>p(ind_previous)+standiv*r
                ind_ss = ind_ss - 1;
            end
        end
        new_index_start(ii) = ind_ss;
    end
    
    %find std and use it as feedback
    standiv = std(p(new_index_start));
    count = count + 1;
end

plot(t,p,'b');
hold on
plot(t(new_index_start),p(new_index_start),'-or')

end