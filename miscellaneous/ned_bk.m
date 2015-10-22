function [output] = ned()
%negative effort dependence
%most obstructive point is defined as the point after peak that has slope
%of zero
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';   
k_threshold = 0; %to be defined
data = [];
% data_span = [];
labels = [];
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')&&~strcmp(files{kk},'results.mat')
        load(files{kk});
        index_len = size(new_index,1); %find total number of inspirations
        neg_eff_dep = zeros(index_len,1);
%         neg_eff_span = zeros(index_len,1);
        for jj = 1:index_len
            if new_index(jj,2)-new_index(jj,1)~=1 %if the breath isn't invalidated
                p_insp = p(new_index(jj,1):new_index(jj,2)); %airflow of each inspiration
                %find local maximum and its location
                maximum = max(p_insp);
                max_loc = find(p_insp==maximum);
                %all the peaks associate with each inspiration
                [pks,locs]= findpeaks(p_insp);
                if length(pks)==1
                    %if there is only one peak, find point b, if possible
                    a = locs;
                    p_after_pk = p_insp(a:length(p_insp));
                    k_after_pk = diff(p_after_pk);
                    if max(diff(k_after_pk))>=k_threshold
                        b = find(k_after_pk == max(k_after_pk))+ a;
                        neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/p_insp(a);
%                         neg_eff_span(jj) = (b - a)/length(p_insp);
                    else
                        neg_eff_dep(jj) = 0; %normal breath; neg_eff_span is zero by default
                    end
                    %             elseif find(pks==maximum)==1 %if the first peak is the maximum
                elseif (length(pks)==2)&&(pks(1)>0.5*maximum)
                    a = locs(1);
                    p_after_pk = p_insp(a:length(p_insp));
                    k_after_pk = diff(p_after_pk);
                    temp = find(k_after_pk >=0);
                    b = temp(1)+a;
                    neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/p_insp(a);
%                     neg_eff_span(jj) = (b - a)/length(p_insp);
                elseif length(pks)==3
                    if (pks(1)>0.5*maximum)
                        a = locs(1);
                    else
                        a = locs(2);
                    end
                    p_after_pk = p_insp(a:length(p_insp));
                    k_after_pk = diff(p_after_pk);
                    temp = find(k_after_pk >=0); 
                    b = temp(1)+a;
                    neg_eff_dep(jj) = (p_insp(a)-p_insp(b))/p_insp(a);
%                     neg_eff_span(jj) = (b - a)/length(p_insp);
                else
                    neg_eff_dep(jj) = 3; %intermediate or abnormal case
%                     neg_eff_span(jj) = 3;
                end
            else
                neg_eff_dep(jj) = 4; %if the point is unknown or invalidated 
%                 neg_eff_span(jj) = 4;
            end
        end
        %so at this point i can find all the ned for that tp file
        %next thing to do is stacking up the data 
        type_char = char(type_cell);
        
        %combine all the outlier indexes
        index_remove = find(neg_eff_dep == 3 | neg_eff_dep == 4 |(strcmp(type_cell,'U'))');
        
        if any(index_remove)
            neg_eff_dep(index_remove) = [];
%             neg_eff_span(index_remove) = [];
            type_char(index_remove)=[];
        end
        
        data = [data;neg_eff_dep];
%         data_span = [data_span;neg_eff_span];
        labels = [labels; type_char];
        

    end
end  
    %plot boxplot
    Label_size = 15;
    %used grouporder to arange the order of the boxes
    %the labels option let you rename the labels (from group1 to G1)
    size(data,1)
    boxplot(data,labels,'grouporder',{'N','I','F'},'label',{'Normal','Intermediate','Flow-Limited'})
%     boxplot(data_span,labels,'grouporder',{'N','I','F'},'label',{'Normal','Intermediate','Flow-Limited'})
    ylim([0,1])
    %         xlabel('3 Types','FontSize',Label_size,'FontWeight','bold')
    ylabel('NED','FontSize',Label_size,'FontWeight','bold')
    %         title('3 Types - Boxplot','FontSize',Label_size,'FontWeight','bold')    
    h = findobj(gca, 'type', 'text');
    % this alters Yticklabels [0 to 1]
    set(gca,'FontSize',Label_size);
    set(gca,'FontWeight','bold')
    % this alters the group labels: G1, G2, G3
    set(h,'FontSize',Label_size);
    set(h,'Interpreter','tex');
    set(h,'FontWeight','bold')
    % this moves the groups labels and the Xlabel down to avoid overlap
    for j=1:length(h)
        set(h(j),'Position',get(h(j),'Position')+[0 -10 0]);
    end
end