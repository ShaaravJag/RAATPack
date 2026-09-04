function varargout = HAMGUI(varargin)
% HAMGUI MATLAB code for HAMGUI.fig
%      HAMGUI, by itself, creates a new HAMGUI or raises the existing
%      singleton*.
%
%      H = HAMGUI returns the handle to a new HAMGUI or the handle to
%      the existing singleton*.
%
%      HAMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAMGUI.M with the given input arguments.
%
%      HAMGUI('Property','Value',...) creates a new HAMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HAMGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HAMGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HAMGUI

% Last Modified by GUIDE v2.5 10-Dec-2019 00:12:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HAMGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @HAMGUI_OutputFcn, ...
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


% --- Executes just before HAMGUI is made visible.
function HAMGUI_OpeningFcn(hObject, eventdata, handles, varargin)
        try s=RAATPackversion;
    catch
        setappdata(0,'RAATPackversion','RAATPack_v2');
RAATPackversion=getappdata(0,'RAATPackversion');

temporary_directory=dir(mcrcachedir);
list_directories={temporary_directory.name};
RAATPack_folder_index=find(contains(list_directories,'RAATPa'));
RAATPack_folder=cell2mat(list_directories(RAATPack_folder_index));
RAATPack_folder=([mcrcachedir,'\',RAATPack_folder,'\',RAATPackversion,'\']);
setappdata(0,'RAATPack_folder',RAATPack_folder);
oldpath = path;
path(oldpath,RAATPack_folder);
    end

%[matlabImage,map,alpha] = imread([foldername,'\CAITLogo.png']);
%image(matlabImage,'AlphaData',alpha)
%axis off
%axis image
    
%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges');
if admin_privileges_value==1

end


% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HAMGUI (see VARARGIN)

% Choose default command line output for HAMGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HAMGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HAMGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)


% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
   function pushbutton2_callback(hObject, events, handles)
      FI_GUI_v6();
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
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



% --- Executes during object creation, after setting all properties.
function text17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
set(handles.text2,'String',F);
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles) 


% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
   
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton6


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)


% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
    [FileName,PathName] = uigetfile('*.dat','Input','MultiSelect','off');
File1 = fullfile(PathName,FileName); 
handles.File1 = File1;
guidata(hObject,handles);
set(handles.text25,'String',File1);
Filename_sample1 = get(handles.text25,'String');
xy_sample1 = importdata(Filename_sample1);
celldata1 = xy_sample1.textdata;
celldata1 = celldata1(11:end-8,2:3);
cellsize1 = size(celldata1);
i = 0;
while(1)
    i = i+1;
    cellmat1(i,:) = [str2num(cell2mat(celldata1(i,1))),str2num(cell2mat(celldata1(i,2)))];
    if i == cellsize1(1)
        break
    end
end
cellmat1(:,2) = cellmat1(:,2)*(-1); %center (kN)
cellmat1(:,1) = cellmat1(1,1)-cellmat1(:,1); %displacement (mm)
x_sample1=cellmat1(:,1);
y_sample1=cellmat1(:,2);
handles.x_sample1=x_sample1;
handles.y_sample1=y_sample1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function text21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8





