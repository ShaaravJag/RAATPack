function varargout = BondGUI(varargin)
% BondGUI MATLAB code for BondGUI.fig
%      BondGUI, by itself, creates a new BondGUI or raises the existing
%      singleton*.
%
%      H = BondGUI returns the handle to a new BondGUI or the handle to
%      the existing singleton*.
%
%      BondGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BondGUI.M with the given input arguments.
%
%      BondGUI('Property','Value',...) creates a new BondGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BondGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BondGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BondGUI

% Last Modified by GUIDE v2.5 10-Dec-2019 00:03:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BondGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BondGUI_OutputFcn, ...
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


% --- Executes just before BondGUI is made visible.
function BondGUI_OpeningFcn(hObject, eventdata, handles, varargin)
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
fid = fopen('Configs\BondStrengthconfig.txt');
config_file = string(textscan(fid, '%s','delimiter','\n'));
fclose(fid);
set(handles.config_text,'String',config_file);

%[matlabImage,map,alpha] = imread([foldername,'\CAITLogo.png']);
%image(matlabImage,'AlphaData',alpha)
%axis off
%axis image
    
%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges');
if admin_privileges_value==1
set(handles.text71,'visible','on');
set(handles.edit28,'String','Rutgers University');
set(handles.edit29,'String',date);
set(handles.edit30,'String','Haas');
end

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BondGUI (see VARARGIN)

% Choose default command line output for BondGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BondGUI wait for user response (see UIRESUME)
% uiwait(handles.BONDfig);


% --- Outputs from this function are returned to the command line.
function varargout = BondGUI_OutputFcn(hObject, eventdata, handles) 
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
cellmat1(:,2) = cellmat1(:,2)*(-1); %load (kN)
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


% --- Executes on button press in pushbutton23.
function pushbutton30_Callback(hObject, eventdata, handles)
config_text=get(handles.config_text,'String');
file_selected=strcmp(config_text,'Default');
admin_privileges_value=getappdata(0,'admin_privileges');
    if file_selected==1 && admin_privileges_value==0
opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
uiwait(warndlg('\color{blue} The file configuration has not been set. Please enter configuration manually or select config file.',...
             'Memory Warning', opts));
else
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
C    = cell(1, number_of_files);
C(:) = {'File #'};
file_numbers=strcat(C,string(1:number_of_files));

%% Open files
RAATPack_folder=getappdata(0,'RAATPack_folder');
configfilename = get(handles.config_text,'String');
[x,y] = file_opener(configfilename,full_file_path,number_of_files);
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',file_numbers,'Data',cell(number_of_files,5),'ColumnEditable',true);

%% Set The Sample #s & File Names
tabledata=get(handles.uitable2,'Data');
tabledata(:,1)=filename;
set(handles.uitable2, 'Data',tabledata,'ColumnEditable',true);

close(f);
handles.x=x;
handles.y=y;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.filename=filename;
guidata(hObject,handles);
end
    end
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes when BONDfig is resized.
function BONDfig_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to BONDfig (see GCBO)
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
load(File_sample1);
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
RAATPack_folder_full=([tempdir,getenv('username'),'\mcrCache9.4\',RAATPack_folder,'\RAATPack_v2\Bond Strength\']);
foldername=RAATPack_folder_full;
IDEALCTGUI_direct=([foldername,'BondGUI.m']);
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

x=handles.x;
y=handles.y;



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
length=tabledata(:,4)';
diameter=tabledata(:,5)';

%% Set Graph Colors
cla(handles.axes5);
axes(handles.axes5);
hold(handles.axes5, 'on');
[graphdata,color]=cellfun(@colors,x,y,'UniformOutput',false);
set(handles.axes5, 'Visible','off');
hold(handles.axes5, 'off');
handles.color=color;
%% Set Listbox
set(handles.listbox3,'String',specimenID);
set(handles.listbox3,'Value',1);

%% Run Analysis
try
[peak,displacementatpeak,Bond_strength,length_in,diameter_in] = cellfun(@BondStrfinder,x,y,diameter,length,'UniformOutput',false);
calculated_parameters= [peak;displacementatpeak;Bond_strength]
%% Update Table with Sample 1
table_2_data=[AV;length_in;diameter_in;calculated_parameters];
averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));
for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end
table_2_data=[table_2_data,averages];
colnames=    [{'Air Voids (%)'}
    {'Length (in)'}
    {'Diameter (in)'}
    {'Peak Load (kN)'}
    {'Displacement at Peak Load (mm)'}
    {'Bond Strength (psi)'}];
