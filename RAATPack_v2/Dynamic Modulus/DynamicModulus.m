function varargout = DynamicModulus(varargin)
% DYNAMICMODULUS MATLAB code for DynamicModulus.fig
%      DYNAMICMODULUS, by itself, creates a new DYNAMICMODULUS or raises the existing
%      singleton*.
%
%      H = DYNAMICMODULUS returns the handle to a new DYNAMICMODULUS or the handle to
%      the existing singleton*.
%
%      DYNAMICMODULUS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNAMICMODULUS.M with the given input arguments.
%
%      DYNAMICMODULUS('Property','Value',...) creates a new DYNAMICMODULUS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DynamicModulus_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DynamicModulus_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose 'GUI allows only one
%      instance to run (singleton)'.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DynamicModulus

% Last Modified by GUIDE v2.5 30-Mar-2020 19:18:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DynamicModulus_OpeningFcn, ...
    'gui_OutputFcn',  @DynamicModulus_OutputFcn, ...
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


% --- Executes just before DynamicModulus is made visible.
function DynamicModulus_OpeningFcn(hObject, eventdata, handles, varargin)
datacursormode on
foldername = pwd;
handles.foldername=foldername;
popup_options={'Sample 1 Data','Sample 2 Data','Sample 3 Data', 'Average Sample Data', 'All Sample Data'};
set(handles.popupmenu1, 'String', popup_options);
frequencies=[{25; 10; 5; 1; 0.5; 0.1; []} , {25; 10; 5; 1; 0.5; 0.1; []} , {25; 10; 5; 1; 0.5; 0.1; 0.01}];
text={'Choose Asphalt Binder Grade';'none';'PG 46-34';'PG 46-40';'PG 46-46';'PG 52-10';'PG 52-16';'PG 52-22';'PG 52-28';'PG 52-34';'PG 52-40';'PG 52-46';'PG 58-10';'PG 58-16';'PG 58-22';'PG 58-28';'PG 58-34';'PG 58-40';'PG 64-10';'PG 64-16';'PG 64-22';'PG 64-28';'PG 64-34';'PG 64-40';'PG 70-10';'PG 70-16';'PG 70-22';'PG 70-28';'PG 70-34';'PG 70-40';'PG 76-10';'PG 76-16';'PG 76-22';'PG 76-28';'PG 76-34';'PG 82-10';'PG 82-16';'PG 82-22';'PG 82-28';'PG 82-34';'AC-2.5';'AC-5';'AC-10';'AC-20';'AC-3';'AC-40';'PEN 40-50';'PEN 60-70';'PEN 85-100';'PEN 120-150';'PEN 200-300'};
set(handles.popupmenu14,'String',text);

guidata(hObject,handles);

%% Set default state for analyses completed
handles.analysis_completed=0;
handles.EA_completed=0;
handles.VTS_completed=0;
handles.Witczak_completed=0;
handles.HirschEA_completed=0;
handles.HirschVTS_completed=0;


%% Admin Privileges

admin_privileges_value=getappdata(0,'admin_privileges');

if admin_privileges_value==1
    set(handles.checkbox86,'visible','on');
    set(handles.checkbox87,'visible','on');
    set(handles.checkbox95,'visible','on');
    set(handles.checkbox96,'visible','on');
    set(handles.uipanel67,'visible','on');
    set(handles.witczakmenu,'visible','on');
    set(handles.hirschmenu,'visible','on');
    set(handles.radiobutton39,'visible','on');
    set(handles.radiobutton40,'visible','on');
    set(handles.radiobutton41,'visible','on');
    set(handles.radiobutton53,'visible','on');
    set(handles.pushbutton25,'visible','on');    
    set(handles.pushbutton86,'visible','on'); 
    set(handles.pushbutton87,'visible','on'); 
end

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DynamicModulus (see VARARGIN)

% Choose default command line output for DynamicModulus
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DynamicModulus wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DynamicModulus_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
tablesize=cell(4,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function uitable3_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable4_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in uitable5.
function uitable5_CellEditCallback(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable5 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable5_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function uitable6_CreateFcn(hObject, eventdata, handles)
tablesize=cell(18,3);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
fit_sample1=handles.fit_sample1;
fit_sample2=handles.fit_sample2;
fit_sample3=handles.fit_sample3;
tabledata_sample1=handles.tabledata_sample1;
tabledata_sample2=handles.tabledata_sample2;
tabledata_sample3=handles.tabledata_sample3;
blackspacedata_sample1=handles.blackspacedata_sample1;
blackspacedata_sample2=handles.blackspacedata_sample2;
blackspacedata_sample3=handles.blackspacedata_sample3;

try
fitting_data_sample1=handles.fitting_data_sample1;
fitting_data_sample2=handles.fitting_data_sample2;
fitting_data_sample3=handles.fitting_data_sample3;
catch
fitting_data_sample1=blackspacedata_sample1;
fitting_data_sample2=blackspacedata_sample2;
fitting_data_sample3=blackspacedata_sample3;
end

val=get(handles.popupmenu1,'Value');

if val==1;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    set(handles.uitable20, 'Data', tabledata_sample1);
    p = polyfit(fitting_data_sample1(:,2),fitting_data_sample1(:,3),2);
    fit_sample1=p(1).*fitting_data_sample1(:,2).^2+p(2).*fitting_data_sample1(:,2)+p(3);
    yfit = polyval(p,fitting_data_sample1(:,2));
    yresid = fitting_data_sample1(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(fitting_data_sample1(:,3))-1) * var(fitting_data_sample1(:,3));
    rsq_sample1 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample1));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',1);
    scatter(handles.axes5,fitting_data_sample1(:,2),fitting_data_sample1(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample1(:,2),fit_sample1,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 1 Black Space Data');
    hold(handles.axes5,'off');
end
if val==2;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    set(handles.uitable20, 'Data', tabledata_sample2);
    p = polyfit(fitting_data_sample2(:,2),fitting_data_sample2(:,3),2);
    fit_sample2=p(1).*fitting_data_sample2(:,2).^2+p(2).*fitting_data_sample2(:,2)+p(3);
    yfit = polyval(p,fitting_data_sample2(:,2));
    yresid = fitting_data_sample2(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(fitting_data_sample2(:,3))-1) * var(fitting_data_sample2(:,3));
    rsq_sample2 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample2));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',2);
    scatter(handles.axes5,fitting_data_sample2(:,2),fitting_data_sample2(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample2(:,2),fit_sample2,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 2 Black Space Data');
    hold(handles.axes5,'off');
end
if val==3;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    set(handles.uitable20, 'Data', tabledata_sample3);
    p = polyfit(fitting_data_sample3(:,2),fitting_data_sample3(:,3),2);
    fit_sample3=p(1).*fitting_data_sample3(:,2).^2+p(2).*fitting_data_sample3(:,2)+p(3);
    yfit = polyval(p,fitting_data_sample3(:,2));
    yresid = fitting_data_sample3(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(fitting_data_sample3(:,3))-1) * var(fitting_data_sample3(:,3));
    rsq_sample3 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample3));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',3);
    scatter(handles.axes5,fitting_data_sample3(:,2),fitting_data_sample3(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample3(:,2),fit_sample3,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 3 Black Space Data');
    hold(handles.axes5,'off');
end
if val==4;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)', 'E* COV',	'Phase COV'};
    set(handles.uitable20,'columnname',fullaverage);
    fulltabledata_average=handles.fulltabledata_average;
    fulltabledata_average=[fulltabledata_average(:,1:6),fulltabledata_average(:,9:10)];
    set(handles.uitable20, 'Data', fulltabledata_average);
    blackspacedata_average=handles.blackspacedata_average;
    p = polyfit(blackspacedata_average(:,2),blackspacedata_average(:,3),2);
    fit_average=p(1).*blackspacedata_average(:,2).^2+p(2).*blackspacedata_average(:,2)+p(3);
    yfit = polyval(p,blackspacedata_average(:,2));
    yresid = blackspacedata_average(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_average(:,3))-1) * var(blackspacedata_average(:,3));
    rsq_average = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_average));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',4);
    scatter(handles.axes5,blackspacedata_average(:,2),blackspacedata_average(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,blackspacedata_average(:,2),fit_average,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Average Black Space Data');
    hold(handles.axes5,'off');
end
if val==5;
    
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)', 'E* COV',	'Phase COV'};
    set(handles.uitable20,'columnname',fullaverage);
    fulltabledata_average=handles.fulltabledata_average;
    fulltabledata_average=[fulltabledata_average(:,1:6),fulltabledata_average(:,9:10)];
    set(handles.uitable20, 'Data', fulltabledata_average);
    blackspacedata_average=handles.blackspacedata_average;
    p = polyfit(blackspacedata_average(:,2),blackspacedata_average(:,3),2);
    fit_average=p(1).*blackspacedata_average(:,2).^2+p(2).*blackspacedata_average(:,2)+p(3);
    yfit = polyval(p,blackspacedata_average(:,2));
    yresid = blackspacedata_average(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_average(:,3))-1) * var(blackspacedata_average(:,3));
    rsq_average = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_average));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',5);
    

p = polyfit(fitting_data_sample1(:,2),fitting_data_sample1(:,3),2);
fit_sample1=p(1).*fitting_data_sample1(:,2).^2+p(2).*fitting_data_sample1(:,2)+p(3);

p = polyfit(fitting_data_sample2(:,2),fitting_data_sample2(:,3),2);
fit_sample2=p(1).*fitting_data_sample2(:,2).^2+p(2).*fitting_data_sample2(:,2)+p(3);

p = polyfit(fitting_data_sample3(:,2),fitting_data_sample3(:,3),2);
fit_sample3=p(1).*fitting_data_sample3(:,2).^2+p(2).*fitting_data_sample3(:,2)+p(3);
    
    scatter(handles.axes5,fitting_data_sample1(:,2),fitting_data_sample1(:,3),'filled','MarkerFaceColor',[1 0 0]);
    hold(handles.axes5,'on')    
    scatter(handles.axes5,fitting_data_sample2(:,2),fitting_data_sample2(:,3),'filled','MarkerFaceColor',[0 1 0]);
    hold(handles.axes5,'on')
    scatter(handles.axes5,fitting_data_sample3(:,2),fitting_data_sample3(:,3),'filled','MarkerFaceColor',[0 0 1]);
    plot(handles.axes5,fitting_data_sample1(:,2),fit_sample1,'r-','LineWidth',2);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample2(:,2),fit_sample2,'g-','LineWidth',2);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample3(:,2),fit_sample3,'b-','LineWidth',2);
    hold(handles.axes5,'on')
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'All Sample Black Space Data');
    legend(handles.axes5,[{'Sample 1'},{'Sample 2'},{'Sample 3'}],'location','southwest')
    hold(handles.axes5,'off'); 
end
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)






% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable10_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable9_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable8_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable7_CreateFcn(hObject, eventdata, handles)
tablesize=cell(18,3);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton10_CreateFcn(hObject, eventdata, handles)

% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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

% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
blackspacedata_sample3_file1=handles.blackspacedata_sample3_file1;
blackspacedata_sample3_file2=handles.blackspacedata_sample3_file2;
blackspacedata_sample3_file3=handles.blackspacedata_sample3_file3;
blackspacedata_sample3=[blackspacedata_sample3_file1;blackspacedata_sample3_file2;blackspacedata_sample3_file3];
handles.blackspacedata_sample3=blackspacedata_sample3;
set(handles.uitable14, 'Data', blackspacedata_sample3);
plot(handles.axes3,blackspacedata_sample3(:,2),blackspacedata_sample3(:,3),'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes5,'Log E* (psi)');
ylabel(handles.axes5,'Phase Angle (degrees)');
title(handles.axes5,'Black Space Data');
legend;
p = polyfit(blackspacedata_sample3(:,1),blackspacedata_sample3(:,2),2);
yfit = polyval(p,blackspacedata_sample3(:,1));
yresid = blackspacedata_sample3(:,2) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample3(:,2))-1) * var(blackspacedata_sample3(:,2));
rsq = 1 - SSresid/SStotal;
guidata(hObject, handles);
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable11_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable12_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable13_CreateFcn(hObject, eventdata, handles)
tablesize=cell(6,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable14_CreateFcn(hObject, eventdata, handles)
tablesize=cell(18,3);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function datapanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datapanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
tabledata_sample1=[cell2mat(get(handles.uitable3,'Data'));cell2mat(get(handles.uitable4,'Data'));cell2mat(get(handles.uitable5,'Data'))];
tabledata_sample2=[cell2mat(get(handles.uitable10,'Data'));cell2mat(get(handles.uitable9,'Data'));cell2mat(get(handles.uitable8,'Data'))];
tabledata_sample3=[cell2mat(get(handles.uitable11,'Data'));cell2mat(get(handles.uitable12,'Data'));cell2mat(get(handles.uitable13,'Data'))];
tabledata_average=(tabledata_sample1+tabledata_sample2+tabledata_sample3)./3;
set(handles.uitable20, 'Data', tabledata_average);
blackspacedata_sample1=handles.blackspacedata_sample1;
blackspacedata_sample2=handles.blackspacedata_sample2;
blackspacedata_sample3=handles.blackspacedata_sample3;
blackspacedata_average=(blackspacedata_sample1+blackspacedata_sample2+blackspacedata_sample3)./3;
set(handles.uitable19, 'Data', blackspacedata_average);
plot(handles.axes5,blackspacedata_average(:,2),blackspacedata_average(:,3),'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes5,'Log E* (psi)');
ylabel(handles.axes5,'Phase Angle (degrees)');
title(handles.axes5,'Average Black Space Data');
legend;
p = polyfit(blackspacedata_sample3(:,1),blackspacedata_sample3(:,2),2);
yfit = polyval(p,blackspacedata_sample3(:,1));
yresid = blackspacedata_sample3(:,2) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample3(:,2))-1) * var(blackspacedata_sample3(:,2));
rsq = 1 - SSresid/SStotal;
guidata(hObject, handles);

% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable20_CreateFcn(hObject, eventdata, handles)
tablesize=cell(19,5);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable19_CreateFcn(hObject, eventdata, handles)
tablesize=cell(19,3);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5



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


