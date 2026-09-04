function varargout = BeamGUI(varargin)
% BeamGUI MATLAB AASHTOe for BeamGUI.fig
%      BeamGUI, by itself, creates a new BeamGUI or raises the existing
%      singleton*.
%
%      H = BeamGUI returns the handle to a new BeamGUI or the handle to
%      the existing singleton*.
%
%      BeamGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BeamGUI.M with the given input arguments.
%
%      BeamGUI('Property','Value',...) creates a new BeamGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BeamGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BeamGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BeamGUI

% Last Modified by GUIDE v2.5 10-Dec-2019 00:05:59

% Begin initialization AASHTOe - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BeamGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BeamGUI_OutputFcn, ...
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
% End initialization AASHTOe - DO NOT EDIT


% --- Executes just before BeamGUI is made visible.
function BeamGUI_OpeningFcn(hObject, eventdata, handles, varargin)
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
fid = fopen('Configs\Beamconfig.txt');
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

end


% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BeamGUI (see VARARGIN)

% Choose default command line output for BeamGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BeamGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BeamGUI_OutputFcn(hObject, eventdata, handles) 
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

% Hint: place AASHTOe in OpeningFcn to populate axes1


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
cellmat1(:,2) = cellmat1(:,2)*(-1); %E (kN)
cellmat1(:,1) = cellmat1(1,1)-cellmat1(:,1); %flexural_stiffness (mm)
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
file_selected=strcmp(config_text,'none');
admin_privileges_value=getappdata(0,'admin_privileges');
    if file_selected==1 && admin_privileges_value==0
opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
uiwait(warndlg('\color{blue} The file configuration has not been set. Please enter configuration manually or select config file.',...
             'Memory Warning', opts));
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
    OGflexural_stiffness=[];
    OGE=[];
    OGcycles=[];
    OGnormalized_modulus=[];

else
OGflexural_stiffness=handles.flexural_stiffness;
OGE=handles.E;
OGcycles=handles.cycles;
OGnormalized_modulus=handles.normalized_modulus;
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
configfilename = get(handles.config_text,'String');
[cycles,flexural_stiffness,E,normalized_modulus] = beam_opener(configfilename,full_file_path,number_of_files);
cycles=[OGcycles cycles];
flexural_stiffness=[OGflexural_stiffness flexural_stiffness];
E=[OGE E];
normalized_modulus=[OGnormalized_modulus normalized_modulus];

newtabledata=cell(number_of_files,6);
newtabledata(:,1)=filename;
tabledata=[OGtabledata;newtabledata];
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',[file_numbers],'Data',tabledata,'ColumnEditable',true);

%% Set The Sample #s & File Names

close(f);
handles.cycles=cycles;
handles.flexural_stiffness=flexural_stiffness;
handles.E=E;
handles.normalized_modulus=normalized_modulus;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.filename=filename;
handles.file_numbers=file_numbers;
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
E(File_sample1);
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
RAATPack_folder_full=([tempdir,getenv('username'),'\mcrCache9.4\',RAATPack_folder,'\RAATPack_v2\BEAM\']);
foldername=RAATPack_folder_full;
IDEALCTGUI_direct=([foldername,'BeamGUI.m']);
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

cycles=handles.cycles;
flexural_stiffness=handles.flexural_stiffness;
E=handles.E;
normalized_modulus=handles.normalized_modulus;

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
width=tabledata(:,4)';
height=tabledata(:,5)';
length=tabledata(:,6)';
%% Set Graph Colors
x=cycles;
y=E;
axes(handles.axes5);
hold(handles.axes5, 'on');
[graphdata,color]=cellfun(@colors,x,y,'UniformOutput',false);
set(handles.axes5, 'Visible','off');
hold(handles.axes5, 'off');
%% Set Listbox
set(handles.listbox3,'String',specimenID);
set(handles.listbox3,'Value',1);

%% Run Analysis
cla(handles.axes1);
axes(handles.axes1);
try
[fit_values_AASHTO,fit_values_ASTM,x1,x2,x3,x4,x5,x6,rsq_ASTM,rsq_AASHTO,stiffness_N50,E_N50,A,b,nf50_AASHTO,nf50_ASTM,max_normalized_modulus,x_at_max] = cellfun(@Beamfinder,cycles, flexural_stiffness, E,normalized_modulus,'UniformOutput',false);
calculated_parameters= [stiffness_N50;A;b;rsq_AASHTO;nf50_AASHTO];
guidata(hObject,handles);
close(f);
%% Update Table with Sample 1
table_2_data=[AV;calculated_parameters];
averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));

if number_of_files==1
    averages=[];
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
if number_of_files==1
    rownames=specimenID;
else
rownames=[specimenID,{'Average'}];
end


colnames=    [{'Air Voids (%)'}
    {'Stiffness Measured at N50'}
    {'A'}
    {'b'}
    {'R^2'}
    {'nf,50'}];
set(handles.uitable1,'RowName',rownames); 
set(handles.uitable1,'ColumnName',colnames); 
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');
set(handles.listbox3,'Value',([1:number_of_files]));


%% Set Handles
handles.specimenID=specimenID;
handles.AV=AV;
handles.width=width;
handles.height=height;
handles.length=length;
handles.color=color;
handles.fit_values_AASHTO=fit_values_AASHTO;
handles.fit_values_ASTM=fit_values_ASTM;
handles.x1=x1;
handles.x2=x2;
handles.x3=x3;
handles.x4=x4;
handles.x5=x5;
handles.x6=x6;
handles.rsq_ASTM=rsq_ASTM;
handles.rsq_AASHTO=rsq_AASHTO;
handles.stiffness_N50=stiffness_N50;
handles.E_N50=E_N50;
handles.A=A;
handles.b=b;
handles.nf50_AASHTO=nf50_AASHTO;
handles.nf50_ASTM=nf50_ASTM;
handles.max_normalized_modulus=max_normalized_modulus;
handles.x_at_max=x_at_max;
guidata(hObject,handles);



%% Graph


