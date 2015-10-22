function feature1 ()
%update the previous dataset
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
files = {files.name}';     
feature1 = [];
type_cell_char = [];
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk}); 
        
        %find Ti/Ttot
        Ti = t(new_index(:,2))-t(new_index(:,1));
        Ti = Ti(1:end-1);
        Ttot = diff(t(new_index(:,1)));
        temp1 = Ti./Ttot;
       
        %convert to char array      
        temp2 = char(type_cell);
        temp2 = temp2(1:end-1,:);
         
        %remove the unknown entries
        index_unknown = find(strcmp(type_cell,'Unknown'));
                   
        if any(index_unknown)
            if index_unknown(end) == length(type_cell)
                index_unknown = index_unknown(1:end-1);
            end
            temp1(index_unknown)=[];
            temp2(index_unknown,:)=[];
        end
        
        if ~isempty(temp2)
            feature1 = [feature1; temp1];
            type_cell_char = [type_cell_char; temp2];
        end
    end
end
        %boxplot
        boxplot(feature1,type_cell_char)
        size(feature1)
end
%%
% convert intermediate to interm 
% clear all
% clc
% filedir = uigetdir;
% cd(filedir);
% files = dir( fullfile(filedir,'*.mat') );   %# list all *.xyz files
% files = {files.name}';     
% for kk = 1:length(files)
%     if ~strcmp(files{kk},'event_time.mat')
%         load(files{kk}); 
%         for jj = 1:length(type_cell)
%             %keep all the strings to be of the same length
%             if strcmp(type_cell{jj},'Intermediate')
%                 type_cell{jj} = 'I';
%             elseif strcmp(type_cell{jj},'Normal')
%                 type_cell{jj} = 'N';
%             elseif strcmp(type_cell{jj},'Unknown')
%                 type_cell{jj} = 'U';
%             elseif strcmp(type_cell{jj},'Flattened')
%                 type_cell{jj} = 'F';
%             end
%         end
%         save(files{kk},'new_index','t_cell','p_cell','t','p','type_cell','loop_count','r');
%     end
% end

               