% --- Executes during object creation, after setting all properties.
function uitable23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable25_CreateFcn(hObject, eventdata, handles)
tablesize=cell(1,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable24_CreateFcn(hObject, eventdata, handles)
tablesize=cell(3,3);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable26_CreateFcn(hObject, eventdata, handles)
tablesize=cell(4,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable27_CreateFcn(hObject, eventdata, handles)
tablesize=cell(3,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable28_CreateFcn(hObject, eventdata, handles)
tablesize=cell(1,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
volumetrics_data=get(handles.uitable1,'Data');
volumetrics_data=table2array(cell2table(volumetrics_data));
Gmm=volumetrics_data(1,:);
Gsb=volumetrics_data(2,:);
AV=volumetrics_data(3,:);
AC=volumetrics_data(4,:);
Gmb=Gmm-(AV/100)*Gmm;
VMA=100-((Gmb*(100-AC))/Gsb);
VFA=(VMA-AV)/VMA*100;
Pc=((20+435000*VFA/VMA)^.58)/(650+(435000*VFA/VMA)^.58);
PI=Pc*(4200000*(1-VMA/100)+435000*(VFA*VMA/10000));
PII=(1-Pc)/((1-VMA/100)/4200000+VMA/(435000*VFA));
EMAX=Pc*(4200000*(1-VMA/100)+435000*(VFA*VMA/10000))+(1-Pc)/((1-VMA/100)/4200000+VMA/(435000*VFA));
handles.EMAX=EMAX;

set(handles.uitable28,'Data',EMAX);
volumetricdata=[Gmb;VMA;VFA];
handles.VFA=VFA;
handles.VMA=VMA;
set(handles.uitable27,'Data',volumetricdata);
set(handles.text132,'String',sprintf('%.0f',EMAX))
guidata(hObject, handles);

% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
PathName = uigetdir_workaround(['\'],'Open Project Folder');
handles.foldername = PathName;
files = dir(fullfile(PathName, '*.csv'));
projectfiles = convertCharsToStrings({files.name});
projectfiles=cellstr(projectfiles(find(~cellfun(@isempty,strfind(projectfiles,'Sum')))));
projectfiles=[string('select file'),projectfiles];
set(handles.popupmenu3,'String',projectfiles);
set(handles.popupmenu4,'String',projectfiles);
set(handles.popupmenu5,'String',projectfiles);
set(handles.popupmenu6,'String',projectfiles);
set(handles.popupmenu7,'String',projectfiles);
set(handles.popupmenu8,'String',projectfiles);
set(handles.popupmenu9,'String',projectfiles);
set(handles.popupmenu10,'String',projectfiles);
set(handles.popupmenu11,'String',projectfiles);
handles.PathName = PathName;
guidata(hObject,handles);

% hObject    handle to pushbutton24 (see GCBO)
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


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
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


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable20.
function uitable20_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable20 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable27.
function uitable27_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable27 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable29_CreateFcn(hObject, eventdata, handles)
tablesize=cell(4,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in uitable26.
function uitable26_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable26 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
%foldername = handles.foldername;
PathName = uigetdir_workaround(['\'],'Open Project Folder');
handles.PathName=PathName;
files = dir(fullfile(PathName, '*.csv'));
files.name;
projectfiles = convertCharsToStrings({files.name});
projectfiles=cellstr(projectfiles(find(~cellfun(@isempty,strfind(projectfiles,'Sum')))));
ind4C=cellstr(projectfiles(find(~cellfun(@isempty,strfind(projectfiles,'4C')))));
ind20C=cellstr(projectfiles(find(~cellfun(@isempty,strfind(projectfiles,'20C')))));
ind35C=cellstr(projectfiles(find(~cellfun(@isempty,strfind(projectfiles,'35C')))));
ind45C=cellstr(projectfiles(find(~cellfun(@isempty,strfind(projectfiles,'45C')))));
ind3545C=[ind35C;ind45C];
set(handles.popupmenu3,'String',ind4C);
set(handles.popupmenu3,'Value',1);
set(handles.popupmenu4,'String',ind20C);
set(handles.popupmenu4,'Value',1);
set(handles.popupmenu5,'String',ind3545C);
set(handles.popupmenu5,'Value',1);
set(handles.popupmenu6,'String',ind4C(2));
set(handles.popupmenu6,'Value',1);
set(handles.popupmenu7,'String',ind20C(2));
set(handles.popupmenu7,'Value',1);
set(handles.popupmenu8,'String',ind3545C(2));
set(handles.popupmenu8,'Value',1);
set(handles.popupmenu9,'String',ind4C(3));
set(handles.popupmenu9,'Value',1);
set(handles.popupmenu10,'String',ind20C(3));
set(handles.popupmenu10,'Value',1);
set(handles.popupmenu11,'String',ind3545C(3));
set(handles.popupmenu11,'Value',1);
guidata(hObject,handles);
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
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


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
file_number=get(handles.popupmenu12,'Value');




%if get(handles.popupmenu12,'Value') ==3
%properties_sample1_file3=sample_properties
%k=5
%end


% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
p=findobj('Style','checkbox');
pp=flipud(p);
checkboxVals = get(pp, 'Value');
temperatures_sample1=[str2double(get(handles.edit5,'String')),str2double(get(handles.edit6,'String')),str2double(get(handles.edit7,'String'))];
checkboxVals=cell2mat(checkboxVals);
frequencies_sample1=[checkboxVals(1:7),checkboxVals(8:14),checkboxVals(15:21)];
properties_sample1=[temperatures_sample1;frequencies_sample1];
properties_sample1=properties_sample1.*[1 1 1; 25 25 25; 10 10 10; 5 5 5; 1 1 1; .5 .5 .5; .1 .1 .1; .01 .01 .01];
temperatures_sample2=[str2double(get(handles.edit11,'String')),str2double(get(handles.edit12,'String')),str2double(get(handles.edit13,'String'))];
frequencies_sample2=[checkboxVals(22:28),checkboxVals(29:35),checkboxVals(36:42)];
properties_sample2=[temperatures_sample2;frequencies_sample2];
properties_sample2=properties_sample2.*[1 1 1; 25 25 25; 10 10 10; 5 5 5; 1 1 1; .5 .5 .5; .1 .1 .1; .01 .01 .01];
temperatures_sample3=[str2double(get(handles.edit14,'String')),str2double(get(handles.edit15,'String')),str2double(get(handles.edit16,'String'))];
frequencies_sample3=[flipud(checkboxVals(57:63)),flipud(checkboxVals(50:56)),flipud(checkboxVals(43:49))];
properties_sample3=[temperatures_sample3;frequencies_sample3];
properties_sample3=properties_sample3.*[1 1 1; 25 25 25; 10 10 10; 5 5 5; 1 1 1; .5 .5 .5; .1 .1 .1; .01 .01 .01];
handles.properties_sample1=properties_sample1;
handles.properties_sample2=properties_sample2;
handles.properties_sample3=properties_sample3;
guidata(hObject,handles);


% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable33_CreateFcn(hObject, eventdata, handles)
tablesize=cell(4,5);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
%% DSR Data
DSRdata=cell2mat(get(handles.uitable33,'Data'));
temperature_C=DSRdata(:,1);
G=DSRdata(:,2);
delta=DSRdata(:,3);
temperature_K=1.8*temperature_C+491.67;
logtemp_DSR=log10(temperature_K);
viscosity_DSR=1000.*G/10.*(1./sin(pi*delta/180)).^4.8628;
loglogviscosity_DSR=log10(log10(viscosity_DSR));
plot(handles.axes6,logtemp_DSR,loglogviscosity_DSR,'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes6,'Log Temp (R)');
ylabel(handles.axes6,'Log Log Viscosity (cPoise)');
title(handles.axes6,'From DSR Testing');
fit=polyfit(logtemp_DSR,loglogviscosity_DSR,1);
VTS=fit(1);
A=fit(2);
set(handles.uitable34,'Data',[VTS;A]);
set(handles.text142,'String',VTS);
set(handles.text144,'String',A);
set(handles.text149,'String',VTS);
set(handles.text151,'String',A);
set(handles.text154,'String','From DSR Testing');
p = polyfit(logtemp_DSR,loglogviscosity_DSR,1);
yfit = polyval(p,logtemp_DSR);
yresid = loglogviscosity_DSR - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(loglogviscosity_DSR)-1) * var(loglogviscosity_DSR);
rsq = 1 - SSresid/SStotal;
set(handles.text80,'String',rsq);
handles.A=A;
handles.VTS=VTS;
guidata(hObject, handles);

% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable34_CreateFcn(hObject, eventdata, handles)
tablesize=cell(2,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable36_CreateFcn(hObject, eventdata, handles)
tablesize=cell(4,4);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable35_CreateFcn(hObject, eventdata, handles)
tablesize=cell(4,5);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
viscosityparameters=[{'Asphalt Binder Grade'}    {'A'      }    {'VTS'    }
    {'None'}    { []     }    {[]   }
    {'PG 46-34'            }    {[11.5040]}    {[-3.9010]}
    {'PG 46-40'            }    {[10.1010]}    {[-3.3930]}
    {'PG 46-46'            }    {[ 8.7550]}    {[-2.9050]}
    {'PG 52-10'            }    {[13.3860]}    {[-4.5700]}
    {'PG 52-16'            }    {[13.3050]}    {[-4.5410]}
    {'PG 52-22'            }    {[12.7550]}    {[-4.3420]}
    {'PG 52-28'            }    {[11.8400]}    {[-4.0120]}
    {'PG 52-34'            }    {[10.7070]}    {[-3.6020]}
    {'PG 52-40'            }    {[ 9.4960]}    {[-3.1640]}
    {'PG 52-46'            }    {[ 8.3100]}    {[-2.7360]}
    {'PG 58-10'            }    {[12.3160]}    {[-4.1720]}
    {'PG 58-16'            }    {[12.2480]}    {[-4.1470]}
    {'PG 58-22'            }    {[11.7870]}    {[-3.9810]}
    {'PG 58-28'            }    {[11.0100]}    {[-3.7010]}
    {'PG 58-34'            }    {[10.0350]}    {[-3.3500]}
    {'PG 58-40'            }    {[ 8.9760]}    {[-2.9680]}
    {'PG 64-10'            }    {[11.4320]}    {[-3.8420]}
    {'PG 64-16'            }    {[11.3750]}    {[-3.8220]}
    {'PG 64-22'            }    {[10.9800]}    {[-3.6800]}
    {'PG 64-28'            }    {[10.3120]}    {[-3.4400]}
    {'PG 64-34'            }    {[ 9.4610]}    {[-3.1340]}
    {'PG 64-40'            }    {[ 8.5240]}    {[-2.7980]}
    {'PG 70-10'            }    {[10.6900]}    {[-3.5660]}
    {'PG 70-16'            }    {[10.6410]}    {[-3.5480]}
    {'PG 70-22'            }    {[10.2990]}    {[-3.4260]}
    {'PG 70-28'            }    {[ 9.7150]}    {[-3.2170]}
    {'PG 70-34'            }    {[ 8.9650]}    {[-2.9480]}
    {'PG 70-40'            }    {[ 8.1290]}    {[-2.6480]}
    {'PG 76-10'            }    {[10.0590]}    {[-3.3310]}
    {'PG 76-16'            }    {[10.0150]}    {[-3.3150]}
    {'PG 76-22'            }    {[ 9.7150]}    {[-3.2080]}
    {'PG 76-28'            }    {[ 9.2000]}    {[-3.0240]}
    {'PG 76-34'            }    {[ 8.5320]}    {[-2.7850]}
    {'PG 82-10'            }    {[ 9.5140]}    {[-3.1280]}
    {'PG 82-16'            }    {[ 9.4750]}    {[-3.1140]}
    {'PG 82-22'            }    {[ 9.2090]}    {[-3.0190]}
    {'PG 82-28'            }    {[ 8.7500]}    {[-2.8560]}
    {'PG 82-34'            }    {[ 8.1510]}    {[-2.6420]}
    {'AC-2.5'              }    {[11.5167]}    {[-3.8900]}
    {'AC-5'                }    {[11.2614]}    {[-3.7914]}
    {'AC-10'               }    {[11.0134]}    {[-3.6954]}
    {'AC-20'               }    {[10.7709]}    {[-3.6017]}
    {'AC-3'                }    {[10.6316]}    {[-3.5480]}
    {'AC-40'               }    {[10.5338]}    {[-3.5104]}
    {'PEN 40-50'           }    {[10.5254]}    {[-3.5047]}
    {'PEN 60-70'           }    {[10.6508]}    {[-3.5537]}
    {'PEN 85-100'          }    {[11.8232]}    {[-3.6210]}
    {'PEN 120-150'         }    {[11.0897]}    {[-3.7252]}
    {'PEN 200-300'         }    {[11.8107]}    {[-4.0068]}];
value=get(handles.popupmenu14);
val = get(hObject,'Value');
VTS=cell2mat(viscosityparameters(val,3));
A=cell2mat(viscosityparameters(val,2));
if val==1||val==2
    set(handles.uitable34,'Data',[]);
    set(handles.text142,'String',[]);
    set(handles.text144,'String',[]);
    set(handles.text149,'String',[]);
    set(handles.text151,'String',[]);
    set(handles.text154,'String',[]);
else
    set(handles.uitable34,'Data',[VTS;A]);
    set(handles.text142,'String',VTS);
    set(handles.text144,'String',A);
    set(handles.text149,'String',VTS);
    set(handles.text151,'String',A);
    set(handles.text154,'String','NCHRP 1-37A');
    
    
end
handles.A=A;
handles.VTS=VTS;
guidata(hObject, handles);
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
%% Penetration and Rotational Viscosity Data
penndata=cell2mat(get(handles.uitable35,'Data'));
penn=penndata(:,2);
viscosity_penn=10.^(10.5012-2.2601.*log10(penn)+0.00389.*log(penn).^2).*100
logtemp_penn=log10(penndata(:,1)+459.7);
loglogviscosity_penn=log10(log10(viscosity_penn));
plot(handles.axes6,logtemp_penn,loglogviscosity_penn,'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes6,'Log Temp (R)');
ylabel(handles.axes6,'Log Log Viscosity (cPoise)');
title(handles.axes6,'From Penetration Testing');
legend;
fit=polyfit(logtemp_penn,loglogviscosity_penn,1);
VTS=fit(1);
A=fit(2);
set(handles.uitable34,'Data',[VTS;A]);
set(handles.text142,'String',VTS);
set(handles.text144,'String',A);
set(handles.text149,'String',VTS);
set(handles.text151,'String',A);
set(handles.text154,'String','From Penetration Testing');
p = polyfit(logtemp_penn,loglogviscosity_penn,1);
yfit = polyval(p,logtemp_penn);
yresid = loglogviscosity_penn - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(loglogviscosity_penn)-1) * var(loglogviscosity_penn);
rsq = 1 - SSresid/SStotal;
set(handles.text80,'String',rsq);
handles.A=A;
handles.VTS=VTS;
guidata(hObject, handles);

% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
rotationaldata=cell2mat(get(handles.uitable36,'Data'));
viscosity_rotational=rotationaldata(:,2);
logtemp_rotational=log10(rotationaldata(:,1)+459.7);
loglogviscosity_rotational=log10(log10(viscosity_rotational));
plot(handles.axes6,logtemp_rotational,loglogviscosity_rotational,'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes6,'Log Temp (R)');
ylabel(handles.axes6,'Log Log Viscosity (cPoise)');
title(handles.axes6,'From Rotational Viscometer Testing');
legend;
fit=polyfit(logtemp_rotational,loglogviscosity_rotational,1);
VTS=fit(1);
A=fit(2);
set(handles.uitable34,'Data',[VTS;A]);
set(handles.text142,'String',VTS);
set(handles.text144,'String',A);
set(handles.text149,'String',VTS);
set(handles.text151,'String',A);
set(handles.text154,'String','From Rotational Viscometer Testing')
p = polyfit(logtemp_rotational,loglogviscosity_rotational,1);
yfit = polyval(p,logtemp_rotational);
yresid = loglogviscosity_rotational - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(loglogviscosity_rotational)-1) * var(loglogviscosity_rotational);
rsq = 1 - SSresid/SStotal;
set(handles.text80,'String',rsq);
handles.A=A;
handles.VTS=VTS;
guidata(hObject, handles);
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16


% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)


% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20


% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21


% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton22


% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton23


% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton24


% --- Executes on button press in radiobutton25.
function radiobutton25_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton25


% --- Executes on button press in radiobutton26.
function radiobutton26_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton26


% --- Executes on button press in radiobutton27.
function radiobutton27_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton27


% --- Executes on button press in radiobutton28.
function radiobutton28_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton28


% --- Executes on button press in radiobutton29.
function radiobutton29_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton29


% --- Executes on button press in radiobutton30.
function radiobutton30_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton30


% --- Executes on button press in radiobutton31.
function radiobutton31_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton31


% --- Executes on button press in radiobutton32.
function radiobutton32_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton32


% --- Executes on button press in radiobutton33.
function radiobutton33_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton33


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
volumetrics_data=get(handles.uitable1,'Data');
volumetrics_data=table2array(cell2table(volumetrics_data));
Gmm=volumetrics_data(1,:);
Gsb=volumetrics_data(2,:);
AV=volumetrics_data(3,:);
AC=volumetrics_data(4,:);
Witczak_input=cell2mat(table2array(cell2table(get(handles.uitable42,'Data'))));
Gb=Witczak_input(1,:);
passing200=Witczak_input(2,:);
retained34=Witczak_input(3,:);
retained38=Witczak_input(4,:);
retained4=Witczak_input(5,:);

Gmb=Gmm-(AV/100)*Gmm;
Mb=AC/100*Gmb;
Vb=Mb/Gb;
Gse=(100-AC)/((100/Gmm)-(AC/Gb));
Ps=100-AC;
Ms=Gmb-Mb;
HMA_AV=AV;
Pba=100*((Gse-Gsb)/(Gsb*Gse))*Gb;
Pbe=AC-(Pba/100)*Ps;
Vs=Ms/Gse;
Vse=Ms/Gsb;
Vabs=Vse-Vs;
Vbe=Vb-Vabs;
ACe=Vbe*100;
VMA=(Vbe*100)+AV;
VFA=(Vbe*100)/VMA*100;
Tgmm=Gmb/(1-(1-(Vbe+Vabs+Vs)));

delta_Witczak=(-1.249937+0.029232*passing200-0.001767*passing200^2-0.002841*retained4-0.05809*HMA_AV-0.802208*(ACe/(ACe+HMA_AV)));
alpha_Witczak=(3.871977-0.0021*retained4+0.003958*retained38-0.000017*retained38^2+0.00547*retained34);

A = 	10.485
VTS = 	-3.4901

frequency=[25 10 5 1 0.5 0.1 25 10 5 1 0.5 0.1 25 10 5 1 0.5 0.1 0.01]';
temperature_F=[39 39 39 39 39 39 68 68 68 68 68 68 95 95 95 95 95 95 95]';
temperature_R=((temperature_F-32)*5/9)*1.8+491.67;
viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
beta_Witczak=(-0.603313-0.313351*log10(frequency));
E_Witczak=(10.^(delta_Witczak+(alpha_Witczak./(1+exp(beta_Witczak-0.393532.*log10(viscosity_Witczak)))))).*10^5;
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function binderdatamenu_Callback(hObject, eventdata, handles)

set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','on');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to binderdatamenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function volumetricdatamenu_Callback(hObject, eventdata, handles)

set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');

set(handles.uipanel31,'visible','on');

set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');

% hObject    handle to volumetricdatamenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function witczakmenu_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','on');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');

% hObject    handle to witczakmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sampledatamenu_Callback(hObject, eventdata, handles)

set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','on');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to sampledatamenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function projectdatamenu_Callback(hObject, eventdata, handles)

set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');

set(handles.uipanel31,'visible','off');

set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');

% hObject    handle to projectdatamenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)

%% Save Handles

% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)

set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','on');

set(handles.uipanel31,'visible','off');

set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
volumetrics_data=get(handles.uitable1,'Data');
volumetrics_data=table2array(cell2table(volumetrics_data));
Gmm=volumetrics_data(1,:);
Gsb=volumetrics_data(2,:);
AV=volumetrics_data(3,:);
AC=volumetrics_data(4,:);
Pb=AC;
Witczak_input=cell2mat(get(handles.uitable63,'Data'));
Gb=Witczak_input(1,:);
passing200=Witczak_input(2,:);
retained34=Witczak_input(3,:);
retained38=Witczak_input(4,:);
retained4=Witczak_input(5,:);

Gmb=Gmm-(AV/100)*Gmm;
Mb=AC/100*Gmb;
Vb=Mb/Gb;
Gse=(100-AC)/((100/Gmm)-(AC/Gb));
Ps=100-AC;
Ms=Gmb-Mb;
HMA_AV=AV;
Pba=100*((Gse-Gsb)/(Gsb*Gse))*Gb;
Pbe=AC-(Pba/100)*Ps;
Vs=Ms/Gse;
Vse=Ms/Gsb;
Vabs=Vse-Vs;
Vbe=Vb-Vabs;
ACe=Vbe*100;
VMA=(Vbe*100)+AV;
VFA=(Vbe*100)/VMA*100;
Tgmm=Gmb/(1-(1-(Vbe+Vabs+Vs)));

delta_Witczak=(-1.249937+0.029232*passing200-0.001767*passing200^2-0.002841*retained4-0.05809*HMA_AV-0.802208*(ACe/(ACe+HMA_AV)));
alpha_Witczak=(3.871977-0.0021*retained4+0.003958*retained38-0.000017*retained38^2+0.00547*retained34);

A=handles.A;
VTS=handles.VTS;

Witczak_data=[AV;Pb;Mb;Gmm;Tgmm;Gmb;Gse;Gsb;Ps;Ms;HMA_AV;Pba;Pbe;ACe;Vs;Vse;Vb;Vabs;Vbe;VMA;VFA;delta_Witczak;alpha_Witczak];
set(handles.uitable66,'Data',Witczak_data);
temperature_F=handles.tabledata_average(:,1);
frequency=handles.tabledata_average(:,3);
temperature_R=((temperature_F-32)*5/9)*1.8+491.67
viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6)
beta_Witczak=(-0.603313-0.313351*log10(frequency));
E_Witczak=(10.^(delta_Witczak+(alpha_Witczak./(1+exp(beta_Witczak-0.393532.*log10(viscosity_Witczak)))))).*10^5;
handles.E_Witczak=E_Witczak;
guidata(hObject, handles);

%% Show E_Witczak Data

set(handles.uitable65,'Data',[temperature_F,frequency,E_Witczak]);


% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','on');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
foldername = handles.foldername;
[FileName,PathName] = uigetfile({'*.xlsx';'*.xls'},'Input',[foldername,'\']);
Fullname1 = fullfile(PathName,FileName);
volumetric_inputdata=xlsread(Fullname1,1)
guidata(hObject,handles);
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function hirschmenu_Callback(hObject, eventdata, handles)

set(handles.splashpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.Hirschpanel,'visible','on');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to hirschmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable44_CreateFcn(hObject, eventdata, handles)
tablesize=cell(19,2);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)

set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');

set(handles.uipanel31,'visible','on');

set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mastercurvemenu_Callback(hObject, eventdata, handles)
% hObject    handle to mastercurvemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function inputmenu_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','on');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to inputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable45_CreateFcn(hObject, eventdata, handles)
tablesize=cell(19,2);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function eashiftmenu_Callback(hObject, eventdata, handles)
EA_completed=handles.EA_completed;
if EA_completed==1
    
    set(handles.datapanel,'visible','off');
    set(handles.binderpanel,'visible','off');
    
    set(handles.uipanel31,'visible','off');
    
    set(handles.EApanel,'visible','on');
    
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    logE_predicted_EA=handles.logE_predicted_EA;
    count_EA=handles.count_EA;
    x_EA=handles.x_EA;
    y_EA=handles.y_EA;
    reducedfrequency_EA=handles.reducedfrequency_EA;
    E_EA=handles.E_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    logE_measured_EA=handles.logE_measured_EA;
    shiftdata_EA=handles.shiftdata_EA;
    
    %EA Table
    set(handles.uitable44, 'Data', shiftdata_EA);
    set(handles.uitable45, 'Data', mastercurve_data_EA);
    plot(handles.axes9,count_EA,logE_measured_EA,'b-',count_EA,logE_predicted_EA,'r-','LineWidth',2);
    xlabel(handles.axes9,'Reduced Frequency');
    ylabel(handles.axes9,'Phase Angle (degrees)');
    title(handles.axes9,'EA Shifting');
    legend(handles.axes9,'Location','southwest','Measured LogE(psi)', 'Predicted log E (psi)');
    set(handles.text36,'String','EA Shifted Data');
    set(handles.text35,'String','Sum of Error^2');
    error_EA=handles.error_EA;;
    set(handles.text34,'String',sprintf('%.4f',error_EA));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    set(handles.text36,'String','EA Shifted Data');
    bestx2_EA=handles.bestx2_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_EA);
    
    
    %EA Graph
    cla(handles.axes10,'reset');
    loglog(handles.axes10,x_EA,y_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_EA,E_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'EA Shifting Master Curve');
    set(handles.text75,'String','EA Shifting Master Curve Data');
    
else
    warning=msgbox('No master curve data available for Arhenius Shifting. Please perform master curve analysis first.','Warning');
end

% hObject    handle to eashiftmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function vtsshiftmenu_Callback(hObject, eventdata, handles)
VTS_completed=handles.VTS_completed;
if VTS_completed==1
    
    set(handles.datapanel,'visible','off');
    set(handles.binderpanel,'visible','off');
    
    set(handles.uipanel31,'visible','off');
    
    set(handles.EApanel,'visible','on');
    
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    shiftdata_VTS=handles.shiftdata_VTS;
    logE_predicted_VTS=handles.logE_predicted_VTS;
    count_VTS=handles.count_VTS;
    x_VTS=handles.x_VTS;
    y_VTS=handles.y_VTS;
    reducedfrequency_VTS=handles.reducedfrequency_VTS;
    E_VTS=handles.E_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    logE_measured_VTS=handles.logE_measured_VTS;
    
    
    %VTS Table
    set(handles.uitable44, 'Data', shiftdata_VTS);
    set(handles.uitable45, 'Data', mastercurve_data_VTS);
    plot(handles.axes9,count_VTS,logE_measured_VTS,'b-',count_VTS,logE_predicted_VTS,'r-','LineWidth',2);
    xlabel(handles.axes9,'Reduced Frequency');
    ylabel(handles.axes9,'Phase Angle (degrees)');
    title(handles.axes9,'VTS Shifting');
    legend(handles.axes9,'Location','southwest','Measured LogE(psi)', 'Predicted log E (psi)');
    set(handles.text36,'String','VTS Shifting Data');
    set(handles.text35,'String','Sum of Error^2');
    error_VTS=handles.error_VTS;
    set(handles.text34,'String',sprintf('%.4f',error_VTS));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    set(handles.text36,'String','VTS Shifted Data');
    bestx2_VTS=handles.bestx2_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_VTS);
    
    
    %VTS Graph
    cla(handles.axes10,'reset');
    loglog(handles.axes10,x_VTS,y_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_VTS,E_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'VTS Shifting Master Curve');
    set(handles.text75,'String','VTS Shifting Master Curve Data');
else
    warning=msgbox('No master curve data available for VTS Shifting. Please perform master curve analysis first.','Warning');
end

% hObject    handle to vtsshiftmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function witczakshiftmenu_Callback(hObject, eventdata, handles)
Witczak_completed=handles.Witczak_completed;
if Witczak_completed==1
    
    set(handles.datapanel,'visible','off');
    set(handles.binderpanel,'visible','off');
    
    set(handles.uipanel31,'visible','off');
    
    set(handles.EApanel,'visible','on');
    
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    shiftdata_Witczak=handles.shiftdata_Witczak;
    logE_predicted_Witczak=handles.logE_predicted_Witczak;
    count_Witczak=handles.count_Witczak;
    x_Witczak=handles.x_Witczak;
    y_Witczak=handles.y_Witczak;
    reducedfrequency_Witczak=handles.reducedfrequency_Witczak;
    E_Witczak=handles.E_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    logE_measured_Witczak=handles.logE_measured_Witczak;
    
    
    %Witczak Table
    set(handles.uitable44, 'Data', shiftdata_Witczak);
    set(handles.uitable45, 'Data', mastercurve_data_Witczak);
    plot(handles.axes9,count_Witczak,logE_measured_Witczak,'b-',count_Witczak,logE_predicted_Witczak,'r-','LineWidth',2);
    xlabel(handles.axes9,'Reduced Frequency');
    ylabel(handles.axes9,'Phase Angle (degrees)');
    title(handles.axes9,'Witczak VTS Shifting');
    legend(handles.axes9,'Location','southwest','Measured LogE(psi)', 'Predicted log E (psi)');
    set(handles.text36,'String','Witczak VTS Shifting Data');
    set(handles.text35,'String','Sum of Error^2');
    error_Witczak=handles.error_Witczak;
    set(handles.text34,'String',sprintf('%.4f',error_Witczak));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    set(handles.text36,'String','Witczak VTS Shifted Data');
    bestx2_Witczak=handles.bestx2_Witczak;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Witczak);
    
    
    %Witczak Graph
    cla(handles.axes10,'reset');
    loglog(handles.axes10,x_Witczak,y_Witczak,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Witczak,E_Witczak,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Witczak VTS Shifting Master Curve');
    set(handles.text75,'String','Witczak VTS Shifting Master Curve Data');
else
    warning=msgbox('No master curve data available for Witczak PE VTS Shifting. Please perform master curve analysis first.','Warning');
end
% hObject    handle to witczakshiftmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function hirscheamenu_Callback(hObject, eventdata, handles)
HirschEA_completed=handles.HirschEA_completed;
if HirschEA_completed==1
    
    set(handles.datapanel,'visible','off');
    set(handles.binderpanel,'visible','off');
    
    set(handles.uipanel31,'visible','off');
    
    set(handles.EApanel,'visible','on');
    
else
    warning=msgbox('No master curve data available for Hirsch EA Shifting. Please perform master curve analysis first.','Warning');
end
% hObject    handle to hirscheamenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)

set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');

set(handles.uipanel31,'visible','off');

set(handles.EApanel,'visible','on');

% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
%% Analysis is being run




% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function analysismenu_Callback(hObject, eventdata, handles)

set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','on'); set(handles.comparisonpanel,'visible','off');

% hObject    handle to analysismenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mastercurvesummarymenu_Callback(hObject, eventdata, handles)
analysis_completed=handles.analysis_completed;
if analysis_completed==1
    
    
    set(handles.datapanel,'visible','off');
    set(handles.binderpanel,'visible','off');
    
    set(handles.uipanel31,'visible','off');
    
    set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
    
    
    % See which analysis was completed
    EA_completed=handles.EA_completed;
    VTS_completed=handles.VTS_completed;
    Witczak_completed=handles.Witczak_completed;
    HirschEA_completed=0;
    HirschVTS_completed=0;
    
    %EA completed?
    if EA_completed==1
        shiftdata_EA=handles.shiftdata_EA;
        logE_predicted_EA=handles.logE_predicted_EA;
        count_EA=handles.count_EA;
        x_EA=handles.x_EA;
        y_EA=handles.y_EA;
        reducedfrequency_EA=handles.reducedfrequency_EA;
        E_EA=handles.E_EA;
        mastercurve_data_EA=handles.mastercurve_data_EA;
        logE_measured_EA=handles.logE_measured_EA;
        loglog(handles.axes11,x_EA,y_EA,'r-','LineWidth',2);
        hold(handles.axes11, 'on' );
        loglog(handles.axes11,reducedfrequency_EA,E_EA,'r-','LineStyle','none','Marker','o');
        hold(handles.axes11, 'on' );
    else
    end
    
    %VTS completed?
    if VTS_completed==1
        shiftdata_VTS=handles.shiftdata_VTS;
        logE_predicted_VTS=handles.logE_predicted_VTS;
        count_VTS=handles.count_VTS;
        x_VTS=handles.x_VTS;
        y_VTS=handles.y_VTS;
        reducedfrequency_VTS=handles.reducedfrequency_VTS;
        E_VTS=handles.E_VTS;
        mastercurve_data_VTS=handles.mastercurve_data_VTS;
        logE_measured_VTS=handles.logE_measured_VTS;
        loglog(handles.axes11,x_VTS,y_VTS,'g-','LineWidth',2);
        hold(handles.axes11, 'on' );
        loglog(handles.axes11,reducedfrequency_VTS,E_VTS,'g-','LineStyle','none','Marker','o');
        hold(handles.axes11, 'on' );
    else
    end
    
    %Witczak completed?
    if Witczak_completed==1
        shiftdata_Witczak=handles.shiftdata_Witczak;
        logE_predicted_Witczak=handles.logE_predicted_Witczak;
        count_Witczak=handles.count_Witczak;
        x_Witczak=handles.x_Witczak;
        y_Witczak=handles.y_Witczak;
        reducedfrequency_Witczak=handles.reducedfrequency_Witczak;
        E_Witczak=handles.E_Witczak;
        mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
        logE_measured_Witczak=handles.logE_measured_Witczak;
        loglog(handles.axes11,x_Witczak,y_Witczak,'b-','LineWidth',2);
        hold(handles.axes11, 'on' );
        loglog(handles.axes11,reducedfrequency_Witczak,E_Witczak,'b-','LineStyle','none','Marker','o');
        hold(handles.axes11, 'on' );
    else
    end
    
    hold(handles.axes11, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes11,'Loading Frequency (Hz)');
    ylabel(handles.axes11,'Dynamic Modulus (psi)');
    legend(handles.axes11,'Location','southeast');
    title(handles.axes11,'Master Curves');
    
    %% Dynamic Legend Entries
    
    n=[EA_completed VTS_completed Witczak_completed HirschEA_completed HirschVTS_completed];
    
    legend_names=['EA'; 'EA'; 'VTS' ;'VTS'; 'Witczak VTS'; 'Witczak VTS'; 'Hirsch EA'; 'Hirsch EA'; 'Hirsch VTS'; 'Hirsch VTS'];
    legend_entries=strings(1,10);
    if n(1)==1
        legend_entries(1)='EA';
        legend_entries(2)='EA';
    end
    if n(2)==1
        legend_entries(3)='VTS';
        legend_entries(4)='VTS';
    end
    if n(3)==1
        legend_entries(5)='Witczak VTS';
        legend_entries(6)='Witczak VTS';
    end
    if n(4)==1
        legend_entries(7)='Hirsch EA';
        legend_entries(8)='Hirsch EA';
    end
    if n(5)==1
        legend_entries(9)='Hirsch VTS';
        legend_entries(10)='Hirsch VTS';
    end
    
    legend_entries=legend_entries(legend_entries ~= '');
    legend(handles.axes11,legend_entries);
else
    warning=msgbox('No master curve data available. Please perform master curve analysis first.','Warning');
end

% hObject    handle to mastercurvesummarymenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function hirschvtsmenu_Callback(hObject, eventdata, handles)
HirschVTS_completed=handles.HirschVTS_completed;
if HirschVTS_completed==1
    
    set(handles.datapanel,'visible','off');
    set(handles.binderpanel,'visible','off');
    
    set(handles.uipanel31,'visible','off');
    
    set(handles.EApanel,'visible','on');
    
else
    warning=msgbox('No master curve data available for Hirsch VTS Shifting. Please perform master curve analysis first.','Warning');
end
% hObject    handle to hirschvtsmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
foldername=([tempdir,getenv('username'),'\mcrCache9.4\RAATPa0\RAATPack_v2\']);
temporary_directory=dir([tempdir,getenv('username'),'\mcrCache9.4']);
list_directories={temporary_directory.name};
RAATPack_folder_index=find(contains(list_directories,'RAATPa'));
RAATPack_folder=cell2mat(list_directories(RAATPack_folder_index));
RAATPack_folder_full=([tempdir,getenv('username'),'\mcrCache9.4\',RAATPack_folder,'\RAATPack_v2\Dynamic Modulus\']);
foldername=RAATPack_folder_full;
IDEALCTGUI_direct=([foldername,'DynamicModulus.m']);
close(gcf);
run(IDEALCTGUI_direct);

% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
foldername = [];
[FileName,PathName] = uigetfile(('*.mat*'),'Input',string(foldername));
File_sample1 = fullfile(PathName,FileName);
if isequal(FileName,0)
else
    close(gcf);
    load(File_sample1);
end
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
currentdata = getappdata(gcf)
uisave('currentdata','\');
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


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


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21



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


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)

% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox23.
function checkbox23_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox23


% --- Executes on button press in checkbox24.
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox24


% --- Executes on button press in checkbox25.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox25


% --- Executes on button press in checkbox26.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26


% --- Executes on button press in checkbox27.
function checkbox27_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox27


% --- Executes on button press in checkbox28.
function checkbox28_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox28


% --- Executes on button press in checkbox29.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox29


% --- Executes on button press in checkbox30.
function checkbox30_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox30


% --- Executes on button press in checkbox31.
function checkbox31_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox31


% --- Executes on button press in checkbox32.
function checkbox32_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox32


% --- Executes on button press in checkbox33.
function checkbox33_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox33


% --- Executes on button press in checkbox34.
function checkbox34_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox34


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


% --- Executes on button press in checkbox39.
function checkbox39_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox39


% --- Executes on button press in checkbox40.
function checkbox40_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox40


% --- Executes on button press in checkbox41.
function checkbox41_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox41


% --- Executes on button press in checkbox42.
function checkbox42_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox42



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


% --- Executes on button press in checkbox43.
function checkbox43_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox43


% --- Executes on button press in checkbox44.
function checkbox44_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox44


% --- Executes on button press in checkbox45.
function checkbox45_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox45


% --- Executes on button press in checkbox46.
function checkbox46_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox46


% --- Executes on button press in checkbox47.
function checkbox47_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox47


% --- Executes on button press in checkbox48.
function checkbox48_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox48


% --- Executes on button press in checkbox49.
function checkbox49_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox49


% --- Executes on button press in checkbox50.
function checkbox50_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox50


% --- Executes on button press in checkbox51.
function checkbox51_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox51


% --- Executes on button press in checkbox52.
function checkbox52_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox52


% --- Executes on button press in checkbox53.
function checkbox53_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox53


% --- Executes on button press in checkbox54.
function checkbox54_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox54


% --- Executes on button press in checkbox55.
function checkbox55_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox55


% --- Executes on button press in checkbox56.
function checkbox56_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox56


% --- Executes on button press in checkbox57.
function checkbox57_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox57


% --- Executes on button press in checkbox58.
function checkbox58_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox58


% --- Executes on button press in checkbox59.
function checkbox59_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox59


% --- Executes on button press in checkbox60.
function checkbox60_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox60


% --- Executes on button press in checkbox61.
function checkbox61_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox61


% --- Executes on button press in checkbox62.
function checkbox62_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox62


% --- Executes on button press in checkbox63.
function checkbox63_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox63



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


% --- Executes on button press in checkbox84.
function checkbox84_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox84


% --- Executes on button press in checkbox83.
function checkbox83_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox83


% --- Executes on button press in checkbox82.
function checkbox82_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox82


% --- Executes on button press in checkbox81.
function checkbox81_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox81


% --- Executes on button press in checkbox80.
function checkbox80_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox80


% --- Executes on button press in checkbox79.
function checkbox79_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox79


% --- Executes on button press in checkbox78.
function checkbox78_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox78


% --- Executes on button press in checkbox77.
function checkbox77_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox77


% --- Executes on button press in checkbox76.
function checkbox76_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox76


% --- Executes on button press in checkbox75.
function checkbox75_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox75


% --- Executes on button press in checkbox74.
function checkbox74_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox74


% --- Executes on button press in checkbox73.
function checkbox73_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox73


% --- Executes on button press in checkbox72.
function checkbox72_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox72


% --- Executes on button press in checkbox71.
function checkbox71_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox71


% --- Executes on button press in checkbox70.
function checkbox70_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox70


% --- Executes on button press in checkbox69.
function checkbox69_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox69


% --- Executes on button press in checkbox68.
function checkbox68_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox68


% --- Executes on button press in checkbox67.
function checkbox67_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox67


% --- Executes on button press in checkbox66.
function checkbox66_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox66


% --- Executes on button press in checkbox65.
function checkbox65_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox65


% --- Executes on button press in checkbox64.
function checkbox64_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox64


% --- Executes during object creation, after setting all properties.
function pushbutton26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
%% Which Curve to Export
curves={'AMPT (EA Shifting)' 'VTS Shifting' 'No Constraints Shifting' 'Witczak Prediction Equation' 'Hirsch Model VT Shifting' 'Hirsch Model EA Shifting'};
RAATPack_folder=getappdata(0,'RAATPack_folder');
EA=get(handles.checkbox85,'Value');
VTS=get(handles.checkbox94,'Value');
NoConstr=get(handles.checkbox96,'Value');
Witczak=get(handles.checkbox86,'Value');
Hirsch_VTS=get(handles.checkbox95,'Value');
Hirsch_EA=get(handles.checkbox87,'Value');
phase=handles.tabledata_average(:,5);
if EA==0
    curves(1)={'N/A'};
end
if VTS==0
curves(2)={'N/A'};
end
if NoConstr==0
curves(3)={'N/A'};
end
if Witczak==0
curves(4)={'N/A'};
end
if Hirsch_VTS==0
curves(5)={'N/A'};
end
if Hirsch_EA==0
curves(6)={'N/A'};
end



opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          select = listdlg('PromptString','Select the Master Curve(s) to Export:',...
                      'SelectionMode','single',...
                      'ListString',curves);
                  
if select==1
    frequency=flip(handles.reducedfrequency_EA);
    E=flip(handles.E_EA);
    phase=flip(phase);
    stdev_E=flip(handles.stdev_E);
    x=handles.x_EA;
    y=handles.y_EA;
    Title={'EA Shifting Master Curve'};
end
if select==2
    frequency=flip(handles.reducedfrequency_VTS);
    E=flip(handles.E_VTS);
    phase=flip(phase);
    stdev_E=flip(handles.stdev_E);
    x=flip(handles.x_VTS);
    y=flip(handles.y_VTS);
    Title={'VTS Shifting Master Curve'};
end
if select==3
    frequency=flip(handles.reducedfrequency_NoConstr);
    E=flip(handles.E_NoConstr);
    stdev_E=flip(handles.stdev_E);
    phase={''};
    x=flip(handles.x_NoConstr);
    y=flip(handles.y_NoConstr);
    Title={'No Constraints Shifting Master Curve'};
end         
if select==4
    frequency=flip(handles.reducedfrequency_Witczak);
    E=flip(handles.E_Witczak);
    phase=flip(phase);
    stdev_E={''};
    x=flip(handles.x_Witczak);
    y=flip(handles.y_Witczak);
    Title={'Witczak Shifting Master Curve'};
end 
if select==5
    frequency=flip(handles.reducedfrequency_Hirsch_VTS);
    E=flip(handles.E_Hirsch_VTS);
    phase=flip(phase);
    stdev_E={''};
    x=flip(handles.x_Hirsch_VTS);
    y=flip(handles.y_Hirsch_VTS);
    Title={'Hirsch Model VTS Shifting Master Curve'};
end
if select==6
    frequency=flip(handles.reducedfrequency_Hirsch_EA);
    E=flip(handles.E_Hirsch_EA);
    phase=flip(phase);
    stdev_E={''};
    x=handles.x_Hirsch_EA;
    y=handles.y_Hirsch_EA;
    Title={'Hirsch Model EA Shifting Master Curve'};
end
%% Export

%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges');
if admin_privileges_value == 0
    templatefile=[RAATPack_folder,'Templates\Dynamic Modulus Templates\Dynamic Modulus Template.xlsx'];
[savefile, savepath] = uiputfile(('*.pdf'),'Save',handles.foldername);
if isequal(savefile,0)
else
handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit39,'String'));
MixType=cellstr(get(handles.edit40,'String'));
Institution=cellstr(get(handles.edit42,'String'));
Date=cellstr(get(handles.edit43,'String'));
Technician=cellstr(get(handles.edit44,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,frequency,1,'H6');
xlswrite(savefullname_excel,E,1,'I6');
xlswrite(savefullname_excel,stdev_E,1,'J6');
xlswrite(savefullname_excel,phase,1,'K6');
xlswrite(savefullname_excel,x,1,'M6');
xlswrite(savefullname_excel,y,1,'N6');


waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Title,1,'A5');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');

xlswrite(savefullname_excel,Project,1,'I2');
xlswrite(savefullname_excel,MixType,1,'I3');
xlswrite(savefullname_excel,Institution,1,'M2');
xlswrite(savefullname_excel,Date,1,'M3');
xlswrite(savefullname_excel,Technician,1,'M4');

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
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Dynamic Modulus session?'], ...
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
templatefile=[RAATPack_folder,'Templates\Dynamic Modulus Templates\Dynamic Modulus Template_RU.xlsx'];
[savefile, savepath] = uiputfile(('*.xlsx'),'Save',handles.foldername);
if isequal(savefile,0)
else
handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit39,'String'));
MixType=cellstr(get(handles.edit40,'String'));
Institution=cellstr(get(handles.edit42,'String'));
Date=cellstr(get(handles.edit43,'String'));
Technician=cellstr(get(handles.edit44,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,frequency,1,'H6');
xlswrite(savefullname_excel,E,1,'I6');
xlswrite(savefullname_excel,stdev_E,1,'J6');
xlswrite(savefullname_excel,phase,1,'K6');
xlswrite(savefullname_excel,x,1,'M6');
xlswrite(savefullname_excel,y,1,'N6');              


waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Title,1,'A5');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');

xlswrite(savefullname_excel,Project,1,'I2');
xlswrite(savefullname_excel,MixType,1,'I3');
xlswrite(savefullname_excel,Institution,1,'M2');
xlswrite(savefullname_excel,Date,1,'M3');
xlswrite(savefullname_excel,Technician,1,'M4');


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

% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
set(handles.volumetricpanel,'visible','off');
set(handles.binderpanel,'visible','on');
set(handles.AMPTpanel,'visible','off');
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
set(handles.volumetricpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.AMPTpanel,'visible','on');
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
set(handles.volumetricpanel,'visible','on');
set(handles.binderpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes6,'reset');
set(handles.uitable34,'Data',[]);
set(handles.text80,'String',[]);
set(handles.text142,'String',[]);
set(handles.text144,'String',[]);
set(handles.text149,'String',[]);
set(handles.text151,'String',[]);
handles.A=[];
handles.VTS=[];
guidata(hObject, handles);

% --- Executes on selection change in popupmenu23.
function popupmenu23_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu23 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu23


% --- Executes during object creation, after setting all properties.
function popupmenu23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu24.
function popupmenu24_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu24 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu24


% --- Executes during object creation, after setting all properties.
function popupmenu24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu27.
function popupmenu27_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu27 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu27


% --- Executes during object creation, after setting all properties.
function popupmenu27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double


% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu21.
function popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21


% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu22.
function popupmenu22_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22


% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu26.
function popupmenu26_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu26 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu26


% --- Executes during object creation, after setting all properties.
function popupmenu26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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



function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19


% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu20.
function popupmenu20_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu20


% --- Executes during object creation, after setting all properties.
function popupmenu20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu25.
function popupmenu25_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu25 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu25


% --- Executes during object creation, after setting all properties.
function popupmenu25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
set(handles.volumetricpanel,'visible','on');
set(handles.binderpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox85.
function checkbox85_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox85


% --- Executes on button press in checkbox86.
function checkbox86_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox86


% --- Executes on button press in checkbox87.
function checkbox87_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox87


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = waitbar(0,'Loading files. Please wait');
set(handles.volumetricpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.datapanel,'visible','on');
PathName=handles.PathName;
%% Sample 1 File 1
idx = get(handles.popupmenu3,'Value');
items = get(handles.popupmenu3,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample1_file1=[];
    blackspacedata_sample1_file1=[];
    freqs_sample1_file1=[];
else
File_sample1_file1 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample1_file1);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample1_file1=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample1_file1=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample1_file1=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample1_file1=str2double(get(handles.edit17,'String'));
target_temperature_sample1_file1=round(target_temperature_sample1_file1*9/5+32).*frequencies_sample1_file1.^0;
tabledata_sample1_file1=[target_temperature_sample1_file1,data_sample1_file1(:,3),frequencies_sample1_file1,data_sample1_file1(:,1)*145.038,data_sample1_file1(:,2),log10(data_sample1_file1(:,1)*145.038)];
blackspacedata_sample1_file1=[tabledata_sample1_file1(:,1),tabledata_sample1_file1(:,6),tabledata_sample1_file1(:,5)];
end
%% Sample 1 File 2
idx = get(handles.popupmenu4,'Value');
items = get(handles.popupmenu4,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample1_file2=[];
    blackspacedata_sample1_file2=[];
    freqs_sample1_file2=[];
else
File_sample1_file2 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample1_file2);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample1_file2=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample1_file2=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample1_file2=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample1_file2=str2double(get(handles.edit18,'String'));
target_temperature_sample1_file2=round(target_temperature_sample1_file2*9/5+32).*frequencies_sample1_file2.^0;
tabledata_sample1_file2=[target_temperature_sample1_file2,data_sample1_file2(:,3),frequencies_sample1_file2,data_sample1_file2(:,1)*145.038,data_sample1_file2(:,2),log10(data_sample1_file2(:,1)*145.038)];
blackspacedata_sample1_file2=[tabledata_sample1_file2(:,1),tabledata_sample1_file2(:,6),tabledata_sample1_file2(:,5)];
end
%% Sample 1 File 3
idx = get(handles.popupmenu5,'Value');
items = get(handles.popupmenu5,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample1_file3=[];
    blackspacedata_sample1_file3=[];
    freqs_sample1_file3=[];
else
File_sample1_file3 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample1_file3);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample1_file3=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample1_file3=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample1_file3=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample1_file3=str2double(get(handles.edit19,'String'));
target_temperature_sample1_file3=round(target_temperature_sample1_file3*9/5+32).*frequencies_sample1_file3.^0;
tabledata_sample1_file3=[target_temperature_sample1_file3,data_sample1_file3(:,3),frequencies_sample1_file3,data_sample1_file3(:,1)*145.038,data_sample1_file3(:,2),log10(data_sample1_file3(:,1)*145.038)];
blackspacedata_sample1_file3=[tabledata_sample1_file3(:,1),tabledata_sample1_file3(:,6),tabledata_sample1_file3(:,5)];
end
%% Sample 2 File 1
idx = get(handles.popupmenu6,'Value');
items = get(handles.popupmenu6,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample2_file1=[];
    blackspacedata_sample2_file1=[];
    freqs_sample2_file1=[];
else
File_sample2_file1 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample2_file1);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample2_file1=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample2_file1=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample2_file1=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample2_file1=str2double(get(handles.edit51,'String'));
target_temperature_sample2_file1=round(target_temperature_sample2_file1*9/5+32).*frequencies_sample2_file1.^0;
tabledata_sample2_file1=[target_temperature_sample2_file1,data_sample2_file1(:,3),frequencies_sample2_file1,data_sample2_file1(:,1)*145.038,data_sample2_file1(:,2),log10(data_sample2_file1(:,1)*145.038)];
blackspacedata_sample2_file1=[tabledata_sample2_file1(:,1),tabledata_sample2_file1(:,6),tabledata_sample2_file1(:,5)];
end
%% Sample 2 File 2
idx = get(handles.popupmenu7,'Value');
items = get(handles.popupmenu7,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample2_file2=[];
    blackspacedata_sample2_file2=[];
    freqs_sample2_file2=[];
else
File_sample2_file2 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample2_file2);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample2_file2=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample2_file2=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample2_file2=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample2_file2=str2double(get(handles.edit50,'String'));
target_temperature_sample2_file2=round(target_temperature_sample2_file2*9/5+32).*frequencies_sample2_file2.^0;
tabledata_sample2_file2=[target_temperature_sample2_file2,data_sample2_file2(:,3),frequencies_sample2_file2,data_sample2_file2(:,1)*145.038,data_sample2_file2(:,2),log10(data_sample2_file2(:,1)*145.038)];
blackspacedata_sample2_file2=[tabledata_sample2_file2(:,1),tabledata_sample2_file2(:,6),tabledata_sample2_file2(:,5)];
end
%% Sample 2 File 3
idx = get(handles.popupmenu8,'Value');
items = get(handles.popupmenu8,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample2_file3=[];
    blackspacedata_sample2_file3=[];
    freqs_sample2_file3=[];
else
File_sample2_file3 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample2_file3);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample2_file3=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample2_file3=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample2_file3=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample2_file3=str2double(get(handles.edit49,'String'));
target_temperature_sample2_file3=round(target_temperature_sample2_file3*9/5+32).*frequencies_sample2_file3.^0;
tabledata_sample2_file3=[target_temperature_sample2_file3,data_sample2_file3(:,3),frequencies_sample2_file3,data_sample2_file3(:,1)*145.038,data_sample2_file3(:,2),log10(data_sample2_file3(:,1)*145.038)];
blackspacedata_sample2_file3=[tabledata_sample2_file3(:,1),tabledata_sample2_file3(:,6),tabledata_sample2_file3(:,5)];
end
%% Sample 3 File 1
idx = get(handles.popupmenu9,'Value');
items = get(handles.popupmenu9,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample3_file1=[];
    blackspacedata_sample3_file1=[];
    freqs_sample3_file1=[];
else
File_sample3_file1 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample3_file1);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample3_file1=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample3_file1=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample3_file1=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample3_file1=str2double(get(handles.edit54,'String'));
target_temperature_sample3_file1=round(target_temperature_sample3_file1*9/5+32).*frequencies_sample3_file1.^0;
tabledata_sample3_file1=[target_temperature_sample3_file1,data_sample3_file1(:,3),frequencies_sample3_file1,data_sample3_file1(:,1)*145.038,data_sample3_file1(:,2),log10(data_sample3_file1(:,1)*145.038)];
blackspacedata_sample3_file1=[tabledata_sample3_file1(:,1),tabledata_sample3_file1(:,6),tabledata_sample3_file1(:,5)];
end
%% Sample 3 File 2
idx = get(handles.popupmenu10,'Value');
items = get(handles.popupmenu10,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample3_file2=[];
    blackspacedata_sample3_file2=[];
    freqs_sample3_file2=[];
else
File_sample3_file2 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample3_file2);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample3_file2=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample3_file2=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample3_file2=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample3_file2=str2double(get(handles.edit53,'String'));
target_temperature_sample3_file2=round(target_temperature_sample3_file2*9/5+32).*frequencies_sample3_file2.^0;
tabledata_sample3_file2=[target_temperature_sample3_file2,data_sample3_file2(:,3),frequencies_sample3_file2,data_sample3_file2(:,1)*145.038,data_sample3_file2(:,2),log10(data_sample3_file2(:,1)*145.038)];
blackspacedata_sample3_file2=[tabledata_sample3_file2(:,1),tabledata_sample3_file2(:,6),tabledata_sample3_file2(:,5)];
end
%% Sample 3 File 3
idx = get(handles.popupmenu11,'Value');
items = get(handles.popupmenu11,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample3_file3=[];
    blackspacedata_sample3_file3=[];
    freqs_sample3_file3=[];
else
File_sample3_file3 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample3_file3);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample3_file3=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample3_file3=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample3_file3=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample3_file3=str2double(get(handles.edit52,'String'));
target_temperature_sample3_file3=round(target_temperature_sample3_file3*9/5+32).*frequencies_sample3_file3.^0;
tabledata_sample3_file3=[target_temperature_sample3_file3,data_sample3_file3(:,3),frequencies_sample3_file3,data_sample3_file3(:,1)*145.038,data_sample3_file3(:,2),log10(data_sample3_file3(:,1)*145.038)];
blackspacedata_sample3_file3=[tabledata_sample3_file3(:,1),tabledata_sample3_file3(:,6),tabledata_sample3_file3(:,5)];
end

%% Make sure frequencies match
if size(freqs_sample1_file1,2)~=size(freqs_sample2_file1,2)|| size(freqs_sample1_file1,2)~=size(freqs_sample3_file1,2)|| size(freqs_sample2_file1,2)~=size(freqs_sample3_file1,2)||size(freqs_sample1_file2,2)~=size(freqs_sample2_file2,2)|| size(freqs_sample1_file2,2)~=size(freqs_sample3_file2,2)|| size(freqs_sample2_file2,2)~=size(freqs_sample3_file2,2)||size(freqs_sample1_file3,2)~=size(freqs_sample2_file3,2)|| size(freqs_sample1_file3,2)~=size(freqs_sample3_file3,2)|| size(freqs_sample2_file3,2)~=size(freqs_sample3_file3,2)
warn=1
end
[q,b]=max([size(freqs_sample1_file1,2),size(freqs_sample1_file2,2), size(freqs_sample1_file3,2),size(freqs_sample2_file1,2),size(freqs_sample2_file2,2), size(freqs_sample2_file3,2),size(freqs_sample3_file1,2),size(freqs_sample3_file2,2), size(freqs_sample3_file3,2)]);
allfreq={freqs_sample1_file1;freqs_sample1_file2; freqs_sample1_file3;freqs_sample2_file1;freqs_sample2_file2; freqs_sample2_file3;freqs_sample3_file1;freqs_sample3_file2; freqs_sample3_file3};

basefreq=allfreq{b}'
handles.basefreq=basefreq;
[xx,ia,ib] = intersect(freqs_sample1_file1,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample1_file1=basefreq;
newfreq_sample1_file1(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit17,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;

try
base_tabledata(ib,:)=tabledata_sample1_file1;
catch
base_tabledata(ib,:)=tabledata_sample1_file1(ib,:);
end

tabledata_sample1_file1=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample1_file1;  
catch
    base_blackspacedata(ib,:)=blackspacedata_sample1_file1(ib,:);
  
end
blackspacedata_sample1_file1=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample1_file2,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample1_file2=basefreq;
newfreq_sample1_file2(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit18,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample1_file2;
catch
    base_tabledata(ib,:)=tabledata_sample1_file2(ib,:);

end

tabledata_sample1_file2=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample1_file2;    
catch
    base_blackspacedata(ib,:)=blackspacedata_sample1_file2(ib,:);

end
blackspacedata_sample1_file2=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample1_file3,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample1_file3=basefreq;
newfreq_sample1_file3(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit19,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample1_file3;
catch
    base_tabledata(ib,:)=tabledata_sample1_file3(ib,:);

end

tabledata_sample1_file3=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample1_file3;   
catch
    base_blackspacedata(ib,:)=blackspacedata_sample1_file3(ib,:);
 
end
blackspacedata_sample1_file3=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample2_file1,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample2_file1=basefreq;
newfreq_sample2_file1(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit51,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample2_file1;
catch
base_tabledata(ib,:)=tabledata_sample2_file1(ib,:);
end

tabledata_sample2_file1=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample2_file1;  
catch
    base_blackspacedata(ib,:)=blackspacedata_sample2_file1(ib,:);
  
end
blackspacedata_sample2_file1=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample2_file2,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample2_file2=basefreq;
newfreq_sample2_file2(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit50,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample2_file2;
catch
    base_tabledata(ib,:)=tabledata_sample2_file2(ib,:);

end

tabledata_sample2_file2=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample2_file2;    
catch
    base_blackspacedata(ib,:)=blackspacedata_sample2_file2(ib,:);

end
blackspacedata_sample2_file2=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample2_file3,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample2_file3=basefreq;
newfreq_sample2_file3(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit49,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample2_file3;
catch
    base_tabledata(ib,:)=tabledata_sample2_file3(ib,:);

end

tabledata_sample2_file3=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample2_file3;   
catch
    base_blackspacedata(ib,:)=blackspacedata_sample2_file3(ib,:);
 
end
blackspacedata_sample2_file3=base_blackspacedata;


[xx,ia,ib] = intersect(freqs_sample3_file1,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample3_file1=basefreq;
newfreq_sample3_file1(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit54,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample3_file1;
catch
base_tabledata(ib,:)=tabledata_sample3_file1(ib,:);
end

tabledata_sample3_file1=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample3_file1;  
catch
    base_blackspacedata(ib,:)=blackspacedata_sample3_file1(ib,:);
  
end
blackspacedata_sample3_file1=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample3_file2,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample3_file2=basefreq;
newfreq_sample3_file2(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit53,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample3_file2;
catch
    base_tabledata(ib,:)=tabledata_sample3_file2(ib,:);
end

tabledata_sample3_file2=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample3_file2;    
catch
    base_blackspacedata(ib,:)=blackspacedata_sample3_file2(ib,:);

end
blackspacedata_sample3_file2=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample3_file3,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample3_file3=basefreq;
newfreq_sample3_file3(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit52,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample3_file3;
catch
    base_tabledata(ib,:)=tabledata_sample3_file3(ib,:);

end

tabledata_sample3_file3=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample3_file3;   
catch
    base_blackspacedata(ib,:)=blackspacedata_sample3_file3(ib,:);
 
end
blackspacedata_sample3_file3=base_blackspacedata;


%% Average Data
tabledata_sample1=[tabledata_sample1_file1;tabledata_sample1_file2;tabledata_sample1_file3];
tabledata_sample2=[tabledata_sample2_file1;tabledata_sample2_file2;tabledata_sample2_file3];
tabledata_sample3=[tabledata_sample3_file1;tabledata_sample3_file2;tabledata_sample3_file3];
handles.tabledata_sample1=tabledata_sample1;
handles.tabledata_sample2=tabledata_sample2;
handles.tabledata_sample3=tabledata_sample3;
blackspacedata_sample1=[blackspacedata_sample1_file1;blackspacedata_sample1_file2;blackspacedata_sample1_file3];
blackspacedata_sample2=[blackspacedata_sample2_file1;blackspacedata_sample2_file2;blackspacedata_sample2_file3];
blackspacedata_sample3=[blackspacedata_sample3_file1;blackspacedata_sample3_file2;blackspacedata_sample3_file3];
handles.blackspacedata_sample1=blackspacedata_sample1;
handles.blackspacedata_sample2=blackspacedata_sample2;
handles.blackspacedata_sample3=blackspacedata_sample3;


pp1=nanmean([tabledata_sample1(:,1),tabledata_sample2(:,1),tabledata_sample3(:,1)],2);
pp2=nanmean([tabledata_sample1(:,2),tabledata_sample2(:,2),tabledata_sample3(:,2)],2);
pp3=nanmean([tabledata_sample1(:,3),tabledata_sample2(:,3),tabledata_sample3(:,3)],2);
pp4=nanmean([tabledata_sample1(:,4),tabledata_sample2(:,4),tabledata_sample3(:,4)],2);
pp5=nanmean([tabledata_sample1(:,5),tabledata_sample2(:,5),tabledata_sample3(:,5)],2);
pp6=nanmean([tabledata_sample1(:,6),tabledata_sample2(:,6),tabledata_sample3(:,6)],2);
tabledata_average=[pp1,pp2,pp3,pp4,pp5,pp6];

pp1=nanmean([blackspacedata_sample1(:,1),blackspacedata_sample2(:,1),blackspacedata_sample3(:,1)],2);
pp2=nanmean([blackspacedata_sample1(:,2),blackspacedata_sample2(:,2),blackspacedata_sample3(:,2)],2);
pp3=nanmean([blackspacedata_sample1(:,3),blackspacedata_sample2(:,3),blackspacedata_sample3(:,3)],2);
blackspacedata_average=[pp1,pp2,pp3];

tabledata_average(any(isnan(tabledata_average), 2), :) = [];
blackspacedata_average(any(isnan(blackspacedata_average), 2), :) = [];
tabledata_average(:,6)=log10(tabledata_average(:,4));
handles.tabledata_average=tabledata_average;
handles.ogdata=tabledata_average;

blackspacedata_average(:,2)=log10(tabledata_average(:,4));
handles.blackspacedata_average=blackspacedata_average;
handles.ogblackspace=blackspacedata_average;
tabledata_sample1(:,4);
stdev_E=nanstd([tabledata_sample1(:,4),tabledata_sample2(:,4),tabledata_sample3(:,4)],[],2);
stdev_phase=nanstd([tabledata_sample1(:,5),tabledata_sample2(:,5),tabledata_sample3(:,5)],[],2);

stdev_E(any(isnan(stdev_E), 2), :) = [];
stdev_phase(any(isnan(stdev_phase), 2), :) = [];


cov_E=stdev_E./tabledata_average(:,4)*100;
stdev_phase=stdev_phase./tabledata_average(:,5)*100;
covdata=[stdev_E,stdev_phase,cov_E,stdev_phase];


fulltabledata_average=[tabledata_average,covdata];
handles.fulltabledata_average=fulltabledata_average;
handles.stdev_E=stdev_E;
guidata(hObject,handles);
%% Set Table & Graph
handles.blackspacedata_sample1(any(isnan(blackspacedata_sample1), 2), :) = [];
handles.blackspacedata_sample2(any(isnan(blackspacedata_sample2), 2), :) = [];
handles.blackspacedata_sample3(any(isnan(blackspacedata_sample3), 2), :) = [];

tabledata_sample1=handles.tabledata_sample1;
set(handles.uitable20, 'Data', tabledata_sample1);
blackspacedata_sample1=handles.blackspacedata_sample1;
%Sample 1 Fit
p = polyfit(blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),2);
fit_sample1=p(1).*blackspacedata_sample1(:,2).^2+p(2).*blackspacedata_sample1(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample1(:,2));
yresid = blackspacedata_sample1(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample1(:,3))-1) * var(blackspacedata_sample1(:,3));
rsq_sample1 = 1 - SSresid/SStotal;;
set(handles.text34,'String',sprintf('%.4f',rsq_sample1));
set(handles.text35,'String','Goodness of Fit R^2');
set(handles.popupmenu1,'Value',1);
scatter(handles.axes5,blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),'filled','MarkerFaceColor',[0 0 0]);
hold(handles.axes5,'on')
plot(handles.axes5,blackspacedata_sample1(:,2),fit_sample1,'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes5,'Log E* (psi)');
ylabel(handles.axes5,'Phase Angle (degrees)');
title(handles.axes5,'Sample 1 Black Space Data');
hold(handles.axes5,'off');


%% Fit Check
%Sample 1 Fit
p = polyfit(blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),2);
fit_sample1=p(1).*blackspacedata_sample1(:,2).^2+p(2).*blackspacedata_sample1(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample1(:,2));
yresid = blackspacedata_sample1(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample1(:,3))-1) * var(blackspacedata_sample1(:,3));
rsq_sample1 = 1 - SSresid/SStotal;;
%Sample 2 Fit
p = polyfit(blackspacedata_sample2(:,2),blackspacedata_sample2(:,3),2);
fit_sample2=p(1).*blackspacedata_sample2(:,2).^2+p(2).*blackspacedata_sample2(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample2(:,2));
yresid = blackspacedata_sample2(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample2(:,3))-1) * var(blackspacedata_sample2(:,3));
rsq_sample2 = 1 - SSresid/SStotal;
%Sample 3 Fit
p = polyfit(blackspacedata_sample3(:,2),blackspacedata_sample3(:,3),2);
fit_sample3=p(1).*blackspacedata_sample3(:,2).^2+p(2).*blackspacedata_sample3(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample3(:,2));
yresid = blackspacedata_sample3(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample3(:,3))-1) * var(blackspacedata_sample3(:,3));
rsq_sample3 = 1 - SSresid/SStotal;
close(f);

handles.fit_sample1=fit_sample1;
handles.fit_sample2=fit_sample2;
handles.fit_sample3=fit_sample3;
guidata(hObject, handles);

if rsq_sample3 < .95
    f = msgbox('WARNING: R^2 value for averaged sample data is less than 0.95. Check data for potential errors during testing.','Warning');
end
if rsq_sample3 < .95
    f = msgbox('WARNING: R^2 value for sample 3 is less than 0.95. Check data for potential errors during testing.','Warning');
end
if rsq_sample2 < .95
    f = msgbox('WARNING: R^2 value for sample 2 is less than 0.95. Check data for potential errors during testing.','Warning');
end
if rsq_sample1 < .95
    f = msgbox('WARNING: R^2 value for sample 1 is less than 0.95. Check data for potential errors during testing.','Warning');
end
if cov_E > .13
    
    f = msgbox('WARNING: The Coefficient of Variation (COV) between E* values are greater than 13%. Check the consistency of test temperatures or potential errors in LVDT/sample alignment. To view these values, select the average sample data tab.');
end
%% Save Handles


% --- Executes on button press in pushbutton64.
function pushbutton64_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable63_CreateFcn(hObject, eventdata, handles)
tablesize=cell(5,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','on');
% hObject    handle to pushbutton69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable66_CreateFcn(hObject, eventdata, handles)
tablesize=cell(23,1);
set(hObject, 'Data', tablesize);
% hObject    handle to uitable66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','on');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');

% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','on');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
% hObject    handle to pushbutton71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shiftdata_Witczak=log10(E_Witczak);
logE_measured_Witczak=log10(E_Witczak);
binder_data=get(handles.uitable34,'Data');
VTS=binder_data(1);
A=binder_data(2);
EMAX=get(handles.uitable28,'Data');
viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
for j=1:size(temperature_R,1)
    if viscosity_Witczak(j)>2.7*10^12;
        viscosity_Witczak(j)=2.7*10^12;
    else
        viscosity_Witczak(j) = 10.^(10.^(A+(VTS.*log10(temperature_F(j)+459.7))));
    end
end
viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
viscosity_ref_Witczak=viscosity_Witczak(7);
x0 = [3.7935		-1.0528	0.4188	1.2440];
sse= @(x) sseval_Witczak(x,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
lb = [0,-5,0, 0];
ub = [5,0,5, 5];
A = [];
b = [];
Aeq = [];
beq = [];
bestx_Witczak = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
sseval_Witczak(bestx_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);

x2_Witczak=bestx_Witczak;
bestx2_Witczak = fmincon(sse,x2_Witczak,A,b,Aeq,beq,lb,ub);
sseval_Witczak(bestx2_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);

delta_Witczak=bestx2_Witczak(1);
beta_Witczak=bestx2_Witczak(2);
gamma_Witczak=bestx2_Witczak(3);
C_Witczak=bestx2_Witczak(4);
k=get(handles.uitable28,'Data');
EMAX=k;
reference_temp=str2double(get(handles.edit20,'String'))+273.15;
count_Witczak = 1:length(frequency);
logE_predicted_Witczak=((delta_Witczak+((log10(EMAX)-delta_Witczak)./(1+exp(beta_Witczak+gamma_Witczak*(log10(1./frequency)-C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak))))))));
handles.logE_measured_Witczak=logE_measured_Witczak;
handles.count_Witczak=count_Witczak;
handles.logE_predicted_Witczak=logE_predicted_Witczak;
error_Witczak=sseval_Witczak(bestx2_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
handles.error_Witczak=error_Witczak;
handles.bestx2_Witczak=bestx2_Witczak;
guidata(hObject, handles);
reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
x_Witczak=1./(10.^reduced);
y_Witczak=10.^(delta_Witczak+((log10(EMAX)-delta_Witczak)./(1+exp(beta_Witczak+gamma_Witczak*reduced))));
%frequency=[25;10;5;1;.5;.1;25;10;5;1;.5;.1;25;10;5;1;.5;.1;0.01];
reducedT=(log10(1./frequency)-(C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak))));
reducedfrequency_Witczak=1./(10.^reducedT);
tabledata_average=handles.tabledata_average;
E_Witczak=tabledata_average(:,4);
mastercurve_data_Witczak=[reducedfrequency_Witczak,E_Witczak];
handles.mastercurve_data_Witczak=mastercurve_data_Witczak;
handles.x_Witczak=x_Witczak;
handles.y_Witczak=y_Witczak;
handles.reducedfrequency=reducedfrequency_Witczak;
handles.E_Witczak=E_Witczak;
handles.mastercurve_data_Witczak=mastercurve_data_Witczak;
handles.logE_predicted_Witczak=logE_predicted_Witczak;
handles.reducedfrequency_Witczak=reducedfrequency_Witczak;


%Witczak VTS Table
shiftdata_Witczak=[logE_measured_Witczak, logE_predicted_Witczak];
handles.shiftdata_Witczak=shiftdata_Witczak;
set(handles.uitable44, 'Data', shiftdata_Witczak);
set(handles.uitable45, 'Data', mastercurve_data_Witczak);
plot(handles.axes9,count_Witczak,logE_measured_Witczak,'b-',count_Witczak,logE_predicted_Witczak,'r-','LineWidth',2);
xlabel(handles.axes9,'Reduced Frequency');
ylabel(handles.axes9,'Phase Angle (degrees)');
title(handles.axes9,'Witczak VTS Shifting');
legend(handles.axes9,'Location','southwest','Measured LogE(psi)', 'Predicted log E (psi)');

set(handles.text35,'String','Sum of Error^2');
error_Witczak=handles.error_Witczak
set(handles.text34,'String',sprintf('%.4f',error_Witczak));
newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};

bestx2_Witczak=handles.bestx2_Witczak
count_Witczak=handles.count_Witczak;
coefficients={'Delta','Beta','Gamma','C'};
set(handles.uitable25,'columnname',coefficients);
set(handles.uitable25, 'Data',bestx2_Witczak);


%Witczak VTS Graph
cla(handles.axes10,'reset');
loglog(handles.axes10,x_Witczak,y_Witczak,'b-','LineWidth',2);
hold(handles.axes10, 'on' );
loglog(handles.axes10,reducedfrequency_Witczak,E_Witczak,'k','LineStyle','none','Marker','o');
hold(handles.axes10, 'off' );
axis(handles.axes10,[10^-7 10^7 1000 10^7]);
xlabel(handles.axes10,'Loading Frequency (Hz)');
ylabel(handles.axes10,'Dynamic Modulus (psi)');
legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
title(handles.axes10,'Witczak VTS Shifting Master Curve');

% Has Witczak VTS been completed?


guidata(hObject, handles);


% --- Executes on button press in checkbox94.
function checkbox94_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox94


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)




% hObject    handle to pushbutton73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function pushbutton74_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton74.
p=get(handles.uibuttongroup10,'SelectedObject');
stdev_E=handles.stdev_E;
if p.Tag=='radiobutton50'
    handles.tabledata_average(:,1)=handles.ogdata(:,1);  
    handles.blackspacedata_average(:,1)=handles.ogdata(:,1);  
    try
    handles.temps_Hirsch=handles.temps_F_Hirsch;
    end
elseif p.Tag=='radiobutton49'
    handles.tabledata_average(:,1)=handles.ogdata(:,2);
    handles.blackspacedata_average(:,1)=handles.ogdata(:,2);
    try
    handles.temps_Hirsch=handles.temps_F_Hirsch;
    end
end
guidata(hObject, handles);

phase=handles.tabledata_average(:,5);
temperature_F=handles.tabledata_average(:,1);
frequency=handles.tabledata_average(:,3);
temperature_R=((temperature_F-32)*5/9)*1.8+491.67;



%% EA Shifting
if get(handles.checkbox85,'Value')==1
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    EAshiftdata=blackspacedata_average;
    temperature_F=EAshiftdata(:,1);
    frequency=tabledata_average(:,3);
    logE_measured_EA=EAshiftdata(:,2);
    EMAX=get(handles.uitable28,'Data');
    x0_EA = [4,-1,-0.5,2.0*10^5];
    sse= @(x) sseval(x,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    lb = [-50,-50,-50,2*10^5];
    ub = [50,0,0,2*10^5];
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_EA = fmincon(sse,x0_EA,A,b,Aeq,beq,lb,ub);
    sseval(bestx_EA,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    
    x2_EA=bestx_EA;
    bestx2_EA = fmincon(sse,x2_EA,A,b,Aeq,beq,lb,ub);
    
    sseval(bestx2_EA,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    
    
    
    
    delta_EA=bestx2_EA(1);
    beta_EA=bestx2_EA(2);
    gamma_EA=bestx2_EA(3);
    EA_EA=bestx2_EA(4);
    k=get(handles.uitable28,'Data');
    EMAX=k;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    count_EA = 1:length(frequency);
    logE_predicted_EA=(delta_EA+((log10(EMAX)-delta_EA)./(1+exp(beta_EA+gamma_EA*(log10(frequency)+(EA_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)))))));
    handles.reduced_EA=(log10(frequency)+(EA_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)));
    handles.logE_measured_EA=logE_measured_EA;
    handles.count_EA=count_EA;
    error_EA=sseval(bestx2_EA,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    handles.error_EA=error_EA;
    handles.bestx2_EA=bestx2_EA;
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_EA=10.^reduced;
    y_EA=10.^(delta_EA+((log10(EMAX)-delta_EA)./(1+exp(beta_EA+gamma_EA*reduced))));
    reducedfrequency_EA=10.^((log10(frequency)+((EA_EA/19.14714)*((1./((temperature_F-32)*5/9+273.15))-(1./reference_temp)))));
    tabledata_average=handles.tabledata_average;
    E_EA=tabledata_average(:,4);
    mastercurve_data_EA=[reducedfrequency_EA,E_EA];
    handles.x_EA=x_EA;
    handles.y_EA=y_EA;
    handles.reducedfrequency_EA=reducedfrequency_EA;
    handles.E_EA=E_EA;
    handles.mastercurve_data_EA=mastercurve_data_EA;
    handles.logE_predicted_EA=logE_predicted_EA;
end

%% VTS Shifting

if get(handles.checkbox94,'Value')==1
    A=handles.A;
    VTS=handles.VTS;
    
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    frequency=tabledata_average(:,3);
    EMAX=get(handles.uitable28,'Data');
    
    A=handles.A;
    VTS=handles.VTS;
    shiftdata_VTS=blackspacedata_average;
    logE_measured_VTS=shiftdata_VTS(:,2);
    binder_data=get(handles.uitable34,'Data');
    temperature_F=shiftdata_VTS(:,1);
    k=size(temperature_F);
    k=k(1);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    temperature_F=handles.tabledata_average(:,1);
    frequency=handles.tabledata_average(:,3);
    temperature_R=temperature_F+459.67;
    viscosity_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_VTS(j)>2.7*10^12;
            viscosity_VTS(j)=2.7*10^12;
        else
            viscosity_VTS(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_VTS>2.7*10^12;
        viscosity_ref_VTS=2.7*10^12;
    else
        viscosity_ref_VTS= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end
    
    
    x0 = [2.7550 -1.3202	0.4716	1.0764];
    sse= @(x) sseval_VTS(x,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    lb = [0,-5,0, 0];
    ub = [5,0,5, 5];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_VTS = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
    sseval_VTS(bestx_VTS,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    
    x2_VTS=bestx_VTS;
    bestx2_VTS = fmincon(sse,x2_VTS,A,b,Aeq,beq,lb,ub);
    sseval_VTS(bestx2_VTS,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    
    delta_VTS=bestx2_VTS(1);
    beta_VTS=bestx2_VTS(2);
    gamma_VTS=bestx2_VTS(3);
    C_VTS=bestx2_VTS(4);
    
    count_VTS = 1:length(frequency);
    logE_predicted_VTS=((delta_VTS+((log10(EMAX)-delta_VTS)./(1+exp(beta_VTS+gamma_VTS*(log10(1./frequency)-C_VTS.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS))))))));
    handles.reduced_VTS=(log10(1./frequency)-C_VTS.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS)));
    handles.logE_measured_VTS=logE_measured_VTS;
    handles.count_VTS=count_VTS;
    handles.logE_predicted_VTS=logE_predicted_VTS;
    error_VTS=sseval_VTS(bestx2_VTS,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    handles.error_VTS=error_VTS;
    handles.bestx2_VTS=bestx2_VTS;
    guidata(hObject, handles);
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_VTS=1./(10.^reduced);
    y_VTS=10.^(delta_VTS+((log10(EMAX)-delta_VTS)./(1+exp(beta_VTS+gamma_VTS*reduced))));
    %frequency=[25;10;5;1;.5;.1;25;10;5;1;.5;.1;25;10;5;1;.5;.1;0.01];
    reducedT=(log10(1./frequency)-(C_VTS.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS))));
    reducedfrequency_VTS=1./(10.^reducedT);
    tabledata_average=handles.tabledata_average;
    E_VTS=tabledata_average(:,4);
    mastercurve_data_VTS=[reducedfrequency_VTS,E_VTS];
    handles.mastercurve_data_VTS=mastercurve_data_VTS;
    handles.x_VTS=x_VTS;
    handles.y_VTS=y_VTS;
    handles.reducedfrequency=reducedfrequency_VTS;
    handles.E_VTS=E_VTS;
    handles.mastercurve_data_VTS=mastercurve_data_VTS;
    handles.logE_predicted_VTS=logE_predicted_VTS;
    handles.reducedfrequency_VTS=reducedfrequency_VTS;
    handles.count_VTS=count_VTS;
    handles.error_VTS=error_VTS;
end

%% Experimental Shifting

if get(handles.checkbox96,'Value')==1
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    NoConstrshiftdata=blackspacedata_average;
    temperature_F=NoConstrshiftdata(:,1);
    frequency=tabledata_average(:,3);
    EMAX=get(handles.uitable28,'Data');
    

    A=handles.A;
    VTS=handles.VTS;
    shiftdata_NoConstr=blackspacedata_average;
    logE_measured_NoConstr=shiftdata_NoConstr(:,2);
    binder_data=get(handles.uitable34,'Data');
    temperature_F=shiftdata_NoConstr(:,1);
    k=size(temperature_F);
    k=k(1);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    temperature_F=handles.tabledata_average(:,1);
    frequency=handles.tabledata_average(:,3);
    temperature_R=temperature_F+459.67;
    viscosity_NoConstr=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_NoConstr(j)>2.7*10^12;
            viscosity_NoConstr(j)=2.7*10^12;
        else
            viscosity_NoConstr(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_NoConstr=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_NoConstr>2.7*10^12;
        viscosity_ref_NoConstr=2.7*10^12;
    else
        viscosity_ref_NoConstr= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end    

temp1_idx=max(find(shiftdata_NoConstr(:,1)-shiftdata_NoConstr(1,1)<5));
temp2_idx=temp1_idx+1;
temp3_idx=max(find(shiftdata_NoConstr(:,1)-shiftdata_NoConstr(temp2_idx,1)<5))+1;

range1=shiftdata_NoConstr(1:temp1_idx,:);
range2=shiftdata_NoConstr(temp2_idx:temp3_idx-1,:);
range3=shiftdata_NoConstr(temp3_idx:end,:);

frequency1=frequency(1:temp1_idx,:);
frequency2=frequency(temp2_idx:temp3_idx-1,:);
frequency3=frequency(temp3_idx:end,:);


x0_NoConstr = [3.5,1,0.5,2,-2.5];
    sse= @(x) sseval_exp(x,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);
    lb = [-50,-50,0,0,-5];
    ub = [50,0,50,5,0];
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_NoConstr = fmincon(sse,x0_NoConstr,A,b,Aeq,beq,lb,ub);
    sseval_exp(bestx_NoConstr,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);
    
    x2_NoConstr=bestx_NoConstr;
    bestx2_NoConstr = fmincon(sse,x2_NoConstr,A,b,Aeq,beq,lb,ub);
    
    sseval_exp(bestx2_NoConstr,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);    
    delta_NoConstr=bestx2_NoConstr(1);
    beta_NoConstr=bestx2_NoConstr(2);
    gamma_NoConstr=bestx2_NoConstr(3);
    c_NoConstr=bestx2_NoConstr(4);
    cc_NoConstr=0;
    ccc_NoConstr=bestx2_NoConstr(5);
    
    k=get(handles.uitable28,'Data');
    EMAX=k;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    count_NoConstr = 1:length(frequency);
    
    frequency_exp1=10^c_NoConstr.*frequency1;
frequency_exp2=10^cc_NoConstr.*frequency2;
frequency_exp3=10^ccc_NoConstr.*frequency3;

frequency_exp=[frequency_exp1;frequency_exp2;frequency_exp3];
reduced_T_NoConstr=log10(1./frequency_exp);
    
    logE_predicted_NoConstr=((delta_NoConstr+((log10(EMAX)-delta_NoConstr)./(1+exp(beta_NoConstr+gamma_NoConstr.*(reduced_T_NoConstr))))));
    handles.reduced_NoConstr=log10(1./frequency_exp);
    handles.logE_measured_NoConstr=logE_measured_NoConstr;
    handles.count_NoConstr=count_NoConstr;
    error_NoConstr=sseval_exp(bestx2_NoConstr,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);
    handles.error_NoConstr=error_NoConstr;
    handles.bestx2_NoConstr=bestx2_NoConstr;
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_NoConstr=1./(10.^reduced);
    y_NoConstr=10.^(delta_NoConstr+((log10(EMAX)-delta_NoConstr)./(1+exp(beta_NoConstr+gamma_NoConstr*reduced))));
    reducedfrequency_NoConstr=frequency_exp;
    tabledata_average=handles.tabledata_average;
    E_NoConstr=tabledata_average(:,4);
    mastercurve_data_NoConstr=[reducedfrequency_NoConstr,E_NoConstr];
    handles.x_NoConstr=x_NoConstr;
    handles.y_NoConstr=y_NoConstr;
    handles.reducedfrequency_NoConstr=reducedfrequency_NoConstr;
    handles.E_NoConstr=E_NoConstr;
    handles.mastercurve_data_NoConstr=mastercurve_data_NoConstr;
    handles.logE_predicted_NoConstr=logE_predicted_NoConstr;
 end   
%% Witczak Master Curve
if get(handles.checkbox86,'Value')==1
    
        volumetrics_data=get(handles.uitable1,'Data');
volumetrics_data=table2array(cell2table(volumetrics_data));
Gmm=volumetrics_data(1,:);
Gsb=volumetrics_data(2,:);
AV=volumetrics_data(3,:);
AC=volumetrics_data(4,:);
Pb=AC;
Witczak_input=cell2mat(get(handles.uitable63,'Data'));
Gb=Witczak_input(1,:);
passing200=Witczak_input(2,:);
retained34=Witczak_input(3,:);
retained38=Witczak_input(4,:);
retained4=Witczak_input(5,:);

Gmb=Gmm-(AV/100)*Gmm;
Mb=AC/100*Gmb;
Vb=Mb/Gb;
Gse=(100-AC)/((100/Gmm)-(AC/Gb));
Ps=100-AC;
Ms=Gmb-Mb;
HMA_AV=AV;
Pba=100*((Gse-Gsb)/(Gsb*Gse))*Gb;
Pbe=AC-(Pba/100)*Ps;
Vs=Ms/Gse;
Vse=Ms/Gsb;
Vabs=Vse-Vs;
Vbe=Vb-Vabs;
ACe=Vbe*100;
VMA=(Vbe*100)+AV;
VFA=(Vbe*100)/VMA*100;
Tgmm=Gmb/(1-(1-(Vbe+Vabs+Vs)));

delta_Witczak=(-1.249937+0.029232*passing200-0.001767*passing200^2-0.002841*retained4-0.05809*HMA_AV-0.802208*(ACe/(ACe+HMA_AV)));
alpha_Witczak=(3.871977-0.0021*retained4+0.003958*retained38-0.000017*retained38^2+0.00547*retained34);

A=handles.A;
VTS=handles.VTS;

Witczak_data=[AV;Pb;Mb;Gmm;Tgmm;Gmb;Gse;Gsb;Ps;Ms;HMA_AV;Pba;Pbe;ACe;Vs;Vse;Vb;Vabs;Vbe;VMA;VFA;delta_Witczak;alpha_Witczak];
set(handles.uitable66,'Data',Witczak_data);
frequency=handles.tabledata_average(:,3);
temperature_R=((temperature_F-32)*5/9)*1.8+491.67
viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6)
beta_Witczak=(-0.603313-0.313351*log10(frequency));
E_Witczak=(10.^(delta_Witczak+(alpha_Witczak./(1+exp(beta_Witczak-0.393532.*log10(viscosity_Witczak)))))).*10^5;
handles.E_Witczak=E_Witczak;
guidata(hObject, handles);

%% Show E_Witczak Data

set(handles.uitable65,'Data',[temperature_F,frequency,E_Witczak]);
    
    A=handles.A;
    VTS=handles.VTS;
    E_Witczak=handles.E_Witczak;
    shiftdata_Witczak=log10(E_Witczak);
    logE_measured_Witczak=log10(E_Witczak);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_Witczak(j)>2.7*10^12;
            viscosity_Witczak(j)=2.7*10^12;
        else
            viscosity_Witczak(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_Witczak>2.7*10^12;
        viscosity_ref_Witczak=2.7*10^12;
    else
        viscosity_ref_Witczak= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end
    
    EMAX=get(handles.uitable28,'Data');
    
    x0 = [3.7935		-1.0528	0.4188	1.2440];
    sse= @(x) sseval_Witczak(x,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
    lb = [0,-5,0, 0];
    ub = [5,0,5, 5];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_Witczak = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
    sseval_Witczak(bestx_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
    
    x2_Witczak=bestx_Witczak;
    bestx2_Witczak = fmincon(sse,x2_Witczak,A,b,Aeq,beq,lb,ub);
    sseval_Witczak(bestx2_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
    
    delta_Witczak=bestx2_Witczak(1);
    beta_Witczak=bestx2_Witczak(2);
    gamma_Witczak=bestx2_Witczak(3);
    C_Witczak=bestx2_Witczak(4);
    
    reference_temp=str2num(get(handles.edit20,'String'));
    count_Witczak = 1:length(frequency);
    
    logE_predicted_Witczak=((delta_Witczak+((log10(EMAX)-delta_Witczak)./(1+exp(beta_Witczak+gamma_Witczak*(log10(1./frequency)-C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak))))))));
    handles.reduced_Witczak=(log10(1./frequency)-C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak)));
    handles.logE_measured_Witczak=logE_measured_Witczak;
    handles.count_Witczak=count_Witczak;
    handles.logE_predicted_Witczak=logE_predicted_Witczak;
    error_Witczak=sseval_Witczak(bestx2_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak)
    handles.error_Witczak=error_Witczak;
    handles.bestx2_Witczak=bestx2_Witczak;
    guidata(hObject, handles);
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_Witczak=1./(10.^reduced);
    y_Witczak=10.^(delta_Witczak+((log10(EMAX)-delta_Witczak)./(1+exp(beta_Witczak+gamma_Witczak*reduced))));
    
    %frequency=[25;10;5;1;.5;.1;25;10;5;1;.5;.1;25;10;5;1;.5;.1;0.01];
    reducedT=(log10(1./frequency)-(C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak))));
    reducedfrequency_Witczak=1./(10.^reducedT);
    tabledata_average=handles.tabledata_average;
    mastercurve_data_Witczak=[reducedfrequency_Witczak,E_Witczak];
    handles.x_Witczak=x_Witczak;
    handles.y_Witczak=y_Witczak;
    handles.reducedfrequency_Witczak=reducedfrequency_Witczak;
    handles.E_Witczak=E_Witczak;
    handles.mastercurve_data_Witczak=mastercurve_data_Witczak;
    handles.logE_predicted_Witczak=logE_predicted_Witczak;
end

%% Hirsch EA Shifting
if get(handles.checkbox87,'Value')==1
frequency=handles.frequency_Hirsch;

temperature_F=handles.temps_Hirsch;

    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    EAshiftdata=blackspacedata_average;
    logE_measured_Hirsch_EA=handles.logE_measured_Hirsch_EA;
    EMAX=get(handles.uitable28,'Data');
    x0_Hirsch_EA = [4,-1,-0.5,2.0*10^5];
    sse= @(x) sseval(x,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    lb = [-5,-5,-5,2*10^5];
    ub = [5,0,0,2*10^5];
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_Hirsch_EA = fmincon(sse,x0_Hirsch_EA,A,b,Aeq,beq,lb,ub);
    sseval(bestx_Hirsch_EA,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    
    x2_Hirsch_EA=bestx_Hirsch_EA;
    bestx2_Hirsch_EA = fmincon(sse,x2_Hirsch_EA,A,b,Aeq,beq,lb,ub);
    sseval(bestx2_Hirsch_EA,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    
    delta_Hirsch_EA=bestx2_Hirsch_EA(1);
    beta_Hirsch_EA=bestx2_Hirsch_EA(2);
    gamma_Hirsch_EA=bestx2_Hirsch_EA(3);
    EA_Hirsch_EA=bestx2_Hirsch_EA(4);
    k=get(handles.uitable28,'Data');
    EMAX=k;
    
    count_Hirsch_EA = 1:length(frequency);
    logE_predicted_Hirsch_EA=(delta_Hirsch_EA+((log10(EMAX)-delta_Hirsch_EA)./(1+exp(beta_Hirsch_EA+gamma_Hirsch_EA*(log10(frequency)+(EA_Hirsch_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)))))));
    handles.reduced_Hirsch_EA=(log10(frequency)+(EA_Hirsch_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)));
    handles.logE_measured_Hirsch_EA=logE_measured_Hirsch_EA;
    handles.count_Hirsch_EA=count_Hirsch_EA;
    error_Hirsch_EA=sseval(bestx2_Hirsch_EA,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    handles.error_Hirsch_EA=error_Hirsch_EA;
    handles.bestx2_Hirsch_EA=bestx2_Hirsch_EA;
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_Hirsch_EA=10.^reduced;
    y_Hirsch_EA=10.^(delta_Hirsch_EA+((log10(EMAX)-delta_Hirsch_EA)./(1+exp(beta_Hirsch_EA+gamma_Hirsch_EA*reduced))));
    
    reducedfrequency_Hirsch_EA=10.^((log10(frequency)+((EA_Hirsch_EA/19.14714)*((1./((temperature_F-32)*5/9+273.15))-(1./reference_temp)))));
    tabledata_average=handles.tabledata_average;
    E_Hirsch_EA=handles.E_Hirsch;
    mastercurve_data_Hirsch_EA=[reducedfrequency_Hirsch_EA,E_Hirsch_EA];
    handles.x_Hirsch_EA=x_Hirsch_EA;
    handles.y_Hirsch_EA=y_Hirsch_EA;
    handles.reducedfrequency_Hirsch_EA=reducedfrequency_Hirsch_EA;
    handles.E_Hirsch_EA=E_Hirsch_EA;
    handles.mastercurve_data_Hirsch_EA=mastercurve_data_Hirsch_EA;
    handles.logE_predicted_Hirsch_EA=logE_predicted_Hirsch_EA;
end



%% Hirsch VTS Shifting

if get(handles.checkbox95,'Value')==1
    A=handles.A;
    VTS=handles.VTS;
    
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
frequency=handles.frequency_Hirsch;

temperature_F=handles.temps_Hirsch;
    EMAX=get(handles.uitable28,'Data');
    
    A=handles.A;
    VTS=handles.VTS;
    shiftdata_Hirsch_VTS=blackspacedata_average;
    logE_measured_Hirsch_VTS=handles.logE_measured_Hirsch_EA;
    binder_data=get(handles.uitable34,'Data');
    k=size(temperature_F);
    k=k(1);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    temperature_R=temperature_F+459.67;
    viscosity_Hirsch_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_Hirsch_VTS(j)>2.7*10^12;
            viscosity_Hirsch_VTS(j)=2.7*10^12;
        else
            viscosity_Hirsch_VTS(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_Hirsch_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_Hirsch_VTS>2.7*10^12;
        viscosity_ref_Hirsch_VTS=2.7*10^12;
    else
        viscosity_ref_Hirsch_VTS= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end
    
    
    x0 = [2.7550 -1.3202	0.4716	1.0764];
    sse= @(x) sseval_Hirsch_VTS(x,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    lb = [0,-5,0, 0];
    ub = [5,0,5, 5];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_Hirsch_VTS = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
    sseval_Hirsch_VTS(bestx_Hirsch_VTS,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    
    x2_Hirsch_VTS=bestx_Hirsch_VTS;
    bestx2_Hirsch_VTS = fmincon(sse,x2_Hirsch_VTS,A,b,Aeq,beq,lb,ub);
    sseval_Hirsch_VTS(bestx2_Hirsch_VTS,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    
    delta_Hirsch_VTS=bestx2_Hirsch_VTS(1);
    beta_Hirsch_VTS=bestx2_Hirsch_VTS(2);
    gamma_Hirsch_VTS=bestx2_Hirsch_VTS(3);
    C_Hirsch_VTS=bestx2_Hirsch_VTS(4);
    
    count_Hirsch_VTS = 1:length(frequency);
    logE_predicted_Hirsch_VTS=((delta_Hirsch_VTS+((log10(EMAX)-delta_Hirsch_VTS)./(1+exp(beta_Hirsch_VTS+gamma_Hirsch_VTS*(log10(1./frequency)-C_Hirsch_VTS.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS))))))));
    handles.reduced_Hirsch_VTS=(log10(1./frequency)-C_Hirsch_VTS.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS)));
    handles.logE_measured_Hirsch_VTS=logE_measured_Hirsch_VTS;
    handles.count_Hirsch_VTS=count_Hirsch_VTS;
    handles.logE_predicted_Hirsch_VTS=logE_predicted_Hirsch_VTS;
    error_Hirsch_VTS=sseval_Hirsch_VTS(bestx2_Hirsch_VTS,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    handles.error_Hirsch_VTS=error_Hirsch_VTS;
    handles.bestx2_Hirsch_VTS=bestx2_Hirsch_VTS;
    guidata(hObject, handles);
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_Hirsch_VTS=1./(10.^reduced);
    y_Hirsch_VTS=10.^(delta_Hirsch_VTS+((log10(EMAX)-delta_Hirsch_VTS)./(1+exp(beta_Hirsch_VTS+gamma_Hirsch_VTS*reduced))));
    reducedT=(log10(1./frequency)-(C_Hirsch_VTS.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS))));
    reducedfrequency_Hirsch_VTS=1./(10.^reducedT);
    tabledata_average=handles.tabledata_average;
    E_Hirsch_VTS=handles.E_Hirsch_EA;
    mastercurve_data_Hirsch_VTS=[reducedfrequency_Hirsch_VTS,E_Hirsch_VTS];
    handles.mastercurve_data_Hirsch_VTS=mastercurve_data_Hirsch_VTS;
    handles.x_Hirsch_VTS=x_Hirsch_VTS;
    handles.y_Hirsch_VTS=y_Hirsch_VTS;
    handles.reducedfrequency=reducedfrequency_Hirsch_VTS;
    handles.E_Hirsch_VTS=E_Hirsch_VTS;
    handles.mastercurve_data_Hirsch_VTS=mastercurve_data_Hirsch_VTS;
    handles.logE_predicted_Hirsch_VTS=logE_predicted_Hirsch_VTS;
    handles.reducedfrequency_Hirsch_VTS=reducedfrequency_Hirsch_VTS;
    handles.count_Hirsch_VTS=count_Hirsch_VTS;
    handles.error_Hirsch_VTS=error_Hirsch_VTS;
end

guidata(hObject, handles);
%% Graph
set(handles.uitable71,'visible','off');
phase=handles.tabledata_average(:,5);
phase_Hirsch=phase(1:end-1);
p=get(handles.uibuttongroup6,'SelectedObject');
if get(handles.checkbox85,'Value')==1 
    set(handles.radiobutton37,'value',1);
    logE_measured_EA=handles.logE_measured_EA;
    logE_predicted_EA=handles.logE_predicted_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    x_EA=handles.x_EA;
    y_EA=handles.y_EA;
    reducedfrequency=handles.reducedfrequency_EA;
    E_EA=handles.E_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    count_EA=handles.count_EA;
    reducedfrequency_EA=handles.reducedfrequency_EA;
    error_EA=handles.error_EA;;
    
    
    
    %EA Phase Angle
    
    set(handles.uitable44, 'Data', [handles.reduced_EA,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_EA);
    
    p = polyfit(handles.reduced_EA,phase,5);
    fit_sample1=p(1).*handles.reduced_EA.^5+p(2).*handles.reduced_EA.^4+p(3).*handles.reduced_EA.^3+p(4).*handles.reduced_EA.^2+p(5).*handles.reduced_EA+p(6);
    
    yfit = polyval(p,handles.reduced_EA);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_EA)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;
set(handles.text179,'String',rsq_sample1);
    scatter(handles.axes9,handles.reduced_EA,phase,'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes9,'on');
    plot(handles.axes9,handles.reduced_EA,fit_sample1,'b-','LineWidth',2);
    hold(handles.axes9,'off');
    xlabel(handles.axes9,'Reduced Frequency');
    ylabel(handles.axes9,'Phase Angle (degrees)');
    set(handles.text95,'String',sprintf('%.4f',error_EA));
    
    error_EA=handles.error_EA;;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_EA=handles.bestx2_EA;
    count_EA=handles.count_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_EA);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_EA,y_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_EA,E_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'EA Shifting Master Curve');
    guidata(hObject, handles);
    
elseif get(handles.checkbox94,'Value')==1
    %VTS Table
    set(handles.radiobutton38,'value',1);
    logE_measured_VTS=handles.logE_measured_VTS;
    logE_predicted_VTS=handles.logE_predicted_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    x_VTS=handles.x_VTS;
    y_VTS=handles.y_VTS;
    reducedfrequency=handles.reducedfrequency_VTS;
    E_VTS=handles.E_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    count_VTS=handles.count_VTS;
    reducedfrequency_VTS=handles.reducedfrequency_VTS;
    error_VTS=handles.error_VTS;
    
    

    set(handles.uitable44, 'Data', [handles.reduced_VTS,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_VTS);
    p = polyfit(handles.reduced_VTS,phase,5);
    fit_sample1=p(1).*handles.reduced_VTS.^5+p(2).*handles.reduced_VTS.^4+p(3).*handles.reduced_VTS.^3+p(4).*handles.reduced_VTS.^2+p(5).*handles.reduced_VTS+p(6);
yfit = polyval(p,handles.reduced_VTS);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_VTS)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;

    
    set(handles.text95,'String',sprintf('%.4f',error_VTS));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    bestx2_VTS=handles.bestx2_VTS;
    count_VTS=handles.count_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_VTS);
    
    
    
    %VTS Graph
    loglog(handles.axes10,x_VTS,y_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_VTS,E_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'VTS Shifting Master Curve');
    
elseif get(handles.checkbox86,'Value')==1
    set(handles.radiobutton39,'value',1);
    logE_measured_Witczak=handles.logE_measured_Witczak;
    logE_predicted_Witczak=handles.logE_predicted_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    x_Witczak=handles.x_Witczak;
    y_Witczak=handles.y_Witczak;
    reducedfrequency=handles.reducedfrequency_Witczak;
    E_Witczak=handles.E_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    count_Witczak=handles.count_Witczak;
    reducedfrequency_Witczak=handles.reducedfrequency_Witczak;
    error_Witczak=handles.error_Witczak;
    
    
    %% Witczak Master Curve
    
    %Witczak VTS Table
    
    shiftdata_Witczak=[logE_measured_Witczak, logE_predicted_Witczak];
    handles.shiftdata_Witczak=shiftdata_Witczak;
    set(handles.uitable44, 'Data', [handles.reduced_Witczak,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_Witczak);
    p = polyfit(handles.reduced_Witczak,phase,5);
    fit_sample1=p(1).*handles.reduced_Witczak.^5+p(2).*handles.reduced_Witczak.^4+p(3).*handles.reduced_Witczak.^3+p(4).*handles.reduced_Witczak.^2+p(5).*handles.reduced_Witczak+p(6);
    yfit = polyval(p,handles.reduced_Witczak);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Witczak)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;
    

    
    set(handles.text35,'String','Sum of Error^2');
    error_Witczak=handles.error_Witczak
    set(handles.text95,'String',error_Witczak);
    set(handles.text34,'String',sprintf('%.4f',error_Witczak));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Witczak=handles.bestx2_Witczak;
    count_Witczak=handles.count_Witczak;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Witczak);
    
    
    %Witczak VTS Graph
    cla(handles.axes10,'reset');
    loglog(handles.axes10,x_Witczak,y_Witczak,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Witczak,E_Witczak,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Witczak VTS Shifting Master Curve');
    
    
elseif get(handles.checkbox87,'Value')==1
    set(handles.radiobutton41,'value',1);
    logE_measured_Hirsch_EA=handles.logE_measured_Hirsch_EA;
    logE_predicted_Hirsch_EA=handles.logE_predicted_Hirsch_EA;
    mastercurve_data_Hirsch_EA=handles.mastercurve_data_Hirsch_EA;
    x_Hirsch_EA=handles.x_Hirsch_EA;
    y_Hirsch_EA=handles.y_Hirsch_EA;
    reducedfrequency=handles.reducedfrequency_Hirsch_EA;
    E_Hirsch_EA=handles.E_Hirsch_EA;
    mastercurve_data_Hirsch_EA=handles.mastercurve_data_Hirsch_EA;
    count_Hirsch_EA=handles.count_Hirsch_EA;
    reducedfrequency_Hirsch_EA=handles.reducedfrequency_Hirsch_EA;
    error_Hirsch_EA=handles.error_Hirsch_EA;
    
    
    
    %EA Table
    shiftdata_Hirsch_EA=[logE_measured_Hirsch_EA, logE_predicted_Hirsch_EA];
    handles.shiftdata_Hirsch_EA=shiftdata_Hirsch_EA;
    
    set(handles.uitable44, 'Data', [handles.reduced_Hirsch_EA,phase_Hirsch]);
    set(handles.uitable45, 'Data', mastercurve_data_Hirsch_EA);
    p = polyfit(handles.reduced_Hirsch_EA,phase_Hirsch,5);
    fit_sample1=p(1).*handles.reduced_Hirsch_EA.^5+p(2).*handles.reduced_Hirsch_EA.^4+p(3).*handles.reduced_Hirsch_EA.^3+p(4).*handles.reduced_Hirsch_EA.^2+p(5).*handles.reduced_Hirsch_EA+p(6);
    yfit = polyval(p,handles.reduced_Hirsch_EA);
yresid = phase_Hirsch - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Hirsch_EA)-1) * var(phase_Hirsch);
rsq_sample1 = 1 - SSresid/SStotal;
    
    
    set(handles.text95,'String',sprintf('%.4f',error_Hirsch_EA));
    
    error_Hirsch_EA=handles.error_Hirsch_EA;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Hirsch_EA=handles.bestx2_Hirsch_EA;
    count_Hirsch_EA=handles.count_Hirsch_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Hirsch_EA);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_Hirsch_EA,y_Hirsch_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Hirsch_EA,E_Hirsch_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Hirsch EA Shifting Master Curve');
    guidata(hObject, handles);
    
    
    
