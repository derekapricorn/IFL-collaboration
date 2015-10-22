% convert types words to letters
% do this before screening
clear all
clc
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';     
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk}); 
        for jj = 1:length(type_cell)
            %keep all the strings to be of the same length
            if strcmp(type_cell{jj},'Intermediate')
                type_cell{jj} = 'I';
            elseif strcmp(type_cell{jj},'Normal')
                type_cell{jj} = 'N';
            elseif strcmp(type_cell{jj},'Flattened')
                type_cell{jj} = 'F';
            elseif strcmp(type_cell{jj},'Unknown')||strcmp(type_cell{jj},'Low signal')
                type_cell{jj} = 'U';
            end
        end
        save(files{kk},'t_cell','p_cell','t','p','type_cell');
    end
    clearvars t_cell p_cell t p type_cell
end

%%
%examine the modified breaths
plot(t,p)
hold on
plot(t(new_index(:,1)),p(new_index(:,1)),'or')
plot(t(new_index(:,2)),p(new_index(:,2)),'og')
%find the indexes of the vertical labels
v_index = round((new_index(:,1)+new_index(:,2))/2);
%find the matching color for each type: normal-g,
%interm-y,flattend-r
color_type = cell(length(type_cell),1);
for counter = 1:length(color_type)
    if strcmp(ned_type(counter),'N')
        color_type{counter} = 'g';
    elseif strcmp(ned_type(counter),'I')
        color_type{counter} = 'm';
    elseif strcmp(ned_type(counter),'F')
        color_type{counter} = 'r';
    else
        color_type{counter} = 'k';
    end
end
% temp = cell(length(color_type),1);
% for ii = 1:length(color_type)
%     temp{ii} = num2str(ii);
% end
vline(t(v_index),color_type);
hold off
%%
%overall workflow
ned_1()
find_type(0.03,0.15)

%display percentage of each type
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat'));   %# list all *.xyz files
files = {files.name}';
n_count = 0;
f_count = 0;
i_count = 0;
tot_count = 0;
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        n_count = n_count + sum(ned_type == 'N');
        i_count = i_count + sum(ned_type == 'I');
        f_count = f_count + sum(ned_type == 'F');
        tot_count = tot_count + length(ned_type)-sum(ned_type == 'U');
    end
end
disp('percentage of normal breaths =')
disp(n_count/tot_count)
disp('percentage of flattened breaths =')
disp(f_count/tot_count)
% disp('total count')
% disp(tot_count)
% disp('f_count')
% disp(f_count)
%%
%plot box plot for the newly generate NED
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat'));   %# list all *.xyz files
files = {files.name}';    
data_ned = [];
data_idc = [];
labels_ned = [];
labels_idc = [];
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        
        index_remove = (ned_type == 'U');
        data_ned = [data_ned;neg_eff_dep(~index_remove)];
        labels_ned = [labels_ned;ned_type(~index_remove)];
        
        index_remove = index_remove(1:end-1);
        ned_type = ned_type(1:end-1);
        data_idc = [data_idc;insp_duty_cycle(~index_remove)];
        labels_idc = [labels_idc;ned_type(~index_remove)];
    end
end

%%
%plot
Label_size = 15;
%used grouporder to arange the order of the boxes
%the labels option let you rename the labels (from group1 to G1)
boxplot(data_ned,labels_ned,'grouporder',{'N','I','F'},'label',{'Normal','Intermediate','Flow-Limited'})
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
%%
%plot box plot for newly genereated Ti/Ttot

% a label for each data point
Label_size = 15;
%used grouporder to arange the order of the boxes
%the labels option let you rename the labels (from group1 to G1)
boxplot(data_idc,labels_idc,'grouporder',{'N','I','F'},'label',{'Normal','Intermediate','Flow-Limited'})
ylim([0,1])
%         xlabel('3 Types','FontSize',Label_size,'FontWeight','bold')
ylabel('Ti/Ttot','FontSize',Label_size,'FontWeight','bold')
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
%         h2 = get(gca, 'XLabel');
%         set(h2,'Position',get(h2,'Position')+[0 -8 0]);
%%
%1 way anova with tukey test
%comparing the NED
find_type(0.03,0.15)