% --- Executes during object creation, after setting all properties.
function text27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on pushbutton22 and none of its controls.
function pushbutton22_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
        if get(handles.checkbox10,'Value')==1
        set(handles.checkbox13,'Value',1)
    else
        set(handles.checkbox13,'Value',0)
    end
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
            if get(handles.checkbox11,'Value')==1
        set(handles.checkbox14,'Value',1)
    else
        set(handles.checkbox14,'Value',0)
    end
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentdata = getappdata(gcf)
uisave('currentdata','\');


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldername = [];
[FileName,PathName] = uigetfile(('*.mat*'),'Input',string(foldername));
File_sample1 = fullfile(PathName,FileName); 
if isequal(FileName,0)
else
close(gcf);
center(File_sample1);
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldername=([tempdir,getenv('username'),'\mcrCache9.4\RAATPa0\RAATPack_v2\']);
temporary_directory=dir([tempdir,getenv('username'),'\mcrCache9.4']);
list_directories={temporary_directory.name};
RAATPack_folder_index=find(contains(list_directories,'RAATPa'));
RAATPack_folder=cell2mat(list_directories(RAATPack_folder_index));
RAATPack_folder_full=([tempdir,getenv('username'),'\mcrCache9.4\',RAATPack_folder,'\RAATPack_v2\HAM']);
foldername=RAATPack_folder_full;
IDEALCTGUI_direct=([foldername,'HAMGUI.m']);
close(gcf);
run(IDEALCTGUI_direct);

% --- Executes during object creation, after setting all properties.
function pushbutton21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
f = waitbar(0,'Running Analysis. Please wait...');
set(handles.uipanel4,'visible','off');
set(handles.uipanel8,'visible','on');
set(handles.uipanel9,'visible','off');

right=handles.right;
left=handles.left;
cyclesL=handles.cyclesL;
cyclesR=handles.cyclesR;


tabledata = get(handles.uitable2,'Data');
number_of_files=size(tabledata,1);
specimenID=tabledata(:,2)';
numel(specimenID);
for k = 1:numel(specimenID)
  if isempty(specimenID{k})
    specimenID{k} = ['Sample #' num2str(k)];
  end
end
AV=tabledata(:,3)';


%% Set Graph Colors
axes(handles.axes5);
hold(handles.axes5, 'on');
x=cyclesL;
y=left;
[graphdata,color]=cellfun(@colors,x,y,'UniformOutput',false);
set(handles.axes5, 'Visible','off');
hold(handles.axes5, 'off');

%% Set Listbox
set(handles.listbox3,'String',specimenID);
set(handles.listbox3,'Value',1);
file_number=get(handles.listbox3,'Value');
if size(file_number)==1
end
%% Run Analysis
cla(handles.axes1);
axes(handles.axes1);
try
[Cx1_R, Cy1_R, Sx1_R, Sy1_R, InfPtx1_R, InfPty1_R, Cx1_L, Cy1_L, Sx1_L, Sy1_L, InfPtx1_L, InfPty1_L,Max_Rut_left,Stripping_Slope_left,Creeping_Slope_left,SIP_Ratio_left,Inf_Pt_left,Max_Rut_right,Stripping_Slope_right,Creeping_Slope_right,SIP_Ratio_right,Inf_Pt_right,Avg_Rut1,Avg_CS1,Avg_SS1,Avg_InfPt1,Avg_SIP_Ratio] = cellfun(@HAMfinder,cyclesL,cyclesR,left,right,specimenID,'UniformOutput',false);
close(f);
calculated_parameters=[Avg_Rut1;Avg_CS1;Avg_SS1;Avg_InfPt1];
calculated_parameters_left=[Max_Rut_left(file_number);Creeping_Slope_left(file_number);Stripping_Slope_left(file_number);Inf_Pt_left(file_number)];
calculated_parameters_right=[Max_Rut_right(file_number);Creeping_Slope_right(file_number);Stripping_Slope_right(file_number);Inf_Pt_right(file_number)];
%% Update Table with Sample 1
table_2_data=[calculated_parameters_left,calculated_parameters_right];


averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2))

for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end

if contains(string(table_2_data{1}),'Max') || contains(string(table_2_data{2}),'N/A')
    averages{1}='Max rut';
end
    
table_2_data=[table_2_data,averages];
colnames=    [{'Average Rut Depth (mm) at 20,000 cycles'}
    {'Average Creep Slope (mm/cycle)'}
    {'Average Stripping Slope (mm/cycle))'}
    {'Average Stripping Inflection Point (cycles))'}];
set(handles.uitable1,'ColumnName',colnames); 
set(handles.uitable1,'RowName',[{'Left Wheel'},{'Right Wheel'},{'Average'}]);
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');
set(handles.listbox3,'Value',([1:number_of_files]));

%% Set Handles
handles.specimenID=specimenID;
handles.AV=AV;
handles.cyclesL=cyclesL;
handles.cyclesR=cyclesR;
handles.left=left;
handles.right=right;
handles.Avg_Rut1=Avg_Rut1;
handles.Avg_CS1=Avg_CS1;
handles.Avg_SS1=Avg_SS1;
handles.Avg_InfPt1=Avg_InfPt1;
handles.Max_Rut_left=Max_Rut_left;
handles.Stripping_Slope_left=Stripping_Slope_left;
handles.Creeping_Slope_left=Creeping_Slope_left;
handles.SIP_Ratio_left=SIP_Ratio_left;
handles.Inf_Pt_left=Inf_Pt_left;
handles.Max_Rut_right=Max_Rut_right;
handles.Stripping_Slope_right=Stripping_Slope_right;
handles.Creeping_Slope_right=Creeping_Slope_right;
handles.SIP_Ratio_right=SIP_Ratio_right;
handles.Inf_Pt_right=Inf_Pt_right;
handles.color=color;
handles.Cx1_R=Cx1_R;
handles.Cy1_R=Cy1_R;
handles.Sx1_R=Sx1_R;
handles.Sy1_R=Sy1_R;
handles.InfPtx1_R=InfPtx1_R;
handles.InfPty1_R=InfPty1_R;
handles.Cx1_L=Cx1_L;
handles.Cy1_L=Cy1_L;
handles.Sx1_L=Sx1_L;
handles.Sy1_L=Sy1_L;
handles.InfPtx1_L=InfPtx1_L;
handles.InfPty1_L=InfPty1_L;
guidata(hObject,handles);

catch
g = msgbox('Error occurred while running analysis. Please check your data and try again.', 'Error','error');
close(f)
end

% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
tabledata = get(handles.uitable2,'Data');
set(handles.uitable2,'Data',tabledata,'ColumnEditable',true);  
cla(handles.axes1);
set(handles.listbox3,'Value',[]);
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
    
selectedRow = eventdata.Indices(1);
selectedCol = eventdata.Indices(2);
if selectedCol == 2
    if eventdata.NewData == 1
        handles.selectedRow = selectedRow;
    else
        handles.selectedRow = [];
    end
    guidata(hObject, handles);
end
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
right=handles.right;
left=handles.left;
cyclesL=handles.cyclesL;
cyclesR=handles.cyclesR;
Avg_Rut1=handles.Avg_Rut1;
Avg_CS1=handles.Avg_CS1;
Avg_SS1=handles.Avg_SS1;
Avg_InfPt1=handles.Avg_InfPt1;
Max_Rut_left=handles.Max_Rut_left;
Stripping_Slope_left=handles.Stripping_Slope_left;
Creeping_Slope_left=handles.Creeping_Slope_left;
SIP_Ratio_left=handles.SIP_Ratio_left;
Inf_Pt_left=handles.Inf_Pt_left;
Max_Rut_right=handles.Max_Rut_right;
Stripping_Slope_right=handles.Stripping_Slope_right;
Creeping_Slope_right=handles.Creeping_Slope_right;
SIP_Ratio_right=handles.SIP_Ratio_right;
Inf_Pt_right=handles.Inf_Pt_right;
Cx1_R=handles.Cx1_R;
Cy1_R=handles.Cy1_R;
Sx1_R=handles.Sx1_R;
Sy1_R=handles.Sy1_R;
InfPtx1_R=handles.InfPtx1_R;
InfPty1_R=handles.InfPty1_R;
Cx1_L=handles.Cx1_L;
Cy1_L=handles.Cy1_L;
Sx1_L=handles.Sx1_L;
Sy1_L=handles.Sy1_L;
InfPtx1_L=handles.InfPtx1_L;
InfPty1_L=handles.InfPty1_L;


AV=handles.AV;
specimenID=handles.specimenID;
color=handles.color;

%% Graph samples


file_number=get(handles.listbox3,'Value');
if size(file_number)==1

end

cla(handles.axes1);

calculated_parameters_left=[Max_Rut_left(file_number);Creeping_Slope_left(file_number);Stripping_Slope_left(file_number);Inf_Pt_left(file_number)];
calculated_parameters_right=[Max_Rut_right(file_number);Creeping_Slope_right(file_number);Stripping_Slope_right(file_number);Inf_Pt_right(file_number)];
%% Update Table with Sample 1
table_2_data=[calculated_parameters_left,calculated_parameters_right];

%% Calculate Averages
calculated_parameters_left=[Max_Rut_left(file_number);Creeping_Slope_left(file_number);Stripping_Slope_left(file_number);Inf_Pt_left(file_number)];
calculated_parameters_right=[Max_Rut_right(file_number);Creeping_Slope_right(file_number);Stripping_Slope_right(file_number);Inf_Pt_right(file_number)];
%% Update Table with Sample 1
table_2_data=[calculated_parameters_left,calculated_parameters_right];


averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));
for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end

if contains(string(table_2_data{1}),'Max') || contains(string(table_2_data{2}),'N/A')
    averages{1}='Max rut';
end

table_2_data=[table_2_data,averages];
colnames=    [{'Average Rut Depth (mm) at 20,000 cycles'}
    {'Average Creep Slope (mm/cycle)'}
    {'Average Stripping Slope (mm/cycle))'}
    {'Average Stripping Inflection Point (cycles))'}];
set(handles.uitable1,'ColumnName',colnames); 
set(handles.uitable1,'RowName',[{'Left Wheel'},{'Right Wheel'},{'Average'}]);
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');



p=get(handles.uibuttongroup19,'SelectedObject');
if p.Tag=='radiobutton57'
    axes(handles.axes1)
    hold(handles.axes1,'on')
    title(handles.axes1,specimenID(file_number));
plot(cyclesL{file_number},left{file_number}.*(-1),'b-','LineWidth',3);
hold(handles.axes1,'on')
plot(Cx1_L{file_number},Cy1_L{file_number},'g-','LineWidth',2);
hold(handles.axes1,'on')
plot(Sx1_L{file_number},Sy1_L{file_number},'r-','LineWidth',2);
hold(handles.axes1,'on')
plot(InfPtx1_L{file_number},InfPty1_L{file_number},'ko','LineWidth',2);
hold(handles.axes1,'off')
axis([0 20100 get(handles.slider2, 'Value') 0]);
%set(gca, 'XTickRabel', num2str(get(handles.axes1,'XTick')','%d'));
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Left Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');



end
if p.Tag=='radiobutton59'
    axes(handles.axes1)
    hold(handles.axes1,'on')
    title(handles.axes1,specimenID(file_number));
plot(cyclesR{file_number},right{file_number}.*(-1),'m-',Cx1_R{file_number},Cy1_R{file_number},'g-',Sx1_R{file_number},Sy1_R{file_number},'r-',InfPtx1_R{file_number},InfPty1_R{file_number},'ko','LineWidth',2);
axis([0 20100 get(handles.slider2, 'Value') 0]);
%set(gca, 'XTickRabel', num2str(get(handles.axes1,'XTick')','%d'));
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Right Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');

end
if p.Tag=='radiobutton61'
    axes(handles.axes1)
    hold(handles.axes1,'on')
    title(handles.axes1,specimenID(file_number));
plot(cyclesL{file_number},left{file_number}.*(-1),'b-',cyclesR{file_number},right{file_number}.*(-1),'m-','LineWidth',2);
axis([0 20100 get(handles.slider2, 'Value') 0]);
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Left Wheel','Right Wheel');

end
hold(handles.axes1, 'off');

guidata(hObject, handles);
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel4,'visible','on');
set(handles.uipanel8,'visible','off');
set(handles.uipanel9,'visible','off');
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
set(handles.uipanel4,'visible','off');
set(handles.uipanel8,'visible','on');
set(handles.uipanel9,'visible','off');
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
specimenID=handles.specimenID;
filename=handles.filename;
if get(handles.checkbox15,'value') ==1
[p b] = size(filename);
spaces=(cellstr(repmat(': ',b,1)))';
try
IDwfile=strcat(specimenID,spaces,filename);
catch
IDwfile=strcat(specimenID,spaces,filename');
end
set(handles.listbox3,'String',IDwfile);
else
set(handles.listbox3,'String',specimenID); 
end
% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
set(handles.uipanel4,'visible','off');
set(handles.uipanel8,'visible','off');
set(handles.uipanel9,'visible','on');

% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
x_for_export=handles.x_for_export;
y_for_export=handles.y_for_export;
number_of_files=size(get(handles.listbox3,'Value'),2)
xy={x_for_export,y_for_export};
xy=cat(1,xy{:})';
i=1:number_of_files;
i=0;
S = [];
while (1)
i=i+1;
sample={[xy{i,1},xy{i,2}]};
xy_data(i)=sample;
vars = {'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l'};
S.(vars{i}) = xy_data(i);
if i==number_of_files
    break
end
end
xy_data;
xy_1=[];
xy_2=[];
xy_3=[];
xy_4=[];
xy_5=[];
xy_6=[];
xy_7=[];
xy_8=[];
xy_9=[];
xy_10=[];
xy_11=[];
xy_12=[];
try
xy_1=cell2mat(S.(vars{1}));
xy_2=cell2mat(S.(vars{2}));
xy_3=cell2mat(S.(vars{3}));
xy_4=cell2mat(S.(vars{4}));
xy_5=cell2mat(S.(vars{5}));
xy_6=cell2mat(S.(vars{6}));
xy_7=cell2mat(S.(vars{7}));
xy_8=cell2mat(S.(vars{8}));
xy_9=cell2mat(S.(vars{9}));
xy_10=cell2mat(S.(vars{10}));
xy_11=cell2mat(S.(vars{11}));
xy_12=cell2mat(S.(vars{12}));
catch
end


% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles);
error=0;
    set(handles.popupmenu3, 'String', {' ', ';', '"','none',','});
set(handles.popupmenu3,'value',5);
[FileName,PathName] = uigetfile('*.*','MultiSelect','off');
f = waitbar(0,'Opening File. Please wait...');
Fullname2 = fullfile(PathName,FileName); 
handles.Fullname2 = Fullname2;
guidata(hObject,handles);
set(handles.text64,'String',Fullname2);
waitbar(0.5,f,'Opening File. Please wait...');
try
raw_data_file=readtable(Fullname2,'ReadVariableNames',false);
catch 
    g = msgbox('Unsupported file.', 'Error','error');
error=1;
close(f);
end
if error==1
else
set(handles.uitable6,'Data',table2cell(raw_data_file));
if contains(Fullname2,'.csv') ==1
    set(handles.text77,'visible','on')
    set(handles.popupmenu3,'visible','on')
    set(handles.popupmenu6,'visible','off') 
    set(handles.text89,'visible','off')
else
    set(handles.text77,'visible','off')
    set(handles.popupmenu3,'visible','off') 
    set(handles.popupmenu6,'visible','on') 
    set(handles.text89,'visible','on')
    [status,handles.sheets] = xlsfinfo(Fullname2);
set(handles.popupmenu6,'String',handles.sheets);

end
close(f);
end
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
Filename_config=get(handles.text64,'String');

if contains(Filename_config,'.xls') == 1
    opts = detectImportOptions(Filename_config);
    opts.SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	opts.DataRange=[str2num(get(handles.edit37,'String')) Inf];
    opts.VariableNames= {'Displacement', 'Load', 'right','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
elseif contains(Filename_config,'.csv') == 1
    
opts = detectImportOptions(Filename_config);
opts.SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
opts.DataLines=[str2num(get(handles.edit37,'String')) Inf];
opts.VariableNames= {'Displacement', 'Load', 'right','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
opts.ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
opts.Delimiter = popupstrings{get(handles.popupmenu3,'Value')};

end

xy_config=readtable(Filename_config,opts);
xy_config=xy_config(~any(ismissing(xy_config),2),:);
x_config=xy_config{:,1};
config=xy_config{:,2};

plot(handles.axes4,x_config,config,'r-','Linewidth',3);
x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
xlabel(handles.axes4,['Displacement ' '(' x_label ')']);
ylabel(handles.axes4,['Load (' y_label ')']);
title(handles.axes4,'Preview');

set(handles.uitable5,'Data',table2cell(xy_config(1:15,:)));

handles.x_config_original=x_config;
handles.y_config_original=config;
handles.xy_config_original=xy_config;
handles.x_config=x_config;
handles.y_config=config;
handles.xy_config=xy_config;
guidata(hObject,handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)

set(handles.edit37,'String',0);
set(handles.edit36,'String',0);
set(handles.edit37,'String',0);
set(handles.popupmenu3,'Value',5);
set(handles.uitable5,'Data',{});
set(handles.checkbox16,'Value',0);
set(handles.checkbox17,'Value',0);
set(handles.checkbox18,'Value',0);
set(handles.checkbox19,'Value',0);
set(handles.checkbox20,'Value',0);
set(handles.checkbox21,'Value',0);

cla(handles.axes4);
handles.x_config_original=0;
handles.y_config_original=0;
guidata(hObject,handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
%% Which test is the user configuring?

RAATPack_folder=getappdata(0,'RAATPack_folder');
[FileName,PathName] = uiputfile('*.xlsx');
configfilename = fullfile(PathName,FileName);
set(handles.config_text,'String',configfilename);


f=waitbar(0,'Exporting. Please Wait...');

%%

if contains(get(handles.text64,'String'),'.csv') == 1
SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
DataLines=[str2num(get(handles.edit37,'String')) Inf];
VariableNames= {'tabledata', 'Displacement', 'Load'};
ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
Transformations=string({get(handles.checkbox17,'Value');get(handles.checkbox18,'Value');get(handles.checkbox16,'Value');get(handles.checkbox19,'Value');get(handles.checkbox20,'Value');get(handles.checkbox21,'Value')});
FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);DataLines(1);DataLines(2);VariableNames(2);VariableNames(3);Delimiter});
displacement_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
center_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
Units=string([{displacement_units};{center_units}]);
xlswrite(configfilename,FileConfig,'B1:B7');
xlswrite(configfilename,Transformations,'B8:B13');
xlswrite(configfilename,Units,'B14:B15');
end

if contains(get(handles.text64,'String'),'.xls') == 1
    SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	DataRange=[str2num(get(handles.edit37,'String')) Inf];
    VariableNames= {'Displacement', 'Load', 'Time','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
    Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
    Transformations=string({get(handles.checkbox17,'Value');get(handles.checkbox18,'Value');get(handles.checkbox16,'Value');get(handles.checkbox19,'Value');get(handles.checkbox20,'Value');get(handles.checkbox21,'Value')});
    FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);DataRange(1);DataRange(2);VariableNames(1);VariableNames(2);Delimiter});
    displacement_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
    center_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
    Units=string([{displacement_units};{center_units}]);
    xlswrite(configfilename,FileConfig,'B1:B7');
    xlswrite(configfilename,Transformations,'B8:B13');
    xlswrite(configfilename,Units,'B14:B15');
end

close(f);
labels=[{'Time Start'}
{'Stroke Start'}
{'Load Start'}
{'COD Gage Start'}
{'Data Start'}
{'Data End'}
{'X1'}
{'X2'}
{'X3'}
{'X4'}
{'Delimiter'}
{'Offset from Start (Time)'}
{'Negative (Time)'}
{'Offset from End (Time)'}
{'Offset from Start (Stroke)'}
{'Negative (Stroke)'}
{'Offset from End (Stroke)'}
{'Offset from Start (COD Gage)'}
{'Negative (COD Gage)'}
{'Offset from End (COD Gage)'}
{'Offset from Start (Load)'}
{'Negative (Load)'}
{'Offset from End (Load)'}
{'Time units'}
{'Stroke Units'}
{'COD Gage units'}
{'Load Units'}];

xlswrite(configfilename,labels,'A1:A27');
config_file=([RAATPack_folder,'Configs\DCTconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, configfilename);
fclose(fid);

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg(['\color{blue} The DCT Configuration File has been updated.'],...
             'Notification', opts);

set(handles.uipanel4,'visible','on');
set(handles.uipanel8,'visible','off');
set(handles.uipanel9,'visible','off');         
         

% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in uitable6.
function uitable6_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable6 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uibuttongroup4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over radiobutton14.
function radiobutton14_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uibuttongroup4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
set(handles.uipanel4,'visible','off');
set(handles.uipanel8,'visible','off');
set(handles.uipanel9,'visible','on');
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uibuttongroup5.
function uibuttongroup5_SelectionChangedFcn(hObject, eventdata, handles)
x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);
% hObject    handle to the selected object in uibuttongroup5 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup4.
function uibuttongroup4_SelectionChangedFcn(hObject, eventdata, handles)
x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);
% hObject    handle to the selected object in uibuttongroup4 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile({'*.xlsx'},'Input','\','MultiSelect', 'off');
if filename==0
else
config_filename = fullfile(pathname,filename);
set(handles.config_text,'String',config_filename);
RAATPack_folder=getappdata(0,'RAATPack_folder');
config_file=([RAATPack_folder,'Configs\DCTconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, config_filename);
fclose(fid);
end
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu3.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
 Filename_config=get(handles.text64,'String');
 if contains(Filename_config,'.xls') == 1
    opts = detectImportOptions(Filename_config,'Sheet',get(handles.popupmenu6,'Value'));
 else
opts = detectImportOptions(Filename_config);
 end
 
 %% Warnings
error=0;
if isempty(get(handles.edit35,'String'))==1 || str2num(get(handles.edit35,'String'))==0
f = msgbox('Please enter a valid number for the first row of data.', 'Error','error');
error=1;
end
if isempty(get(handles.edit37,'String'))==1 || str2num(get(handles.edit37,'String'))==0 | str2num(get(handles.edit37,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the center wheel column.', 'Error','error');
error=1;
end
if isempty(get(handles.edit36,'String'))==1 || str2num(get(handles.edit36,'String'))==0 || str2num(get(handles.edit36,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the right wheel column.', 'Error','error');
error=1;
end

if isempty(get(handles.edit38,'String'))==1 || str2num(get(handles.edit38,'String'))==0 || str2num(get(handles.edit38,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the left wheel column.', 'Error','error');
error=1;
end

if str2num(get(handles.edit37,'String'))~=0 && str2num(get(handles.edit36,'String'))~=0 && str2num(get(handles.edit37,'String'))==str2num(get(handles.edit36,'String'))
f = msgbox('Center wheel and right wheel columns may not be the same.', 'Error','error');
error=1;
end

if str2num(get(handles.edit37,'String'))~=0 && str2num(get(handles.edit38,'String'))~=0 && str2num(get(handles.edit37,'String'))==str2num(get(handles.edit38,'String'))
f = msgbox('Center wheel and left wheel columns may not be the same.', 'Error','error');
error=1;
end

if str2num(get(handles.edit38,'String'))~=0 && str2num(get(handles.edit36,'String'))~=0 && str2num(get(handles.edit38,'String'))==str2num(get(handles.edit36,'String'))
f = msgbox('Left wheel and right wheel columns may not be the same.', 'Error','error');
error=1;
end

if contains(Filename_config,'.xls') == 1
    opts.SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
    opts.DataRange=[str2num(get(handles.edit35,'String')) Inf];
    opts.Sheet=get(handles.popupmenu6,'Value');
    opts = setvartype(opts,'double');
    opts.VariableNames= {'Left', 'Center', 'Right','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
    data_config=readtable(Filename_config,opts,'basic',false);
elseif contains(Filename_config,'.csv') == 1    
    opts.SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
opts.DataLines=[str2num(get(handles.edit35,'String')) Inf];
opts.VariableNames= {'Left', 'Center', 'Right','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
opts.ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
opts.Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
data_config=readtable(Filename_config,opts);
end


data_config=data_config(~any(ismissing(data_config),2),:)
left_config=data_config{:,1};
center_config=data_config{:,2};
right_config=data_config{:,3};

if isempty(left_config)==1
f = msgbox('Could not preview file. Please try a different delimiter or sheet.', 'Error','error');
error=1;
end
if error==1
else
%plot(handles.axes4,COD_config,left_config,'r-','Linewidth',3);
%xlabel(handles.axes4,['COD (' get(get(handles.uibuttongroup5,'SelectedObject'), 'String') ')']);
%ylabel(handles.axes4,['Load (' get(get(handles.uibuttongroup4,'SelectedObject'), 'String') ')']);
%title(handles.axes4,'Preview');

set(handles.uitable5,'Data',table2cell(data_config(1:15,:)));


handles.left_config_original=left_config;
handles.center_config_original=center_config;
handles.right_config_original=right_config;
handles.data_config_original=data_config;

handles.left_config=left_config;
handles.center_config=center_config;
handles.right_config=right_config;
handles.data_config=data_config;

guidata(hObject,handles)
end

% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup8.
function uibuttongroup8_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup8 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup7.
function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)
    x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);
% hObject    handle to the selected object in uibuttongroup7 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
    %% Which test is the user configuring?
RAATPack_folder=getappdata(0,'RAATPack_folder');
[FileName,PathName] = uiputfile('*.xlsx');
configfilename = fullfile(PathName,FileName);
set(handles.config_text,'String',configfilename);


f=waitbar(0,'Exporting. Please Wait...');

%%

if contains(get(handles.text64,'String'),'.csv') == 1
SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String')) str2num(get(handles.edit39,'String'))];
DataLines=[str2num(get(handles.edit35,'String')) Inf];
VariableNames= {'tabledata', 'Time', 'Stroke','Load','COD'};
ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
Transformations=string({get(handles.checkbox17,'Value');get(handles.checkbox18,'Value');get(handles.checkbox16,'Value');get(handles.checkbox19,'Value');get(handles.checkbox20,'Value');get(handles.checkbox21,'Value');get(handles.checkbox23,'Value');get(handles.checkbox24,'Value');get(handles.checkbox22,'Value');get(handles.checkbox25,'Value');get(handles.checkbox26,'Value');get(handles.checkbox27,'Value')});
FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);SelectedVariableNames(3);SelectedVariableNames(4);DataLines(1);DataLines(2);VariableNames(2);VariableNames(3);VariableNames(4);VariableNames(5);Delimiter});
left_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
center_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
COD_gage_units=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
right_units=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
Units=string([{right_units};{left_units};{center_units};{COD_gage_units}]);
xlswrite(configfilename,FileConfig,'B1:B11');
xlswrite(configfilename,Transformations,'B12:B23');
xlswrite(configfilename,Units,'B24:B27');
end

if contains(get(handles.text64,'String'),'.xls') == 1
    SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String')) str2num(get(handles.edit39,'String'))];
	DataRange=[str2num(get(handles.edit35,'String')) Inf];
    VariableNames= {'Time', 'Stroke','Load','COD','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
    Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
    Sheett=get(handles.popupmenu6,'Value');
    Transformations=string({get(handles.checkbox17,'Value');get(handles.checkbox18,'Value');get(handles.checkbox16,'Value');get(handles.checkbox19,'Value');get(handles.checkbox20,'Value');get(handles.checkbox21,'Value');get(handles.checkbox23,'Value');get(handles.checkbox24,'Value');get(handles.checkbox22,'Value');get(handles.checkbox25,'Value');get(handles.checkbox26,'Value');get(handles.checkbox27,'Value')});
    FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);SelectedVariableNames(3);SelectedVariableNames(4);DataRange(1);DataRange(2);VariableNames(1);VariableNames(2);VariableNames(3);VariableNames(4);Delimiter});
    left_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
    center_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
    COD_gage_units=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
    right_units=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
Units=string([{right_units};{left_units};{center_units};{COD_gage_units}]);
xlswrite(configfilename,FileConfig,'B1:B11');
xlswrite(configfilename,Transformations,'B12:B23');
xlswrite(configfilename,Units,'B24:B27');
xlswrite(configfilename,Sheett,1,'B28');
end



close(f);

labels=[{'Time Start'}
{'Stroke Start'}
{'Load Start'}
{'COD Gage Start'}
{'Data Start'}
{'Data End'}
{'X1'}
{'X2'}
{'X3'}
{'X4'}
{'Delimiter'}
{'Offset from Start (Time)'}
{'Negative (Time)'}
{'Offset from End (Time)'}
{'Offset from Start (Stroke)'}
{'Negative (Stroke)'}
{'Offset from End (Stroke)'}
{'Offset from Start (COD Gage)'}
{'Negative (COD Gage)'}
{'Offset from End (COD Gage)'}
{'Offset from Start (Load)'}
{'Negative (Load)'}
{'Offset from End (Load)'}
{'Time units'}
{'Stroke Units'}
{'COD Gage units'}
{'Load Units'}];

xlswrite(configfilename,labels,'A1:A27');
config_file=([RAATPack_folder,'Configs\DCTconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, configfilename);
fclose(fid);

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg(['\color{blue} The DCT Configuration File has been updated.'],...
             'Notification', opts);

% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox16.
function checkbox22_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on button press in checkbox17.
function checkbox23_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox24_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox19.
function checkbox25_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in checkbox20.
function checkbox26_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox27_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in checkbox22.
function checkbox28_Callback(hObject, eventdata, handles)
file_number=get(handles.listbox3,'Value');
filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
diameter=handles.diameter;
thickness=handles.thickness;
ligament=handles.ligament;
right=handles.right;
left=handles.left;
center=handles.center;
COD=handles.COD;
fittedCOD=handles.fittedCOD;
COD=handles.COD;
peakcenter=handles.peakcenter;
displacementatpeak=handles.displacementatpeak;
rightatpeak=handles.rightatpeak;
testduration=handles.testduration;
Gf=handles.Gf;
slope=handles.slope;
b=handles.b;
color=handles.color;
    calculated_parameters= [peakcenter(file_number);displacementatpeak(file_number);rightatpeak(file_number);testduration(file_number);Gf(file_number);slope(file_number)];
table_2_data=[AV(file_number);diameter(file_number);thickness(file_number);ligament(file_number);calculated_parameters];
if(size(get(handles.listbox3,'Value'))==1)
    averages=[]
else
averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));
for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end
end

table_2_data=[table_2_data,averages];
if(size(get(handles.listbox3,'Value'))==1)
    rownames=specimenID(file_number);
else
rownames=[specimenID(file_number),{'Average'}];
end
set(handles.uitable1,'RowName',rownames);
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');

if(get(handles.checkbox28,'Value'))==0
cla(handles.axes1);


%% Calculate Averages
max_yaxis=max(cellfun(@max,center));
max_xaxis=max(cellfun(@max,fittedCOD));
fittedCOD=fittedCOD(file_number);
center=center(file_number);


axes(handles.axes1);
hold(handles.axes1, 'on');
colors=color(file_number);
graphdata=cellfun(@multiplotter,fittedCOD,center,colors,'UniformOutput',false);
xlabel(handles.axes1,'COD (mm)');
ylabel(handles.axes1,'Load (kN)');
axP = get(gca,'Position');
ylim(handles.axes1,[0 (max_yaxis+1)]);
xlim(handles.axes1,[0 (max_xaxis+1)]);
legend(handles.axes1,specimenID(file_number),'location','eastoutside');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');

handles.fittedCOD_for_export=fittedCOD;
handles.center_for_export=center;
guidata(hObject, handles);
elseif get(handles.checkbox28,'Value')==1
    cla(handles.axes1);
    number_of_files=handles.number_of_files;
file_number=get(handles.listbox3,'Value');


%% Calculate Averages
max_xaxis=max(cellfun(@max,right));
max_yaxis=max(cellfun(@max,COD));
COD=COD(file_number);
right=right(file_number);
axes(handles.axes1);
hold(handles.axes1, 'on');
colors=color(file_number);
graphdata=cellfun(@multiplotter,right,COD,colors,'UniformOutput',false);

xlabel(handles.axes1,'Time (sec)');
ylabel(handles.axes1,'COD (mm)');
axP = get(gca,'Position');
ylim(handles.axes1,[0 (max_yaxis+1)]);
xlim(handles.axes1,[0 (max_xaxis+1)]);
slope=slope(file_number);
b=b(file_number);
legend_text(1:(size(file_number,2)))={': '};
legend_text2(1:(size(file_number,2)))={'x + '};
COD_verification=[string(slope);legend_text2;b];
COD_verification=strcat(string(specimenID(file_number)),legend_text,string(slope),legend_text2,string(b))';
legend(handles.axes1,COD_verification,'location','northwest');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');


end
fittedCOD_for_export=fittedCOD;
handles.center_for_export=center;
guidata(hObject, handles);
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox23.
function checkbox29_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox23


% --- Executes on button press in checkbox24.
function checkbox30_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox24


% --- Executes on button press in checkbox25.
function checkbox31_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox25


% --- Executes on button press in checkbox26.
function checkbox32_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26


% --- Executes on button press in checkbox27.
function checkbox33_Callback(hObject, eventdata, handles)
    COD_config_original=handles.COD_config_original;
left_config_original=handles.left_config_original;
right_config_original=handles.right_config_original;
center_config_original=handles.center_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[center_config,right_config,COD_config,left_config] = DCT_transformer(COD_config_original,left_config_original,right_config_original,center_config_original,checkboxes);
xy_config=[center_config,right_config,left_config,COD_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.COD_config=COD_config;
handles.left_config=left_config;
handles.center_config=center_config;
handles.COD_config=COD_config;
handles.CODy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to checkbox27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox27


% --- Executes when selected object is changed in uibuttongroup10.
function uibuttongroup10_SelectionChangedFcn(hObject, eventdata, handles)
    COD_config=handles.COD_config;
left_config=handles.left_config;
center_config=handles.center_config;
data_config=handles.data_config;
right_config=handles.right_config;
x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to the selected object in uibuttongroup10 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup9.
function uibuttongroup9_SelectionChangedFcn(hObject, eventdata, handles)
    COD_config=handles.COD_config;
left_config=handles.left_config;
center_config=handles.center_config;
data_config=handles.data_config;
right_config=handles.right_config;
x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = COD_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= right_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=left_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=center_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = COD_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= right_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=left_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=center_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);
% hObject    handle to the selected object in uibuttongroup9 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
    try
OGfile_numbers=get(handles.uitable2,'RowName');
OGnumber_of_files=size(OGfile_numbers,1);
OGtabledata=get(handles.uitable2,'Data');
try
checks=isempty(OGfile_numbers{1});
catch 
OGfile_numbers={OGfile_numbers} ;   
end
if isempty(OGfile_numbers{1})==1
    OGfile_numbers=[];
    OGnumber_of_files=0;
    OGtabledata=[];
    OGleft=[];
    OGright=[];
    OGcyclesL=[];
    OGcyclesR=[];
else
OGleft=handles.left;
OGright=handles.right;
OGcyclesL=handles.cyclesL;
OGcyclesR=handles.cyclesR;
end
        
        
        
%% User Selects Files
[filename,pathname] = uigetfile({'*.csv;*.xls;*.xlsx;*.dat'},'Input','\','MultiSelect', 'on');
if isnumeric(filename)==1 && filename==0
else
full_file_path = fullfile(pathname,filename);
if isstr(full_file_path)
    full_file_path={full_file_path};
end
f = waitbar(0,'Opening Files. Please wait...');

%% # of Files Selected
if isstr(filename) == 1
number_of_files = 1;
filename={filename};
else
number_of_files = size(filename,2);
end
C    = cell(1, OGnumber_of_files+number_of_files);
C(:) = {'File #'};
file_numbers=strcat(C,string(1:OGnumber_of_files+number_of_files));

%% Open files
RAATPack_folder=getappdata(0,'RAATPack_folder');

[left,right,cyclesL,cyclesR] = HAMopen(full_file_path,number_of_files);
right=[OGright right];
left=[OGleft left];
cyclesL=[OGcyclesL cyclesL];
cyclesR=[OGcyclesR cyclesR];

newtabledata=cell(number_of_files,3);
newtabledata(:,1)=filename;
tabledata=[OGtabledata;newtabledata];
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',[file_numbers],'Data',tabledata,'ColumnEditable',true);

%% Set The Sample #s & File Names

close(f);
handles.right=right;
handles.left=left;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.filename=tabledata(:,1);
handles.file_numbers=file_numbers;
handles.cyclesL=cyclesL;
handles.cyclesR=cyclesR;
guidata(hObject,handles);
end
catch
g = msgbox('Error occurred while opening files. Please check your file formatting and try again.', 'Error','error');
close(f)
    end

% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
tabledata=get(handles.uitable2,'Data');

handles.filename=tabledata(:,1);
    
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          removefiles = listdlg('PromptString','Select the Files to Remove:',...
                      'SelectionMode','multiple',...
                      'ListString',handles.filename);
                  tabledata(removefiles,:)=[];
handles.right(removefiles)=[];
handles.left(removefiles)=[];
handles.cyclesL(removefiles)=[];
handles.cyclesR(removefiles)=[];


handles.file_numbers(removefiles)=[];
handles.filename(removefiles)=[];
                  
                  
set(handles.uitable2,'RowName',[handles.file_numbers],'Data',tabledata,'ColumnEditable',true);                 
guidata(hObject,handles);


% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
                if contains(handles.Fullname2,'.xls') ==1
    raw_data_file=readtable(handles.Fullname2,'Sheet',get(handles.popupmenu6,'Value'),'ReadVariableNames',false,'basic',1);
    set(handles.uitable6,'Data',table2cell(raw_data_file));
    value=get(handles.popupmenu6,'Value');
end
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox35.
function checkbox35_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox35


% --- Executes on button press in checkbox36.
function checkbox36_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox36


% --- Executes on button press in checkbox37.
function checkbox37_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox37


% --- Executes on button press in checkbox38.
function checkbox38_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox38


% --- Executes during object creation, after setting all properties.
function uibuttongroup19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uibuttongroup19.
function uibuttongroup19_SelectionChangedFcn(hObject, eventdata, handles)
right=handles.right;
left=handles.left;
cyclesL=handles.cyclesL;
cyclesR=handles.cyclesR;
Avg_Rut1=handles.Avg_Rut1;
Avg_CS1=handles.Avg_CS1;
Avg_SS1=handles.Avg_SS1;
Avg_InfPt1=handles.Avg_InfPt1;
Max_Rut_left=handles.Max_Rut_left;
Stripping_Slope_left=handles.Stripping_Slope_left;
Creeping_Slope_left=handles.Creeping_Slope_left;
SIP_Ratio_left=handles.SIP_Ratio_left;
Inf_Pt_left=handles.Inf_Pt_left;
Max_Rut_right=handles.Max_Rut_right;
Stripping_Slope_right=handles.Stripping_Slope_right;
Creeping_Slope_right=handles.Creeping_Slope_right;
SIP_Ratio_right=handles.SIP_Ratio_right;
Inf_Pt_right=handles.Inf_Pt_right;
Cx1_R=handles.Cx1_R;
Cy1_R=handles.Cy1_R;
Sx1_R=handles.Sx1_R;
Sy1_R=handles.Sy1_R;
InfPtx1_R=handles.InfPtx1_R;
InfPty1_R=handles.InfPty1_R;
Cx1_L=handles.Cx1_L;
Cy1_L=handles.Cy1_L;
Sx1_L=handles.Sx1_L;
Sy1_L=handles.Sy1_L;
InfPtx1_L=handles.InfPtx1_L;
InfPty1_L=handles.InfPty1_L;


AV=handles.AV;
specimenID=handles.specimenID;
color=handles.color;

%% Graph samples


file_number=get(handles.listbox3,'Value');
if size(file_number)==1

end

cla(handles.axes1);

calculated_parameters=[Avg_Rut1(file_number);Avg_CS1(file_number);Avg_SS1(file_number);Avg_InfPt1(file_number)];
table_2_data=[AV(file_number);calculated_parameters];

%% Calculate Averages



p=get(handles.uibuttongroup19,'SelectedObject');
if p.Tag=='radiobutton57'
    axes(handles.axes1)
    hold(handles.axes1,'on')
    title(handles.axes1,specimenID(file_number));
plot(cyclesL{file_number},left{file_number}.*(-1),'b-',Cx1_L{file_number},Cy1_L{file_number},'g-',Sx1_L{file_number},Sy1_L{file_number},'r-',InfPtx1_L{file_number},InfPty1_L{file_number},'ko','LineWidth',2);
axis([0 20100 get(handles.slider2, 'Value') 0]);
%set(gca, 'XTickRabel', num2str(get(handles.axes1,'XTick')','%d'));
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Left Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');



end
if p.Tag=='radiobutton59'
    axes(handles.axes1)
    hold(handles.axes1,'on')
    title(handles.axes1,specimenID(file_number));
plot(cyclesR{file_number},right{file_number}.*(-1),'m-',Cx1_R{file_number},Cy1_R{file_number},'g-',Sx1_R{file_number},Sy1_R{file_number},'r-',InfPtx1_R{file_number},InfPty1_R{file_number},'ko','LineWidth',2);
axis([0 20100 get(handles.slider2, 'Value') 0]);
%set(gca, 'XTickRabel', num2str(get(handles.axes1,'XTick')','%d'));
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Right Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');

end
if p.Tag=='radiobutton61'
    axes(handles.axes1)
    hold(handles.axes1,'on')
    title(handles.axes1,specimenID(file_number));
plot(cyclesL{file_number},left{file_number}.*(-1),'b-',cyclesR{file_number},right{file_number}.*(-1),'m-','LineWidth',2);
axis([0 20100 get(handles.slider2, 'Value') 0]);
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Left Wheel','Right Wheel');

end
hold(handles.axes1, 'off');

guidata(hObject, handles);
% hObject    handle to the selected object in uibuttongroup19 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton61.
function radiobutton61_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton61



function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit48 as text
%        str2double(get(hObject,'String')) returns contents of edit48 as a double


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
set(hObject,'SliderStep',[1/20, 1/20]);
x=get(handles.slider2, 'Value');
set(handles.text94,'String',x);
axis(handles.axes1,([0 20100 x 0]));
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
set(hObject,'Min',-20);
set(hObject,'Max',0);
set(hObject,'Value',-20);
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
    if strcmp(getappdata(0,'logo'),'None')==1
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
 f = warndlg('\color{blue} Please Select Your Logo File from the Settings Menu of the RAAT-Pack Home Screen',...
             'Warning', opts);   
else
        RAATPack_folder=getappdata(0,'RAATPack_folder');
filename=handles.filename;
right=handles.right;
left=handles.left;
cyclesL=handles.cyclesL;
cyclesR=handles.cyclesR;
Avg_Rut1=handles.Avg_Rut1;
Avg_CS1=handles.Avg_CS1;
Avg_SS1=handles.Avg_SS1;
Avg_InfPt1=handles.Avg_InfPt1;
Max_Rut_left=handles.Max_Rut_left;
Stripping_Slope_left=handles.Stripping_Slope_left;
Creeping_Slope_left=handles.Creeping_Slope_left;
SIP_Ratio_left=handles.SIP_Ratio_left;
Inf_Pt_left=handles.Inf_Pt_left;
Max_Rut_right=handles.Max_Rut_right;
Stripping_Slope_right=handles.Stripping_Slope_right;
Creeping_Slope_right=handles.Creeping_Slope_right;
SIP_Ratio_right=handles.SIP_Ratio_right;
Inf_Pt_right=handles.Inf_Pt_right;
Cx1_R=handles.Cx1_R
Cy1_R=handles.Cy1_R;
Sx1_R=handles.Sx1_R;
Sy1_R=handles.Sy1_R;
InfPtx1_R=handles.InfPtx1_R;
InfPty1_R=handles.InfPty1_R;
Cx1_L=handles.Cx1_L;
Cy1_L=handles.Cy1_L;
Sx1_L=handles.Sx1_L;
Sy1_L=handles.Sy1_L;
InfPtx1_L=handles.InfPtx1_L;
InfPty1_L=handles.InfPty1_L;
AV=handles.AV;
specimenID=handles.specimenID;
color=handles.color;

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          file_number = listdlg('PromptString','Select the Sample to Export:',...
                      'SelectionMode','multiple',...
                      'ListString',specimenID);
calculated_parameters= [Max_Rut_left(file_number);Creeping_Slope_left(file_number);Stripping_Slope_left(file_number);Inf_Pt_left(file_number)];
calculated_parameterss= [Max_Rut_right(file_number);Creeping_Slope_right(file_number);Stripping_Slope_right(file_number);Inf_Pt_right(file_number)];

excel_data=[calculated_parameters,calculated_parameterss]';

%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges')
if admin_privileges_value == 0
    templatefile=[RAATPack_folder,'Templates\HAM Templates\HAM Template.xlsx'];
[savefile, savepath] = uiputfile(('*.pdf'),'Save',handles.foldername);
if isequal(savefile,0)
else

handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit11,'String'));
MixType=cellstr(get(handles.edit15,'String'));
TestTemp=cellstr(get(handles.edit31,'String'));
Institution=cellstr(get(handles.edit28,'String'));
Date=cellstr(get(handles.edit29,'String'));
Technician=cellstr(get(handles.edit30,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,excel_data,1,'B7');





xlswrite(savefullname_excel,cyclesL{file_number},2,'A3');
xlswrite(savefullname_excel,left{file_number},2,'B3');

xlswrite(savefullname_excel,cyclesR{file_number},2,'D3');
xlswrite(savefullname_excel,right{file_number},2,'E3');

xlswrite(savefullname_excel,Sx1_L{file_number}',2,'J3');
xlswrite(savefullname_excel,-Sy1_L{file_number}',2,'K3');
xlswrite(savefullname_excel,Cx1_L{file_number}',2,'M3');
xlswrite(savefullname_excel,-Cy1_L{file_number}',2,'N3');


xlswrite(savefullname_excel,Sx1_R{file_number}',2,'S3');
xlswrite(savefullname_excel,-Sy1_R{file_number}',2,'T3');
xlswrite(savefullname_excel,Cx1_R{file_number}',2,'V3');
xlswrite(savefullname_excel,-Cy1_R{file_number}',2,'W3');

xlswrite(savefullname_excel,InfPtx1_L{file_number},2,'P3');
xlswrite(savefullname_excel,InfPty1_L{file_number},2,'Q3');

xlswrite(savefullname_excel,InfPtx1_R{file_number},2,'Y3');
xlswrite(savefullname_excel,InfPty1_R{file_number},2,'Z3');




waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');
logo = getappdata(0,'logo'); 
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
Workbook = Excel.Workbooks.Open(sprintf('%s',savefullname_excel));
Sheets = Excel.ActiveWorkBook.Sheets;
Sheet1 = get(Sheets, 'Item', 1);
Sheet1.Activate;
Shapes = Sheet1.Shapes;
left = Excel.ActiveSheet.Range('A1').Left;
top = Excel.ActiveSheet.Range('A1').Top;
Shapes.AddPicture([logo] ,0,1,left,top,-1,-1);
invoke(Workbook, 'SaveAs', [savefullname_excel]);

hWorksheet = Workbook.Sheets.Item(1);
hWorksheet.ExportAsFixedFormat('xlTypePDF',savefullname_pdf);

% Close the workbook.
Workbook.Close(false);
% Shut down Excel.
Excel.Quit;

%% Delete excel file

delete(savefullname_excel);

waitbar(1,f,'Exporting. Please Wait...');
close(f);
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Hamburg session?'], ...
	'', ...
	'Yes','No','Yes');

switch answer
    case 'Yes'
currentdata = getappdata(gcf)
uisave('currentdata',handles.foldername);
    case 'No'
end
end

else
    templatefile=[RAATPack_folder,'Templates\HAM Templates\HAM Template_RU.xlsx'];
[savefile, savepath] = uiputfile(('*.xlsx'),'Save',handles.foldername);
if isequal(savefile,0)
else

handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit11,'String'));
MixType=cellstr(get(handles.edit15,'String'));
TestTemp=cellstr(get(handles.edit31,'String'));
Institution=cellstr(get(handles.edit28,'String'));
Date=cellstr(get(handles.edit29,'String'));
Technician=cellstr(get(handles.edit30,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,excel_data,1,'B7');





xlswrite(savefullname_excel,cyclesL{file_number},2,'A3');
xlswrite(savefullname_excel,left{file_number},2,'B3');

xlswrite(savefullname_excel,cyclesR{file_number},2,'D3');
xlswrite(savefullname_excel,right{file_number},2,'E3');

xlswrite(savefullname_excel,Sx1_L{file_number}',2,'J3');
xlswrite(savefullname_excel,-Sy1_L{file_number}',2,'K3');
xlswrite(savefullname_excel,Cx1_L{file_number}',2,'M3');
xlswrite(savefullname_excel,-Cy1_L{file_number}',2,'N3');


xlswrite(savefullname_excel,Sx1_R{file_number}',2,'S3');
xlswrite(savefullname_excel,-Sy1_R{file_number}',2,'T3');
xlswrite(savefullname_excel,Cx1_R{file_number}',2,'V3');
xlswrite(savefullname_excel,-Cy1_R{file_number}',2,'W3');

xlswrite(savefullname_excel,InfPtx1_L{file_number},2,'P3');
xlswrite(savefullname_excel,InfPty1_L{file_number},2,'Q3');

xlswrite(savefullname_excel,InfPtx1_R{file_number},2,'Y3');
xlswrite(savefullname_excel,InfPty1_R{file_number},2,'Z3');

waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');

logo = getappdata(0,'logo'); 
Excel = actxserver('Excel.Application');
Excel.DisplayAlerts = false; 
Workbook = Excel.Workbooks.Open(sprintf('%s',savefullname_excel));
Sheets = Excel.ActiveWorkBook.Sheets;
Sheet1 = get(Sheets, 'Item', 1);
Sheet1.Activate;
Shapes = Sheet1.Shapes;
left = Excel.ActiveSheet.Range('A1').Left;
top = Excel.ActiveSheet.Range('A1').Top;
Shapes.AddPicture([logo] ,0,1,left,top,-1,-1);
invoke(Workbook, 'SaveAs', [savefullname_excel]);
invoke(Workbook,'Close');
invoke(Excel,'Quit');

waitbar(1,f,'Exporting. Please Wait...');
close(f);
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this RAATPack session?'], ...
	'', ...
	'Yes','No','Yes');

switch answer
    case 'Yes'
currentdata = getappdata(gcf)
uisave('currentdata',handles.foldername);
    case 'No'
end
end
end
end
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
    RAATPack_folder=getappdata(0,'RAATPack_folder');
filename=handles.filename;
right=handles.right;
left=handles.left;
cyclesL=handles.cyclesL;
cyclesR=handles.cyclesR;
Avg_Rut1=handles.Avg_Rut1;
Avg_CS1=handles.Avg_CS1;
Avg_SS1=handles.Avg_SS1;
Avg_InfPt1=handles.Avg_InfPt1;
Max_Rut_left=handles.Max_Rut_left;
Stripping_Slope_left=handles.Stripping_Slope_left;
Creeping_Slope_left=handles.Creeping_Slope_left;
SIP_Ratio_left=handles.SIP_Ratio_left;
Inf_Pt_left=handles.Inf_Pt_left;
Max_Rut_right=handles.Max_Rut_right;
Stripping_Slope_right=handles.Stripping_Slope_right;
Creeping_Slope_right=handles.Creeping_Slope_right;
SIP_Ratio_right=handles.SIP_Ratio_right;
Inf_Pt_right=handles.Inf_Pt_right;
Cx1_R=handles.Cx1_R
Cy1_R=handles.Cy1_R;
Sx1_R=handles.Sx1_R;
Sy1_R=handles.Sy1_R;
InfPtx1_R=handles.InfPtx1_R;
InfPty1_R=handles.InfPty1_R;
Cx1_L=handles.Cx1_L;
Cy1_L=handles.Cy1_L;
Sx1_L=handles.Sx1_L;
Sy1_L=handles.Sy1_L;
InfPtx1_L=handles.InfPtx1_L;
InfPty1_L=handles.InfPty1_L;
AV=handles.AV;
specimenID=handles.specimenID;
color=handles.color;

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          file_number = listdlg('PromptString','Select the Sample to Export:',...
                      'SelectionMode','multiple',...
                      'ListString',specimenID);
calculated_parameters= [Max_Rut_left(file_number);Creeping_Slope_left(file_number);Stripping_Slope_left(file_number);Inf_Pt_left(file_number)];
calculated_parameterss= [Max_Rut_right(file_number);Creeping_Slope_right(file_number);Stripping_Slope_right(file_number);Inf_Pt_right(file_number)];

excel_data=[calculated_parameters,calculated_parameterss]';

%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges')
if admin_privileges_value == 0
    templatefile=[RAATPack_folder,'Templates\HAM Templates\HAM Template.xlsx'];
[savefile, savepath] = uiputfile(('*.pdf'),'Save',handles.foldername);
if isequal(savefile,0)
else

handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit11,'String'));
MixType=cellstr(get(handles.edit15,'String'));
TestTemp=cellstr(get(handles.edit31,'String'));
Institution=cellstr(get(handles.edit28,'String'));
Date=cellstr(get(handles.edit29,'String'));
Technician=cellstr(get(handles.edit30,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,excel_data,1,'B7');





xlswrite(savefullname_excel,cyclesL{file_number},2,'A3');
xlswrite(savefullname_excel,left{file_number},2,'B3');

xlswrite(savefullname_excel,cyclesR{file_number},2,'D3');
xlswrite(savefullname_excel,right{file_number},2,'E3');

xlswrite(savefullname_excel,Sx1_L{file_number}',2,'J3');
xlswrite(savefullname_excel,-Sy1_L{file_number}',2,'K3');
xlswrite(savefullname_excel,Cx1_L{file_number}',2,'M3');
xlswrite(savefullname_excel,-Cy1_L{file_number}',2,'N3');


xlswrite(savefullname_excel,Sx1_R{file_number}',2,'S3');
xlswrite(savefullname_excel,-Sy1_R{file_number}',2,'T3');
xlswrite(savefullname_excel,Cx1_R{file_number}',2,'V3');
xlswrite(savefullname_excel,-Cy1_R{file_number}',2,'W3');

xlswrite(savefullname_excel,InfPtx1_L{file_number},2,'P3');
xlswrite(savefullname_excel,InfPty1_L{file_number},2,'Q3');

xlswrite(savefullname_excel,InfPtx1_R{file_number},2,'Y3');
xlswrite(savefullname_excel,InfPty1_R{file_number},2,'Z3');




waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');
hExcel = actxserver('Excel.Application');
hWorkbook = hExcel.Workbooks.Open(sprintf('%s',savefullname_excel));
hWorksheet = hWorkbook.Sheets.Item(1);
hWorksheet.ExportAsFixedFormat('xlTypePDF',savefullname_pdf);

% Close the workbook.
hWorkbook.Close(false);
% Shut down Excel.
hExcel.Quit;

%% Delete excel file

delete(savefullname_excel);

waitbar(1,f,'Exporting. Please Wait...');
close(f);
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Hamburg session?'], ...
	'', ...
	'Yes','No','Yes');

switch answer
    case 'Yes'
currentdata = getappdata(gcf)
uisave('currentdata',handles.foldername);
    case 'No'
end
end

else
    templatefile=[RAATPack_folder,'Templates\HAM Templates\HAM Template_RU.xlsx'];
[savefile, savepath] = uiputfile(('*.xlsx'),'Save',handles.foldername);
if isequal(savefile,0)
else

handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit11,'String'));
MixType=cellstr(get(handles.edit15,'String'));
TestTemp=cellstr(get(handles.edit31,'String'));
Institution=cellstr(get(handles.edit28,'String'));
Date=cellstr(get(handles.edit29,'String'));
Technician=cellstr(get(handles.edit30,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,excel_data,1,'B7');





xlswrite(savefullname_excel,cyclesL{file_number},2,'A3');
xlswrite(savefullname_excel,left{file_number},2,'B3');

xlswrite(savefullname_excel,cyclesR{file_number},2,'D3');
xlswrite(savefullname_excel,right{file_number},2,'E3');

xlswrite(savefullname_excel,Sx1_L{file_number}',2,'J3');
xlswrite(savefullname_excel,-Sy1_L{file_number}',2,'K3');
xlswrite(savefullname_excel,Cx1_L{file_number}',2,'M3');
xlswrite(savefullname_excel,-Cy1_L{file_number}',2,'N3');


xlswrite(savefullname_excel,Sx1_R{file_number}',2,'S3');
xlswrite(savefullname_excel,-Sy1_R{file_number}',2,'T3');
xlswrite(savefullname_excel,Cx1_R{file_number}',2,'V3');
xlswrite(savefullname_excel,-Cy1_R{file_number}',2,'W3');

xlswrite(savefullname_excel,InfPtx1_L{file_number},2,'P3');
xlswrite(savefullname_excel,InfPty1_L{file_number},2,'Q3');

xlswrite(savefullname_excel,InfPtx1_R{file_number},2,'Y3');
xlswrite(savefullname_excel,InfPty1_R{file_number},2,'Z3');

waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');

hExcel = actxserver('Excel.Application');
hWorkbook = hExcel.Workbooks.Open(sprintf('%s',savefullname_excel));
hWorksheet = hWorkbook.Sheets.Item(1);

% Close the workbook.
hWorkbook.Close(false);
% Shut down Excel.
hExcel.Quit;

waitbar(1,f,'Exporting. Please Wait...');
close(f);
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this RAATPack session?'], ...
	'', ...
	'Yes','No','Yes');

switch answer
    case 'Yes'
currentdata = getappdata(gcf)
uisave('currentdata',handles.foldername);
    case 'No'
end
end

end
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