elseif get(handles.checkbox95,'Value')==1
    set(handles.radiobutton40,'value',1);
    logE_measured_Hirsch_VTS=handles.logE_measured_Hirsch_VTS;
    logE_predicted_Hirsch_VTS=handles.logE_predicted_Hirsch_VTS;
    mastercurve_data_Hirsch_VTS=handles.mastercurve_data_Hirsch_VTS;
    x_Hirsch_VTS=handles.x_Hirsch_VTS;
    y_Hirsch_VTS=handles.y_Hirsch_VTS;
    reducedfrequency=handles.reducedfrequency_Hirsch_VTS;
    E_Hirsch_VTS=handles.E_Hirsch_VTS;
    mastercurve_data_Hirsch_VTS=handles.mastercurve_data_Hirsch_VTS;
    count_Hirsch_VTS=handles.count_Hirsch_VTS;
    reducedfrequency_Hirsch_VTS=handles.reducedfrequency_Hirsch_VTS;
    error_Hirsch_VTS=handles.error_Hirsch_VTS;
    
    
    
    %EA Table
    shiftdata_Hirsch_VTS=[logE_measured_Hirsch_VTS, logE_predicted_Hirsch_VTS];
    handles.shiftdata_Hirsch_VTS=shiftdata_Hirsch_VTS;
    
    q=handles.reduced_Hirsch_VTS;
    set(handles.uitable44, 'Data', [handles.reduced_Hirsch_VTS,phase_Hirsch]);
    set(handles.uitable45, 'Data', mastercurve_data_Hirsch_VTS);
    p = polyfit(handles.reduced_Hirsch_VTS,phase_Hirsch,5);
    fit_sample1=p(1).*handles.reduced_Hirsch_VTS.^5+p(2).*handles.reduced_Hirsch_VTS.^4+p(3).*handles.reduced_Hirsch_VTS.^3+p(4).*handles.reduced_Hirsch_VTS.^2+p(5).*handles.reduced_Hirsch_VTS+p(6);
    yfit = polyval(p,handles.reduced_Hirsch_VTS);