[~,~,stats] = anova1(data_ned,labels_ned,'grouporder',{'F','I','N'})
figure
%Multcompare using HSD Tukey at 5% significance
[c,~,~,gnames] = multcompare(stats,'alpha',0.05,'ctype','hsd');
[gnames(c(:,1)), gnames(c(:,2)), num2cell(c(:,3:6))]

%comparing the IDC
[~,~,stats] = anova1(data_idc,labels_idc)
figure
[c,~,~,gnames] = multcompare(stats,'alpha',0.05,'ctype','hsd');
[gnames(c(:,1)), gnames(c(:,2)), num2cell(c(:,3:6))]

%%
%test the effacacy of the plateau detection algorithm
index_len = size(new_index,1); %find total number of inspirations
flag = zeros(index_len,1);
%neg_eff_span = zeros(index_len,1);
for jj = 1:index_len
    if new_index(jj,2)-new_index(jj,1)~=1 %if the breath isn't invalidated
        p_insp = p(new_index(jj,1):new_index(jj,2)); %airflow of each inspiration
        flag(jj) = plateau_detection(p_insp)
    end
end

%%
%plot the colour bars according to the automatic results
plot(t,p,'LineWidth', 2)
hold on
plot(t(new_index(:,1)),p(new_index(:,1)),'-.or')
plot(t(new_index(:,2)),p(new_index(:,2)),'-.og')

%find the indexes of the vertical labels
v_index = round((new_index(:,1)+new_index(:,2))/2);
%find the matching color for each type: normal-g,
%interm-y,flattend-r
color_type = cell(length(ned_type)-1,1);
for counter = 1:length(ned_type)
    if strcmp(ned_type(counter),'N')
        color_type{counter} = 'g';
    elseif strcmp(ned_type(counter),'I')
        color_type{counter} = 'm';
    elseif strcmp(ned_type(counter),'F')
        color_type{counter} = 'r';
    else
        color_type{counter} = 'k';
    end
end
temp = cell(length(color_type),1);
for ii = 1:length(color_type)
    temp{ii} = num2str(ii);
end
vline(t(v_index),color_type,temp);
hold off
%%
%find difference between the mannual anno vs auto algorithm
manual_anno_types = char(type_cell);
find(manual_anno_types - ned_type<0)
agree_ratio = 1 - sum(manual_anno_types - ned_type<0)/length(type_cell);
disp('agreement ratio is')
disp(num2str(agree_ratio))

%%
clear all
clc
tot_len = 0;
disagreed_items = 0;
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';     
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk}); 
        tot_len = tot_len + length(type_cell);
        disagreed_items = sum(char(type_cell) - ned_type > 0)+disagreed_items;
    end
end
disagree_ratio = disagreed_items/tot_len;
disp('total disagreement ratio is')
disp(num2str(disagree_ratio))
        
%%
%superimpose flow limited breaths
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat'));   %# list all *.xyz files
files = {files.name}';    
p_out = [];
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk});
        for ii = 1:length(type_cell)
            if ned_type(ii) == 'F'
                p_insp = p(new_index(ii,1):new_index(ii,2))';
                vq = interp1(1:length(p_insp),p_insp,linspace(1,length(p_insp),200),'spline');
                p_out = [p_out;vq];
%               t_out = linspace(0,1,length(p_out));
%               plot(t_out,p_out)
%               plot(p_insp)
            end
        end
    end    
end
p_final = mean(p_out,1);
plot(mean(p_out,1))
% this will remove the lines/tick marks
     box off;
     set(gca,'xcolor',get(gcf,'color'));
     set(gca,'xtick',[]);
          box off;
     set(gca,'ycolor',get(gcf,'color'));
     set(gca,'ytick',[]);
            