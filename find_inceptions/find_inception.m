function varargout = find_inception(varargin)
% FIND_INCEPTION MATLAB code for find_inception.fig
%      FIND_INCEPTION, by itself, creates a new FIND_INCEPTION or raises the existing
%      singleton*.
%
%      H = FIND_INCEPTION returns the handle to a new FIND_INCEPTION or the handle to
%      the existing singleton*.
%
%      FIND_INCEPTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIND_INCEPTION.M with the given input arguments.
%
%      FIND_INCEPTION('Property','Value',...) creates a new FIND_INCEPTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before find_inception_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to find_inception_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help find_inception

% Last Modified by GUIDE v2.5 22-Jun-2015 17:51:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @find_inception_OpeningFcn, ...
                   'gui_OutputFcn',  @find_inception_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before find_inception is made visible.
function find_inception_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to find_inception (see VARARGIN)

% Choose default command line output for find_inception
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using find_inception.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes find_inception wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = find_inception_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S= handles.S;
if handles.update_flag%update the fixes
    new_index = handles.new_index;
    for ii = 1:size(handles.list_update,1)
        if handles.list_update(ii,2)==0
            S.type_cell{handles.list_update(ii,1)} = 'Unknown';
            %bring the two poitns together so that we know they are dealt
            %with
            new_index(handles.list_update(ii,1),2) = new_index(handles.list_update(ii,1),1)+1;
        else
            new_index(handles.list_update(ii,1),:) = [handles.list_update(ii,2) handles.list_update(ii,3)];
        end
    end
    handles.new_index = new_index;
    handles.type_cell = S.type_cell;
    handles.update_flag = 0;
    handles.list_update = 0;
end
axes(handles.axes1);
plot(S.t,S.p)
hold on
plot(S.t(handles.new_index(:,1)),S.p(handles.new_index(:,1)),'-.or')
plot(S.t(handles.new_index(:,2)),S.p(handles.new_index(:,2)),'-.og')

v_index = round((handles.new_index(:,1)+handles.new_index(:,2))/2);
%find the matching color for each type: normal-g,
%interm-y,flattend-r
color_type = cell(length(S.type_cell)-1,1);
for counter = 1:length(color_type)
    if strcmp(S.type_cell{counter},'N')
        color_type{counter} = 'g';
    elseif strcmp(S.type_cell{counter},'I')
        color_type{counter} = 'm';
    elseif strcmp(S.type_cell{counter},'F')
        color_type{counter} = 'r';
    else 
        color_type{counter} = 'k';
    end
    num_type(counter) = text(S.t(v_index(counter)),0,num2str(counter));