yresid = phase_Hirsch - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Hirsch_VTS)-1) * var(phase_Hirsch);
rsq_sample1 = 1 - SSresid/SStotal;;

    set(handles.text95,'String',sprintf('%.4f',error_Hirsch_VTS));
    
    error_Hirsch_VTS=handles.error_Hirsch_VTS
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Hirsch_VTS=handles.bestx2_Hirsch_VTS;
    count_Hirsch_VTS=handles.count_Hirsch_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Hirsch_VTS);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_Hirsch_VTS,y_Hirsch_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Hirsch_VTS,E_Hirsch_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Hirsch VTS Shifting Master Curve');
    guidata(hObject, handles);
    
 elseif get(handles.checkbox96,'Value')==1
     set(handles.uitable71,'visible','on');
     set(handles.radiobutton53,'value',1);
    logE_measured_NoConstr=handles.logE_measured_NoConstr;
    logE_predicted_NoConstr=handles.logE_predicted_NoConstr;
    mastercurve_data_NoConstr=handles.mastercurve_data_NoConstr;
    x_NoConstr=handles.x_NoConstr;
    y_NoConstr=handles.y_NoConstr;
    reducedfrequency=handles.reducedfrequency_NoConstr;
    E_NoConstr=handles.E_NoConstr;
    mastercurve_data_NoConstr=handles.mastercurve_data_NoConstr;
    count_NoConstr=handles.count_NoConstr;
    reducedfrequency_NoConstr=handles.reducedfrequency_NoConstr;
    error_NoConstr=handles.error_NoConstr;;
    
    
    
    %EA Table
    shiftdata_NoConstr=[logE_measured_NoConstr, logE_predicted_NoConstr];
    handles.shiftdata_NoConstr=shiftdata_NoConstr;
    
    q=handles.reduced_NoConstr;
    set(handles.uitable44, 'Data', [handles.reduced_NoConstr,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_NoConstr);
    p = polyfit(handles.reduced_NoConstr,phase,5);
    fit_sample1=p(1).*handles.reduced_NoConstr.^5+p(2).*handles.reduced_NoConstr.^4+p(3).*handles.reduced_NoConstr.^3+p(4).*handles.reduced_NoConstr.^2+p(5).*handles.reduced_NoConstr+p(6);
    yfit = polyval(p,handles.reduced_NoConstr);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_NoConstr)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;

    set(handles.text95,'String',sprintf('%.4f',error_NoConstr));
    
    error_NoConstr=handles.error_NoConstr;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_NoConstr=handles.bestx2_NoConstr
    count_NoConstr=handles.count_NoConstr;
    coefficients={'Delta','Beta','Gamma'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_NoConstr(1:3));
    
    set(handles.uitable71, 'Visible','on');
    set(handles.uitable71, 'Data',[bestx2_NoConstr(4),0,bestx2_NoConstr(5)]);
   
    
    loglog(handles.axes10,x_NoConstr,y_NoConstr,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_NoConstr,E_NoConstr,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'No Constraints Shifting Master Curve');
    guidata(hObject, handles);    
    