set(handles.uitable1,'ColumnName',colnames); 
set(handles.uitable1,'RowName',[specimenID,{'Average'}]);
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');
set(handles.listbox3,'Value',([1:number_of_files]));

   
%% Graph first sample
max_yaxis=max(cellfun(@max,y));
max_xaxis=max(cellfun(@max,x));
cla(handles.axes1);
axes(handles.axes1);
cla(handles.axes1);
hold(handles.axes1, 'on');
graphdata=cellfun(@multiplotter,x,y,color,'UniformOutput',false);
xlabel(handles.axes1,'Displacement (mm)');
ylabel(handles.axes1,'Load (kN)');
axP = get(gca,'Position');
ylim(handles.axes1,[0 (max_yaxis+1)]);
xlim(handles.axes1,[0 (max_xaxis+1)]);
legend(handles.axes1,specimenID,'location','eastoutside');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');

%%
handles.peak=peak;
handles.Bond_strength=Bond_strength;
handles.specimenID=specimenID;
handles.AV=AV;
handles.length=length;
handles.displacementatpeak=displacementatpeak;
handles.diameter_in=diameter_in;
handles.length_in=length_in;

handles.diameter=diameter;
handles.x_for_export=x;
handles.y_for_export=y;
guidata(hObject,handles);
close(f);
catch
g = msgbox('Error occurred while running analysis. Please check your data and sample dimensions.', 'Error','error');
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
cla(handles.axes1);
file_number=get(handles.listbox3,'Value');
x=handles.x;
y=handles.y;
filename=handles.filename;
color=handles.color;

specimenID=handles.specimenID;
AV=handles.AV;
length=handles.length;
diameter=handles.diameter;
length_in=handles.length_in;
diameter_in=handles.diameter_in;
peak=handles.peak;
Bond_strength=handles.Bond_strength;
displacementatpeak=handles.displacementatpeak;

calculated_parameters= [peak(file_number);displacementatpeak(file_number);Bond_strength(file_number)];
table_2_data=[AV(file_number);length_in(file_number);diameter_in(file_number);calculated_parameters];

%% Calculate Averages
x=x(file_number);
y=y(file_number);
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


axes(handles.axes1);
hold(handles.axes1, 'on');
colors=color(file_number);
graphdata=cellfun(@multiplotter,x,y,colors,'UniformOutput',false);
xlabel(handles.axes1,'Displacement (mm)');
ylabel(handles.axes1,'Load (kN)');
axP = get(gca,'Position'); 
legend(handles.axes1,specimenID(file_number),'Location','eastoutside');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');


handles.x_for_export=x;
handles.y_for_export=y;
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
filename=handles.filename';
if get(handles.checkbox15,'value') ==1
[p b] = size(filename);
spaces=(cellstr(repmat(': ',b,1)))';
IDwfile=strcat(specimenID,spaces,filename);
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
set(handles.text62,'String',Fullname2);
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
    set(handles.text64,'visible','on')
    set(handles.popupmenu3,'visible','on')
    set(handles.popupmenu4,'visible','off') 
    set(handles.text72,'visible','off')
else
    set(handles.text64,'visible','off')
    set(handles.popupmenu3,'visible','off') 
    set(handles.popupmenu4,'visible','on') 
    set(handles.text72,'visible','on')
    [status,handles.sheets] = xlsfinfo(Fullname2);