axes(handles.axes1);
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter,cycles,flexural_stiffness,color,'UniformOutput',false);
xlabel(handles.axes1,'# of Cycles (n)');
ylabel(handles.axes1,'Flexural Stiffness (MPa)');
axP = get(gca,'Position');
xlim(handles.axes1,[1 1E8]);
ylim(handles.axes1,[100 100000]);
set(gca, 'Position', axP);
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter2,cycles,fit_values_AASHTO,color,'UniformOutput',false);
legend(handles.axes1,specimenID,'location','northwest');
hold(handles.axes1, 'off');
handles.cycles_for_export=cycles;
handles.flexural_stiffness_for_export=flexural_stiffness;
guidata(hObject, handles);
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
    filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
width=handles.width;
height=handles.height;
length=handles.length;
color=handles.color;
fit_values_AASHTO=handles.fit_values_AASHTO;
fit_values_ASTM=handles.fit_values_ASTM;
x1=handles.x1;
x2=handles.x2;
x3=handles.x3;
x4=handles.x4;
x5=handles.x5;
x6=handles.x6;
rsq_ASTM=handles.rsq_ASTM;
rsq_AASHTO=handles.rsq_AASHTO;
stiffness_N50=handles.stiffness_N50;
A=handles.A;
b=handles.b;
E=handles.E;
cycles=handles.cycles;
normalized_modulus=handles.normalized_modulus;
flexural_stiffness=handles.flexural_stiffness;
nf50_AASHTO=handles.nf50_AASHTO;
nf50_ASTM=handles.nf50_ASTM;
max_normalized_modulus=handles.max_normalized_modulus;
x_at_max=handles.x_at_max;
color=handles.color;
file_number=get(handles.listbox3,'Value');
cycles=cycles(file_number);
E=E(file_number);
colors=color(file_number);
flexural_stiffness=flexural_stiffness(file_number);
fit_values_AASHTO=fit_values_AASHTO(file_number);
fit_values_ASTM=fit_values_ASTM(file_number);
normalized_modulus=normalized_modulus(file_number);
analysis=get(get(handles.uibuttongroup18,'SelectedObject'),'Tag');
if analysis=='radiobutton57'
    
%% Table 
calculated_parameters= [stiffness_N50(file_number);A(file_number);b(file_number);rsq_AASHTO(file_number);nf50_AASHTO(file_number)];
table_2_data=[AV(file_number);calculated_parameters];
colnames=    [{'Air Voids (%)'}
    {'Stiffness Measured at N50'}
    {'A'}
    {'b'}
    {'R^2'}
    {'nf,50'}];
%% Graph
cla(handles.axes1,'reset');
hold(handles.axes1, 'on');
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
graphdata=cellfun(@Beamplotter,cycles,flexural_stiffness,colors,'UniformOutput',false);
xlabel(handles.axes1,'# of Cycles (n)');
ylabel(handles.axes1,'Flexural Stiffness (MPa)');
axP = get(gca,'Position');
xlim(handles.axes1,[1 1E8]);
ylim(handles.axes1,[100 100000]);
set(gca, 'Position', axP);
set(handles.axes1, 'YScale', 'log');
set(handles.axes1, 'XScale', 'log');
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter2,cycles,fit_values_AASHTO,colors,'UniformOutput',false);
legend(handles.axes1,specimenID(file_number),'location','northwest');

hold(handles.axes1, 'off');
handles.cycles_for_export=cycles;
handles.flexural_stiffness_for_export=flexural_stiffness;
handles.E_for_export=E;
guidata(hObject, handles);



elseif analysis=='radiobutton58'
    
%% Table
calculated_parameters= [x6(file_number);x5(file_number);x4(file_number);x3(file_number);x2(file_number);x1(file_number);rsq_ASTM(file_number);nf50_ASTM(file_number);x_at_max(file_number)];
table_2_data=[AV(file_number);calculated_parameters];
colnames=    [{'Air Voids (%)'}
    {'a'}
    {'b'}
    {'c'}
    {'d'}
    {'e'}
    {'f'}
    {'R^2'}
    {'nf,50'}
    {'n at max'}];

%% Graph
cla(handles.axes1,'reset');
hold(handles.axes1, 'on');
set(gca, 'YScale', 'linear');
set(gca, 'XScale', 'linear');
graphdata=cellfun(@Beamplotter,cycles,normalized_modulus,colors,'UniformOutput',false);
xlabel(handles.axes1,'# of Cycles (n)');
ylabel(handles.axes1,'Normalized Modulus (MPa)');
axP = get(gca,'Position');
max_xaxis=max(cellfun(@max,cycles));
max_yaxis=max(cellfun(@max,normalized_modulus));
ylim(handles.axes1,[0 (max_yaxis+100)]);
xlim(handles.axes1,[0 (max_xaxis+20000)]);
set(gca, 'Position', axP);
set(handles.axes1, 'YScale', 'linear');
set(handles.axes1, 'XScale', 'linear');
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter2,cycles,fit_values_ASTM,colors,'UniformOutput',false);

legend(handles.axes1,specimenID(file_number),'location','northwest');

hold(handles.axes1, 'off');
guidata(hObject, handles);

end

if(size(get(handles.listbox3,'Value'))==1)
    averages=[];
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
set(handles.uitable1,'ColumnName',colnames);
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');
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
spaces=(cellstr(repmat(": ",b,1)))';
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
    set(handles.text64,'visible','on')
    set(handles.popupmenu3,'visible','on')
    set(handles.popupmenu6,'visible','off') 
    set(handles.text91,'visible','off')
else
    set(handles.text64,'visible','off')
    set(handles.popupmenu3,'visible','off') 
    set(handles.popupmenu6,'visible','on') 
    set(handles.text91,'visible','on')
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
Filename_config=get(handles.text64,'String');