end   
    
set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.EApanel,'visible','on');

guidata(hObject, handles);
% hObject    handle to pushbutton74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logE_measured_Witczak=handles.logE_measured_Witczak;
logE_predicted_Witczak=handles.logE_predicted_Witczak;
mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
x_Witczak=handles.x_Witczak;
y_Witczak=handles.y_Witczak;
reducedfrequency=handles.reducedfrequency_Witczak;
E_Witczak=handles.E_Witczak;
mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
count_Witczak=handles.count_Witczak;
reducedfrequency_Witczak=handles.reducedfrequency_Witczak;
error_Witczak=handles.error_Witczak;


%% Witczak Master Curve

%Witczak VTS Table

shiftdata_Witczak=[logE_measured_Witczak, logE_predicted_Witczak];
handles.shiftdata_Witczak=shiftdata_Witczak;
set(handles.uitable44, 'Data', shiftdata_Witczak);
set(handles.uitable45, 'Data', mastercurve_data_Witczak);
plot(handles.axes9,count_Witczak,logE_measured_Witczak,'b-',count_Witczak,logE_predicted_Witczak,'r-','LineWidth',2);
xlabel(handles.axes9,'Reduced Frequency');
ylabel(handles.axes9,'Phase Angle (degrees)');
title(handles.axes9,'Witczak VTS Shifting');
legend(handles.axes9,'Location','southwest','Measured LogE(psi)', 'Predicted log E (psi)');

set(handles.text35,'String','Sum of Error^2');
error_Witczak=handles.error_Witczak
set(handles.text95,'String',error_Witczak);
set(handles.text34,'String',sprintf('%.4f',error_Witczak));
newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};

bestx2_Witczak=handles.bestx2_Witczak;
count_Witczak=handles.count_Witczak;
coefficients={'Delta','Beta','Gamma','C'};
set(handles.uitable25,'columnname',coefficients);
set(handles.uitable25, 'Data',bestx2_Witczak);


%Witczak VTS Graph
cla(handles.axes10,'reset');
loglog(handles.axes10,x_Witczak,y_Witczak,'b-','LineWidth',2);
hold(handles.axes10, 'on' );
loglog(handles.axes10,reducedfrequency_Witczak,E_Witczak,'k','LineStyle','none','Marker','o');
hold(handles.axes10, 'off' );
axis(handles.axes10,[10^-7 10^7 1000 10^7])
xlabel(handles.axes10,'Loading Frequency (Hz)');
ylabel(handles.axes10,'Dynamic Modulus (psi)');
legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
title(handles.axes10,'Witczak VTS Shifting Master Curve');

set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.EApanel,'visible','on');


% --- Executes when selected object is changed in uibuttongroup6.
function uibuttongroup6_SelectionChangedFcn(hObject, eventdata, handles)
%% Graph
set(handles.uitable71,'visible','off');
phase=handles.tabledata_average(:,5);
phase_Hirsch=phase(1:end-1);
p=get(handles.uibuttongroup6,'SelectedObject');
if p.Tag=='radiobutton37'
    logE_measured_EA=handles.logE_measured_EA;
    logE_predicted_EA=handles.logE_predicted_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    x_EA=handles.x_EA;
    y_EA=handles.y_EA;
    reducedfrequency=handles.reducedfrequency_EA;
    E_EA=handles.E_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    count_EA=handles.count_EA;
    reducedfrequency_EA=handles.reducedfrequency_EA;
    error_EA=handles.error_EA;;
    
    
    
    %EA Phase Angle
    
    set(handles.uitable44, 'Data', [handles.reduced_EA,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_EA);
    
    p = polyfit(handles.reduced_EA,phase,5);
    fit_sample1=p(1).*handles.reduced_EA.^5+p(2).*handles.reduced_EA.^4+p(3).*handles.reduced_EA.^3+p(4).*handles.reduced_EA.^2+p(5).*handles.reduced_EA+p(6);
    
    yfit = polyval(p,handles.reduced_EA);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_EA)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;
set(handles.text179,'String',rsq_sample1);
    scatter(handles.axes9,handles.reduced_EA,phase,'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes9,'on');
    plot(handles.axes9,handles.reduced_EA,fit_sample1,'b-','LineWidth',2);
    hold(handles.axes9,'off');
    xlabel(handles.axes9,'Reduced Frequency');
    ylabel(handles.axes9,'Phase Angle (degrees)');
    set(handles.text95,'String',sprintf('%.4f',error_EA));
    
    error_EA=handles.error_EA;;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_EA=handles.bestx2_EA;
    count_EA=handles.count_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_EA);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_EA,y_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_EA,E_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'EA Shifting Master Curve');
    guidata(hObject, handles);
    
elseif p.Tag=='radiobutton38'
    %VTS Table
    logE_measured_VTS=handles.logE_measured_VTS;
    logE_predicted_VTS=handles.logE_predicted_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    x_VTS=handles.x_VTS;
    y_VTS=handles.y_VTS;
    reducedfrequency=handles.reducedfrequency_VTS;
    E_VTS=handles.E_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    count_VTS=handles.count_VTS;
    reducedfrequency_VTS=handles.reducedfrequency_VTS;
    error_VTS=handles.error_VTS;
    
    

    %set(handles.uitable44, 'Data', [handles.reduced_VTS,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_VTS);
    p = polyfit(handles.reduced_VTS,phase,5);
    fit_sample1=p(1).*handles.reduced_VTS.^5+p(2).*handles.reduced_VTS.^4+p(3).*handles.reduced_VTS.^3+p(4).*handles.reduced_VTS.^2+p(5).*handles.reduced_VTS+p(6);
yfit = polyval(p,handles.reduced_VTS);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_VTS)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;

    
    set(handles.text95,'String',sprintf('%.4f',error_VTS));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    bestx2_VTS=handles.bestx2_VTS;
    count_VTS=handles.count_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_VTS);
    
    
    
    %VTS Graph
    loglog(handles.axes10,x_VTS,y_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_VTS,E_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'VTS Shifting Master Curve');
    
elseif p.Tag=='radiobutton39'
    logE_measured_Witczak=handles.logE_measured_Witczak;
    logE_predicted_Witczak=handles.logE_predicted_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    x_Witczak=handles.x_Witczak;
    y_Witczak=handles.y_Witczak;
    reducedfrequency=handles.reducedfrequency_Witczak;
    E_Witczak=handles.E_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    count_Witczak=handles.count_Witczak;
    reducedfrequency_Witczak=handles.reducedfrequency_Witczak;
    error_Witczak=handles.error_Witczak;
    
    
    %% Witczak Master Curve
    
    %Witczak VTS Table
    
    shiftdata_Witczak=[logE_measured_Witczak, logE_predicted_Witczak];
    handles.shiftdata_Witczak=shiftdata_Witczak;
    %set(handles.uitable44, 'Data', [handles.reduced_Witczak,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_Witczak);
    p = polyfit(handles.reduced_Witczak,phase,5);
    fit_sample1=p(1).*handles.reduced_Witczak.^5+p(2).*handles.reduced_Witczak.^4+p(3).*handles.reduced_Witczak.^3+p(4).*handles.reduced_Witczak.^2+p(5).*handles.reduced_Witczak+p(6);
    yfit = polyval(p,handles.reduced_Witczak);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Witczak)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;
    

    
    set(handles.text35,'String','Sum of Error^2');
    error_Witczak=handles.error_Witczak
    set(handles.text95,'String',error_Witczak);
    set(handles.text34,'String',sprintf('%.4f',error_Witczak));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Witczak=handles.bestx2_Witczak;
    count_Witczak=handles.count_Witczak;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Witczak);
    
    
    %Witczak VTS Graph
    cla(handles.axes10,'reset');
    loglog(handles.axes10,x_Witczak,y_Witczak,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Witczak,E_Witczak,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Witczak VTS Shifting Master Curve');
    
    
elseif p.Tag=='radiobutton41'
    logE_measured_Hirsch_EA=handles.logE_measured_Hirsch_EA;
    logE_predicted_Hirsch_EA=handles.logE_predicted_Hirsch_EA;
    mastercurve_data_Hirsch_EA=handles.mastercurve_data_Hirsch_EA;
    x_Hirsch_EA=handles.x_Hirsch_EA;
    y_Hirsch_EA=handles.y_Hirsch_EA;
    reducedfrequency=handles.reducedfrequency_Hirsch_EA;
    E_Hirsch_EA=handles.E_Hirsch_EA;
    mastercurve_data_Hirsch_EA=handles.mastercurve_data_Hirsch_EA;
    count_Hirsch_EA=handles.count_Hirsch_EA;
    reducedfrequency_Hirsch_EA=handles.reducedfrequency_Hirsch_EA;
    error_Hirsch_EA=handles.error_Hirsch_EA;
    
    
    
    %EA Table
    shiftdata_Hirsch_EA=[logE_measured_Hirsch_EA, logE_predicted_Hirsch_EA];
    handles.shiftdata_Hirsch_EA=shiftdata_Hirsch_EA;
    
    %set(handles.uitable44, 'Data', [handles.reduced_Hirsch_EA,phase_Hirsch]);
    set(handles.uitable45, 'Data', mastercurve_data_Hirsch_EA);
    p = polyfit(handles.reduced_Hirsch_EA,phase_Hirsch,5);
    fit_sample1=p(1).*handles.reduced_Hirsch_EA.^5+p(2).*handles.reduced_Hirsch_EA.^4+p(3).*handles.reduced_Hirsch_EA.^3+p(4).*handles.reduced_Hirsch_EA.^2+p(5).*handles.reduced_Hirsch_EA+p(6);
    yfit = polyval(p,handles.reduced_Hirsch_EA);
yresid = phase_Hirsch - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Hirsch_EA)-1) * var(phase_Hirsch);
rsq_sample1 = 1 - SSresid/SStotal;
    
    
    set(handles.text95,'String',sprintf('%.4f',error_Hirsch_EA));
    
    error_Hirsch_EA=handles.error_Hirsch_EA;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Hirsch_EA=handles.bestx2_Hirsch_EA;
    count_Hirsch_EA=handles.count_Hirsch_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Hirsch_EA);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_Hirsch_EA,y_Hirsch_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Hirsch_EA,E_Hirsch_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Hirsch EA Shifting Master Curve');
    guidata(hObject, handles);
    
    
    
elseif p.Tag=='radiobutton40'
    logE_measured_Hirsch_VTS=handles.logE_measured_Hirsch_VTS;
    logE_predicted_Hirsch_VTS=handles.logE_predicted_Hirsch_VTS;
    mastercurve_data_Hirsch_VTS=handles.mastercurve_data_Hirsch_VTS;
    x_Hirsch_VTS=handles.x_Hirsch_VTS;
    y_Hirsch_VTS=handles.y_Hirsch_VTS;
    reducedfrequency=handles.reducedfrequency_Hirsch_VTS;
    E_Hirsch_VTS=handles.E_Hirsch_VTS;
    mastercurve_data_Hirsch_VTS=handles.mastercurve_data_Hirsch_VTS;
    count_Hirsch_VTS=handles.count_Hirsch_VTS;
    reducedfrequency_Hirsch_VTS=handles.reducedfrequency_Hirsch_VTS;
    error_Hirsch_VTS=handles.error_Hirsch_VTS;
    
    
    
    %EA Table
    shiftdata_Hirsch_VTS=[logE_measured_Hirsch_VTS, logE_predicted_Hirsch_VTS];
    handles.shiftdata_Hirsch_VTS=shiftdata_Hirsch_VTS;
    
    q=handles.reduced_Hirsch_VTS;
   %set(handles.uitable44, 'Data', [handles.reduced_Hirsch_VTS,phase_Hirsch]);
    set(handles.uitable45, 'Data', mastercurve_data_Hirsch_VTS);
    p = polyfit(handles.reduced_Hirsch_VTS,phase_Hirsch,5);
    fit_sample1=p(1).*handles.reduced_Hirsch_VTS.^5+p(2).*handles.reduced_Hirsch_VTS.^4+p(3).*handles.reduced_Hirsch_VTS.^3+p(4).*handles.reduced_Hirsch_VTS.^2+p(5).*handles.reduced_Hirsch_VTS+p(6);
    yfit = polyval(p,handles.reduced_Hirsch_VTS);
yresid = phase_Hirsch - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Hirsch_VTS)-1) * var(phase_Hirsch);
rsq_sample1 = 1 - SSresid/SStotal;;

    set(handles.text95,'String',sprintf('%.4f',error_Hirsch_VTS));
    
    error_Hirsch_VTS=handles.error_Hirsch_VTS
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Hirsch_VTS=handles.bestx2_Hirsch_VTS;
    count_Hirsch_VTS=handles.count_Hirsch_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Hirsch_VTS);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_Hirsch_VTS,y_Hirsch_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Hirsch_VTS,E_Hirsch_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Hirsch VTS Shifting Master Curve');
    guidata(hObject, handles);
    
 elseif p.Tag=='radiobutton53'
     set(handles.uitable71,'visible','on');
    logE_measured_NoConstr=handles.logE_measured_NoConstr;
    logE_predicted_NoConstr=handles.logE_predicted_NoConstr;
    mastercurve_data_NoConstr=handles.mastercurve_data_NoConstr;
    x_NoConstr=handles.x_NoConstr;
    y_NoConstr=handles.y_NoConstr;
    reducedfrequency=handles.reducedfrequency_NoConstr;
    E_NoConstr=handles.E_NoConstr;
    mastercurve_data_NoConstr=handles.mastercurve_data_NoConstr;
    count_NoConstr=handles.count_NoConstr;
    reducedfrequency_NoConstr=handles.reducedfrequency_NoConstr;
    error_NoConstr=handles.error_NoConstr;;
    
    
    
    %EA Table
    shiftdata_NoConstr=[logE_measured_NoConstr, logE_predicted_NoConstr];
    handles.shiftdata_NoConstr=shiftdata_NoConstr;
    
    q=handles.reduced_NoConstr;
    %set(handles.uitable44, 'Data', [handles.reduced_NoConstr,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_NoConstr);
    p = polyfit(handles.reduced_NoConstr,phase,5);
    fit_sample1=p(1).*handles.reduced_NoConstr.^5+p(2).*handles.reduced_NoConstr.^4+p(3).*handles.reduced_NoConstr.^3+p(4).*handles.reduced_NoConstr.^2+p(5).*handles.reduced_NoConstr+p(6);
    yfit = polyval(p,handles.reduced_NoConstr);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_NoConstr)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;

    set(handles.text95,'String',sprintf('%.4f',error_NoConstr));
    
    error_NoConstr=handles.error_NoConstr;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_NoConstr=handles.bestx2_NoConstr
    count_NoConstr=handles.count_NoConstr;
    coefficients={'Delta','Beta','Gamma'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_NoConstr(1:3));
    
    set(handles.uitable71, 'Visible','on');
    set(handles.uitable71, 'Data',[bestx2_NoConstr(4),0,bestx2_NoConstr(5)]);
   
    
    loglog(handles.axes10,x_NoConstr,y_NoConstr,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_NoConstr,E_NoConstr,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'No Constraints Shifting Master Curve');
    guidata(hObject, handles);    
    
end   
    
set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.EApanel,'visible','on');

guidata(hObject, handles);
% hObject    handle to the selected object in uibuttongroup6
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox95.
function checkbox95_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox95


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
VFA=handles.VFA;
VMA=handles.VMA;
EMAX=handles.EMAX;

[filename,pathname] = uigetfile(['*.xlsx']);
File_Hirsch = fullfile(pathname,filename);
data_Hirsch=xlsread(File_Hirsch,1);
handles.temps_F_Hirsch=data_Hirsch(:,1);
%handles.actual_temps_F_Hirsch=data_Hirsch(:,2);
G=data_Hirsch(:,3);
handles.frequency_Hirsch=data_Hirsch(:,2);

p=get(handles.uibuttongroup7,'SelectedObject');
if p.Tag=='radiobutton43'
    handles.frequency_Hirsch=data_Hirsch(:,2)./(2*pi)
end

E_Hirsch=((20+(VFA.*3.*abs(G))./VMA).^0.58./(650+(VFA.*3.*abs(G)./VMA).^0.58)).*(4200000.*(1-VMA/100)+3.*abs(G).*(VFA.*VMA./10000))+(1-((20+(VFA.*3.*abs(G))./VMA).^0.58./(650+(VFA.*3.*abs(G)./VMA).^0.58))).*((1-VMA./100)./4200000+VMA./(3.*VFA.*abs(G))).^(-1)
logE_measured_Hirsch_EA=log10(E_Hirsch)
handles.E_Hirsch=E_Hirsch;
handles.logE_measured_Hirsch_EA=logE_measured_Hirsch_EA;

data=[data_Hirsch(:,1),handles.frequency_Hirsch,G,E_Hirsch];
set(handles.uitable70,'Data',data);
guidata(hObject, handles);
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton80.
function pushbutton80_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','on');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to pushbutton80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton81.
function pushbutton81_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','on');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off'); set(handles.comparisonpanel,'visible','off');
% hObject    handle to pushbutton81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox96.
function checkbox96_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox96


% --- Executes when selected object is changed in uibuttongroup7.
function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup7 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exportmenu_Callback(hObject, eventdata, handles)
set(handles.splashpanel,'visible','off'); set(handles.Hirschpanel,'visible','off');
set(handles.datapanel,'visible','off');
set(handles.volumetricpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.Witczakpanel,'visible','off');
set(handles.EApanel,'visible','off');
set(handles.comparisonpanel,'visible','on');

% hObject    handle to exportmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup11.
function uibuttongroup11_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup11 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton74.
p=get(handles.uibuttongroup11,'SelectedObject');
stdev_E=handles.stdev_E;
if p.Tag=='radiobutton52'
    handles.tabledata_average(:,1)=handles.ogdata(:,1);  
    handles.blackspacedata_average(:,1)=handles.ogdata(:,1);  
    try
    handles.temps_Hirsch=handles.temps_F_Hirsch;
    end
elseif p.Tag=='radiobutton51'
    handles.tabledata_average(:,1)=handles.ogdata(:,2);
    handles.blackspacedata_average(:,1)=handles.ogdata(:,2);
    try
    handles.temps_Hirsch=handles.temps_F_Hirsch;
    end
end
guidata(hObject, handles);

phase=handles.tabledata_average(:,5);
temperature_F=handles.tabledata_average(:,1);
frequency=handles.tabledata_average(:,3);
temperature_R=((temperature_F-32)*5/9)*1.8+491.67;



