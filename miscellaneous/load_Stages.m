function [] = load_Stages()
    filetoRead = uigetfile('*.xlsx')
    sheet = 1;
    xlRange = 'C:C';
    xlRange2 = 'D:D';
    time_num = xlsread(filename, sheet, xlRange);
    t_start = datestr(time_num,'HH:MM:SS PM');
    dur = xlsread(filename, sheet, xlRange2);
end


