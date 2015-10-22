function test_fun()

%update the previous dataset
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';%'# file names

for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        dp = diff(p);
        %manually chooose the first 3 cutoff slope threshold
        figure
        plot(t,p)
        hold on
        hline = refline(0,0); %plot reference line at 0
        set(hline,'Color','k')
        %temporarily halt execution to allow creation of three new
        %variables    
        halt_off = input('continue?');
        
        ind_1 = find(t==start_1(1));
        ind_2 = find(t==start_2(1));
        ind_3 = find(t==start_3(1));
        
        slope = mean([dp(ind_1),dp(ind_2),dp(ind_3)]);
        baseline = mean([p(ind_1),p(ind_2),p(ind_3)]);
        stdiv = std([p(ind_1),p(ind_2),p(ind_3)]);
        n = 2; %broadth coefficient
        range = [baseline-n*stdiv,baseline+n*stdiv];
        
            len_t_cell = length(t_cell);
            orig_index = zeros(len_t_cell,1);
            new_index_start= zeros(len_t_cell,1);
            
            fifo_1 = ind_1;
            fifo_2 = ind_2;
            fifo_3 = ind_3;
            
            %find new start index
            for ii = 1:len_t_cell
                t_vec = t_cell{ii}(1);
                ind = find(t==t_vec);%find the original index of inception
                orig_index(ii) = ind;

                %make sure that the point falls within the range
                %if the point is below the range
                if p(ind) < range(1)
                    
                    while p(ind) < range(1) && ind<length(p)-1
                        ind = ind + 1;
                    end
                    
                    while dp(ind) < slope && ind<length(p)-1
                        ind = ind + 1;
                    end
                %if the point is above the range
                elseif p(ind) > range(2)
                    
                    while p(ind) > range(2) && ind>1
                        ind = ind - 1;
                    end
                    
                    while p(ind) > slope && ind>1;
                        ind = ind - 1;
                    end
                %if the point is within the range    
                else
                    if dp(ind) > slope && ind > 1
                        ind = ind - 1;
                    elseif ind<length(p)-1
                        ind = ind + 1; 
                    end                    
                end
                
%                 
%                     fifo_1 = fifo_2;
%                     fifo_2 = fifo_3;
%                     fifo_3 = ind;
%                     
%                     slope = mean([dp(fifo_1),dp(fifo_2),dp(fifo_3)]);
%                     baseline = mean([p(fifo_1),p(fifo_2),p(fifo_3)]);
%                     stdiv = std([p(fifo_1),p(fifo_2),p(fifo_3)]);

                    slope = grad_des(slope, dp(ind), 0.5);
                    baseline = grad_des(baseline, p(ind), 0.5);
                    

                  
            
%                 if ind > 10 && dp(ind)>slope
%                     i_start = ind - 10;
%                 else
%                     i_start = ind;
%                 end
% 
%                 while dp(i_start)<threshold && i_start < length(p)-1
%                     i_start = i_start + 1;
%                 end

                new_index_start(ii) = ind;
            end

            %find new end indexes; 
%             baseline = p(new_index_start);
            %loop through all the start points
            %create the ending indexes
            new_index_end = zeros(len_t_cell,1);
            for jj = 1:len_t_cell
                %find region where p is greater than each threshold
                abv_th = p > baseline;
                %find the downhill zero crossings
                downhill_xing = find(diff(abv_th) == -1);
                %find the indexes of xings greater than the index of start
                temp = find(downhill_xing>new_index_start(jj));
                if numel(temp)== 0
                    %if the last inspiration is not complete, give the end of
                    %the signal to be the end of the last inspiration
                    new_index_end(jj) = length(p);
                else
                    %offset
                    new_index_end(jj) = downhill_xing(temp(1))+1;
                end
            end
            %form the indexes containing the start and end indexes of each inspirations
            %updated
            new_index = [new_index_start,new_index_end];
%             count = int8((threshold-4)*10+1);
%             var_table(count,:) = var(p(new_index));
    end
            save(files{kk},'t_cell','new_index','t','p','type_cell');
    end
    
end

