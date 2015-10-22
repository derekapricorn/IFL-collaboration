function ned_boxplot()
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
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        if any(index_remove)
            neg_eff_dep(index_remove) = [];
            type_char_updated(index_remove)=[];
        end
        data = [data;neg_eff_dep];
        labels = [labels; type_char_updated];
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