%% EA Shifting
if get(handles.checkbox85,'Value')==1
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    EAshiftdata=blackspacedata_average;
    temperature_F=EAshiftdata(:,1);
    frequency=tabledata_average(:,3);
    logE_measured_EA=EAshiftdata(:,2);
    EMAX=get(handles.uitable28,'Data');
    x0_EA = [4,-1,-0.5,2.0*10^5];
    sse= @(x) sseval(x,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    lb = [-50,-50,-50,2*10^5];
    ub = [50,0,0,2*10^5];
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_EA = fmincon(sse,x0_EA,A,b,Aeq,beq,lb,ub);
    sseval(bestx_EA,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    
    x2_EA=bestx_EA;
    bestx2_EA = fmincon(sse,x2_EA,A,b,Aeq,beq,lb,ub);
    
    sseval(bestx2_EA,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    
    
    
    
    delta_EA=bestx2_EA(1);
    beta_EA=bestx2_EA(2);
    gamma_EA=bestx2_EA(3);
    EA_EA=bestx2_EA(4);
    k=get(handles.uitable28,'Data');
    EMAX=k;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    count_EA = 1:length(frequency);
    logE_predicted_EA=(delta_EA+((log10(EMAX)-delta_EA)./(1+exp(beta_EA+gamma_EA*(log10(frequency)+(EA_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)))))));
    handles.reduced_EA=(log10(frequency)+(EA_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)));
    handles.logE_measured_EA=logE_measured_EA;
    handles.count_EA=count_EA;
    error_EA=sseval(bestx2_EA,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp);
    handles.error_EA=error_EA;
    handles.bestx2_EA=bestx2_EA;
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_EA=10.^reduced;
    y_EA=10.^(delta_EA+((log10(EMAX)-delta_EA)./(1+exp(beta_EA+gamma_EA*reduced))));
    reducedfrequency_EA=10.^((log10(frequency)+((EA_EA/19.14714)*((1./((temperature_F-32)*5/9+273.15))-(1./reference_temp)))));
    tabledata_average=handles.tabledata_average;
    E_EA=tabledata_average(:,4);
    mastercurve_data_EA=[reducedfrequency_EA,E_EA];
    handles.x_EA=x_EA;
    handles.y_EA=y_EA;
    handles.reducedfrequency_EA=reducedfrequency_EA;
    handles.E_EA=E_EA;
    handles.mastercurve_data_EA=mastercurve_data_EA;
    handles.logE_predicted_EA=logE_predicted_EA;
end

%% VTS Shifting

if get(handles.checkbox94,'Value')==1
    A=handles.A;
    VTS=handles.VTS;
    
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    frequency=tabledata_average(:,3);
    EMAX=get(handles.uitable28,'Data');
    
    A=handles.A;
    VTS=handles.VTS;
    shiftdata_VTS=blackspacedata_average;
    logE_measured_VTS=shiftdata_VTS(:,2);
    binder_data=get(handles.uitable34,'Data');
    temperature_F=shiftdata_VTS(:,1);
    k=size(temperature_F);
    k=k(1);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    temperature_F=handles.tabledata_average(:,1);
    frequency=handles.tabledata_average(:,3);
    temperature_R=temperature_F+459.67;
    viscosity_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_VTS(j)>2.7*10^12;
            viscosity_VTS(j)=2.7*10^12;
        else
            viscosity_VTS(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_VTS>2.7*10^12;
        viscosity_ref_VTS=2.7*10^12;
    else
        viscosity_ref_VTS= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end
    
    
    x0 = [2.7550 -1.3202	0.4716	1.0764];
    sse= @(x) sseval_VTS(x,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    lb = [0,-5,0, 0];
    ub = [5,0,5, 5];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_VTS = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
    sseval_VTS(bestx_VTS,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    
    x2_VTS=bestx_VTS;
    bestx2_VTS = fmincon(sse,x2_VTS,A,b,Aeq,beq,lb,ub);
    sseval_VTS(bestx2_VTS,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    
    delta_VTS=bestx2_VTS(1);
    beta_VTS=bestx2_VTS(2);
    gamma_VTS=bestx2_VTS(3);
    C_VTS=bestx2_VTS(4);
    
    count_VTS = 1:length(frequency);
    logE_predicted_VTS=((delta_VTS+((log10(EMAX)-delta_VTS)./(1+exp(beta_VTS+gamma_VTS*(log10(1./frequency)-C_VTS.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS))))))));
    handles.reduced_VTS=(log10(1./frequency)-C_VTS.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS)));
    handles.logE_measured_VTS=logE_measured_VTS;
    handles.count_VTS=count_VTS;
    handles.logE_predicted_VTS=logE_predicted_VTS;
    error_VTS=sseval_VTS(bestx2_VTS,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS);
    handles.error_VTS=error_VTS;
    handles.bestx2_VTS=bestx2_VTS;
    guidata(hObject, handles);
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_VTS=1./(10.^reduced);
    y_VTS=10.^(delta_VTS+((log10(EMAX)-delta_VTS)./(1+exp(beta_VTS+gamma_VTS*reduced))));
    %frequency=[25;10;5;1;.5;.1;25;10;5;1;.5;.1;25;10;5;1;.5;.1;0.01];
    reducedT=(log10(1./frequency)-(C_VTS.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS))));
    reducedfrequency_VTS=1./(10.^reducedT);
    tabledata_average=handles.tabledata_average;
    E_VTS=tabledata_average(:,4);
    mastercurve_data_VTS=[reducedfrequency_VTS,E_VTS];
    handles.mastercurve_data_VTS=mastercurve_data_VTS;
    handles.x_VTS=x_VTS;
    handles.y_VTS=y_VTS;
    handles.reducedfrequency=reducedfrequency_VTS;
    handles.E_VTS=E_VTS;
    handles.mastercurve_data_VTS=mastercurve_data_VTS;
    handles.logE_predicted_VTS=logE_predicted_VTS;
    handles.reducedfrequency_VTS=reducedfrequency_VTS;
    handles.count_VTS=count_VTS;
    handles.error_VTS=error_VTS;
end

%% Experimental Shifting

if get(handles.checkbox96,'Value')==1
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    NoConstrshiftdata=blackspacedata_average;
    temperature_F=NoConstrshiftdata(:,1);
    frequency=tabledata_average(:,3);
    EMAX=get(handles.uitable28,'Data');
    

    A=handles.A;
    VTS=handles.VTS;
    shiftdata_NoConstr=blackspacedata_average;
    logE_measured_NoConstr=shiftdata_NoConstr(:,2);
    binder_data=get(handles.uitable34,'Data');
    temperature_F=shiftdata_NoConstr(:,1);
    k=size(temperature_F);
    k=k(1);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    temperature_F=handles.tabledata_average(:,1);
    frequency=handles.tabledata_average(:,3);
    temperature_R=temperature_F+459.67;
    viscosity_NoConstr=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_NoConstr(j)>2.7*10^12;
            viscosity_NoConstr(j)=2.7*10^12;
        else
            viscosity_NoConstr(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_NoConstr=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_NoConstr>2.7*10^12;
        viscosity_ref_NoConstr=2.7*10^12;
    else
        viscosity_ref_NoConstr= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end    

temp1_idx=max(find(shiftdata_NoConstr(:,1)-shiftdata_NoConstr(1,1)<5));
temp2_idx=temp1_idx+1;
temp3_idx=max(find(shiftdata_NoConstr(:,1)-shiftdata_NoConstr(temp2_idx,1)<5))+1;

range1=shiftdata_NoConstr(1:temp1_idx,:);
range2=shiftdata_NoConstr(temp2_idx:temp3_idx-1,:);
range3=shiftdata_NoConstr(temp3_idx:end,:);

frequency1=frequency(1:temp1_idx,:);
frequency2=frequency(temp2_idx:temp3_idx-1,:);
frequency3=frequency(temp3_idx:end,:);


x0_NoConstr = [3.5,1,0.5,2,-2.5];
    sse= @(x) sseval_exp(x,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);
    lb = [-50,-50,0,0,-5];
    ub = [50,0,50,5,0];
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_NoConstr = fmincon(sse,x0_NoConstr,A,b,Aeq,beq,lb,ub);
    sseval_exp(bestx_NoConstr,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);
    
    x2_NoConstr=bestx_NoConstr;
    bestx2_NoConstr = fmincon(sse,x2_NoConstr,A,b,Aeq,beq,lb,ub);
    
    sseval_exp(bestx2_NoConstr,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);    
    delta_NoConstr=bestx2_NoConstr(1);
    beta_NoConstr=bestx2_NoConstr(2);
    gamma_NoConstr=bestx2_NoConstr(3);
    c_NoConstr=bestx2_NoConstr(4);
    cc_NoConstr=0;
    ccc_NoConstr=bestx2_NoConstr(5);
    
    k=get(handles.uitable28,'Data');
    EMAX=k;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    count_NoConstr = 1:length(frequency);
    
    frequency_exp1=10^c_NoConstr.*frequency1;
frequency_exp2=10^cc_NoConstr.*frequency2;
frequency_exp3=10^ccc_NoConstr.*frequency3;

frequency_exp=[frequency_exp1;frequency_exp2;frequency_exp3];
reduced_T_NoConstr=log10(1./frequency_exp);
    
    logE_predicted_NoConstr=((delta_NoConstr+((log10(EMAX)-delta_NoConstr)./(1+exp(beta_NoConstr+gamma_NoConstr.*(reduced_T_NoConstr))))));
    handles.reduced_NoConstr=log10(1./frequency_exp);
    handles.logE_measured_NoConstr=logE_measured_NoConstr;
    handles.count_NoConstr=count_NoConstr;
    error_NoConstr=sseval_exp(bestx2_NoConstr,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX);
    handles.error_NoConstr=error_NoConstr;
    handles.bestx2_NoConstr=bestx2_NoConstr;
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_NoConstr=1./(10.^reduced);
    y_NoConstr=10.^(delta_NoConstr+((log10(EMAX)-delta_NoConstr)./(1+exp(beta_NoConstr+gamma_NoConstr*reduced))));
    reducedfrequency_NoConstr=frequency_exp;
    tabledata_average=handles.tabledata_average;
    E_NoConstr=tabledata_average(:,4);
    mastercurve_data_NoConstr=[reducedfrequency_NoConstr,E_NoConstr];
    handles.x_NoConstr=x_NoConstr;
    handles.y_NoConstr=y_NoConstr;
    handles.reducedfrequency_NoConstr=reducedfrequency_NoConstr;
    handles.E_NoConstr=E_NoConstr;
    handles.mastercurve_data_NoConstr=mastercurve_data_NoConstr;
    handles.logE_predicted_NoConstr=logE_predicted_NoConstr;
 end   
%% Witczak Master Curve
if get(handles.checkbox86,'Value')==1
    
        volumetrics_data=get(handles.uitable1,'Data');
volumetrics_data=table2array(cell2table(volumetrics_data));
Gmm=volumetrics_data(1,:);
Gsb=volumetrics_data(2,:);
AV=volumetrics_data(3,:);
AC=volumetrics_data(4,:);
Pb=AC;
Witczak_input=cell2mat(get(handles.uitable63,'Data'));
Gb=Witczak_input(1,:);
passing200=Witczak_input(2,:);
retained34=Witczak_input(3,:);
retained38=Witczak_input(4,:);
retained4=Witczak_input(5,:);

Gmb=Gmm-(AV/100)*Gmm;
Mb=AC/100*Gmb;
Vb=Mb/Gb;
Gse=(100-AC)/((100/Gmm)-(AC/Gb));
Ps=100-AC;
Ms=Gmb-Mb;
HMA_AV=AV;
Pba=100*((Gse-Gsb)/(Gsb*Gse))*Gb;
Pbe=AC-(Pba/100)*Ps;
Vs=Ms/Gse;
Vse=Ms/Gsb;
Vabs=Vse-Vs;
Vbe=Vb-Vabs;
ACe=Vbe*100;
VMA=(Vbe*100)+AV;
VFA=(Vbe*100)/VMA*100;
Tgmm=Gmb/(1-(1-(Vbe+Vabs+Vs)));

delta_Witczak=(-1.249937+0.029232*passing200-0.001767*passing200^2-0.002841*retained4-0.05809*HMA_AV-0.802208*(ACe/(ACe+HMA_AV)));
alpha_Witczak=(3.871977-0.0021*retained4+0.003958*retained38-0.000017*retained38^2+0.00547*retained34);

A=handles.A;
VTS=handles.VTS;

Witczak_data=[AV;Pb;Mb;Gmm;Tgmm;Gmb;Gse;Gsb;Ps;Ms;HMA_AV;Pba;Pbe;ACe;Vs;Vse;Vb;Vabs;Vbe;VMA;VFA;delta_Witczak;alpha_Witczak];
set(handles.uitable66,'Data',Witczak_data);
frequency=handles.tabledata_average(:,3);
temperature_R=((temperature_F-32)*5/9)*1.8+491.67
viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6)
beta_Witczak=(-0.603313-0.313351*log10(frequency));
E_Witczak=(10.^(delta_Witczak+(alpha_Witczak./(1+exp(beta_Witczak-0.393532.*log10(viscosity_Witczak)))))).*10^5;
handles.E_Witczak=E_Witczak;
guidata(hObject, handles);

%% Show E_Witczak Data

set(handles.uitable65,'Data',[temperature_F,frequency,E_Witczak]);
    
    A=handles.A;
    VTS=handles.VTS;
    E_Witczak=handles.E_Witczak;
    shiftdata_Witczak=log10(E_Witczak);
    logE_measured_Witczak=log10(E_Witczak);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    viscosity_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_Witczak(j)>2.7*10^12;
            viscosity_Witczak(j)=2.7*10^12;
        else
            viscosity_Witczak(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_Witczak=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_Witczak>2.7*10^12;
        viscosity_ref_Witczak=2.7*10^12;
    else
        viscosity_ref_Witczak= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end
    
    EMAX=get(handles.uitable28,'Data');
    
    x0 = [3.7935		-1.0528	0.4188	1.2440];
    sse= @(x) sseval_Witczak(x,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
    lb = [0,-5,0, 0];
    ub = [5,0,5, 5];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_Witczak = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
    sseval_Witczak(bestx_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
    
    x2_Witczak=bestx_Witczak;
    bestx2_Witczak = fmincon(sse,x2_Witczak,A,b,Aeq,beq,lb,ub);
    sseval_Witczak(bestx2_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak);
    
    delta_Witczak=bestx2_Witczak(1);
    beta_Witczak=bestx2_Witczak(2);
    gamma_Witczak=bestx2_Witczak(3);
    C_Witczak=bestx2_Witczak(4);
    
    reference_temp=str2num(get(handles.edit20,'String'));
    count_Witczak = 1:length(frequency);
    
    logE_predicted_Witczak=((delta_Witczak+((log10(EMAX)-delta_Witczak)./(1+exp(beta_Witczak+gamma_Witczak*(log10(1./frequency)-C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak))))))));
    handles.reduced_Witczak=(log10(1./frequency)-C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak)));
    handles.logE_measured_Witczak=logE_measured_Witczak;
    handles.count_Witczak=count_Witczak;
    handles.logE_predicted_Witczak=logE_predicted_Witczak;
    error_Witczak=sseval_Witczak(bestx2_Witczak,frequency,viscosity_Witczak,logE_measured_Witczak,EMAX,viscosity_ref_Witczak)
    handles.error_Witczak=error_Witczak;
    handles.bestx2_Witczak=bestx2_Witczak;
    guidata(hObject, handles);
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_Witczak=1./(10.^reduced);
    y_Witczak=10.^(delta_Witczak+((log10(EMAX)-delta_Witczak)./(1+exp(beta_Witczak+gamma_Witczak*reduced))));
    
    %frequency=[25;10;5;1;.5;.1;25;10;5;1;.5;.1;25;10;5;1;.5;.1;0.01];
    reducedT=(log10(1./frequency)-(C_Witczak.*(log10(viscosity_Witczak)-log10(viscosity_ref_Witczak))));
    reducedfrequency_Witczak=1./(10.^reducedT);
    tabledata_average=handles.tabledata_average;
    mastercurve_data_Witczak=[reducedfrequency_Witczak,E_Witczak];
    handles.x_Witczak=x_Witczak;
    handles.y_Witczak=y_Witczak;
    handles.reducedfrequency_Witczak=reducedfrequency_Witczak;
    handles.E_Witczak=E_Witczak;
    handles.mastercurve_data_Witczak=mastercurve_data_Witczak;
    handles.logE_predicted_Witczak=logE_predicted_Witczak;
end

%% Hirsch EA Shifting
if get(handles.checkbox87,'Value')==1
frequency=handles.frequency_Hirsch;

temperature_F=handles.temps_Hirsch;

    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
    EAshiftdata=blackspacedata_average;
    logE_measured_Hirsch_EA=handles.logE_measured_Hirsch_EA;
    EMAX=get(handles.uitable28,'Data');
    x0_Hirsch_EA = [4,-1,-0.5,2.0*10^5];
    sse= @(x) sseval(x,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    lb = [-5,-5,-5,2*10^5];
    ub = [5,0,0,2*10^5];
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_Hirsch_EA = fmincon(sse,x0_Hirsch_EA,A,b,Aeq,beq,lb,ub);
    sseval(bestx_Hirsch_EA,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    
    x2_Hirsch_EA=bestx_Hirsch_EA;
    bestx2_Hirsch_EA = fmincon(sse,x2_Hirsch_EA,A,b,Aeq,beq,lb,ub);
    sseval(bestx2_Hirsch_EA,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    
    delta_Hirsch_EA=bestx2_Hirsch_EA(1);
    beta_Hirsch_EA=bestx2_Hirsch_EA(2);
    gamma_Hirsch_EA=bestx2_Hirsch_EA(3);
    EA_Hirsch_EA=bestx2_Hirsch_EA(4);
    k=get(handles.uitable28,'Data');
    EMAX=k;
    
    count_Hirsch_EA = 1:length(frequency);
    logE_predicted_Hirsch_EA=(delta_Hirsch_EA+((log10(EMAX)-delta_Hirsch_EA)./(1+exp(beta_Hirsch_EA+gamma_Hirsch_EA*(log10(frequency)+(EA_Hirsch_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)))))));
    handles.reduced_Hirsch_EA=(log10(frequency)+(EA_Hirsch_EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)));
    handles.logE_measured_Hirsch_EA=logE_measured_Hirsch_EA;
    handles.count_Hirsch_EA=count_Hirsch_EA;
    error_Hirsch_EA=sseval(bestx2_Hirsch_EA,frequency,temperature_F,logE_measured_Hirsch_EA,EMAX,reference_temp);
    handles.error_Hirsch_EA=error_Hirsch_EA;
    handles.bestx2_Hirsch_EA=bestx2_Hirsch_EA;
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_Hirsch_EA=10.^reduced;
    y_Hirsch_EA=10.^(delta_Hirsch_EA+((log10(EMAX)-delta_Hirsch_EA)./(1+exp(beta_Hirsch_EA+gamma_Hirsch_EA*reduced))));
    
    reducedfrequency_Hirsch_EA=10.^((log10(frequency)+((EA_Hirsch_EA/19.14714)*((1./((temperature_F-32)*5/9+273.15))-(1./reference_temp)))));
    tabledata_average=handles.tabledata_average;
    E_Hirsch_EA=handles.E_Hirsch;
    mastercurve_data_Hirsch_EA=[reducedfrequency_Hirsch_EA,E_Hirsch_EA];
    handles.x_Hirsch_EA=x_Hirsch_EA;
    handles.y_Hirsch_EA=y_Hirsch_EA;
    handles.reducedfrequency_Hirsch_EA=reducedfrequency_Hirsch_EA;
    handles.E_Hirsch_EA=E_Hirsch_EA;
    handles.mastercurve_data_Hirsch_EA=mastercurve_data_Hirsch_EA;
    handles.logE_predicted_Hirsch_EA=logE_predicted_Hirsch_EA;
end



%% Hirsch VTS Shifting

if get(handles.checkbox95,'Value')==1
    A=handles.A;
    VTS=handles.VTS;
    
    tabledata_average=handles.tabledata_average;
    blackspacedata_average=handles.blackspacedata_average;
    reference_temp=str2double(get(handles.edit20,'String'))+273.15;
frequency=handles.frequency_Hirsch;

temperature_F=handles.temps_Hirsch;
    EMAX=get(handles.uitable28,'Data');
    
    A=handles.A;
    VTS=handles.VTS;
    shiftdata_Hirsch_VTS=blackspacedata_average;
    logE_measured_Hirsch_VTS=handles.logE_measured_Hirsch_EA;
    binder_data=get(handles.uitable34,'Data');
    k=size(temperature_F);
    k=k(1);
    temperature_R_ref=str2num(get(handles.edit20,'String'))*9/5+491.67;
    temperature_R=temperature_F+459.67;
    viscosity_Hirsch_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R)))))./100)./(10^6);
    for j=1:size(temperature_R,1)
        if viscosity_Hirsch_VTS(j)>2.7*10^12;
            viscosity_Hirsch_VTS(j)=2.7*10^12;
        else
            viscosity_Hirsch_VTS(j) = 10.^(10.^(A+(VTS.*log10(temperature_R(j)))));
        end
    end
    
    viscosity_ref_Hirsch_VTS=((10.^(10.^(A+VTS.*(log10(temperature_R_ref)))))./100)./(10^6);
    
    if viscosity_ref_Hirsch_VTS>2.7*10^12;
        viscosity_ref_Hirsch_VTS=2.7*10^12;
    else
        viscosity_ref_Hirsch_VTS= 10.^(10.^(A+(VTS.*log10(temperature_R_ref))));
    end
    
    
    x0 = [2.7550 -1.3202	0.4716	1.0764];
    sse= @(x) sseval_Hirsch_VTS(x,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    lb = [0,-5,0, 0];
    ub = [5,0,5, 5];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    bestx_Hirsch_VTS = fmincon(sse,x0,A,b,Aeq,beq,lb,ub);
    sseval_Hirsch_VTS(bestx_Hirsch_VTS,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    
    x2_Hirsch_VTS=bestx_Hirsch_VTS;
    bestx2_Hirsch_VTS = fmincon(sse,x2_Hirsch_VTS,A,b,Aeq,beq,lb,ub);
    sseval_Hirsch_VTS(bestx2_Hirsch_VTS,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    
    delta_Hirsch_VTS=bestx2_Hirsch_VTS(1);
    beta_Hirsch_VTS=bestx2_Hirsch_VTS(2);
    gamma_Hirsch_VTS=bestx2_Hirsch_VTS(3);
    C_Hirsch_VTS=bestx2_Hirsch_VTS(4);
    
    count_Hirsch_VTS = 1:length(frequency);
    logE_predicted_Hirsch_VTS=((delta_Hirsch_VTS+((log10(EMAX)-delta_Hirsch_VTS)./(1+exp(beta_Hirsch_VTS+gamma_Hirsch_VTS*(log10(1./frequency)-C_Hirsch_VTS.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS))))))));
    handles.reduced_Hirsch_VTS=(log10(1./frequency)-C_Hirsch_VTS.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS)));
    handles.logE_measured_Hirsch_VTS=logE_measured_Hirsch_VTS;
    handles.count_Hirsch_VTS=count_Hirsch_VTS;
    handles.logE_predicted_Hirsch_VTS=logE_predicted_Hirsch_VTS;
    error_Hirsch_VTS=sseval_Hirsch_VTS(bestx2_Hirsch_VTS,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS);
    handles.error_Hirsch_VTS=error_Hirsch_VTS;
    handles.bestx2_Hirsch_VTS=bestx2_Hirsch_VTS;
    guidata(hObject, handles);
    reduced=[-10	-9	-8	-7	-6	-4	-3	-2	-1	0	2	3	4	5	6	8	9	10]';
    x_Hirsch_VTS=1./(10.^reduced);
    y_Hirsch_VTS=10.^(delta_Hirsch_VTS+((log10(EMAX)-delta_Hirsch_VTS)./(1+exp(beta_Hirsch_VTS+gamma_Hirsch_VTS*reduced))));
    reducedT=(log10(1./frequency)-(C_Hirsch_VTS.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS))));
    reducedfrequency_Hirsch_VTS=1./(10.^reducedT);
    tabledata_average=handles.tabledata_average;
    E_Hirsch_VTS=handles.E_Hirsch_EA;
    mastercurve_data_Hirsch_VTS=[reducedfrequency_Hirsch_VTS,E_Hirsch_VTS];
    handles.mastercurve_data_Hirsch_VTS=mastercurve_data_Hirsch_VTS;
    handles.x_Hirsch_VTS=x_Hirsch_VTS;
    handles.y_Hirsch_VTS=y_Hirsch_VTS;
    handles.reducedfrequency=reducedfrequency_Hirsch_VTS;
    handles.E_Hirsch_VTS=E_Hirsch_VTS;
    handles.mastercurve_data_Hirsch_VTS=mastercurve_data_Hirsch_VTS;
    handles.logE_predicted_Hirsch_VTS=logE_predicted_Hirsch_VTS;
    handles.reducedfrequency_Hirsch_VTS=reducedfrequency_Hirsch_VTS;
    handles.count_Hirsch_VTS=count_Hirsch_VTS;
    handles.error_Hirsch_VTS=error_Hirsch_VTS;
end

guidata(hObject, handles);
%% Graph
set(handles.uitable71,'visible','off');
phase=handles.tabledata_average(:,5);
phase_Hirsch=phase(1:end-1);
p=get(handles.uibuttongroup6,'SelectedObject');
if p.Tag=='radiobutton37'
    logE_measured_EA=handles.logE_measured_EA;
    logE_predicted_EA=handles.logE_predicted_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    x_EA=handles.x_EA;
    y_EA=handles.y_EA;
    reducedfrequency=handles.reducedfrequency_EA;
    E_EA=handles.E_EA;
    mastercurve_data_EA=handles.mastercurve_data_EA;
    count_EA=handles.count_EA;
    reducedfrequency_EA=handles.reducedfrequency_EA;
    error_EA=handles.error_EA;;
    
    
    
    %EA Phase Angle
    
    set(handles.uitable44, 'Data', [handles.reduced_EA,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_EA);
    
    p = polyfit(handles.reduced_EA,phase,5);
    fit_sample1=p(1).*handles.reduced_EA.^5+p(2).*handles.reduced_EA.^4+p(3).*handles.reduced_EA.^3+p(4).*handles.reduced_EA.^2+p(5).*handles.reduced_EA+p(6);
    
    yfit = polyval(p,handles.reduced_EA);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_EA)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;
set(handles.text179,'String',rsq_sample1);
    scatter(handles.axes9,handles.reduced_EA,phase,'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes9,'on');
    plot(handles.axes9,handles.reduced_EA,fit_sample1,'b-','LineWidth',2);
    hold(handles.axes9,'off');
    xlabel(handles.axes9,'Reduced Frequency');
    ylabel(handles.axes9,'Phase Angle (degrees)');
    set(handles.text95,'String',sprintf('%.4f',error_EA));
    
    error_EA=handles.error_EA;;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_EA=handles.bestx2_EA;
    count_EA=handles.count_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_EA);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_EA,y_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_EA,E_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'EA Shifting Master Curve');
    guidata(hObject, handles);
    
elseif p.Tag=='radiobutton38'
    %VTS Table
    logE_measured_VTS=handles.logE_measured_VTS;
    logE_predicted_VTS=handles.logE_predicted_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    x_VTS=handles.x_VTS;
    y_VTS=handles.y_VTS;
    reducedfrequency=handles.reducedfrequency_VTS;
    E_VTS=handles.E_VTS;
    mastercurve_data_VTS=handles.mastercurve_data_VTS;
    count_VTS=handles.count_VTS;
    reducedfrequency_VTS=handles.reducedfrequency_VTS;
    error_VTS=handles.error_VTS;
    
    

    %set(handles.uitable44, 'Data', [handles.reduced_VTS,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_VTS);
    p = polyfit(handles.reduced_VTS,phase,5);
    fit_sample1=p(1).*handles.reduced_VTS.^5+p(2).*handles.reduced_VTS.^4+p(3).*handles.reduced_VTS.^3+p(4).*handles.reduced_VTS.^2+p(5).*handles.reduced_VTS+p(6);
yfit = polyval(p,handles.reduced_VTS);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_VTS)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;

    
    set(handles.text95,'String',sprintf('%.4f',error_VTS));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    bestx2_VTS=handles.bestx2_VTS;
    count_VTS=handles.count_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_VTS);
    
    
    
    %VTS Graph
    loglog(handles.axes10,x_VTS,y_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_VTS,E_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'VTS Shifting Master Curve');
    
elseif p.Tag=='radiobutton39'
    logE_measured_Witczak=handles.logE_measured_Witczak;
    logE_predicted_Witczak=handles.logE_predicted_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    x_Witczak=handles.x_Witczak;
    y_Witczak=handles.y_Witczak;
    reducedfrequency=handles.reducedfrequency_Witczak;
    E_Witczak=handles.E_Witczak;
    mastercurve_data_Witczak=handles.mastercurve_data_Witczak;
    count_Witczak=handles.count_Witczak;
    reducedfrequency_Witczak=handles.reducedfrequency_Witczak;
    error_Witczak=handles.error_Witczak;
    
    
    %% Witczak Master Curve
    
    %Witczak VTS Table
    
    shiftdata_Witczak=[logE_measured_Witczak, logE_predicted_Witczak];
    handles.shiftdata_Witczak=shiftdata_Witczak;
    %set(handles.uitable44, 'Data', [handles.reduced_Witczak,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_Witczak);
    p = polyfit(handles.reduced_Witczak,phase,5);
    fit_sample1=p(1).*handles.reduced_Witczak.^5+p(2).*handles.reduced_Witczak.^4+p(3).*handles.reduced_Witczak.^3+p(4).*handles.reduced_Witczak.^2+p(5).*handles.reduced_Witczak+p(6);
    yfit = polyval(p,handles.reduced_Witczak);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Witczak)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;;
    

    
    set(handles.text35,'String','Sum of Error^2');
    error_Witczak=handles.error_Witczak
    set(handles.text95,'String',error_Witczak);
    set(handles.text34,'String',sprintf('%.4f',error_Witczak));
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Witczak=handles.bestx2_Witczak;
    count_Witczak=handles.count_Witczak;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Witczak);
    
    
    %Witczak VTS Graph
    cla(handles.axes10,'reset');
    loglog(handles.axes10,x_Witczak,y_Witczak,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Witczak,E_Witczak,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7])
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Witczak VTS Shifting Master Curve');
    
    
elseif p.Tag=='radiobutton41'
    logE_measured_Hirsch_EA=handles.logE_measured_Hirsch_EA;
    logE_predicted_Hirsch_EA=handles.logE_predicted_Hirsch_EA;
    mastercurve_data_Hirsch_EA=handles.mastercurve_data_Hirsch_EA;
    x_Hirsch_EA=handles.x_Hirsch_EA;
    y_Hirsch_EA=handles.y_Hirsch_EA;
    reducedfrequency=handles.reducedfrequency_Hirsch_EA;
    E_Hirsch_EA=handles.E_Hirsch_EA;
    mastercurve_data_Hirsch_EA=handles.mastercurve_data_Hirsch_EA;
    count_Hirsch_EA=handles.count_Hirsch_EA;
    reducedfrequency_Hirsch_EA=handles.reducedfrequency_Hirsch_EA;
    error_Hirsch_EA=handles.error_Hirsch_EA;
    
    
    
    %EA Table
    shiftdata_Hirsch_EA=[logE_measured_Hirsch_EA, logE_predicted_Hirsch_EA];
    handles.shiftdata_Hirsch_EA=shiftdata_Hirsch_EA;
    
    %set(handles.uitable44, 'Data', [handles.reduced_Hirsch_EA,phase_Hirsch]);
    set(handles.uitable45, 'Data', mastercurve_data_Hirsch_EA);
    p = polyfit(handles.reduced_Hirsch_EA,phase_Hirsch,5);
    fit_sample1=p(1).*handles.reduced_Hirsch_EA.^5+p(2).*handles.reduced_Hirsch_EA.^4+p(3).*handles.reduced_Hirsch_EA.^3+p(4).*handles.reduced_Hirsch_EA.^2+p(5).*handles.reduced_Hirsch_EA+p(6);
    yfit = polyval(p,handles.reduced_Hirsch_EA);