if contains(Filename_config,'.xls') == 1
    opts = detectImportOptions(Filename_config);
    opts.SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	opts.DataRange=[str2num(get(handles.edit37,'String')) Inf];
    opts.VariableNames= {'flexural_stiffness', 'E', 'cycles','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
elseif contains(Filename_config,'.csv') == 1
    
opts = detectImportOptions(Filename_config);
opts.SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
opts.DataLines=[str2num(get(handles.edit37,'String')) Inf];
opts.VariableNames= {'flexural_stiffness', 'E', 'cycles','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
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
xlabel(handles.axes4,['flexural_stiffness ' '(' x_label ')']);
ylabel(handles.axes4,['E (' y_label ')']);
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
AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
VariableNames= {'tabledata', 'flexural_stiffness', 'E'};
ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);DataLines(1);DataLines(2);VariableNames(2);VariableNames(3);Delimiter});
flexural_stiffness_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
E_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
Units=string([{flexural_stiffness_units};{E_units}]);
xlswrite(configfilename,FileConfig,'B1:B7');
xlswrite(configfilename,Units,'B14:B15');
end

if contains(get(handles.text64,'String'),'.xls') == 1
    SelectedVariableNames = [str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	DataRange=[str2num(get(handles.edit37,'String')) Inf];
    VariableNames= {'flexural_stiffness', 'E', 'cycles','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
    Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
    FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);DataRange(1);DataRange(2);VariableNames(1);VariableNames(2);Delimiter});
    flexural_stiffness_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
    E_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
    Units=string([{flexural_stiffness_units};{E_units}]);
    xlswrite(configfilename,FileConfig,'B1:B7');
    xlswrite(configfilename,Units,'B14:B15');
end

close(f);
labels=[{'Cycles'}
{'Flexural Stiffness'}
{'Elastic Modulus'}
{'Data Start'}
{'Data End'}
{'X'}
{'Y'}
{'Delimiter'}
{'Flexural Stiffness Units'}
{'E Units'}]