end
vline(S.t(v_index),color_type)
set(num_type(:),'fontw','bold','fonts',12)
hold off
guidata(hObject, handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_value = get(handles.slider1,'Value');
r = 2.5*slider_value + 0.5;
handles.r = r;
set(handles.text4,'String',r);

%update figure
S = handles.S;
[new_index,t_c] = test_fun_4(S.t,S.p,S.t_cell,S.p_cell,handles.loop_count,handles.r,handles.type_cell);
handles.type_cell = t_c;
handles.new_index = new_index;
%plot new_index if there is
axes(handles.axes1);
plot(S.t,S.p)
hold on
plot(S.t(handles.new_index(:,1)),S.p(handles.new_index(:,1)),'-.or')
plot(S.t(handles.new_index(:,2)),S.p(handles.new_index(:,2)),'-.og')

v_index = round((handles.new_index(:,1)+handles.new_index(:,2))/2);
%find the matching color for each type: normal-g,
%interm-y,flattend-r
color_type = cell(length(S.type_cell)-1,1);
for counter = 1:length(color_type)
    if strcmp(S.type_cell{counter},'N')
        color_type{counter} = 'g';
    elseif strcmp(S.type_cell{counter},'I')
        color_type{counter} = 'm';
    elseif strcmp(S.type_cell{counter},'F')
        color_type{counter} = 'r';
    else 
        color_type{counter} = 'k';
    end
    num_type(counter) = text(S.t(v_index(counter)),0,num2str(counter));
end
vline(S.t(v_index),color_type)
set(num_type(:),'fontw','bold','fonts',12)
hold off

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_value = get(handles.slider2,'Value');
loop_count = 4*slider_value + 1;
handles.loop_count = loop_count;
set(handles.text5,'String',loop_count);

%update figure
S = handles.S;
[new_index,t_c] = test_fun_4(S.t,S.p,S.t_cell,S.p_cell,handles.loop_count,handles.r,handles.type_cell);
handles.new_index = new_index;
handles.type_cell = t_c;
%plot new_index if there is
axes(handles.axes1);
plot(S.t,S.p)
hold on
plot(S.t(handles.new_index(:,1)),S.p(handles.new_index(:,1)),'-.or')
plot(S.t(handles.new_index(:,2)),S.p(handles.new_index(:,2)),'-.og')

v_index = round((handles.new_index(:,1)+handles.new_index(:,2))/2);
%find the matching color for each type: normal-g,
%interm-y,flattend-r
color_type = cell(length(S.type_cell)-1,1);
for counter = 1:length(color_type)
    if strcmp(S.type_cell{counter},'N')
        color_type{counter} = 'g';
    elseif strcmp(S.type_cell{counter},'I')
        color_type{counter} = 'm';
    elseif strcmp(S.type_cell{counter},'F')
        color_type{counter} = 'r';
    else
        color_type{counter} = 'k';
    end
    num_type(counter) = text(S.t(v_index(counter)),0,num2str(counter));
end
vline(S.t(v_index),color_type)
set(num_type(:),'fontw','bold','fonts',12)
hold off

guidata(hObject,handles);
  
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Pick a segment');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       %initial setup
       cd(pathname);
       S = load(filename);
       handles.S = S;
       handles.filename = filename;
       %setting default
       handles.loop_count = 2;
       set(handles.slider2,'Value',0.25);
       set(handles.text5,'String',handles.loop_count);
       handles.r = 2;
       set(handles.slider1,'Value',0.6);
       set(handles.text4,'String',handles.r);
       set(handles.edit5, 'String', handles.filename);  
       handles.update_flag = 0;       
       %setting new_index
       handles.type_cell = S.type_cell;
       if ~isfield(S,'new_index')
            [new_index,t_c] = test_fun_4(S.t,S.p,S.t_cell,S.p_cell,handles.loop_count,handles.r,handles.type_cell);
            handles.new_index = new_index;
            handles.type_cell = t_c;
       else
           handles.new_index = S.new_index;
           handles.loop_count = S.loop_count;
           handles.r = S.r;           
       end       
       %plot new_index if there is
       axes(handles.axes1);
       plot(S.t,S.p)
       hold on
       plot(S.t(handles.new_index(:,1)),S.p(handles.new_index(:,1)),'-.or')
       plot(S.t(handles.new_index(:,2)),S.p(handles.new_index(:,2)),'-.og')
       
       %find the indexes of the vertical labels
       v_index = round((handles.new_index(:,1)+handles.new_index(:,2))/2);
       %find the matching color for each type: normal-g,
       %interm-y,flattend-r
%        color_type = cell(length(S.type_cell)-1,1);
       color_type = cell(length(S.type_cell),1);
%        num_type = char(length(color_type));
       for counter = 1:length(color_type)
           if strcmp(S.type_cell{counter},'N')
               color_type{counter} = 'g';
           elseif strcmp(S.type_cell{counter},'I')
               color_type{counter} = 'm';
           elseif strcmp(S.type_cell{counter},'F')
               color_type{counter} = 'r';
           else 
               color_type{counter} = 'k';
           end
           num_type(counter) = text(S.t(v_index(counter)),0,num2str(counter));
       end
%        temp = cell(length(color_type),1);
%        for ii = 1:length(color_type)
%            temp{ii} = num2str(ii);
%        end
       vline(S.t(v_index),color_type);
       %plot the numbers for the inspirations
       set(num_type(:),'fontw','bold','fonts',12)
       hold off  

    dcmObj = datacursormode;  %# Turn on data cursors and return the
                          %#   data cursor mode object
    set(dcmObj,'UpdateFcn',@NewCallback);  %# Set the data cursor mode object update
end                                     %#   function so it uses updateFcn.m
guidata(hObject, handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.S;
new_index = handles.new_index;
t = S.t;
p = S.p;
type_cell = handles.type_cell;
t_cell = S.t_cell;
p_cell = S.p_cell;
loop_count = handles.loop_count;
r = handles.r;
save(handles.filename,'new_index','t_cell','p_cell','t','p','type_cell','loop_count','r');
guidata(hObject, handles);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
orig_time = get(handles.edit3,'String');
target_time = get(handles.edit4,'String');
orig_time = str2double(orig_time);
target_time = str2double(target_time);
  
S = handles.S;
%find the index of the index which corresponds to the original time
%instance: i_i
temp = find(S.t > orig_time);
orig_index = temp(1);
difference = abs(handles.new_index(:,1)-orig_index);
i_i = find(difference==min(difference));

%find the time start
if target_time ~= 0   
    %error checking
    if abs(target_time-orig_time)>1
        warndlg('Warning: Wrong Entry!!')
    end
    temp = find(S.t > target_time);
    target_start = temp(1);
    %find target_end
    abv_th = S.p > S.p(target_start);
    %find the downhill zero crossings
    downhill_xing = find(diff(abv_th) == -1);
    %find the indexes of xings greater than the index of start
    temp = find(downhill_xing>target_start);
    %error checking
    if numel(temp)~=0
        %offset
        end_temp = downhill_xing(temp(1));
        if abs(S.p(end_temp)-S.p(target_start))<abs(S.p(end_temp+1)-S.p(target_start))
            target_end = downhill_xing(temp(1));
        else
            target_end = downhill_xing(temp(1))+1;
        end
    else
        target_end = length(S.p);
    end
else %annul the pair
    target_start = 0;
    target_end = 0;
end

%list update is a [n*3] matrix where the 1st column is the i_i, second
%is the target start and 3rd is the target end
if ~handles.update_flag
    handles.list_update = [i_i target_start target_end];
else
    handles.list_update = [handles.list_update; i_i target_start target_end];
end

handles.update_flag = 1;
guidata(hObject, handles);
    
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
