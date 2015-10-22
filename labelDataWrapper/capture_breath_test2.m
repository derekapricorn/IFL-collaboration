function [t_cell,p_cell] = capture_breath_test2(t, p, ts, te, c)
%capture each breath event, the onset of which is defined as the point of
%maximum rate of change, within the threshold range for zero flow (20% of
%peak amplitude). The ending is determined as the point with the same value
%of the beginning. 
%Inputs: time, pressure, start times, end times, count number(iteration
%number)

%initialize time cell arrays, row 1 is time, row 2 is pressure
type_cell = cell(1,length(ts));
t_cell = cell(1,length(ts));
p_cell = cell(1,length(ts));
% [PKS_max,LOCS_max] = findpeaks(p,'MinPeakDistance',100,'MinPeakHeight',baseline);
count = 1;
for index = 1:length(ts)
     %for each inspiration, locate the above-bias region
     p_buffer = p((t>ts(index) & t<te(index)) == 1);
     t_buffer = t((t>ts(index) & t<te(index)) == 1);
        
     %check data validity, if theres any value lower than start and end
     %set it to unknown
     min_val = min(p_buffer(1),p_buffer(end));
     if min(p_buffer(2:end-1))<min_val 
         t_cell{index} = t_buffer;
         p_cell{index} = p_buffer;
         type_cell{index} = 'Unknown';
         continue
     end
     
         %find peak index
         ip = find(p_buffer == max(p_buffer));
         %find 2nd derivative
         sec_deriv = diff(p_buffer(1:ip),2);
         %find bending point
         temp = find(sec_deriv >= 0);

         %check if there is a bending point
         if  isempty(temp) || temp(1) == 1 
             is = 1;
             ie = length(p_buffer);         
         else
             %find start index
             is = temp(1);
             %find p value at end      
             ps = p_buffer(is);
             %get second half
             shalf = p_buffer(ip:end);
             %find end index
             [~,ie] = min(abs(shalf - ps));
             ie = ie + ip - 1;
             
             %check if the bending point is higher than 0.5 of peak
             if ps > 0.5 * p_buffer(ip);
                 is = 1;
                 ie = length(p_buffer);  
             end
         end
         
         
         
%     %calculate threshold pressure, assuming threshold range is +-20%
%     p_th = 0.2*p_max;
%     %find the threshold range
%     p_range = p_buffer.*(p_buffer<= p_th);
%     %find the max rate of change
%     diff_range = diff(p_range);
%     %find the index where max slope of the curve occur within the range
%     i_start = find(diff_range == max(diff_range)); 
%     %find the end index
%     p_start = p_range(i_start);
%     %make the start and end be at the same level
%     i_end = find(diff(p_range <= p_start)==1)+1;

    t_cell{index} = t_buffer(is:ie);
    p_cell{index} = p_buffer(is:ie);
    type_cell{index} = 'Unknown';
    count = count + 1;
end

fn = strcat('tp_',num2str(c),'.mat');
save(fn,'t_cell','p_cell','t','p','type_cell');

end

