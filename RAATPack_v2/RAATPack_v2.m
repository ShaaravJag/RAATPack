function varargout = RAATPack_v2(varargin)
% RAATPACK_V2 MATLAB code for RAATPack_v2.fig
%      RAATPACK_V2, by itself, creates a new RAATPACK_V2 or raises the existing
%      singleton*.
%
%      H = RAATPACK_V2 returns the handle to a new RAATPACK_V2 or the handle to
%      the existing singleton*.
%
%      RAATPACK_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAATPACK_V2.M with the given input arguments.
%
%      RAATPACK_V2('Property','Value',...) creates a new RAATPACK_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RAATPack_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RAATPack_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RAATPack_v2

% Last Modified by GUIDE v2.5 10-Dec-2019 01:17:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RAATPack_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @RAATPack_v2_OutputFcn, ...
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


% --- Executes just before RAATPack_v2 is made visible.
function RAATPack_v2_OpeningFcn(hObject, eventdata, handles, varargin)
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

[matlabImage,map,alpha] = imread('CAITLogo.png');
image(matlabImage,'AlphaData',alpha)
axis off
axis image

fid = fopen('Configs\Logo.txt');
pic = string(textscan(fid, '%s','delimiter','\n'))
fclose(fid);
set(handles.text21,'String',pic);
try
myImage = imread(get(handles.text21,'String'));
set(handles.axes7,'Units','pixels');
axes(handles.axes7);
imshow(myImage);
axis off
end


%disclaimer=warndlg('This software is for research purposes only.','Disclaimer','modal');

%axes(handles.SCB)
%picturename='SCB.png';
%h=pictureplotter(picturename);
%set(gca,'ButtonDownFcn','pictureplotter(''SCB.png'')');
%set(h,'ButtonDownFcn','pictureplotter(''SCB2.png'')');
%axis off
%axis image




admin_privileges_value=0;
setappdata(0,'admin_privileges',admin_privileges_value);


% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RAATPack_v2 (see VARARGIN)

% Choose default command line output for RAATPack_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RAATPack_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RAATPack_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Rutgers SCB Module');
SCB_direct=('SCBGUI.m');
run(SCB_direct);
close(f);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Ideal CT Module');
IDEALCTGUI_direct=('IDEALCTGUI.m');
run(IDEALCTGUI_direct);
close(f);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching DCT Module');
DCT_v1_direct=('DCTGUI.m');
run(DCT_v1_direct);
close(f);
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Cold SCB Module');
ColdSCB_direct=('ColdSCBGUI.m');
run(ColdSCB_direct);
close(f);
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching APA Module');
APAGUI_direct=('APAGUI.m');
run(APAGUI_direct);
close(f);
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
%h = msgbox({'Rutgers Asphalt Analysis Tool-Pack' 'Version 2.0' 'Thomas Bennert, Ed Haas, Benjamin Berger, Marissa Berger' 'Rutgers Asphalt Pavement Laboratory' 'Rutgers University, NJ' '2018' '' 'Contact: edhaas@soe.rutgers.edu'},'About','help');
%url = 'https://cait.rutgers.edu/facilities-equipment/pavement-lab/'
%web(url,'-browser')
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching HTIDT Module');
HTIDTGUI_direct=('HTIDTGUI.m');
run(HTIDTGUI_direct);
close(f);
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function RULogin_Callback(hObject, eventdata, handles)
% hObject    handle to RULogin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Beam Fatigue Module');
BEAMGUI_direct=('BeamGUI.m');
run(BEAMGUI_direct);
close(f);
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Dynamic Modulus Module');
HTIDTGUI_direct=('DynamicModulus.m');
run(HTIDTGUI_direct);
close(f);
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Hamburg Module');
HTIDTGUI_direct=('HAMGUI.m');
run(HTIDTGUI_direct);
close(f);
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)


% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5


% --- Executes on mouse press over axes background.
function SCB_ButtonDownFcn(hObject, eventdata, handles)

% hObject    handle to SCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
setappdata(0,'admin_privileges',0);
set(handles.text6,'visible','off');
%set(handles.pushbutton10,'visible','off');
set(handles.pushbutton14,'visible','off');
%set(handles.pushbutton11,'visible','off');
%set(handles.pushbutton12,'visible','off');
set(handles.uipanel3,'visible','off');
guidata(hObject, handles);  
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
f=waitbar(0,'Launching Bond Strength Module');
BondGUI_direct=('BondGUI.m');
run(BondGUI_direct);
close(f);
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel3,'Visible','on');

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Username:','Password:'};
dlgtitle = 'LOGIN';
dims = [1 35];
definput = {'',''};
answer = string(inputdlg(prompt,dlgtitle,dims,definput));
if isempty(answer)
admin_privileges_value=0;
setappdata(0,'admin_privileges',admin_privileges_value);   
else
if answer(1) == 'RAPLCAIT' && answer(2)=='3483' 
admin_privileges_value=1;
setappdata(0,'admin_privileges',admin_privileges_value);
set(handles.text6,'visible','on');
%set(handles.pushbutton10,'visible','on');
%set(handles.pushbutton11,'visible','on');
%set(handles.pushbutton12,'visible','on');
set(handles.pushbutton14,'visible','on');
end
end
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


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
answer=string(get(handles.edit7,'String'));
answerr=string(get(handles.edit8,'String'));
if isempty(answer)
admin_privileges_value=0;
setappdata(0,'admin_privileges',admin_privileges_value);   
else
if answer == 'RAPLCAIT' && answerr=='3483' 
admin_privileges_value=1;
setappdata(0,'admin_privileges',admin_privileges_value);
set(handles.text6,'visible','on');
set(handles.pushbutton11,'visible','on');
end
end
guidata(hObject, handles);  
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
set(handles.uipanel3,'Visible','off');
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
set(handles.settingspanel,'visible','on');

% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
h = msgbox({'Rutgers Asphalt Analysis Tool-Pack' 'Version 2.0' 'Thomas Bennert, Ed Haas, Benjamin Berger, Marissa Berger' 'Rutgers Asphalt Pavement Laboratory' 'Rutgers University, NJ' '2018' '' 'Contact: edhaas@soe.rutgers.edu'},'About','help');

% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile({'*.*'},'Input','\','MultiSelect', 'off');
if filename==0
else
    pic = fullfile(pathname,filename);
    set(handles.text21,'String',pic);
myImage = imread(pic);

set(handles.axes7,'Units','pixels');
axes(handles.axes7);
imshow(myImage);
end
RAATPack_folder=getappdata(0,'RAATPack_folder');
file=([RAATPack_folder,'Configs\Logo.txt']);
fid = fopen(file, 'wt');
fwrite(fid, pic);
fclose(fid);

setappdata(0,'logo',pic);
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
set(handles.settingspanel,'visible','off');
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
cla(handles.axes7);
set(handles.text21,'String','None');
setappdata(0,'logo','None');
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
