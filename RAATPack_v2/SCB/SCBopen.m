function [x,y] = SCBopen(filename,configfilename,full_file_path,number_of_files)

i=0;
while(1)
    i = i+1;
    p=full_file_path{i};
if contains(p,'.xls') == 1 | contains(p,'.csv') == 1
config_settings_file=table2cell(readtable(configfilename,'ReadVariableNames',false));
str2double(config_settings_file);
if contains(p,'.xls') == 1 
    opts = detectImportOptions(p);
    opts = setvartype(opts,'double');
    opts.SelectedVariableNames = [str2double(config_settings_file(1,2)) str2double(config_settings_file(2,2))];
	opts.DataRange=[str2double(config_settings_file(3,2)) Inf];
    opts.Sheet=str2double(config_settings_file(16,2));
    opts.VariableNames= {'Displacement', 'Load', 'time','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
elseif contains(p,'.csv') == 1
    opts = detectImportOptions(p);
    opts = setvartype(opts,'double');
    opts.SelectedVariableNames = [str2double(config_settings_file(1,2)) str2double(config_settings_file(2,2))];
    opts.DataLines=[str2double(config_settings_file(3,2)) Inf];
    options.VariableNames= {'tabledata','Displacement', 'Load','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    opts.ExtraColumnsRule = 'ignore';
    opts.Delimiter = config_settings_file(7,2);
end

xy_data=readtable(p,opts);
xy_data=xy_data(~any(ismissing(xy_data),2),:);
x_data=xy_data{:,1};
y_data=xy_data{:,2};

%% Transform Data
Transformations=str2double(config_settings_file(8:13,2));
if Transformations(1) == 1 && Transformations(2) == 0 && Transformations(3) == 0
    x_data=x_data-x_data(1);
elseif Transformations(1) == 1 && Transformations(2) == 1 && Transformations(3) == 0
    x_data=-(x_data-x_data(1));
elseif Transformations(1) == 0 && Transformations(2) == 1 && Transformations(3) == 0
    x_data=-x_data;
elseif Transformations(1) == 0 && Transformations(2) == 1 && Transformations(3) == 1
    x_data=-(x_data-x_data(end));
elseif Transformations(1) == 0 && Transformations(2) == 0 && Transformations(3) == 1
    x_data=-(x_data-x_data(end));
end
if Transformations(4) == 1 && Transformations(5) == 0 && Transformations(6) == 0
    y_data=y_data-y_data(1);
elseif Transformations(4) == 1 && Transformations(5) == 1 && Transformations(6) == 0
    y_data=-(y_data-y_data(1));
elseif Transformations(4) == 0 && Transformations(5) == 1 && Transformations(6) == 0
    y_data=-y_data;
elseif Transformations(4) == 0 && Transformations(5) == 1 && Transformations(6) == 1
    y_data=-(y_data-y_data(end));
elseif Transformations(4) == 0 && Transformations(5) == 0 && Transformations(6) == 1
    y_data=-(y_data-y_data(end));
end

%% Units 
displacement_units=(config_settings_file(14,2));
load_units=(config_settings_file(15,2));
    
if string(displacement_units) == 'mm'
    x_data=x_data;
elseif string(displacement_units) == 'm'
    x_data=x_data.*1000;
elseif string(displacement_units) == 'Inches'
    x_data=x_data.*25.4;
end

if string(load_units) == 'kN'
    y_data=y_data;
elseif string(load_units) == 'lb'
    y_data=y_data.*0.0044482216152605;
elseif string(load_units) == 'kip'
    y_data=y_data.*4.4482216;
elseif string(load_units) == 'N'
    y_data=y_data.*.001;
end

elseif contains(p,'.DAT') == 1 | contains(p,'.dat') == 1
xy_data = importdata(p);
xy_data=xy_data.textdata;
xy_data=xy_data(:,2:3);
x_data= str2double(xy_data(:,1));
y_data= str2double(xy_data(:,2));


x_data=x_data(~isnan(x_data));
y_data=y_data(~isnan(y_data));

x_data=x_data.*1000;
x_data=x_data(1,1)-x_data;
y_data=-y_data;

end
%Find All Y (Load) Values Greater than 0.1 kN
%-----------------------------------------------------------

F = find(y_data>0.1);

%If Y (Load) does't reach 0.1 kN, trim at the last minimum value
%-----------------------------------------------------------
doesnt_reach_end = find(y_data<0.1);
[max_value,max_index]=max(y_data);
search_range=y_data(max_index:end);
[last_min,index_lastmin]=min(search_range);
index_lastmin=index_lastmin+max_index-1;
if isempty(doesnt_reach_end) || doesnt_reach_end(end)<max_index
x_data = x_data(1:index_lastmin);
y_data = y_data(1:index_lastmin);
else

%Get Rid of All Values After the Last Y>0.1 kN
%-----------------------------------------------------------
index1 = F(end);
x_data = x_data(1:index1);
y_data = y_data(1:index1);

while(1)
%If the Slope at the End is Zero, Keep Cutting Off Until Slope~=0
%----------------------------------------------------------------

    slope = (y_data(index1)-y_data(index1-1))/(x_data(index1)-x_data(index1-1));
    if slope==0
        F = find(y_data>0.1);
        index1 = F(end);
        index1 = index1-1;
    end
    x_data = x_data(1:index1);
    y_data = y_data(1:index1);
    if slope~=0
        break;
    end
end
end

%Plot Displacement (x) vs. Load (y) in New Window
%------------------------------------------------------------
h = figure;
while(1)
plot(x_data,y_data,'b-','Linewidth',2);
    xlabel('Displacement (mm)');
    ylabel('Load (kN)');;
    legend(['Sample ' num2str(i)]);
    title(filename(i));

%Ask the User if They Want to Trim the Beginning
%-----------------------------------------------------------
        x_data_original=x_data;
        y_data_original=y_data;
answer11 = questdlg('Trim Beginning?', ...
	'Trim Beginning', ...
	'Yes','No','No');

switch answer11
%If Yes, Select Points and Cut Off the Beginning
%-----------------------------------------------------------
    case 'Yes'
        %Display Plot
        response11 = msgbox('Please Select Cutoff');
        uiwait(response11)
        plot(x_data,y_data,'b-','Linewidth',2);
            xlabel('Displacement (mm)');
            ylabel('Load (kN)');;
            legend(['Sample ' num2str(i)]);
            title(filename(i));
        %Select Points
        [cox,coy] = getpts;
        %Find X (Displacement) Value Nearest to Select Point
        index1 = knnsearch(x_data,cox);
        %Get Rid of All Points Before that Value
        x_data = x_data(index1:end);
        y_data = y_data(index1:end);
        %Ask the User if the Trim is Good. If Not, Repeat
%-----------------------------------------------------------
plot(x_data,y_data,'b-','Linewidth',2);
    xlabel('Displacement (mm)');
    ylabel('Load (kN)');;
    legend(['Sample ' num2str(i)]);
    title(filename(i));
check11 = questdlg('Is this ok?',...
    'Trim Check',...
    'Yes','No','Yes');
switch check11
    case 'Yes'
        break;
    case 'No'
        x_data=x_data_original;
        y_data=y_data_original;
        continue
end
    case 'No'
        x_data=x_data_original;
        y_data=y_data_original;
        break
end
end   
close(h);
x(i)={x_data};
y(i)={y_data};
if i==number_of_files
    break
end
end