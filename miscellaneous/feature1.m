function feature1 ()
%update the previous dataset
filedir = uigetdir;
cd(filedir);
files = dir( fullfile(filedir,'*.mat'));   %# list all *.xyz files
files = {files.name}';     
for kk = 1:length(files)
    if ~strcmp(files{kk},'event_time.mat')
        load(files{kk}); 
        %find Ti/Ttot
        Ti = t(new_index(:,2))-t(new_index(:,1));
        Ti = Ti(1:end-1);
        Ttot = diff(t(new_index(:,1))); %length decrements by 1
        insp_duty_cycle = Ti./Ttot;
        if ~isempty(insp_duty_cycle)
            save(files{kk},'insp_duty_cycle','-append');
        end
    end
end
        
        
end

               