yresid = phase_Hirsch - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Hirsch_EA)-1) * var(phase_Hirsch);
rsq_sample1 = 1 - SSresid/SStotal;
    
    
    set(handles.text95,'String',sprintf('%.4f',error_Hirsch_EA));
    
    error_Hirsch_EA=handles.error_Hirsch_EA;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Hirsch_EA=handles.bestx2_Hirsch_EA;
    count_Hirsch_EA=handles.count_Hirsch_EA;
    coefficients={'Delta','Beta','Gamma','EA'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Hirsch_EA);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_Hirsch_EA,y_Hirsch_EA,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Hirsch_EA,E_Hirsch_EA,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Hirsch EA Shifting Master Curve');
    guidata(hObject, handles);
    
    
    
elseif p.Tag=='radiobutton40'
    logE_measured_Hirsch_VTS=handles.logE_measured_Hirsch_VTS;
    logE_predicted_Hirsch_VTS=handles.logE_predicted_Hirsch_VTS;
    mastercurve_data_Hirsch_VTS=handles.mastercurve_data_Hirsch_VTS;
    x_Hirsch_VTS=handles.x_Hirsch_VTS;
    y_Hirsch_VTS=handles.y_Hirsch_VTS;
    reducedfrequency=handles.reducedfrequency_Hirsch_VTS;
    E_Hirsch_VTS=handles.E_Hirsch_VTS;
    mastercurve_data_Hirsch_VTS=handles.mastercurve_data_Hirsch_VTS;
    count_Hirsch_VTS=handles.count_Hirsch_VTS;
    reducedfrequency_Hirsch_VTS=handles.reducedfrequency_Hirsch_VTS;
    error_Hirsch_VTS=handles.error_Hirsch_VTS;
    
    
    
    %EA Table
    shiftdata_Hirsch_VTS=[logE_measured_Hirsch_VTS, logE_predicted_Hirsch_VTS];
    handles.shiftdata_Hirsch_VTS=shiftdata_Hirsch_VTS;
    
    q=handles.reduced_Hirsch_VTS;
    %set(handles.uitable44, 'Data', [handles.reduced_Hirsch_VTS,phase_Hirsch]);
    set(handles.uitable45, 'Data', mastercurve_data_Hirsch_VTS);
    p = polyfit(handles.reduced_Hirsch_VTS,phase_Hirsch,5);
    fit_sample1=p(1).*handles.reduced_Hirsch_VTS.^5+p(2).*handles.reduced_Hirsch_VTS.^4+p(3).*handles.reduced_Hirsch_VTS.^3+p(4).*handles.reduced_Hirsch_VTS.^2+p(5).*handles.reduced_Hirsch_VTS+p(6);
    yfit = polyval(p,handles.reduced_Hirsch_VTS);
yresid = phase_Hirsch - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_Hirsch_VTS)-1) * var(phase_Hirsch);
rsq_sample1 = 1 - SSresid/SStotal;;

    set(handles.text95,'String',sprintf('%.4f',error_Hirsch_VTS));
    
    error_Hirsch_VTS=handles.error_Hirsch_VTS
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_Hirsch_VTS=handles.bestx2_Hirsch_VTS;
    count_Hirsch_VTS=handles.count_Hirsch_VTS;
    coefficients={'Delta','Beta','Gamma','C'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_Hirsch_VTS);
    
    
    % EA Graph
    
    loglog(handles.axes10,x_Hirsch_VTS,y_Hirsch_VTS,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_Hirsch_VTS,E_Hirsch_VTS,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'Hirsch VTS Shifting Master Curve');
    guidata(hObject, handles);
    
 elseif p.Tag=='radiobutton53'
     set(handles.uitable71,'visible','on');
    logE_measured_NoConstr=handles.logE_measured_NoConstr;
    logE_predicted_NoConstr=handles.logE_predicted_NoConstr;
    mastercurve_data_NoConstr=handles.mastercurve_data_NoConstr;
    x_NoConstr=handles.x_NoConstr;
    y_NoConstr=handles.y_NoConstr;
    reducedfrequency=handles.reducedfrequency_NoConstr;
    E_NoConstr=handles.E_NoConstr;
    mastercurve_data_NoConstr=handles.mastercurve_data_NoConstr;
    count_NoConstr=handles.count_NoConstr;
    reducedfrequency_NoConstr=handles.reducedfrequency_NoConstr;
    error_NoConstr=handles.error_NoConstr;;
    
    
    
    %EA Table
    shiftdata_NoConstr=[logE_measured_NoConstr, logE_predicted_NoConstr];
    handles.shiftdata_NoConstr=shiftdata_NoConstr;
    
    q=handles.reduced_NoConstr;
    %set(handles.uitable44, 'Data', [handles.reduced_NoConstr,phase]);
    set(handles.uitable45, 'Data', mastercurve_data_NoConstr);
    p = polyfit(handles.reduced_NoConstr,phase,5);
    fit_sample1=p(1).*handles.reduced_NoConstr.^5+p(2).*handles.reduced_NoConstr.^4+p(3).*handles.reduced_NoConstr.^3+p(4).*handles.reduced_NoConstr.^2+p(5).*handles.reduced_NoConstr+p(6);
    yfit = polyval(p,handles.reduced_NoConstr);
yresid = phase - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(handles.reduced_NoConstr)-1) * var(phase);
rsq_sample1 = 1 - SSresid/SStotal;

    set(handles.text95,'String',sprintf('%.4f',error_NoConstr));
    
    error_NoConstr=handles.error_NoConstr;
    newcolumns={'Measured LogE(psi)', 'Predicted log E (psi)'};
    
    bestx2_NoConstr=handles.bestx2_NoConstr
    count_NoConstr=handles.count_NoConstr;
    coefficients={'Delta','Beta','Gamma'};
    set(handles.uitable25,'columnname',coefficients);
    set(handles.uitable25, 'Data',bestx2_NoConstr(1:3));
    
    set(handles.uitable71, 'Visible','on');
    set(handles.uitable71, 'Data',[bestx2_NoConstr(4),0,bestx2_NoConstr(5)]);
   
    
    loglog(handles.axes10,x_NoConstr,y_NoConstr,'b-','LineWidth',2);
    hold(handles.axes10, 'on' );
    loglog(handles.axes10,reducedfrequency_NoConstr,E_NoConstr,'k','LineStyle','none','Marker','o');
    hold(handles.axes10, 'off' );
    axis(handles.axes10,[10^-7 10^7 1000 10^7]);
    xlabel(handles.axes10,'Loading Frequency (Hz)');
    ylabel(handles.axes10,'Dynamic Modulus (psi)');
    legend(handles.axes10,'Location','southeast','Predicted E','Actual E');
    title(handles.axes10,'No Constraints Shifting Master Curve');
    guidata(hObject, handles);    
    
end   
    
set(handles.datapanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.EApanel,'visible','on');
guidata(hObject, handles);


% --- Executes when selected object is changed in uibuttongroup10.
function uibuttongroup10_SelectionChangedFcn(hObject, eventdata, handles)
p=get(handles.uibuttongroup10,'SelectedObject');
if p.Tag=='radiobutton50'
    set(handles.radiobutton52,'Value',1);
else
    set(handles.radiobutton51,'Value',1);
end
% hObject    handle to the selected object in uibuttongroup10 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton82.
function pushbutton82_Callback(hObject, eventdata, handles)
fit_sample1=handles.fit_sample1;
fit_sample2=handles.fit_sample2;
fit_sample3=handles.fit_sample3;
tabledata_sample1=handles.tabledata_sample1;
tabledata_sample2=handles.tabledata_sample2;
tabledata_sample3=handles.tabledata_sample3;
blackspacedata_sample1=handles.blackspacedata_sample1;
blackspacedata_sample2=handles.blackspacedata_sample2;
blackspacedata_sample3=handles.blackspacedata_sample3;

value=get(handles.popupmenu1);
str = get(hObject, 'String');
val = get(hObject,'Value');
if val==1;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    tabledata_sample1=handles.tabledata_sample1;
    set(handles.uitable20, 'Data', tabledata_sample1);
    blackspacedata_sample1=handles.blackspacedata_sample1;
    p = polyfit(blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),2);
    fit_sample1=p(1).*blackspacedata_sample1(:,2).^2+p(2).*blackspacedata_sample1(:,2)+p(3);
    yfit = polyval(p,blackspacedata_sample1(:,2));
    yresid = blackspacedata_sample1(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_sample1(:,3))-1) * var(blackspacedata_sample1(:,3));
    rsq_sample1 = 1 - SSresid/SStotal;;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample1));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',1);
    scatter(handles.axes5,blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,blackspacedata_sample1(:,2),fit_sample1,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 1 Black Space Data');
    hold(handles.axes5,'off');
end
if val==2;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    tabledata_sample2=handles.tabledata_sample2;
    set(handles.uitable20, 'Data', tabledata_sample2);
    blackspacedata_sample2=handles.blackspacedata_sample2;
    p = polyfit(blackspacedata_sample2(:,2),blackspacedata_sample2(:,3),2);
    fit_sample2=p(1).*blackspacedata_sample2(:,2).^2+p(2).*blackspacedata_sample2(:,2)+p(3);
    yfit = polyval(p,blackspacedata_sample2(:,2));
    yresid = blackspacedata_sample2(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_sample2(:,3))-1) * var(blackspacedata_sample2(:,3));
    rsq_sample2 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample2));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',2);
    scatter(handles.axes5,blackspacedata_sample2(:,2),blackspacedata_sample2(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,blackspacedata_sample2(:,2),fit_sample2,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 2 Black Space Data');
    hold(handles.axes5,'off');
end
if val==3;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    tabledata_sample3=handles.tabledata_sample3;
    set(handles.uitable20, 'Data', tabledata_sample3);
    blackspacedata_sample3=handles.blackspacedata_sample3;
    p = polyfit(blackspacedata_sample3(:,2),blackspacedata_sample3(:,3),2);
    fit_sample3=p(1).*blackspacedata_sample3(:,2).^2+p(2).*blackspacedata_sample3(:,2)+p(3);
    yfit = polyval(p,blackspacedata_sample3(:,2));
    yresid = blackspacedata_sample3(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_sample3(:,3))-1) * var(blackspacedata_sample3(:,3));
    rsq_sample3 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample3));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',3);
    scatter(handles.axes5,blackspacedata_sample3(:,2),blackspacedata_sample3(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,blackspacedata_sample3(:,2),fit_sample3,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 3 Black Space Data');
    hold(handles.axes5,'off');
end
if val==4;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)', 'E* COV',	'Phase COV'};
    set(handles.uitable20,'columnname',fullaverage);
    fulltabledata_average=handles.fulltabledata_average;
    fulltabledata_average=[fulltabledata_average(:,1:6),fulltabledata_average(:,9:10)];
    set(handles.uitable20, 'Data', fulltabledata_average);
    blackspacedata_average=handles.blackspacedata_average;
    p = polyfit(blackspacedata_average(:,2),blackspacedata_average(:,3),2);
    fit_average=p(1).*blackspacedata_average(:,2).^2+p(2).*blackspacedata_average(:,2)+p(3);
    yfit = polyval(p,blackspacedata_average(:,2));
    yresid = blackspacedata_average(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_average(:,3))-1) * var(blackspacedata_average(:,3));
    rsq_average = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_average));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',4);
    scatter(handles.axes5,blackspacedata_average(:,2),blackspacedata_average(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,blackspacedata_average(:,2),fit_average,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Average Black Space Data');
    hold(handles.axes5,'off');
end

E_Witczak=handles.E_Witczak;
E_Hirsch=handles.E_Hirsch;
tabledata_average=handles.tabledata_average;
temps=tabledata_average(:,1);
E_actual=tabledata_average(:,4);
size_W=size(E_Witczak,1);
size_H=size(E_Hirsch,1);
E_actual(1:size_W)
error_WPE=(E_Witczak-E_actual(1:size_W))./E_actual(1:size_W)*100;
error_Hirsch=(E_Hirsch-E_actual(1:size_H))./E_actual(1:size_H)*100;
tablee={temps,E_actual,error_WPE,E_Witczak,E_Hirsch,error_Hirsch}
graphx=[1000;10000000];
graphy=[1000;10000000];
smaller=min(size_W,size_H);
tablee=[temps(1:smaller),E_actual(1:smaller),E_Witczak(1:smaller),error_WPE(1:smaller),E_Hirsch(1:smaller),error_Hirsch(1:smaller)];

cla(handles.axes5);
    hold(handles.axes5,'on')
    scatter(handles.axes5,E_actual(1:size_W),E_Witczak,'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    scatter(handles.axes5,E_actual(1:size_H),E_Hirsch,'filled','MarkerFaceColor',[1 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,graphx,graphy,'b-','LineWidth',2);
    set(handles.axes5, 'YScale', 'log');
    set(handles.axes5, 'XScale', 'log');
    Ax = findall(0,'type','axes');
    legendd={'Witczak','Hirsch'};
    legend(handles.axes5,legendd,'Location','northwest');
    xlabel(handles.axes5,'Predicted E* (psi)');
    ylabel(handles.axes5,'Measured E* (psi)');
    title(handles.axes5,'WPE & Hirsch Comparison');
    hold(handles.axes5,'off');
comparison={'Target Temp (F)', 'Measured E* (psi)', 'WPE E* (psi)', '% Error WPE', 'Hirsch Model E* (psi)', '% Error Hirsch'};
    set(handles.uitable20,'columnname',comparison);
  set(handles.uitable20, 'Data', tablee);  
  set(handles.text34,'String',[]);
    set(handles.text35,'String',[]);
% hObject    handle to pushbutton82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox97.
function checkbox97_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox97 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox97


% --- Executes on button press in checkbox98.
function checkbox98_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox98 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox98


% --- Executes during object creation, after setting all properties.
function uibuttongroup6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton85.
function pushbutton85_Callback(hObject, eventdata, handles)
if strcmp(getappdata(0,'logo'),'None')==1
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
 f = warndlg('\color{blue} Please Select Your Logo File from the Settings Menu of the RAAT-Pack Home Screen',...
             'Warning', opts);   
else
%% Which Curve to Export
curves={'AMPT (EA Shifting)' 'VTS Shifting' 'No Constraints Shifting' 'Witczak Prediction Equation' 'Hirsch Model VT Shifting' 'Hirsch Model EA Shifting'};
RAATPack_folder=getappdata(0,'RAATPack_folder');
EA=get(handles.checkbox85,'Value');
VTS=get(handles.checkbox94,'Value');
NoConstr=get(handles.checkbox96,'Value');
Witczak=get(handles.checkbox86,'Value');
Hirsch_VTS=get(handles.checkbox95,'Value');
Hirsch_EA=get(handles.checkbox87,'Value');
phase=handles.tabledata_average(:,5);
if EA==0
    curves(1)={'N/A'};
end
if VTS==0
curves(2)={'N/A'};
end
if NoConstr==0
curves(3)={'N/A'};
end
if Witczak==0
curves(4)={'N/A'};
end
if Hirsch_VTS==0
curves(5)={'N/A'};
end
if Hirsch_EA==0
curves(6)={'N/A'};
end



opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
          select = listdlg('PromptString','Select the Master Curve(s) to Export:',...
                      'SelectionMode','single',...
                      'ListString',curves);
                  
if select==1
    frequency=flip(handles.reducedfrequency_EA);
    E=flip(handles.E_EA);
    phase=flip(phase);
    stdev_E=flip(handles.stdev_E);
    x=handles.x_EA;
    y=handles.y_EA;
    Title={'EA Shifting Master Curve'};
end
if select==2
    frequency=flip(handles.reducedfrequency_VTS);
    E=flip(handles.E_VTS);
    phase=flip(phase);
    stdev_E=flip(handles.stdev_E);
    x=flip(handles.x_VTS);
    y=flip(handles.y_VTS);
    Title={'VTS Shifting Master Curve'};
end
if select==3
    frequency=flip(handles.reducedfrequency_NoConstr);
    E=flip(handles.E_NoConstr);
    stdev_E=flip(handles.stdev_E);
    phase={''};
    x=flip(handles.x_NoConstr);
    y=flip(handles.y_NoConstr);
    Title={'No Constraints Shifting Master Curve'};
end         
if select==4
    frequency=flip(handles.reducedfrequency_Witczak);
    E=flip(handles.E_Witczak);
    phase=flip(phase);
    stdev_E={''};
    x=flip(handles.x_Witczak);
    y=flip(handles.y_Witczak);
    Title={'Witczak Shifting Master Curve'};
end 
if select==5
    frequency=flip(handles.reducedfrequency_Hirsch_VTS);
    E=flip(handles.E_Hirsch_VTS);
    phase=flip(phase);
    stdev_E={''};
    x=flip(handles.x_Hirsch_VTS);
    y=flip(handles.y_Hirsch_VTS);
    Title={'Hirsch Model VTS Shifting Master Curve'};
end
if select==6
    frequency=flip(handles.reducedfrequency_Hirsch_EA);
    E=flip(handles.E_Hirsch_EA);
    phase=flip(phase);
    stdev_E={''};
    x=handles.x_Hirsch_EA;
    y=handles.y_Hirsch_EA;
    Title={'Hirsch Model EA Shifting Master Curve'};
end
%% Export

%% ADMIN Privileges?
admin_privileges_value=getappdata(0,'admin_privileges');
if admin_privileges_value == 0
    templatefile=[RAATPack_folder,'Templates\Dynamic Modulus Templates\Dynamic Modulus Template.xlsx'];
[savefile, savepath] = uiputfile(('*.pdf'),'Save',handles.foldername);
if isequal(savefile,0)
else
handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit39,'String'));
MixType=cellstr(get(handles.edit40,'String'));
Institution=cellstr(get(handles.edit42,'String'));
Date=cellstr(get(handles.edit43,'String'));
Technician=cellstr(get(handles.edit44,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,frequency,1,'H6');
xlswrite(savefullname_excel,E,1,'I6');
xlswrite(savefullname_excel,stdev_E,1,'J6');
xlswrite(savefullname_excel,phase,1,'K6');
xlswrite(savefullname_excel,x,1,'M6');
xlswrite(savefullname_excel,y,1,'N6');


waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Title,1,'A5');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');

xlswrite(savefullname_excel,Project,1,'I2');
xlswrite(savefullname_excel,MixType,1,'I3');
xlswrite(savefullname_excel,Institution,1,'M2');
xlswrite(savefullname_excel,Date,1,'M3');
xlswrite(savefullname_excel,Technician,1,'M4');

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
answer = questdlg(['Your Summary Sheet has been Saved. Would you like to save this Dynamic Modulus session?'], ...
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
templatefile=[RAATPack_folder,'Templates\Dynamic Modulus Templates\Dynamic Modulus Template_RU.xlsx'];
[savefile, savepath] = uiputfile(('*.xlsx'),'Save',handles.foldername);
if isequal(savefile,0)
else
handles.foldername = savepath;
guidata(hObject,handles);   
savefullname_pdf = fullfile(savepath,savefile);
savefullname_excel = strrep(savefullname_pdf,'.pdf','.xlsx');
Project=cellstr(get(handles.edit39,'String'));
MixType=cellstr(get(handles.edit40,'String'));
Institution=cellstr(get(handles.edit42,'String'));
Date=cellstr(get(handles.edit43,'String'));
Technician=cellstr(get(handles.edit44,'String'));
f = waitbar(0,'Exporting. Please wait...');
copyfile (templatefile, savefullname_excel,'f');
waitbar(0.25,f,'Exporting. Please Wait...');

waitbar(0.5,f,'Exporting. Please Wait...');

xlswrite(savefullname_excel,frequency,1,'H6');
xlswrite(savefullname_excel,E,1,'I6');
xlswrite(savefullname_excel,stdev_E,1,'J6');
xlswrite(savefullname_excel,phase,1,'K6');
xlswrite(savefullname_excel,x,1,'M6');
xlswrite(savefullname_excel,y,1,'N6');              


waitbar(0.75,f,'Exporting. Please Wait...');
xlswrite(savefullname_excel,Title,1,'A5');
xlswrite(savefullname_excel,Project,1,'B2');
xlswrite(savefullname_excel,MixType,1,'B3');
xlswrite(savefullname_excel,Institution,1,'E2');
xlswrite(savefullname_excel,Date,1,'E3');
xlswrite(savefullname_excel,Technician,1,'E4');

xlswrite(savefullname_excel,Project,1,'I2');
xlswrite(savefullname_excel,MixType,1,'I3');
xlswrite(savefullname_excel,Institution,1,'M2');
xlswrite(savefullname_excel,Date,1,'M3');
xlswrite(savefullname_excel,Technician,1,'M4');


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
% hObject    handle to pushbutton85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton86.
function pushbutton86_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacursormode on
try
tabledata_sample1=handles.tabledata_sample1;
tabledata_sample2=handles.tabledata_sample2;
tabledata_sample3=handles.tabledata_sample3;
blackspacedata_sample1=handles.blackspacedata_sample1;
blackspacedata_sample2=handles.blackspacedata_sample2;
blackspacedata_sample3=handles.blackspacedata_sample3;




info_struct = getCursorInfo(datacursormode);
answer = questdlg(['Are you sure you would like to delete the point: ' num2str(info_struct.Position(1)) ', ' num2str(info_struct.Position(2)) '?'], ...
	'', ...
	'Yes','No','Yes');

switch answer
    case 'Yes'

%% Check which sample is selected and delete the row of data associated with the point chosen
sample_number=get(handles.popupmenu1,'Value');
if sample_number==1
[rownum,p]=find(tabledata_sample1==info_struct.Position(1));
tabledata_sample1(rownum,:)=[NaN NaN NaN NaN NaN NaN];

[rownum2,p]=find(blackspacedata_sample1==info_struct.Position(1));
blackspacedata_sample1(rownum2,:)=[NaN NaN NaN]
elseif sample_number==2
[rownum,p]=find(tabledata_sample2==info_struct.Position(1));
tabledata_sample2(rownum,:)=[NaN NaN NaN NaN NaN NaN]; 

[rownum2,p]=find(blackspacedata_sample2==info_struct.Position(1));
blackspacedata_sample2(rownum2,:)=[NaN NaN NaN]
elseif sample_number==3
[rownum,p]=find(tabledata_sample3==info_struct.Position(1));
tabledata_sample3(rownum,:)=[NaN NaN NaN NaN NaN NaN]; 

[rownum2,p]=find(blackspacedata_sample3==info_struct.Position(1));
blackspacedata_sample3(rownum2,:)=[NaN NaN NaN]
end

%% Reshape Black Space Data & Update Tables Based on New Data

pp1=nanmean([tabledata_sample1(:,1),tabledata_sample2(:,1),tabledata_sample3(:,1)],2);
pp2=nanmean([tabledata_sample1(:,2),tabledata_sample2(:,2),tabledata_sample3(:,2)],2);
pp3=nanmean([tabledata_sample1(:,3),tabledata_sample2(:,3),tabledata_sample3(:,3)],2);
pp4=nanmean([tabledata_sample1(:,4),tabledata_sample2(:,4),tabledata_sample3(:,4)],2);
pp5=nanmean([tabledata_sample1(:,5),tabledata_sample2(:,5),tabledata_sample3(:,5)],2);
pp6=nanmean([tabledata_sample1(:,6),tabledata_sample2(:,6),tabledata_sample3(:,6)],2);
tabledata_average=[pp1,pp2,pp3,pp4,pp5,pp6];
size(blackspacedata_sample1(:,1))
size(blackspacedata_sample2(:,1))
size(blackspacedata_sample3(:,1))

pp1=nanmean([blackspacedata_sample1(:,1),blackspacedata_sample2(:,1),blackspacedata_sample3(:,1)],2);
pp2=nanmean([blackspacedata_sample1(:,2),blackspacedata_sample2(:,2),blackspacedata_sample3(:,2)],2);
pp3=nanmean([blackspacedata_sample1(:,3),blackspacedata_sample2(:,3),blackspacedata_sample3(:,3)],2);
blackspacedata_average=[pp1,pp2,pp3];

tabledata_average(any(isnan(tabledata_average), 2), :) = [];
blackspacedata_average(any(isnan(blackspacedata_average), 2), :) = [];
tabledata_average(:,6)=log10(tabledata_average(:,4));
handles.tabledata_average=tabledata_average;
handles.ogdata=tabledata_average;

blackspacedata_average(:,2)=log10(tabledata_average(:,4));       
tabledata_sample1(:,4);
stdev_E=nanstd([tabledata_sample1(:,4),tabledata_sample2(:,4),tabledata_sample3(:,4)],[],2);
stdev_phase=nanstd([tabledata_sample1(:,5),tabledata_sample2(:,5),tabledata_sample3(:,5)],[],2);

stdev_E(any(isnan(stdev_E), 2), :) = [];
stdev_phase(any(isnan(stdev_phase), 2), :) = [];


cov_E=stdev_E./tabledata_average(:,4)*100;
stdev_phase=stdev_phase./tabledata_average(:,5)*100;
covdata=[stdev_E,stdev_phase,cov_E,stdev_phase];


fulltabledata_average=[tabledata_average,covdata];
handles.fulltabledata_average=fulltabledata_average;
handles.stdev_E=stdev_E;
guidata(hObject,handles);     

fitting_data_sample1=blackspacedata_sample1(any(~isnan(blackspacedata_sample1), 2), :);
fitting_data_sample2=blackspacedata_sample2(any(~isnan(blackspacedata_sample2), 2), :);
fitting_data_sample3=blackspacedata_sample3(any(~isnan(blackspacedata_sample3), 2), :);

%Sample 1 Fit
p = polyfit(fitting_data_sample1(:,2),fitting_data_sample1(:,3),2);
fit_sample1=p(1).*fitting_data_sample1(:,2).^2+p(2).*fitting_data_sample1(:,2)+p(3);
yfit = polyval(p,fitting_data_sample1(:,2));
yresid = fitting_data_sample1(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(fitting_data_sample1(:,3))-1) * var(fitting_data_sample1(:,3));
rsq_sample1 = 1 - SSresid/SStotal;;

%% Fit Check
%Sample 1 Fit
p = polyfit(fitting_data_sample1(:,2),fitting_data_sample1(:,3),2);
fit_sample1=p(1).*fitting_data_sample1(:,2).^2+p(2).*fitting_data_sample1(:,2)+p(3);
yfit = polyval(p,fitting_data_sample1(:,2));
yresid = fitting_data_sample1(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(fitting_data_sample1(:,3))-1) * var(fitting_data_sample1(:,3));
rsq_sample1 = 1 - SSresid/SStotal;;
%Sample 2 Fit
p = polyfit(fitting_data_sample2(:,2),fitting_data_sample2(:,3),2);
fit_sample2=p(1).*fitting_data_sample2(:,2).^2+p(2).*fitting_data_sample2(:,2)+p(3);
yfit = polyval(p,fitting_data_sample2(:,2));
yresid = fitting_data_sample2(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(fitting_data_sample2(:,3))-1) * var(fitting_data_sample2(:,3));
rsq_sample2 = 1 - SSresid/SStotal;
%Sample 3 Fit
p = polyfit(fitting_data_sample3(:,2),fitting_data_sample3(:,3),2);
fit_sample3=p(1).*fitting_data_sample3(:,2).^2+p(2).*fitting_data_sample3(:,2)+p(3);
yfit = polyval(p,fitting_data_sample3(:,2));
yresid = fitting_data_sample3(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(fitting_data_sample3(:,3))-1) * var(fitting_data_sample3(:,3));



%% Graph New Black Space Data
val=get(handles.popupmenu1,'Value');

if val==1;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    set(handles.uitable20, 'Data', tabledata_sample1);
    p = polyfit(fitting_data_sample1(:,2),fitting_data_sample1(:,3),2);
    fit_sample1=p(1).*fitting_data_sample1(:,2).^2+p(2).*fitting_data_sample1(:,2)+p(3);
    yfit = polyval(p,fitting_data_sample1(:,2));
    yresid = fitting_data_sample1(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(fitting_data_sample1(:,3))-1) * var(fitting_data_sample1(:,3));
    rsq_sample1 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample1));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',1);
    scatter(handles.axes5,fitting_data_sample1(:,2),fitting_data_sample1(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample1(:,2),fit_sample1,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 1 Black Space Data');
    hold(handles.axes5,'off');
end
if val==2;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    set(handles.uitable20, 'Data', tabledata_sample2);
    p = polyfit(fitting_data_sample2(:,2),fitting_data_sample2(:,3),2);
    fit_sample2=p(1).*fitting_data_sample2(:,2).^2+p(2).*fitting_data_sample2(:,2)+p(3);
    yfit = polyval(p,fitting_data_sample2(:,2));
    yresid = fitting_data_sample2(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(fitting_data_sample2(:,3))-1) * var(fitting_data_sample2(:,3));
    rsq_sample2 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample2));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',2);
    scatter(handles.axes5,fitting_data_sample2(:,2),fitting_data_sample2(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample2(:,2),fit_sample2,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 2 Black Space Data');
    hold(handles.axes5,'off');
end
if val==3;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)'};
    set(handles.uitable20,'columnname',fullaverage);
    set(handles.uitable20, 'Data', tabledata_sample3);
    p = polyfit(fitting_data_sample3(:,2),fitting_data_sample3(:,3),2);
    fit_sample3=p(1).*fitting_data_sample3(:,2).^2+p(2).*fitting_data_sample3(:,2)+p(3);
    yfit = polyval(p,fitting_data_sample3(:,2));
    yresid = fitting_data_sample3(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(fitting_data_sample3(:,3))-1) * var(fitting_data_sample3(:,3));
    rsq_sample3 = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_sample3));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',3);
    scatter(handles.axes5,fitting_data_sample3(:,2),fitting_data_sample3(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample3(:,2),fit_sample3,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Sample 3 Black Space Data');
    hold(handles.axes5,'off');
end
if val==4;
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)', 'E* COV',	'Phase COV'};
    set(handles.uitable20,'columnname',fullaverage);
    fulltabledata_average=[fulltabledata_average(:,1:6),fulltabledata_average(:,9:10)];
    set(handles.uitable20, 'Data', fulltabledata_average);
    p = polyfit(blackspacedata_average(:,2),blackspacedata_average(:,3),2);
    fit_average=p(1).*blackspacedata_average(:,2).^2+p(2).*blackspacedata_average(:,2)+p(3);
    yfit = polyval(p,blackspacedata_average(:,2));
    yresid = blackspacedata_average(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_average(:,3))-1) * var(blackspacedata_average(:,3));
    rsq_average = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_average));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',4);
    scatter(handles.axes5,blackspacedata_average(:,2),blackspacedata_average(:,3),'filled','MarkerFaceColor',[0 0 0]);
    hold(handles.axes5,'on')
    plot(handles.axes5,blackspacedata_average(:,2),fit_average,'b-','LineWidth',2);
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'Average Black Space Data');
    hold(handles.axes5,'off');