set(handles.popupmenu4,'String',handles.sheets);

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
Filename_config=get(handles.text62,'String');
 if contains(Filename_config,'.xls') == 1
    opts = detectImportOptions(Filename_config,'Sheet',get(handles.popupmenu4,'Value'));
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
f = msgbox('Please enter a valid number for the displacement column.', 'Error','error');
error=1;
end
if isempty(get(handles.edit36,'String'))==1 || str2num(get(handles.edit36,'String'))==0 || str2num(get(handles.edit36,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the load column.', 'Error','error');
error=1;
end
if str2num(get(handles.edit37,'String'))~=0 && str2num(get(handles.edit36,'String'))~=0 && str2num(get(handles.edit37,'String'))==str2num(get(handles.edit36,'String'))
f = msgbox('Load and displacement columns may not be the same.', 'Error','error');
error=1;
end

%%
if contains(Filename_config,'.xls') == 1 || contains(Filename_config,'.xlsx') == 1
    opts.SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	opts.DataRange=[str2num(get(handles.edit35,'String')) Inf];
    opts.VariableNames= {'Displacement', 'Load', 'time','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    opts.Sheet=get(handles.popupmenu4,'Value');
    opts = setvartype(opts,'double');
    popupstrings=get(handles.popupmenu3,'String');
elseif contains(Filename_config,'.csv') == 1
opts.SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
opts.DataLines=[str2num(get(handles.edit35,'String')) Inf];
opts.VariableNames= {'Displacement', 'Load', 'time','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
opts.ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
opts.Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
end

xy_config=readtable(Filename_config,opts);
xy_config=xy_config(~any(ismissing(xy_config),2),:);
x_config=xy_config{:,1};
config=xy_config{:,2};

if isempty(config)==1
f = msgbox('Could not preview file. Please try a different delimiter or sheet.', 'Error','error');
error=1;
end

if error==1
else
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
end;
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
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

set(handles.edit35,'String',0);
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
        x_config=handles.x_config_original;
y_config=handles.y_config_original;

if(get(handles.checkbox17,'Value')==0 && get(handles.checkbox18,'Value')==0 && get(handles.checkbox16,'Value')==0)

    x_config=handles.x_config_original;
    
elseif(get(handles.checkbox17,'Value')==1 && get(handles.checkbox18,'Value')==0 && get(handles.checkbox16,'Value')==0)
    x_config=x_config-x_config(1);

elseif(get(handles.checkbox17,'Value')==1 && get(handles.checkbox18,'Value')==1 && get(handles.checkbox16,'Value')==0)
    x_config=-(x_config-x_config(1));

elseif(get(handles.checkbox17,'Value')==1 && get(handles.checkbox18,'Value')==1 && get(handles.checkbox16,'Value')==1)
    x_config=handles.x_config_original;
 
elseif(get(handles.checkbox17,'Value')==1 && get(handles.checkbox18,'Value')==0 && get(handles.checkbox16,'Value')==1)
    x_config=handles.x_config_original;    
       
elseif(get(handles.checkbox17,'Value')==0 && get(handles.checkbox18,'Value')==1 && get(handles.checkbox16,'Value')==1)
    x_config=-(x_config-x_config(end)); 

elseif(get(handles.checkbox17,'Value')==0 && get(handles.checkbox18,'Value')==1 && get(handles.checkbox16,'Value')==0)
    x_config=-x_config
    
elseif(get(handles.checkbox17,'Value')==0 && get(handles.checkbox18,'Value')==0 && get(handles.checkbox16,'Value')==1)
    x_config=x_config-x_config(end)
end

if(get(handles.checkbox19,'Value')==0 && get(handles.checkbox20,'Value')==0 && get(handles.checkbox21,'Value')==0)

    y_config=handles.y_config_original;
    
elseif(get(handles.checkbox19,'Value')==1 && get(handles.checkbox20,'Value')==0 && get(handles.checkbox21,'Value')==0)
    y_config=y_config-y_config(1);

elseif(get(handles.checkbox19,'Value')==1 && get(handles.checkbox20,'Value')==1 && get(handles.checkbox21,'Value')==0)
    y_config=-(y_config-y_config(1));

elseif(get(handles.checkbox19,'Value')==1 && get(handles.checkbox20,'Value')==1 && get(handles.checkbox21,'Value')==1)
    y_config=-(y_config-y_config(1));
 
elseif(get(handles.checkbox19,'Value')==1 && get(handles.checkbox20,'Value')==0 && get(handles.checkbox21,'Value')==1)
    y_config=handles.y_config_original;    
       
elseif(get(handles.checkbox19,'Value')==0 && get(handles.checkbox20,'Value')==1 && get(handles.checkbox21,'Value')==1)
    y_config=-(y_config-y_config(end)); 

elseif(get(handles.checkbox19,'Value')==0 && get(handles.checkbox20,'Value')==1 && get(handles.checkbox21,'Value')==0)
    y_config=-y_config
    
elseif(get(handles.checkbox19,'Value')==0 && get(handles.checkbox20,'Value')==0 && get(handles.checkbox21,'Value')==1)
    y_config=y_config-y_config(end)
end



xy_config1=[x_config,y_config];
plot(handles.axes4,x_config,y_config,'r-','Linewidth',3);
xlabel(handles.axes4,get(get(handles.uibuttongroup5,'SelectedObject'), 'String'));
ylabel(handles.axes4,get(get(handles.uibuttongroup4,'SelectedObject'), 'String'));
title(handles.axes4,'Preview');
set(handles.uitable5,'Data',xy_config1(1:13,:));
handles.x_config=x_config;
handles.y_config=y_config;
handles.xy_config1=xy_config1;
guidata(hObject,handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
x_config_original=handles.x_config_original;
y_config_original=handles.y_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value')];
[x_config,y_config]=data_transformer(x_config_original,y_config_original,checkboxes);
xy_config=[x_config,y_config];
plot(handles.axes4,x_config,y_config,'r-','Linewidth',3);
xlabel(handles.axes4,get(get(handles.uibuttongroup5,'SelectedObject'), 'String'));
ylabel(handles.axes4,get(get(handles.uibuttongroup4,'SelectedObject'), 'String'));
title(handles.axes4,'Preview');
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.x_config=x_config;
handles.y_config=y_config;
handles.xy_config1=xy_config;
guidata(hObject,handles);
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
x_config_original=handles.x_config_original;
y_config_original=handles.y_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value')];
[x_config,y_config]=data_transformer(x_config_original,y_config_original,checkboxes);
xy_config=[x_config,y_config];
plot(handles.axes4,x_config,y_config,'r-','Linewidth',3);
xlabel(handles.axes4,get(get(handles.uibuttongroup5,'SelectedObject'), 'String'));
ylabel(handles.axes4,get(get(handles.uibuttongroup4,'SelectedObject'), 'String'));
title(handles.axes4,'Preview');
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.x_config=x_config;
handles.y_config=y_config;
handles.xy_config1=xy_config;
guidata(hObject,handles);
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
x_config_original=handles.x_config_original;
y_config_original=handles.y_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value')];
[x_config,y_config]=data_transformer(x_config_original,y_config_original,checkboxes);
xy_config=[x_config,y_config];
plot(handles.axes4,x_config,y_config,'r-','Linewidth',3);
xlabel(handles.axes4,get(get(handles.uibuttongroup5,'SelectedObject'), 'String'));
ylabel(handles.axes4,get(get(handles.uibuttongroup4,'SelectedObject'), 'String'));
title(handles.axes4,'Preview');
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.x_config=x_config;
handles.y_config=y_config;
handles.xy_config1=xy_config;
guidata(hObject,handles);
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
x_config_original=handles.x_config_original;
y_config_original=handles.y_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value')];
[x_config,y_config]=data_transformer(x_config_original,y_config_original,checkboxes);
xy_config=[x_config,y_config];
plot(handles.axes4,x_config,y_config,'r-','Linewidth',3);
xlabel(handles.axes4,get(get(handles.uibuttongroup5,'SelectedObject'), 'String'));
ylabel(handles.axes4,get(get(handles.uibuttongroup4,'SelectedObject'), 'String'));
title(handles.axes4,'Preview');
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.x_config=x_config;
handles.y_config=y_config;
handles.xy_config1=xy_config;
guidata(hObject,handles);
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
x_config_original=handles.x_config_original;
y_config_original=handles.y_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value')];
[x_config,y_config]=data_transformer(x_config_original,y_config_original,checkboxes);
xy_config=[x_config,y_config];
plot(handles.axes4,x_config,y_config,'r-','Linewidth',3);
xlabel(handles.axes4,get(get(handles.uibuttongroup5,'SelectedObject'), 'String'));
ylabel(handles.axes4,get(get(handles.uibuttongroup4,'SelectedObject'), 'String'));
title(handles.axes4,'Preview');
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.x_config=x_config;
handles.y_config=y_config;
handles.xy_config1=xy_config;
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

if contains(get(handles.text62,'String'),'.csv') == 1
SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
DataLines=[str2num(get(handles.edit35,'String')) Inf];
VariableNames= {'tabledata', 'Displacement', 'Load'};
ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
Transformations=string({get(handles.checkbox17,'Value');get(handles.checkbox18,'Value');get(handles.checkbox16,'Value');get(handles.checkbox19,'Value');get(handles.checkbox20,'Value');get(handles.checkbox21,'Value')});
FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);DataLines(1);DataLines(2);VariableNames(2);VariableNames(3);Delimiter});
displacement_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
load_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
Units=string([{displacement_units};{load_units}]);
xlswrite(configfilename,FileConfig,'B1:B7');
xlswrite(configfilename,Transformations,'B8:B13');
xlswrite(configfilename,Units,'B14:B15');

end

if contains(get(handles.text62,'String'),'.xls') == 1 
    SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	DataRange=[str2num(get(handles.edit35,'String')) Inf];
    VariableNames= {'Displacement', 'Load', 'Time','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
    Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
    Sheett=get(handles.popupmenu4,'Value');
    Transformations=string({get(handles.checkbox17,'Value');get(handles.checkbox18,'Value');get(handles.checkbox16,'Value');get(handles.checkbox19,'Value');get(handles.checkbox20,'Value');get(handles.checkbox21,'Value')});
    FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);DataRange(1);DataRange(2);VariableNames(1);VariableNames(2);Delimiter});
    displacement_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
    load_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
    Units=string([{displacement_units};{load_units}]);
    xlswrite(configfilename,FileConfig,'B1:B7');
    xlswrite(configfilename,Transformations,'B8:B13');
    xlswrite(configfilename,Units,'B14:B15');
    xlswrite(configfilename,Sheett,1,'B16');