xlswrite(configfilename,labels,'A1:A9');
config_file=([RAATPack_folder,'Configs\Beamconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, configfilename);
fclose(fid);

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg(['\color{blue} The Beam Configuration File has been updated.'],...
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
config_file=([RAATPack_folder,'Configs\Beamconfig.txt']);
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
if isempty(get(handles.edit38,'String'))==1 || str2num(get(handles.edit38,'String'))==0 | str2num(get(handles.edit38,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the cycles column.', 'Error','error');
error=1;
end
if isempty(get(handles.edit37,'String'))==1 || str2num(get(handles.edit37,'String'))==0 || str2num(get(handles.edit37,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the flexural stiffness column.', 'Error','error');
error=1;
end
if isempty(get(handles.edit36,'String'))==1 || str2num(get(handles.edit36,'String'))==0 || str2num(get(handles.edit36,'String'))>size(opts.VariableOptions,2)
f = msgbox('Please enter a valid number for the dynamic modulus column.', 'Error','error');
error=1;
end
if str2num(get(handles.edit38,'String'))~=0 && str2num(get(handles.edit37,'String'))~=0 && str2num(get(handles.edit38,'String'))==str2num(get(handles.edit37,'String'))
f = msgbox('Cycle and flexural stiffness columns may not be the same.', 'Error','error');
error=1;
end
if str2num(get(handles.edit38,'String'))~=0 && str2num(get(handles.edit36,'String'))~=0 && str2num(get(handles.edit38,'String'))==str2num(get(handles.edit36,'String'))
f = msgbox('Cycle and dynamic modulus columns may not be the same.', 'Error','error');
error=1;
end
if str2num(get(handles.edit36,'String'))~=0 && str2num(get(handles.edit37,'String'))~=0 && str2num(get(handles.edit36,'String'))==str2num(get(handles.edit37,'String'))
f = msgbox('Flexural stiffness and dynamic modulus columns may not be the same.', 'Error','error');
error=1;
end

if contains(Filename_config,'.xls') == 1
    opts.SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
    opts.DataRange=[str2num(get(handles.edit37,'String')) Inf];
    opts.Sheet=get(handles.popupmenu6,'Value');
    opts.VariableNames= {'cycles', 'flexural_stiffness', 'E','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
opts = setvartype(opts,'double');
elseif contains(Filename_config,'.csv') == 1    
opts.SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
opts.DataLines=[str2num(get(handles.edit37,'String')) Inf];
opts.VariableNames= {'cycles', 'flexural_stiffness', 'E','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
opts.ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
opts.Delimiter = popupstrings{get(handles.popupmenu3,'Value')};

end

data_config=readtable(Filename_config,opts);
data_config=data_config(~any(ismissing(data_config),2),:);
cycles_config=data_config{:,1};
flexural_stiffness_config=data_config{:,2};
E_config=data_config{:,3};


if isempty(E_config)==1
f = msgbox('Could not preview file. Please try a different delimiter or sheet.', 'Error','error');
error=1;
end

plot(handles.axes4,cycles_config,E_config,'r-','Linewidth',3);
xlabel(handles.axes4,['# of Cycles']);
ylabel(handles.axes4,['Elastic Modulus (' get(get(handles.uibuttongroup4,'SelectedObject'), 'String') ')']);
set(handles.radiobutton37,'Value',1)
title(handles.axes4,'Preview');

set(handles.uitable5,'Data',table2cell(data_config(1:15,:)));

handles.E_config_original=E_config;
handles.cycles_config_original=cycles_config;
handles.flexural_stiffness_config_original=flexural_stiffness_config;
handles.data_config_original=data_config;

handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.flexural_stiffness_config=flexural_stiffness_config;
handles.data_config=data_config;

guidata(hObject,handles)
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

set(handles.edit35,'String',0);
set(handles.edit36,'String',0);
set(handles.edit37,'String',0);
set(handles.edit38,'String',0);
set(handles.popupmenu3,'Value',5);
set(handles.uitable5,'Data',{});


cla(handles.axes4);
handles.x_config_original=0;
handles.y_config_original=0;
guidata(hObject,handles)
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
SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
DataLines=[str2num(get(handles.edit35,'String')) Inf];
VariableNames= {'tabledata', 'Cycles', 'Flexural Stiffness','Elastic Modulus'};
ExtraColumnsRule = 'ignore';
popupstrings=get(handles.popupmenu3,'String');
Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);SelectedVariableNames(3);DataLines(1);DataLines(2);VariableNames(2);VariableNames(3);VariableNames(4);Delimiter});
    flexural_stiffness_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
    E_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
Units=string([{flexural_stiffness_units};{E_units}]);
xlswrite(configfilename,FileConfig,'B1:B9');
xlswrite(configfilename,Units,'B10:B111');
end

if contains(get(handles.text64,'String'),'.xls') == 1
    SelectedVariableNames = [str2num(get(handles.edit38,'String')) str2num(get(handles.edit37,'String')) str2num(get(handles.edit36,'String'))];
	DataRange=[str2num(get(handles.edit35,'String')) Inf];
    VariableNames= {'Cycles', 'Flexural Stiffness', 'Elastic Modulus','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    popupstrings=get(handles.popupmenu3,'String');
    Delimiter = popupstrings{get(handles.popupmenu3,'Value')};
Sheett=get(handles.popupmenu6,'Value');
    FileConfig=string({SelectedVariableNames(1);SelectedVariableNames(2);SelectedVariableNames(3);DataRange(1);DataRange(2);VariableNames(1);VariableNames(2);VariableNames(3);Delimiter});
    flexural_stiffness_units=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
    E_units=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
Units=string([{flexural_stiffness_units};{E_units}]);
xlswrite(configfilename,FileConfig,'B1:B9');
xlswrite(configfilename,Units,'B10:B11');
xlswrite(configfilename,Sheett,1,'B12');
end

close(f);
labels=[{'Cycles'}
{'Flexural Stiffness'}
{'Elastic Modulus'}
{'Data Start'}
{'Data End'}
{'X'}
{'Y1'}
{'Y2'}
{'Delimiter'}
{'Flexural Stiffness Units'}
{'E Units'}
{'Sheet'}]

xlswrite(configfilename,labels,'A1:A12');
config_file=([RAATPack_folder,'Configs\Beamconfig.txt']);
fid = fopen(config_file, 'wt');
fwrite(fid, configfilename);
fclose(fid);

opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
f = warndlg(['\color{blue} The Beam Configuration File has been updated.'],...
             'Notification', opts);

% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox16.
function checkbox22_Callback(hObject, eventdata, handles)
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
if(get(handles.checkbox28,'Value'))==0
cla(handles.axes1);
file_number=get(handles.listbox3,'Value');
filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
width=handles.width;
height=handles.height;
length=handles.length;
cycles=handles.cycles;
flexural_stiffness=handles.flexural_stiffness;
E=handles.E;
AASHTO=handles.AASHTO;
cycles=handles.cycles;
AASHTO=handles.AASHTO;
peakE=handles.peakE;
flexural_stiffnessatpeak=handles.flexural_stiffnessatpeak;
cyclesatpeak=handles.cyclesatpeak;
testduration=handles.testduration;
Gf=handles.Gf;
slope=handles.slope;
b=handles.b;

color=handles.color;

calculated_parameters= [peakE(file_number);flexural_stiffnessatpeak(file_number);cyclesatpeak(file_number);testduration(file_number);Gf(file_number);slope(file_number)];
table_2_data=[specimenID(file_number);AV(file_number);width(file_number);height(file_number);length(file_number);calculated_parameters];

%% Calculate Averages
max_yaxis=max(cellfun(@max,E));
max_xaxis=max(cellfun(@max,cycles));
cycles=cycles(file_number);
E=E(file_number);

averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));
averages=[{['Average']}; averages(2:end)];
for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end
table_2_data=[averages,table_2_data];
axes(handles.axes1);
hold(handles.axes1, 'on');
colors=color(file_number);
graphdata=cellfun(@multiplotter,cycles,E,colors,'UniformOutput',false);
xlabel(handles.axes1,'AASHTO (mm)');
ylabel(handles.axes1,'E (kN)');
axP = get(gca,'Position');
ylim(handles.axes1,[0 (max_yaxis+1)]);
xlim(handles.axes1,[0 (max_xaxis+1)]);
legend(handles.axes1,specimenID(file_number),'location','northeast');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');
set(handles.uitable1,'Data',table_2_data);
RAATPack_v2=cycles;
handles.E_for_export=E;
guidata(hObject, handles);
elseif get(handles.checkbox28,'Value')==1
    cla(handles.axes1);
    number_of_files=handles.number_of_files;
file_number=get(handles.listbox3,'Value');
filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
height=handles.height;
length=handles.length;
cycles=handles.cycles;
flexural_stiffness=handles.flexural_stiffness;
width=handles.width;
E=handles.E;
AASHTO=handles.AASHTO;
cycles=handles.cycles;
AASHTO=handles.AASHTO;
peakE=handles.peakE;
flexural_stiffnessatpeak=handles.flexural_stiffnessatpeak;
cyclesatpeak=handles.cyclesatpeak;
testduration=handles.testduration;
Gf=handles.Gf;
slope=handles.slope;
b=handles.b;

color=handles.color;

calculated_parameters= [peakE(file_number);flexural_stiffnessatpeak(file_number);cyclesatpeak(file_number);testduration(file_number);Gf(file_number);slope(file_number)];
table_2_data=[specimenID(file_number);AV(file_number);width(file_number);height(file_number);length(file_number);calculated_parameters];

%% Calculate Averages
max_xaxis=max(cellfun(@max,cycles));
max_yaxis=max(cellfun(@max,AASHTO));
AASHTO=AASHTO(file_number);
cycles=cycles(file_number);

averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));
averages=[{['Average']}; averages(2:end)];
for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end
table_2_data=[averages,table_2_data];
axes(handles.axes1);
hold(handles.axes1, 'on');
colors=color(file_number);
graphdata=cellfun(@multiplotter,cycles,AASHTO,colors,'UniformOutput',false);

xlabel(handles.axes1,'cycles (sec)');
ylabel(handles.axes1,'AASHTO (mm)');
axP = get(gca,'Position');
ylim(handles.axes1,[0 (max_yaxis+1)]);
xlim(handles.axes1,[0 (max_xaxis+1)]);
slope=slope(file_number);
b=b(file_number);
legend_text(1:(size(file_number,2)))={': '};
legend_text2(1:(size(file_number,2)))={'x + '};
AASHTO_verification=[string(slope);legend_text2;b];
AASHTO_verification=strcat(string(specimenID(file_number)),legend_text,string(slope),legend_text2,string(b))';
legend(handles.axes1,AASHTO_verification,'location','northwest');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');
set(handles.uitable1,'Data',table_2_data);
handles.cycles_for_export=cycles;
handles.E_for_export=E;
guidata(hObject, handles);
end
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox23.
function checkbox29_Callback(hObject, eventdata, handles)
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
    AASHTO_config_original=handles.AASHTO_config_original;
E_config_original=handles.E_config_original;
flexural_stiffness_config_original=handles.flexural_stiffness_config_original;
cycles_config_original=handles.cycles_config_original;
checkboxes = [get(handles.checkbox17,'Value') get(handles.checkbox18,'Value') get(handles.checkbox16,'Value') get(handles.checkbox19,'Value') get(handles.checkbox20,'Value') get(handles.checkbox21,'Value') get(handles.checkbox23,'Value') get(handles.checkbox24,'Value') get(handles.checkbox22,'Value') get(handles.checkbox25,'Value') get(handles.checkbox26,'Value') get(handles.checkbox27,'Value')];
[cycles_config,flexural_stiffness_config,AASHTO_config,E_config] = Beam_transformer(AASHTO_config_original,E_config_original,flexural_stiffness_config_original,cycles_config_original,checkboxes);
xy_config=[cycles_config,flexural_stiffness_config,E_config,AASHTO_config];
set(handles.uitable5,'Data',xy_config(1:13,:));
handles.AASHTO_config=AASHTO_config;
handles.E_config=E_config;
handles.cycles_config=cycles_config;
handles.AASHTO_config=AASHTO_config;
handles.AASHTOy_config=xy_config;

x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis =='radiobutton30'
    x_plot = AASHTO_config;
    x_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis =='radiobutton34'
    y_plot = AASHTO_config;
    y_label=get(get(handles.uibuttongroup7,'SelectedObject'), 'String');
elseif y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
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
E_config=handles.E_config;
cycles_config=handles.cycles_config;
data_config=handles.data_config;
flexural_stiffness_config=handles.flexural_stiffness_config;
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');

x_plot=cycles_config;
if y_axis=='radiobutton37'
    y_plot=E_config;
    plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
    
    ylabel(handles.axes4,'Elastic Modulus (MPa)');
elseif y_axis=='radiobutton36'
    y_plot=flexural_stiffness_config;
    plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
    
    ylabel(handles.axes4,'Flexural Stiffness (MPa)');
end

xlabel(handles.axes4,'# of Cycles');


guidata(hObject,handles);
% hObject    handle to the selected object in uibuttongroup10 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup9.
function uibuttongroup9_SelectionChangedFcn(hObject, eventdata, handles)
E_config=handles.E_config;
cycles_config=handles.cycles_config;
data_config=handles.data_config;
flexural_stiffness_config=handles.flexural_stiffness_config;
x_axis=get(get(handles.uibuttongroup9,'SelectedObject'),'Tag');
y_axis=get(get(handles.uibuttongroup10,'SelectedObject'),'Tag');
if x_axis=='radiobutton31'
    x_plot= flexural_stiffness_config;
    x_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif x_axis=='radiobutton32'
    x_plot=E_config;
    x_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif x_axis=='radiobutton33'
    x_plot=cycles_config;
    x_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
if y_axis=='radiobutton35'
    y_plot= flexural_stiffness_config;
    y_label=get(get(handles.uibuttongroup5,'SelectedObject'), 'String');
elseif y_axis=='radiobutton36'
    y_plot=E_config;
    y_label=get(get(handles.uibuttongroup4,'SelectedObject'), 'String');
elseif y_axis=='radiobutton37'
    y_plot=cycles_config;
    y_label=get(get(handles.uibuttongroup8,'SelectedObject'), 'String');
end
plot(handles.axes4,x_plot,y_plot,'r-','Linewidth',3);
xlabel(handles.axes4,[get(get(handles.uibuttongroup9,'SelectedObject'),'String') ' (' x_label ')']);
ylabel(handles.axes4,[get(get(handles.uibuttongroup10,'SelectedObject'),'String') ' (' y_label ')']);


guidata(hObject,handles);
% hObject    handle to the selected object in uibuttongroup9 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox35.
function checkbox35_Callback(hObject, eventdata, handles)
    set(handles.checkbox36,'value',0);
    cla(handles.axes1);
file_number=get(handles.listbox3,'Value');
filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
width=handles.width;
height=handles.height;
length=handles.length;
color=handles.color;
fit_values_AASHTO=handles.fit_values_AASHTO;
fit_values_ASTM=handles.fit_values_ASTM;
x1=handles.x1;
x2=handles.x2;
x3=handles.x3;
x4=handles.x4;
x5=handles.x5;
x6=handles.x6;
rsq_ASTM=handles.rsq_ASTM;
rsq_AASHTO=handles.rsq_AASHTO;
stiffness_N50=handles.stiffness_N50;
A=handles.A;
b=handles.b;
E=handles.E;
cycles=handles.cycles;
flexural_stiffness=handles.flexural_stiffness;
nf50_AASHTO=handles.nf50_AASHTO;
nf50_ASTM=handles.nf50_ASTM;
max_normalized_modulus=handles.max_normalized_modulus;
x_at_max=handles.x_at_max;

color=handles.color;

calculated_parameters= [stiffness_N50(file_number);A(file_number);b(file_number);nf50_AASHTO(file_number)];
table_2_data=[specimenID(file_number);AV(file_number);calculated_parameters];

%% Calculate Averages
max_yaxis=max(cellfun(@max,E));
max_xaxis=max(cellfun(@max,cycles));
cycles=cycles(file_number);
E=E(file_number);
flexural_stiffness=flexural_stiffness(file_number);
fit_values_AASHTO=fit_values_AASHTO(file_number);

averages=cellfun(@mean,table_2_data);
averages=num2cell(mean(averages,2));
averages=[{['Average']}; averages(2:end)];
averages{3}=round(averages{3});
averages{end}=round(averages{end});
for k = 1:numel(averages);
  if isnan(averages{k});
    averages{k} = [];
  end
end
table_2_data=[averages,table_2_data];
axes(handles.axes1);
hold(handles.axes1, 'on');
colors=color(file_number);


graphdata=cellfun(@Beamplotter,cycles,flexural_stiffness,colors,'UniformOutput',false);
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter2,cycles,fit_values_AASHTO,colors,'UniformOutput',false);
xlabel(handles.axes1,'Loading Cycles (n)');
ylabel(handles.axes1,'Flexural Stiffness (MPa)');
xlim(handles.axes1,[1 1E8]);
ylim(handles.axes1,[100 100000]);
axP = get(gca,'Position');
legend(handles.axes1,specimenID(file_number),'location','northeast');
set(gca, 'Position', axP);
hold(handles.axes1, 'off');
colnames=    [{'Specimen ID'}
    {'Air Voids (%)'}
    {'Stiffness Measured at N50'}
    {'A'}
    {'b'}
    {'nf,50'}];
set(handles.uitable1,'ColumnName',colnames); 
columnformat=[{'shortg'}, {'short'}, {'shortg'} ,{'shorte'}, {'shorte'}, {'shortg'}];
set(handles.uitable1,'Data',table_2_data','ColumnFormat',columnformat,'ColumnWidth','Auto');

handles.flexural_stiffness_for_export=flexural_stiffness;
handles.cycles_for_export=cycles;
handles.E_for_export=E;
guidata(hObject, handles);

% hObject    handle to checkbox35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox35


% --- Executes on button press in checkbox36.
function checkbox36_Callback(hObject, eventdata, handles)
        set(handles.checkbox35,'value',0);
% hObject    handle to checkbox36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox36


% --- Executes during object creation, after setting all properties.
function pushbutton15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton57.
function radiobutton57_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton57


% --- Executes on button press in radiobutton58.
function radiobutton58_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton58


% --- Executes when selected object is changed in uibuttongroup18.
function uibuttongroup18_SelectionChangedFcn(hObject, eventdata, handles)
    filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
width=handles.width;
height=handles.height;
length=handles.length;
color=handles.color;
fit_values_AASHTO=handles.fit_values_AASHTO;
fit_values_ASTM=handles.fit_values_ASTM;
x1=handles.x1;
x2=handles.x2;
x3=handles.x3;
x4=handles.x4;
x5=handles.x5;
x6=handles.x6;
rsq_ASTM=handles.rsq_ASTM;
rsq_AASHTO=handles.rsq_AASHTO;
stiffness_N50=handles.stiffness_N50;
A=handles.A;
b=handles.b;
E=handles.E;
cycles=handles.cycles;
normalized_modulus=handles.normalized_modulus;
flexural_stiffness=handles.flexural_stiffness;
nf50_AASHTO=handles.nf50_AASHTO;
nf50_ASTM=handles.nf50_ASTM;
max_normalized_modulus=handles.max_normalized_modulus;
x_at_max=handles.x_at_max;
color=handles.color;
file_number=get(handles.listbox3,'Value');
cycles=cycles(file_number);
E=E(file_number);
colors=color(file_number);
flexural_stiffness=flexural_stiffness(file_number);
fit_values_AASHTO=fit_values_AASHTO(file_number);
fit_values_ASTM=fit_values_ASTM(file_number);
normalized_modulus=normalized_modulus(file_number);
analysis=get(get(handles.uibuttongroup18,'SelectedObject'),'Tag');
if analysis=='radiobutton57'
    
%% Table 
calculated_parameters= [stiffness_N50(file_number);A(file_number);b(file_number);rsq_AASHTO(file_number);nf50_AASHTO(file_number)];
table_2_data=[AV(file_number);calculated_parameters];
colnames=    [{'Air Voids (%)'}
    {'Stiffness Measured at N50'}
    {'A'}
    {'b'}
    {'R^2'}
    {'nf,50'}];
%% Graph
cla(handles.axes1,'reset');
hold(handles.axes1, 'on');
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
graphdata=cellfun(@Beamplotter,cycles,flexural_stiffness,colors,'UniformOutput',false);
xlabel(handles.axes1,'# of Cycles (n)');
ylabel(handles.axes1,'Flexural Stiffness (MPa)');
axP = get(gca,'Position');
xlim(handles.axes1,[1 1E8]);
ylim(handles.axes1,[100 100000]);
set(gca, 'Position', axP);
set(handles.axes1, 'YScale', 'log');
set(handles.axes1, 'XScale', 'log');
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter2,cycles,fit_values_AASHTO,colors,'UniformOutput',false);
legend(handles.axes1,specimenID(file_number),'location','northwest');

hold(handles.axes1, 'off');
handles.cycles_for_export=cycles;
handles.flexural_stiffness_for_export=flexural_stiffness;
handles.E_for_export=E;
guidata(hObject, handles);



elseif analysis=='radiobutton58'
    
%% Table
calculated_parameters= [x6(file_number);x5(file_number);x4(file_number);x3(file_number);x2(file_number);x1(file_number);rsq_ASTM(file_number);nf50_ASTM(file_number);x_at_max(file_number)];
table_2_data=[AV(file_number);calculated_parameters];
colnames=    [{'Air Voids (%)'}
    {'a'}
    {'b'}
    {'c'}
    {'d'}
    {'e'}
    {'f'}
    {'R^2'}
    {'nf,50'}
    {'n at max'}];

%% Graph
cla(handles.axes1,'reset');
hold(handles.axes1, 'on');
set(gca, 'YScale', 'linear');
set(gca, 'XScale', 'linear');
graphdata=cellfun(@Beamplotter,cycles,normalized_modulus,colors,'UniformOutput',false);
xlabel(handles.axes1,'# of Cycles (n)');
ylabel(handles.axes1,'Normalized Modulus (MPa)');
axP = get(gca,'Position');
max_xaxis=max(cellfun(@max,cycles));
max_yaxis=max(cellfun(@max,normalized_modulus));
ylim(handles.axes1,[0 (max_yaxis+100)]);
xlim(handles.axes1,[0 (max_xaxis+20000)]);
set(gca, 'Position', axP);
set(handles.axes1, 'YScale', 'linear');
set(handles.axes1, 'XScale', 'linear');
hold(handles.axes1, 'on');
graphdata=cellfun(@Beamplotter2,cycles,fit_values_ASTM,colors,'UniformOutput',false);

legend(handles.axes1,specimenID(file_number),'location','northwest');

hold(handles.axes1, 'off');
guidata(hObject, handles);

end

if(size(get(handles.listbox3,'Value'))==1)
    averages=[];
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
set(handles.uitable1,'ColumnName',colnames);
set(handles.uitable1,'ColumnWidth','auto','Data',table_2_data','RearrangeableColumns','on');
guidata(hObject, handles);

% hObject    handle to the selected object in uibuttongroup18 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
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
checks=isempty(OGfile_numbers{1});
catch 
OGfile_numbers={OGfile_numbers};    
end
if isempty(OGfile_numbers{1})==1
    OGfile_numbers=[];
    OGnumber_of_files=0;
    OGtabledata=[];
    OGflexural_stiffness=[];
    OGE=[];
    OGcycles=[];
    OGnormalized_modulus=[];

else
OGflexural_stiffness=handles.flexural_stiffness;
OGE=handles.E;
OGcycles=handles.cycles;
OGnormalized_modulus=handles.normalized_modulus;
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
configfilename=([RAATPack_folder,'Configs\Beam-Default.xlsx']);
end

[cycles,flexural_stiffness,E,normalized_modulus] = beam_opener(configfilename,full_file_path,number_of_files);
cycles=[OGcycles cycles];
flexural_stiffness=[OGflexural_stiffness flexural_stiffness];
E=[OGE E];
normalized_modulus=[OGnormalized_modulus normalized_modulus];

newtabledata=cell(number_of_files,6);
newtabledata(:,1)=filename;
tabledata=[OGtabledata;newtabledata];
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',[file_numbers],'Data',tabledata,'ColumnEditable',true);

%% Set The Sample #s & File Names

close(f);
handles.cycles=cycles;
handles.flexural_stiffness=flexural_stiffness;
handles.E=E;
handles.normalized_modulus=normalized_modulus;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.filename=filename;
handles.file_numbers=file_numbers;
guidata(hObject,handles);
end
         
    else

OGfile_numbers=get(handles.uitable2,'RowName');
OGnumber_of_files=size(OGfile_numbers,1);
OGtabledata=get(handles.uitable2,'Data');
try
checks=isempty(OGfile_numbers{1});
catch 
OGfile_numbers={OGfile_numbers};    
end
if isempty(OGfile_numbers{1})==1
    OGfile_numbers=[];
    OGnumber_of_files=0;
    OGtabledata=[];
    OGflexural_stiffness=[];
    OGE=[];
    OGcycles=[];
    OGnormalized_modulus=[];

else
OGflexural_stiffness=handles.flexural_stiffness;
OGE=handles.E;
OGcycles=handles.cycles;
OGnormalized_modulus=handles.normalized_modulus;
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
configfilename=([RAATPack_folder,'Configs\Beam-Default.xlsx']);
end
[cycles,flexural_stiffness,E,normalized_modulus] = beam_opener(configfilename,full_file_path,number_of_files);
cycles=[OGcycles cycles];
flexural_stiffness=[OGflexural_stiffness flexural_stiffness];
E=[OGE E];
normalized_modulus=[OGnormalized_modulus normalized_modulus];

newtabledata=cell(number_of_files,6);
newtabledata(:,1)=filename;
tabledata=[OGtabledata;newtabledata];
%% Set Table As Empty 1x5 (as placeholder for actual values)
set(handles.uitable2,'RowName',[file_numbers],'Data',tabledata,'ColumnEditable',true);

%% Set The Sample #s & File Names

close(f);
handles.cycles=cycles;
handles.flexural_stiffness=flexural_stiffness;
handles.E=E;
handles.normalized_modulus=normalized_modulus;
handles.full_file_path=full_file_path;
handles.foldername = pathname;
handles.number_of_files=number_of_files;
handles.filename=filename;
handles.file_numbers=file_numbers;
guidata(hObject,handles);
end
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
handles.normalized_modulus(removefiles)=[];
handles.cycles(removefiles)=[];
handles.E(removefiles)=[];
handles.flexural_stiffness(removefiles)=[];


handles.file_numbers(removefiles)=[];
handles.filename(removefiles)=[];
                  
                  
set(handles.uitable2,'RowName',[handles.file_numbers],'Data',tabledata,'ColumnEditable',true);                 
guidata(hObject,handles);

% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
    set(handles.config_text,'String','Default');
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
    if strcmp(getappdata(0,'logo'),'None')==1
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
 f = warndlg('\color{blue} Please Select Your Logo File from the Settings Menu of the RAAT-Pack Home Screen',...
             'Warning', opts);   
else
        RAATPack_folder=getappdata(0,'RAATPack_folder');
filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
width=handles.width;
height=handles.height;
length=handles.length;
color=handles.color;
fit_values_AASHTO=handles.fit_values_AASHTO;
fit_values_ASTM=handles.fit_values_ASTM;
x1=handles.x1;
x2=handles.x2;
x3=handles.x3;
x4=handles.x4;
x5=handles.x5;
x6=handles.x6;
rsq_ASTM=handles.rsq_ASTM;
rsq_AASHTO=handles.rsq_AASHTO;
stiffness_N50=handles.stiffness_N50;
E_N50=handles.E_N50;
A=handles.A;
b=handles.b;
E=handles.E;
cycles=handles.cycles;
normalized_modulus=handles.normalized_modulus;
flexural_stiffness=handles.flexural_stiffness;
nf50_AASHTO=handles.nf50_AASHTO;
nf50_ASTM=handles.nf50_ASTM;
max_normalized_modulus=handles.max_normalized_modulus;
x_at_max=handles.x_at_max;
color=handles.color;







opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          file_number = listdlg('PromptString','Select the Sample to Export:',...
                      'SelectionMode','multiple',...
                      'ListString',specimenID);
             
calculated_parameters=[nf50_AASHTO(file_number);nf50_ASTM(file_number)];
excel_data=[specimenID(file_number); AV(file_number);width(file_number);height(file_number);length(file_number);calculated_parameters]';
ASTM_trendline=[x6(file_number);x5(file_number);x4(file_number);x3(file_number);x2(file_number);x1(file_number)];
%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges');
if admin_privileges_value == 0
    templatefile=[RAATPack_folder,'Templates\BEAM Templates\BEAM Template.xlsx'];
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

xlswrite(savefullname_excel,excel_data,1,'A7');                  

xlswrite(savefullname_excel,cycles{file_number},2,'A3');
xlswrite(savefullname_excel,flexural_stiffness{file_number},2,'B3');
xlswrite(savefullname_excel,A{file_number},2,'F2');
xlswrite(savefullname_excel,b{file_number},2,'F3');
xlswrite(savefullname_excel,stiffness_N50{file_number},2,'F4');
xlswrite(savefullname_excel,E_N50{file_number},2,'F5');
xlswrite(savefullname_excel,cycles{file_number},2,'H3');
xlswrite(savefullname_excel,normalized_modulus{file_number},2,'I3');
xlswrite(savefullname_excel,ASTM_trendline,2,'L2');
xlswrite(savefullname_excel,x_at_max{file_number},2,'M8');


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
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Beam Fatigue session?'], ...
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
templatefile=[RAATPack_folder,'Templates\BEAM Templates\BEAM Template_RU.xlsx'];
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

xlswrite(savefullname_excel,excel_data,1,'A7');                  

xlswrite(savefullname_excel,cycles{file_number},2,'A3');
xlswrite(savefullname_excel,flexural_stiffness{file_number},2,'B3');
xlswrite(savefullname_excel,A{file_number},2,'F2');
xlswrite(savefullname_excel,b{file_number},2,'F3');
xlswrite(savefullname_excel,stiffness_N50{file_number},2,'F4');
xlswrite(savefullname_excel,E_N50{file_number},2,'F5');
xlswrite(savefullname_excel,cycles{file_number},2,'H3');
xlswrite(savefullname_excel,normalized_modulus{file_number},2,'I3');
xlswrite(savefullname_excel,ASTM_trendline,2,'L2');
xlswrite(savefullname_excel,x_at_max{file_number},2,'M8');



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
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
    RAATPack_folder=getappdata(0,'RAATPack_folder');
filename=handles.filename;
specimenID=handles.specimenID;
AV=handles.AV;
width=handles.width;
height=handles.height;
length=handles.length;
color=handles.color;
fit_values_AASHTO=handles.fit_values_AASHTO;
fit_values_ASTM=handles.fit_values_ASTM;
x1=handles.x1;
x2=handles.x2;
x3=handles.x3;
x4=handles.x4;
x5=handles.x5;
x6=handles.x6;
rsq_ASTM=handles.rsq_ASTM;
rsq_AASHTO=handles.rsq_AASHTO;
stiffness_N50=handles.stiffness_N50;
E_N50=handles.E_N50;
A=handles.A;
b=handles.b;
E=handles.E;
cycles=handles.cycles;
normalized_modulus=handles.normalized_modulus;
flexural_stiffness=handles.flexural_stiffness;
nf50_AASHTO=handles.nf50_AASHTO;
nf50_ASTM=handles.nf50_ASTM;
max_normalized_modulus=handles.max_normalized_modulus;
x_at_max=handles.x_at_max;
color=handles.color;







opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          file_number = listdlg('PromptString','Select the Sample to Export:',...
                      'SelectionMode','multiple',...
                      'ListString',specimenID);
             
calculated_parameters=[nf50_AASHTO(file_number);nf50_ASTM(file_number)];
excel_data=[specimenID(file_number); AV(file_number);width(file_number);height(file_number);length(file_number);calculated_parameters]';
ASTM_trendline=[x6(file_number);x5(file_number);x4(file_number);x3(file_number);x2(file_number);x1(file_number)];
%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges');
if admin_privileges_value == 0
    templatefile=[RAATPack_folder,'Templates\BEAM Templates\BEAM Template.xlsx'];
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

xlswrite(savefullname_excel,excel_data,1,'A7');                  

xlswrite(savefullname_excel,cycles{file_number},2,'A3');
xlswrite(savefullname_excel,flexural_stiffness{file_number},2,'B3');
xlswrite(savefullname_excel,A{file_number},2,'F2');
xlswrite(savefullname_excel,b{file_number},2,'F3');
xlswrite(savefullname_excel,stiffness_N50{file_number},2,'F4');
xlswrite(savefullname_excel,E_N50{file_number},2,'F5');
xlswrite(savefullname_excel,cycles{file_number},2,'H3');
xlswrite(savefullname_excel,normalized_modulus{file_number},2,'I3');
xlswrite(savefullname_excel,ASTM_trendline,2,'L2');
xlswrite(savefullname_excel,x_at_max{file_number},2,'M8');


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
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Beam Fatigue session?'], ...
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
templatefile=[RAATPack_folder,'Templates\BEAM Templates\BEAM Template_RU.xlsx'];
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

xlswrite(savefullname_excel,excel_data,1,'A7');                  

xlswrite(savefullname_excel,cycles{file_number},2,'A3');
xlswrite(savefullname_excel,flexural_stiffness{file_number},2,'B3');
xlswrite(savefullname_excel,A{file_number},2,'F2');
xlswrite(savefullname_excel,b{file_number},2,'F3');
xlswrite(savefullname_excel,stiffness_N50{file_number},2,'F4');
xlswrite(savefullname_excel,E_N50{file_number},2,'F5');
xlswrite(savefullname_excel,cycles{file_number},2,'H3');
xlswrite(savefullname_excel,normalized_modulus{file_number},2,'I3');
xlswrite(savefullname_excel,ASTM_trendline,2,'L2');
xlswrite(savefullname_excel,x_at_max{file_number},2,'M8');



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
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