end
if val==5;
    
    fullaverage={'Target Temp (F)', 'Chamber Temp (F)','Frequency (Hz)','E* (psi)','Phase Angle (degrees)', 'Measured Log E* (psi)', 'E* COV',	'Phase COV'};
    set(handles.uitable20,'columnname',fullaverage);
    fulltabledata_average=[fulltabledata_average(:,1:6),fulltabledata_average(:,9:10)];
    set(handles.uitable20, 'Data', fulltabledata_average);
    p = polyfit(blackspacedata_average(:,2),blackspacedata_average(:,3),2);
    fit_average=p(1).*blackspacedata_average(:,2).^2+p(2).*blackspacedata_average(:,2)+p(3);
    yfit = polyval(p,blackspacedata_average(:,2));
    yresid = blackspacedata_average(:,3) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(blackspacedata_average(:,3))-1) * var(blackspacedata_average(:,3));
    rsq_average = 1 - SSresid/SStotal;
    set(handles.text34,'String',sprintf('%.4f',rsq_average));
    set(handles.text35,'String','Goodness of Fit R^2');
    set(handles.popupmenu1,'Value',5);
    

p = polyfit(fitting_data_sample1(:,2),fitting_data_sample1(:,3),2);
fit_sample1=p(1).*fitting_data_sample1(:,2).^2+p(2).*fitting_data_sample1(:,2)+p(3);

p = polyfit(fitting_data_sample2(:,2),fitting_data_sample2(:,3),2);
fit_sample2=p(1).*fitting_data_sample2(:,2).^2+p(2).*fitting_data_sample2(:,2)+p(3);

p = polyfit(fitting_data_sample3(:,2),fitting_data_sample3(:,3),2);
fit_sample3=p(1).*fitting_data_sample3(:,2).^2+p(2).*fitting_data_sample3(:,2)+p(3);
    
    scatter(handles.axes5,fitting_data_sample1(:,2),fitting_data_sample1(:,3),'filled','MarkerFaceColor',[1 0 0]);
    hold(handles.axes5,'on')    
    scatter(handles.axes5,fitting_data_sample2(:,2),fitting_data_sample2(:,3),'filled','MarkerFaceColor',[0 1 0]);
    hold(handles.axes5,'on')
    scatter(handles.axes5,fitting_data_sample3(:,2),fitting_data_sample3(:,3),'filled','MarkerFaceColor',[0 0 1]);
    plot(handles.axes5,fitting_data_sample1(:,2),fit_sample1,'r-','LineWidth',2);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample2(:,2),fit_sample2,'g-','LineWidth',2);
    hold(handles.axes5,'on')
    plot(handles.axes5,fitting_data_sample3(:,2),fit_sample3,'b-','LineWidth',2);
    hold(handles.axes5,'on')
    Ax = findall(0,'type','axes');
    xlabel(handles.axes5,'Log E* (psi)');
    ylabel(handles.axes5,'Phase Angle (degrees)');
    title(handles.axes5,'All Sample Black Space Data');
    legend(handles.axes5,[{'Sample 1'},{'Sample 2'},{'Sample 3'}],'location','southwest')
    hold(handles.axes5,'off'); 
end

    case 'No'
end
datacursormode on
handles.blackspacedata_average=blackspacedata_average;
handles.tabledata_average=tabledata_average;
handles.ogblackspace=blackspacedata_average;
handles.tabledata_sample1=tabledata_sample1;
handles.tabledata_sample2=tabledata_sample2;
handles.tabledata_sample3=tabledata_sample3;
handles.blackspacedata_sample1=blackspacedata_sample1;
handles.blackspacedata_sample2=blackspacedata_sample2;
handles.blackspacedata_sample3=blackspacedata_sample3;     
handles.fit_sample1=fit_sample1;
handles.fit_sample2=fit_sample2;
handles.fit_sample3=fit_sample3;
handles.fitting_data_sample1=fitting_data_sample1;
handles.fitting_data_sample2=fitting_data_sample2;
handles.fitting_data_sample3=fitting_data_sample3;
guidata(hObject, handles);
catch
    datacursormode on
end


% --- Executes on button press in pushbutton87.
function pushbutton87_Callback(hObject, eventdata, handles)
f = waitbar(0,'Loading files. Please wait');
set(handles.volumetricpanel,'visible','off');
set(handles.binderpanel,'visible','off');
set(handles.AMPTpanel,'visible','off');
set(handles.datapanel,'visible','on');
PathName=handles.PathName;
%% Sample 1 File 1
idx = get(handles.popupmenu3,'Value');
items = get(handles.popupmenu3,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample1_file1=[];
    blackspacedata_sample1_file1=[];
    freqs_sample1_file1=[];
else
File_sample1_file1 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample1_file1);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample1_file1=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample1_file1=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample1_file1=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample1_file1=str2double(get(handles.edit17,'String'));
target_temperature_sample1_file1=round(target_temperature_sample1_file1*9/5+32).*frequencies_sample1_file1.^0;
tabledata_sample1_file1=[target_temperature_sample1_file1,data_sample1_file1(:,3),frequencies_sample1_file1,data_sample1_file1(:,1)*145.038,data_sample1_file1(:,2),log10(data_sample1_file1(:,1)*145.038)];
blackspacedata_sample1_file1=[tabledata_sample1_file1(:,1),tabledata_sample1_file1(:,6),tabledata_sample1_file1(:,5)];
end
%% Sample 1 File 2
idx = get(handles.popupmenu4,'Value');
items = get(handles.popupmenu4,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample1_file2=[];
    blackspacedata_sample1_file2=[];
    freqs_sample1_file2=[];
else
File_sample1_file2 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample1_file2);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample1_file2=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample1_file2=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample1_file2=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample1_file2=str2double(get(handles.edit18,'String'));
target_temperature_sample1_file2=round(target_temperature_sample1_file2*9/5+32).*frequencies_sample1_file2.^0;
tabledata_sample1_file2=[target_temperature_sample1_file2,data_sample1_file2(:,3),frequencies_sample1_file2,data_sample1_file2(:,1)*145.038,data_sample1_file2(:,2),log10(data_sample1_file2(:,1)*145.038)];
blackspacedata_sample1_file2=[tabledata_sample1_file2(:,1),tabledata_sample1_file2(:,6),tabledata_sample1_file2(:,5)];
end
%% Sample 1 File 3
idx = get(handles.popupmenu5,'Value');
items = get(handles.popupmenu5,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample1_file3=[];
    blackspacedata_sample1_file3=[];
    freqs_sample1_file3=[];
else
File_sample1_file3 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample1_file3);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample1_file3=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample1_file3=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample1_file3=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample1_file3=str2double(get(handles.edit19,'String'));
target_temperature_sample1_file3=round(target_temperature_sample1_file3*9/5+32).*frequencies_sample1_file3.^0;
tabledata_sample1_file3=[target_temperature_sample1_file3,data_sample1_file3(:,3),frequencies_sample1_file3,data_sample1_file3(:,1)*145.038,data_sample1_file3(:,2),log10(data_sample1_file3(:,1)*145.038)];
blackspacedata_sample1_file3=[tabledata_sample1_file3(:,1),tabledata_sample1_file3(:,6),tabledata_sample1_file3(:,5)];
end
%% Sample 2 File 1
idx = get(handles.popupmenu6,'Value');
items = get(handles.popupmenu6,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample2_file1=[];
    blackspacedata_sample2_file1=[];
    freqs_sample2_file1=[];
else
File_sample2_file1 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample2_file1);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample2_file1=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample2_file1=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample2_file1=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample2_file1=str2double(get(handles.edit51,'String'));
target_temperature_sample2_file1=round(target_temperature_sample2_file1*9/5+32).*frequencies_sample2_file1.^0;
tabledata_sample2_file1=[target_temperature_sample2_file1,data_sample2_file1(:,3),frequencies_sample2_file1,data_sample2_file1(:,1)*145.038,data_sample2_file1(:,2),log10(data_sample2_file1(:,1)*145.038)];
blackspacedata_sample2_file1=[tabledata_sample2_file1(:,1),tabledata_sample2_file1(:,6),tabledata_sample2_file1(:,5)];
end
%% Sample 2 File 2
idx = get(handles.popupmenu7,'Value');
items = get(handles.popupmenu7,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample2_file2=[];
    blackspacedata_sample2_file2=[];
    freqs_sample2_file2=[];
else
File_sample2_file2 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample2_file2);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample2_file2=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample2_file2=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample2_file2=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample2_file2=str2double(get(handles.edit50,'String'));
target_temperature_sample2_file2=round(target_temperature_sample2_file2*9/5+32).*frequencies_sample2_file2.^0;
tabledata_sample2_file2=[target_temperature_sample2_file2,data_sample2_file2(:,3),frequencies_sample2_file2,data_sample2_file2(:,1)*145.038,data_sample2_file2(:,2),log10(data_sample2_file2(:,1)*145.038)];
blackspacedata_sample2_file2=[tabledata_sample2_file2(:,1),tabledata_sample2_file2(:,6),tabledata_sample2_file2(:,5)];
end
%% Sample 2 File 3
idx = get(handles.popupmenu8,'Value');
items = get(handles.popupmenu8,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample2_file3=[];
    blackspacedata_sample2_file3=[];
    freqs_sample2_file3=[];
else
File_sample2_file3 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample2_file3);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample2_file3=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample2_file3=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample2_file3=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample2_file3=str2double(get(handles.edit49,'String'));
target_temperature_sample2_file3=round(target_temperature_sample2_file3*9/5+32).*frequencies_sample2_file3.^0;
tabledata_sample2_file3=[target_temperature_sample2_file3,data_sample2_file3(:,3),frequencies_sample2_file3,data_sample2_file3(:,1)*145.038,data_sample2_file3(:,2),log10(data_sample2_file3(:,1)*145.038)];
blackspacedata_sample2_file3=[tabledata_sample2_file3(:,1),tabledata_sample2_file3(:,6),tabledata_sample2_file3(:,5)];
end
%% Sample 3 File 1
idx = get(handles.popupmenu9,'Value');
items = get(handles.popupmenu9,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample3_file1=[];
    blackspacedata_sample3_file1=[];
    freqs_sample3_file1=[];
else
File_sample3_file1 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample3_file1);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample3_file1=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample3_file1=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample3_file1=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample3_file1=str2double(get(handles.edit54,'String'));
target_temperature_sample3_file1=round(target_temperature_sample3_file1*9/5+32).*frequencies_sample3_file1.^0;
tabledata_sample3_file1=[target_temperature_sample3_file1,data_sample3_file1(:,3),frequencies_sample3_file1,data_sample3_file1(:,1)*145.038,data_sample3_file1(:,2),log10(data_sample3_file1(:,1)*145.038)];
blackspacedata_sample3_file1=[tabledata_sample3_file1(:,1),tabledata_sample3_file1(:,6),tabledata_sample3_file1(:,5)];
end
%% Sample 3 File 2
idx = get(handles.popupmenu10,'Value');
items = get(handles.popupmenu10,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample3_file2=[];
    blackspacedata_sample3_file2=[];
    freqs_sample3_file2=[];
else
File_sample3_file2 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample3_file2);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample3_file2=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample3_file2=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample3_file2=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample3_file2=str2double(get(handles.edit53,'String'));
target_temperature_sample3_file2=round(target_temperature_sample3_file2*9/5+32).*frequencies_sample3_file2.^0;
tabledata_sample3_file2=[target_temperature_sample3_file2,data_sample3_file2(:,3),frequencies_sample3_file2,data_sample3_file2(:,1)*145.038,data_sample3_file2(:,2),log10(data_sample3_file2(:,1)*145.038)];
blackspacedata_sample3_file2=[tabledata_sample3_file2(:,1),tabledata_sample3_file2(:,6),tabledata_sample3_file2(:,5)];
end
%% Sample 3 File 3
idx = get(handles.popupmenu11,'Value');
items = get(handles.popupmenu11,'String');
selectedItem = items{idx};
if contains(selectedItem,'select file')==1
    tabledata_sample3_file3=[];
    blackspacedata_sample3_file3=[];
    freqs_sample3_file3=[];
else
File_sample3_file3 = fullfile(PathName,selectedItem);
[num,txt,raw]=xlsread(File_sample3_file3);
p = strcmpi(' Dynamic modulus (MPa)',raw(:,1));
rowNum=find(p==1);
%rowNum = txt(p==1);

freqs=txt(rowNum-1,2:end);
freqs(cellfun('isempty',freqs)) = [];
freqs=erase(freqs,' Hz');
freqs_sample3_file3=[cellfun(@str2num, freqs(1,:))];

DM=num(rowNum-4,:);
phase=num(rowNum-3,:);
DM=DM(~isnan(DM));
phase=phase(~isnan(phase));
temps=num(rowNum-2,:);
temps=temps(~isnan(temps)).*9/5+32;
data_sample3_file3=[DM;phase;temps]';
eh=txt(rowNum-1,2:end);
eh=eh(~cellfun('isempty',eh));
newStr = erase(eh,' Hz');
frequencies_sample3_file3=[cellfun(@str2num, newStr(1:end,:))]';
target_temperature_sample3_file3=str2double(get(handles.edit52,'String'));
target_temperature_sample3_file3=round(target_temperature_sample3_file3*9/5+32).*frequencies_sample3_file3.^0;
tabledata_sample3_file3=[target_temperature_sample3_file3,data_sample3_file3(:,3),frequencies_sample3_file3,data_sample3_file3(:,1)*145.038,data_sample3_file3(:,2),log10(data_sample3_file3(:,1)*145.038)];
blackspacedata_sample3_file3=[tabledata_sample3_file3(:,1),tabledata_sample3_file3(:,6),tabledata_sample3_file3(:,5)];
end

%% Make sure frequencies match
if size(freqs_sample1_file1,2)~=size(freqs_sample2_file1,2)|| size(freqs_sample1_file1,2)~=size(freqs_sample3_file1,2)|| size(freqs_sample2_file1,2)~=size(freqs_sample3_file1,2)||size(freqs_sample1_file2,2)~=size(freqs_sample2_file2,2)|| size(freqs_sample1_file2,2)~=size(freqs_sample3_file2,2)|| size(freqs_sample2_file2,2)~=size(freqs_sample3_file2,2)||size(freqs_sample1_file3,2)~=size(freqs_sample2_file3,2)|| size(freqs_sample1_file3,2)~=size(freqs_sample3_file3,2)|| size(freqs_sample2_file3,2)~=size(freqs_sample3_file3,2)
warn=1
end
[q,b]=max([size(freqs_sample1_file1,2),size(freqs_sample1_file2,2), size(freqs_sample1_file3,2),size(freqs_sample2_file1,2),size(freqs_sample2_file2,2), size(freqs_sample2_file3,2),size(freqs_sample3_file1,2),size(freqs_sample3_file2,2), size(freqs_sample3_file3,2)]);
allfreq={freqs_sample1_file1;freqs_sample1_file2; freqs_sample1_file3;freqs_sample2_file1;freqs_sample2_file2; freqs_sample2_file3;freqs_sample3_file1;freqs_sample3_file2; freqs_sample3_file3};

basefreq=allfreq{b}'
handles.basefreq=basefreq;
[xx,ia,ib] = intersect(freqs_sample1_file1,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample1_file1=basefreq;
newfreq_sample1_file1(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit17,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;

try
base_tabledata(ib,:)=tabledata_sample1_file1;
catch
base_tabledata(ib,:)=tabledata_sample1_file1(ib,:);
end

tabledata_sample1_file1=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample1_file1;  
catch
    base_blackspacedata(ib,:)=blackspacedata_sample1_file1(ib,:);
  
end
blackspacedata_sample1_file1=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample1_file2,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample1_file2=basefreq;
newfreq_sample1_file2(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit18,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample1_file2;
catch
    base_tabledata(ib,:)=tabledata_sample1_file2(ib,:);

end

tabledata_sample1_file2=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample1_file2;    
catch
    base_blackspacedata(ib,:)=blackspacedata_sample1_file2(ib,:);

end
blackspacedata_sample1_file2=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample1_file3,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample1_file3=basefreq;
newfreq_sample1_file3(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit19,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample1_file3;
catch
    base_tabledata(ib,:)=tabledata_sample1_file3(ib,:);

end

tabledata_sample1_file3=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample1_file3;   
catch
    base_blackspacedata(ib,:)=blackspacedata_sample1_file3(ib,:);
 
end
blackspacedata_sample1_file3=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample2_file1,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample2_file1=basefreq;
newfreq_sample2_file1(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit51,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample2_file1;
catch
base_tabledata(ib,:)=tabledata_sample2_file1(ib,:);
end

tabledata_sample2_file1=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample2_file1;  
catch
    base_blackspacedata(ib,:)=blackspacedata_sample2_file1(ib,:);
  
end
blackspacedata_sample2_file1=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample2_file2,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample2_file2=basefreq;
newfreq_sample2_file2(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit50,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample2_file2;
catch
    base_tabledata(ib,:)=tabledata_sample2_file2(ib,:);

end

tabledata_sample2_file2=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample2_file2;    
catch
    base_blackspacedata(ib,:)=blackspacedata_sample2_file2(ib,:);

end
blackspacedata_sample2_file2=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample2_file3,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample2_file3=basefreq;
newfreq_sample2_file3(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit49,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample2_file3;
catch
    base_tabledata(ib,:)=tabledata_sample2_file3(ib,:);

end

tabledata_sample2_file3=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample2_file3;   
catch
    base_blackspacedata(ib,:)=blackspacedata_sample2_file3(ib,:);
 
end
blackspacedata_sample2_file3=base_blackspacedata;


[xx,ia,ib] = intersect(freqs_sample3_file1,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample3_file1=basefreq;
newfreq_sample3_file1(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit54,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample3_file1;
catch
base_tabledata(ib,:)=tabledata_sample3_file1(ib,:);
end

tabledata_sample3_file1=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample3_file1;  
catch
    base_blackspacedata(ib,:)=blackspacedata_sample3_file1(ib,:);
  
end
blackspacedata_sample3_file1=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample3_file2,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample3_file2=basefreq;
newfreq_sample3_file2(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit53,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample3_file2;
catch
    base_tabledata(ib,:)=tabledata_sample3_file2(ib,:);
end

tabledata_sample3_file2=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample3_file2;    
catch
    base_blackspacedata(ib,:)=blackspacedata_sample3_file2(ib,:);

end
blackspacedata_sample3_file2=base_blackspacedata;

[xx,ia,ib] = intersect(freqs_sample3_file3,basefreq,'stable');
[p,q]=setdiff(basefreq,basefreq(ib),'stable');
newfreq_sample3_file3=basefreq;
newfreq_sample3_file3(q)=NaN;
base_tabledata=NaN(size(basefreq,1),6);
base_tabledata(:,3)=basefreq;
temps=round(str2double(get(handles.edit52,'String')).* ones(length(basefreq),1).*9/5+32);
base_tabledata(:,1)=temps;
try
base_tabledata(ib,:)=tabledata_sample3_file3;
catch
    base_tabledata(ib,:)=tabledata_sample3_file3(ib,:);

end

tabledata_sample3_file3=base_tabledata;
base_blackspacedata=NaN(size(basefreq,1),3);
try
base_blackspacedata(ib,:)=blackspacedata_sample3_file3;   
catch
    base_blackspacedata(ib,:)=blackspacedata_sample3_file3(ib,:);
 
end
blackspacedata_sample3_file3=base_blackspacedata;


%% Average Data
tabledata_sample1=[tabledata_sample1_file1;tabledata_sample1_file2;tabledata_sample1_file3];
tabledata_sample2=[tabledata_sample2_file1;tabledata_sample2_file2;tabledata_sample2_file3];
tabledata_sample3=[tabledata_sample3_file1;tabledata_sample3_file2;tabledata_sample3_file3];
handles.tabledata_sample1=tabledata_sample1;
handles.tabledata_sample2=tabledata_sample2;
handles.tabledata_sample3=tabledata_sample3;
blackspacedata_sample1=[blackspacedata_sample1_file1;blackspacedata_sample1_file2;blackspacedata_sample1_file3];
blackspacedata_sample2=[blackspacedata_sample2_file1;blackspacedata_sample2_file2;blackspacedata_sample2_file3];
blackspacedata_sample3=[blackspacedata_sample3_file1;blackspacedata_sample3_file2;blackspacedata_sample3_file3];
handles.blackspacedata_sample1=blackspacedata_sample1;
handles.blackspacedata_sample2=blackspacedata_sample2;
handles.blackspacedata_sample3=blackspacedata_sample3;


pp1=nanmean([tabledata_sample1(:,1),tabledata_sample2(:,1),tabledata_sample3(:,1)],2);
pp2=nanmean([tabledata_sample1(:,2),tabledata_sample2(:,2),tabledata_sample3(:,2)],2);
pp3=nanmean([tabledata_sample1(:,3),tabledata_sample2(:,3),tabledata_sample3(:,3)],2);
pp4=nanmean([tabledata_sample1(:,4),tabledata_sample2(:,4),tabledata_sample3(:,4)],2);
pp5=nanmean([tabledata_sample1(:,5),tabledata_sample2(:,5),tabledata_sample3(:,5)],2);
pp6=nanmean([tabledata_sample1(:,6),tabledata_sample2(:,6),tabledata_sample3(:,6)],2);
tabledata_average=[pp1,pp2,pp3,pp4,pp5,pp6];

pp1=nanmean([blackspacedata_sample1(:,1),blackspacedata_sample2(:,1),blackspacedata_sample3(:,1)],2);
pp2=nanmean([blackspacedata_sample1(:,2),blackspacedata_sample2(:,2),blackspacedata_sample3(:,2)],2);
pp3=nanmean([blackspacedata_sample1(:,3),blackspacedata_sample2(:,3),blackspacedata_sample3(:,3)],2);
blackspacedata_average=[pp1,pp2,pp3];

tabledata_average(any(isnan(tabledata_average), 2), :) = [];
blackspacedata_average(any(isnan(blackspacedata_average), 2), :) = [];
tabledata_average(:,6)=log10(tabledata_average(:,4));
handles.tabledata_average=tabledata_average;
handles.ogdata=tabledata_average;

blackspacedata_average(:,2)=log10(tabledata_average(:,4));
handles.blackspacedata_average=blackspacedata_average;
handles.ogblackspace=blackspacedata_average;
tabledata_sample1(:,4);
stdev_E=nanstd([tabledata_sample1(:,4),tabledata_sample2(:,4),tabledata_sample3(:,4)],[],2);
stdev_phase=nanstd([tabledata_sample1(:,5),tabledata_sample2(:,5),tabledata_sample3(:,5)],[],2);

stdev_E(any(isnan(stdev_E), 2), :) = [];
stdev_phase(any(isnan(stdev_phase), 2), :) = [];


cov_E=stdev_E./tabledata_average(:,4)*100;
stdev_phase=stdev_phase./tabledata_average(:,5)*100;
covdata=[stdev_E,stdev_phase,cov_E,stdev_phase];


fulltabledata_average=[tabledata_average,covdata];
handles.fulltabledata_average=fulltabledata_average;
handles.stdev_E=stdev_E;
guidata(hObject,handles);
%% Set Table & Graph
handles.blackspacedata_sample1(any(isnan(blackspacedata_sample1), 2), :) = [];
handles.blackspacedata_sample2(any(isnan(blackspacedata_sample2), 2), :) = [];
handles.blackspacedata_sample3(any(isnan(blackspacedata_sample3), 2), :) = [];

tabledata_sample1=handles.tabledata_sample1;
set(handles.uitable20, 'Data', tabledata_sample1);
blackspacedata_sample1=handles.blackspacedata_sample1;
%Sample 1 Fit
p = polyfit(blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),2);
fit_sample1=p(1).*blackspacedata_sample1(:,2).^2+p(2).*blackspacedata_sample1(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample1(:,2));
yresid = blackspacedata_sample1(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample1(:,3))-1) * var(blackspacedata_sample1(:,3));
rsq_sample1 = 1 - SSresid/SStotal;;
set(handles.text34,'String',sprintf('%.4f',rsq_sample1));
set(handles.text35,'String','Goodness of Fit R^2');
set(handles.popupmenu1,'Value',1);
scatter(handles.axes5,blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),'filled','MarkerFaceColor',[0 0 0]);
hold(handles.axes5,'on')
plot(handles.axes5,blackspacedata_sample1(:,2),fit_sample1,'b-','LineWidth',2);
Ax = findall(0,'type','axes');
xlabel(handles.axes5,'Log E* (psi)');
ylabel(handles.axes5,'Phase Angle (degrees)');
title(handles.axes5,'Sample 1 Black Space Data');
hold(handles.axes5,'off');


%% Fit Check
%Sample 1 Fit
p = polyfit(blackspacedata_sample1(:,2),blackspacedata_sample1(:,3),2);
fit_sample1=p(1).*blackspacedata_sample1(:,2).^2+p(2).*blackspacedata_sample1(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample1(:,2));
yresid = blackspacedata_sample1(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample1(:,3))-1) * var(blackspacedata_sample1(:,3));
rsq_sample1 = 1 - SSresid/SStotal;;
%Sample 2 Fit
p = polyfit(blackspacedata_sample2(:,2),blackspacedata_sample2(:,3),2);
fit_sample2=p(1).*blackspacedata_sample2(:,2).^2+p(2).*blackspacedata_sample2(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample2(:,2));
yresid = blackspacedata_sample2(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample2(:,3))-1) * var(blackspacedata_sample2(:,3));
rsq_sample2 = 1 - SSresid/SStotal;
%Sample 3 Fit
p = polyfit(blackspacedata_sample3(:,2),blackspacedata_sample3(:,3),2);
fit_sample3=p(1).*blackspacedata_sample3(:,2).^2+p(2).*blackspacedata_sample3(:,2)+p(3);
yfit = polyval(p,blackspacedata_sample3(:,2));
yresid = blackspacedata_sample3(:,3) - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(blackspacedata_sample3(:,3))-1) * var(blackspacedata_sample3(:,3));
rsq_sample3 = 1 - SSresid/SStotal;
close(f);

handles.fit_sample1=fit_sample1;
handles.fit_sample2=fit_sample2;
handles.fit_sample3=fit_sample3;
guidata(hObject, handles);


% hObject    handle to pushbutton87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