end

close(f);
labels=[{'Displacement'}
{'Load Start'}
{'Data Start'}
{'Data End'}
{'X'}
{'Y'}
{'Delimiter'}
{'Offset from Start (Disp)'}
{'Negative (Disp)'}
{'Offset from End (Disp)'}
{'Offset from Start (Load)'}
{'Negative (Load)'}
{'Offset from End (Load)'}
{'Displacement units'}
{'Load Units'}
{'Sheet'}]

xlswrite(configfilename,labels,'A1:A16');
config_file=([RAATPack_folder,'Configs\BondStrengthconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, configfilename);
fclose(fid);

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg(['\color{blue} The Bond Strength Configuration File has been updated.'],...
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
% hObject    handle to text62 (see GCBO)
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
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
xlabel(handles.axes4,['Displacement ' '(' x_label ')']);
ylabel(handles.axes4,['Load (' y_label ')']);
% hObject    handle to the selected object in uibuttongroup5 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup4.
function uibuttongroup4_SelectionChangedFcn(hObject, eventdata, handles)
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
xlabel(handles.axes4,['Displacement ' '(' x_label ')']);
ylabel(handles.axes4,['Load (' y_label ')']);
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
config_file=([RAATPack_folder,'Configs\BondStrengthconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, config_filename);
fclose(fid);
end
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
    try
   config_text=get(handles.config_text,'String');
file_selected=strcmp(config_text,'Default');
admin_privileges_value=getappdata(0,'admin_privileges');
    if file_selected==1 && admin_privileges_value==0
opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
uiwait(warndlg('\color{blue} The default file template will be used. Your data must be formatted for the RAATPack before opening.',...
             'Memory Warning', opts));
         OGfile_numbers=get(handles.uitable2,'RowName');
OGnumber_of_files=size(OGfile_numbers,1);
OGtabledata=get(handles.uitable2,'Data');
try
checks=isempty(OGfile_numbers{1})
catch 
OGfile_numbers={OGfile_numbers}    
end
if isempty(OGfile_numbers{1})==1
    OGfile_numbers=[];
    OGnumber_of_files=0;
    OGtabledata=[];
    OGx=[];
    OGy=[];
else
    OGx=handles.x;
OGy=handles.y;
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
configfilename= get(handles.config_text,'String');
if strcmp(get(handles.config_text,'String'),'Default')==1
configfilename=([RAATPack_folder,'Configs\BondStrength-Default.xlsx']);
end
[x,y] = file_opener(configfilename,full_file_path,number_of_files);
x=[OGx x];
y=[OGy y];

newtabledata=cell(number_of_files,5);
newtabledata(:,1)=filename;
tabledata=[OGtabledata;newtabledata];
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',[file_numbers],'Data',tabledata,'ColumnEditable',true);

%% Set The Sample #s & File Names

close(f);
handles.x=x;
handles.y=y;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.file_numbers=file_numbers;
handles.filename=tabledata(:,1);
guidata(hObject,handles);
end
         
    else

OGfile_numbers=get(handles.uitable2,'RowName');
OGnumber_of_files=size(OGfile_numbers,1);
OGtabledata=get(handles.uitable2,'Data');
try
checks=isempty(OGfile_numbers{1})
catch 
OGfile_numbers={OGfile_numbers}    
end
if isempty(OGfile_numbers{1})==1
    OGfile_numbers=[];
    OGnumber_of_files=0;
    OGtabledata=[];
    OGx=[];
    OGy=[];
else
    OGx=handles.x;
OGy=handles.y;
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
configfilename= get(handles.config_text,'String');
if strcmp(get(handles.config_text,'String'),'Default')==1
configfilename=([RAATPack_folder,'Configs\BondStrength-Default.xlsx']);
end
[x,y] = file_opener(configfilename,full_file_path,number_of_files);
x=[OGx x];
y=[OGy y];

newtabledata=cell(number_of_files,5);
newtabledata(:,1)=filename;
tabledata=[OGtabledata;newtabledata];
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',[file_numbers],'Data',tabledata,'ColumnEditable',true);

%% Set The Sample #s & File Names

close(f);
handles.x=x;
handles.y=y;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.file_numbers=file_numbers;
handles.filename=tabledata(:,1);
guidata(hObject,handles);
end
    end
    
    catch
g = msgbox('Error occurred while opening files. Please check your file formatting and try again.', 'Error','error');
close(f)
    end
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
tabledata=get(handles.uitable2,'Data');

handles.filename=tabledata(:,1);
    
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          removefiles = listdlg('PromptString','Select the Files to Remove:',...
                      'SelectionMode','multiple',...
                      'ListString',handles.filename);
                  tabledata(removefiles,:)=[];
handles.x(removefiles)=[];
handles.y(removefiles)=[];
handles.file_numbers(removefiles)=[];
handles.filename(removefiles)=[];                  
            

set(handles.uitable2,'RowName',[handles.file_numbers],'Data',tabledata,'ColumnEditable',true);                 
guidata(hObject,handles);
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
            if contains(handles.Fullname2,'.xls') ==1
    raw_data_file=readtable(handles.Fullname2,'Sheet',get(handles.popupmenu4,'Value'),'ReadVariableNames',false,'basic',1);
    set(handles.uitable6,'Data',table2cell(raw_data_file));
    value=get(handles.popupmenu4,'Value');
end
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
        set(handles.config_text,'String','Default');
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
    if strcmp(getappdata(0,'logo'),'None')==1
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
 f = warndlg('\color{blue} Please Select Your Logo File from the Settings Menu of the RAAT-Pack Home Screen',...
             'Warning', opts);   
else
        % Warning
if size(get(handles.listbox3,'value'),2)>12
opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg('\color{blue} Please Select 12 or Fewer Entries for Export',...
             'Memory Warning', opts);
else
    file_number=get(handles.listbox3,'Value');
x=handles.x;
y=handles.y;
filename=handles.filename;
color=handles.color;

specimenID=handles.specimenID;
AV=handles.AV;
length=handles.length;
diameter=handles.diameter;
length_in=handles.length_in;
diameter_in=handles.diameter_in;
displacementatpeak=handles.displacementatpeak;
peak=handles.peak;
Bond_strength=handles.Bond_strength;

calculated_parameters= [peak(file_number);displacementatpeak(file_number);Bond_strength(file_number)];
excel_data=[specimenID(file_number);AV(file_number);length_in(file_number);diameter_in(file_number);calculated_parameters];
    file_number=get(handles.listbox3,'value');
%% ADMIN Privileges?
RAATPack_folder=getappdata(0,'RAATPack_folder')
admin_privileges_value=getappdata(0,'admin_privileges')
if admin_privileges_value == 0
templatefile=([RAATPack_folder,'Templates\Bond Strength Templates\Bond Strength Summary Template Sheet',string(size(file_number,2)),'.xlsx']);
templatefile=strjoin(templatefile,'')
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


xlswrite(savefullname_excel,excel_data',1,'A7');
%% XY Data
x_for_export=handles.x_for_export;
y_for_export=handles.y_for_export;
number_of_files=size(get(handles.listbox3,'Value'),2);
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
xlswrite(savefullname_excel,xy_1,2,'A3');
catch
end
try
xy_2=cell2mat(S.(vars{2}));
xlswrite(savefullname_excel,xy_2,2,'D3');
catch
end
try
xy_3=cell2mat(S.(vars{3}));
xlswrite(savefullname_excel,xy_3,2,'G3');
catch
end
try
xy_4=cell2mat(S.(vars{4}));
xlswrite(savefullname_excel,xy_4,2,'J3');
catch
end
try
xy_5=cell2mat(S.(vars{5}));
xlswrite(savefullname_excel,xy_5,2,'M3');
catch
end
try
xy_6=cell2mat(S.(vars{6}));
xlswrite(savefullname_excel,xy_6,2,'P3');
catch
end
try
xy_7=cell2mat(S.(vars{7}));
xlswrite(savefullname_excel,xy_7,2,'S3');
catch
end
try
xy_8=cell2mat(S.(vars{8}));
xlswrite(savefullname_excel,xy_8,2,'V3');
catch
end
try
xy_9=cell2mat(S.(vars{9}));
xlswrite(savefullname_excel,xy_9,2,'Y3');
catch
end
try
xy_10=cell2mat(S.(vars{10}));
xlswrite(savefullname_excel,xy_10,2,'AB3');
catch
end
try
xy_11=cell2mat(S.(vars{11}));
xlswrite(savefullname_excel,xy_11,2,'AE3');
catch
end
try
xy_12=cell2mat(S.(vars{12}));
xlswrite(savefullname_excel,xy_12,2,'AH3');
catch
end

%% Pass/Fail
try
passfail=str2num(get(handles.edit34,'String'));
xlswrite(savefullname_excel,passfail,1,'F25');
catch
end

%%
waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'F2');
xlswrite(savefullname_excel,Date,1,'F3');
xlswrite(savefullname_excel,Technician,1,'F4');

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
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Bond Strength session?'], ...
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
%% ADMIN Privileges Enabled (Save Excel File)
    templatefile=[RAATPack_folder,'Templates\Bond Strength Templates\Bond Strength Summary Template Sheet',string(size(file_number,2)),'_RU.xlsx'];
templatefile=strjoin(templatefile,'')
[savefile, savepath] = uiputfile(('*.xlsx'),'Save',handles.foldername);
if isequal(savefile,0)
else

handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_excel = fullfile(savepath,savefile);
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

xlswrite(savefullname_excel,excel_data',1,'A7');
%% XY Data
x_for_export=handles.x_for_export;
y_for_export=handles.y_for_export;
number_of_files=size(get(handles.listbox3,'Value'),2);
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
xlswrite(savefullname_excel,xy_1,2,'A3');
catch
end
try
xy_2=cell2mat(S.(vars{2}));
xlswrite(savefullname_excel,xy_2,2,'D3');
catch
end
try
xy_3=cell2mat(S.(vars{3}));
xlswrite(savefullname_excel,xy_3,2,'G3');
catch
end
try
xy_4=cell2mat(S.(vars{4}));
xlswrite(savefullname_excel,xy_4,2,'J3');
catch
end
try
xy_5=cell2mat(S.(vars{5}));
xlswrite(savefullname_excel,xy_5,2,'M3');
catch
end
try
xy_6=cell2mat(S.(vars{6}));
xlswrite(savefullname_excel,xy_6,2,'P3');
catch
end
try
xy_7=cell2mat(S.(vars{7}));
xlswrite(savefullname_excel,xy_7,2,'S3');
catch
end
try
xy_8=cell2mat(S.(vars{8}));
xlswrite(savefullname_excel,xy_8,2,'V3');
catch
end
try
xy_9=cell2mat(S.(vars{9}));
xlswrite(savefullname_excel,xy_9,2,'Y3');
catch
end
try
xy_10=cell2mat(S.(vars{10}));
xlswrite(savefullname_excel,xy_10,2,'AB3');
catch
end
try
xy_11=cell2mat(S.(vars{11}));
xlswrite(savefullname_excel,xy_11,2,'AE3');
catch
end
try
xy_12=cell2mat(S.(vars{12}));
xlswrite(savefullname_excel,xy_12,2,'AH3');
catch
end




%% Pass/Fail
try
passfail=str2num(get(handles.edit34,'String'));
xlswrite(savefullname_excel,passfail,1,'F25');
catch
end






%%

waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'F2');
xlswrite(savefullname_excel,Date,1,'F3');
xlswrite(savefullname_excel,Technician,1,'F4');


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
    end
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
    % Warning
if size(get(handles.listbox3,'value'),2)>12
opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg('\color{blue} Please Select 12 or Fewer Entries for Export',...
             'Memory Warning', opts);
else
    file_number=get(handles.listbox3,'Value');
x=handles.x;
y=handles.y;
filename=handles.filename;
color=handles.color;

specimenID=handles.specimenID;
AV=handles.AV;
length=handles.length;
diameter=handles.diameter;
length_in=handles.length_in;
diameter_in=handles.diameter_in;
displacementatpeak=handles.displacementatpeak;
peak=handles.peak;
Bond_strength=handles.Bond_strength;

calculated_parameters= [peak(file_number);displacementatpeak(file_number);Bond_strength(file_number)];
excel_data=[specimenID(file_number);AV(file_number);length_in(file_number);diameter_in(file_number);calculated_parameters];
    file_number=get(handles.listbox3,'value');
%% ADMIN Privileges?
RAATPack_folder=getappdata(0,'RAATPack_folder')
admin_privileges_value=getappdata(0,'admin_privileges')
if admin_privileges_value == 0
templatefile=([RAATPack_folder,'Templates\Bond Strength Templates\Bond Strength Summary Template Sheet',string(size(file_number,2)),'.xlsx']);
templatefile=strjoin(templatefile,'')
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


xlswrite(savefullname_excel,excel_data',1,'A7');
%% XY Data
x_for_export=handles.x_for_export;
y_for_export=handles.y_for_export;
number_of_files=size(get(handles.listbox3,'Value'),2);
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
xlswrite(savefullname_excel,xy_1,2,'A3');
catch
end
try
xy_2=cell2mat(S.(vars{2}));
xlswrite(savefullname_excel,xy_2,2,'D3');
catch
end
try
xy_3=cell2mat(S.(vars{3}));
xlswrite(savefullname_excel,xy_3,2,'G3');
catch
end
try
xy_4=cell2mat(S.(vars{4}));
xlswrite(savefullname_excel,xy_4,2,'J3');
catch
end
try
xy_5=cell2mat(S.(vars{5}));
xlswrite(savefullname_excel,xy_5,2,'M3');
catch
end
try
xy_6=cell2mat(S.(vars{6}));
xlswrite(savefullname_excel,xy_6,2,'P3');
catch
end
try
xy_7=cell2mat(S.(vars{7}));
xlswrite(savefullname_excel,xy_7,2,'S3');
catch
end
try
xy_8=cell2mat(S.(vars{8}));
xlswrite(savefullname_excel,xy_8,2,'V3');
catch
end
try
xy_9=cell2mat(S.(vars{9}));
xlswrite(savefullname_excel,xy_9,2,'Y3');
catch
end
try
xy_10=cell2mat(S.(vars{10}));
xlswrite(savefullname_excel,xy_10,2,'AB3');
catch
end
try
xy_11=cell2mat(S.(vars{11}));
xlswrite(savefullname_excel,xy_11,2,'AE3');
catch
end
try
xy_12=cell2mat(S.(vars{12}));
xlswrite(savefullname_excel,xy_12,2,'AH3');
catch
end

%% Pass/Fail
try
passfail=str2num(get(handles.edit34,'String'));
xlswrite(savefullname_excel,passfail,1,'F25');
catch
end

%%
waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'F2');
xlswrite(savefullname_excel,Date,1,'F3');
xlswrite(savefullname_excel,Technician,1,'F4');

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
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Bond Strength session?'], ...
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
%% ADMIN Privileges Enabled (Save Excel File)
    templatefile=[RAATPack_folder,'Templates\Bond Strength Templates\Bond Strength Summary Template Sheet',string(size(file_number,2)),'_RU.xlsx'];
templatefile=strjoin(templatefile,'')
[savefile, savepath] = uiputfile(('*.xlsx'),'Save',handles.foldername);
if isequal(savefile,0)
else

handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_excel = fullfile(savepath,savefile);
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

xlswrite(savefullname_excel,excel_data',1,'A7');
%% XY Data
x_for_export=handles.x_for_export;
y_for_export=handles.y_for_export;
number_of_files=size(get(handles.listbox3,'Value'),2);
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
xlswrite(savefullname_excel,xy_1,2,'A3');
catch
end
try
xy_2=cell2mat(S.(vars{2}));
xlswrite(savefullname_excel,xy_2,2,'D3');
catch
end
try
xy_3=cell2mat(S.(vars{3}));
xlswrite(savefullname_excel,xy_3,2,'G3');
catch
end
try
xy_4=cell2mat(S.(vars{4}));
xlswrite(savefullname_excel,xy_4,2,'J3');
catch
end
try
xy_5=cell2mat(S.(vars{5}));
xlswrite(savefullname_excel,xy_5,2,'M3');
catch
end
try
xy_6=cell2mat(S.(vars{6}));
xlswrite(savefullname_excel,xy_6,2,'P3');
catch
end
try
xy_7=cell2mat(S.(vars{7}));
xlswrite(savefullname_excel,xy_7,2,'S3');
catch
end
try
xy_8=cell2mat(S.(vars{8}));
xlswrite(savefullname_excel,xy_8,2,'V3');
catch
end
try
xy_9=cell2mat(S.(vars{9}));
xlswrite(savefullname_excel,xy_9,2,'Y3');
catch
end
try
xy_10=cell2mat(S.(vars{10}));
xlswrite(savefullname_excel,xy_10,2,'AB3');
catch
end
try
xy_11=cell2mat(S.(vars{11}));
xlswrite(savefullname_excel,xy_11,2,'AE3');
catch
end
try
xy_12=cell2mat(S.(vars{12}));
xlswrite(savefullname_excel,xy_12,2,'AH3');
catch
end




%% Pass/Fail
try
passfail=str2num(get(handles.edit34,'String'));
xlswrite(savefullname_excel,passfail,1,'F25');
catch
end






%%

waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,TestTemp,1,'B4');
xlswrite(savefullname_excel,Institution,1,'F2');
xlswrite(savefullname_excel,Date,1,'F3');
xlswrite(savefullname_excel,Technician,1,'F4');


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
end
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
