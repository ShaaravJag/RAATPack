function [time,stroke,load,COD] = ColdSCBopen(configfilename,full_file_path,number_of_files);

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
    opts.SelectedVariableNames = [str2double(config_settings_file(1,2)) str2double(config_settings_file(2,2)) str2double(config_settings_file(3,2)) str2double(config_settings_file(4,2))];
	opts.DataRange=[str2double(config_settings_file(5,2)) Inf];
    opts.Sheet=str2double(config_settings_file(28,2));
    opts.VariableNames= {'Time', 'Stroke', 'Load','COD','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
elseif contains(p,'.csv') == 1
    opts = detectImportOptions(p);
    opts = setvartype(opts,'double');
    opts.SelectedVariableNames = [str2double(config_settings_file(1,2)) str2double(config_settings_file(2,2)) str2double(config_settings_file(3,2)) str2double(config_settings_file(4,2))];
    opts.DataLines=[str2double(config_settings_file(5,2)) Inf];
    options.VariableNames= {'tabledata','Time', 'Stroke','Load','COD','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    opts.ExtraColumnsRule = 'ignore';
    opts.Delimiter = config_settings_file(11,2);
end

xy_data=readtable(p,opts);
xy_data=xy_data(~any(ismissing(xy_data),2),:);

time_data=xy_data{:,1};
time_data=time_data-time_data(1);
stroke_data=xy_data{:,2};
load_data=xy_data{:,3};
COD_data=xy_data{:,4};

%% Transform Data
Transformations=str2double(config_settings_file(12:23,2));
if Transformations(1) == 1 && Transformations(2) == 0 && Transformations(3) == 0
    COD_data=COD_data-COD_data(1);
elseif Transformations(1) == 1 && Transformations(2) == 1 && Transformations(3) == 0
    COD_data=-(COD_data-COD_data(1));
elseif Transformations(1) == 0 && Transformations(2) == 1 && Transformations(3) == 0
    COD_data=-COD_data;
elseif Transformations(1) == 0 && Transformations(2) == 1 && Transformations(3) == 1
    COD_data=-(COD_data-COD_data(end));
elseif Transformations(1) == 0 && Transformations(2) == 0 && Transformations(3) == 1
    COD_data=-(COD_data-COD_data(end));
end
if Transformations(4) == 1 && Transformations(5) == 0 && Transformations(6) == 0
    load_data=load_data-load_data(1);
elseif Transformations(4) == 1 && Transformations(5) == 1 && Transformations(6) == 0
    load_data=-(load_data-load_data(1));
elseif Transformations(4) == 0 && Transformations(5) == 1 && Transformations(6) == 0
    load_data=-load_data;
elseif Transformations(4) == 0 && Transformations(5) == 1 && Transformations(6) == 1
    load_data=-(load_data-load_data(end));
elseif Transformations(4) == 0 && Transformations(5) == 0 && Transformations(6) == 1
    load_data=-(load_data-load_data(end));
end

Transformations=str2double(config_settings_file(12:23,2));
if Transformations(10) == 1 && Transformations(11) == 0 && Transformations(12) == 0
    stroke_data=stroke_data-stroke_data(1);
elseif Transformations(10) == 1 && Transformations(11) == 1 && Transformations(12) == 0
    stroke_data=-(stroke_data-stroke_data(1));
elseif Transformations(10) == 0 && Transformations(11) == 1 && Transformations(12) == 0
    stroke_data=-stroke_data;
elseif Transformations(10) == 0 && Transformations(11) == 1 && Transformations(12) == 1
    stroke_data=-(stroke_data-stroke_data(end));
elseif Transformations(10) == 0 && Transformations(11) == 0 && Transformations(12) == 1
    stroke_data=-(stroke_data-stroke_data(end));
end
if Transformations(7) == 1 && Transformations(8) == 0 && Transformations(9) == 0
    time_data=time_data-time_data(1);
elseif Transformations(7) == 1 && Transformations(8) == 1 && Transformations(9) == 0
    time_data=-(time_data-time_data(1));
elseif Transformations(7) == 0 && Transformations(8) == 1 && Transformations(9) == 0
    time_data=-time_data;
elseif Transformations(7) == 0 && Transformations(8) == 1 && Transformations(9) == 1
    time_data=-(time_data-time_data(end));
elseif Transformations(7) == 0 && Transformations(8) == 0 && Transformations(9) == 1
    time_data=-(time_data-time_data(end));
end

%% Units 
time_units=(config_settings_file(24,2));
stroke_units=(config_settings_file(25,2));
load_units=(config_settings_file(26,2));
COD_units=(config_settings_file(27,2));

if string(time_units) == 'sec'
    time_data=time_data;
elseif string(COD_units) == 'min'
    time_data=time_data.*60;
end

if string(COD_units) == 'mm'
    COD_data=COD_data;
elseif string(COD_units) == 'm'
    COD_data=COD_data.*1000;
elseif string(COD_units) == 'in'
    COD_data=COD_data.*25.4;
end

if string(stroke_units) == 'mm'
    stroke_data=stroke_data;
elseif string(stroke_units) == 'm'
    stroke_data=stroke_data.*1000;
elseif string(stroke_units) == 'in'
    stroke_data=stroke_data.*25.4;
end

if string(load_units) == 'kN'
    load_data=load_data;
elseif string(load_units) == 'lb'
    load_data=load_data.*0.0044482216152605;
elseif string(load_units) == 'kip'
    load_data=load_data.*4.4482216;
elseif string(load_units) == 'N'
    load_data=load_data.*.001;
end

elseif contains(p,'.DAT') == 1 | contains(p,'.dat') == 1
xy_data = importdata(p);
xy_data=xy_data.textdata;
time_data= str2double(xy_data(:,1));
stroke_data= str2double(xy_data(:,2));
load_data = str2double(xy_data(:,3));
COD_data= str2double(xy_data(:,4));

time_data=time_data(~isnan(time_data));
stroke_data=stroke_data(~isnan(stroke_data));
load_data=load_data(~isnan(load_data));
COD_data=COD_data(~isnan(COD_data));

time_data=time_data-time_data(1,1);
stroke_data=(stroke_data(1,1)-stroke_data).*1000;
load_data=(-load_data)./1000;
COD_data=-COD_data;

end
COD(i)={COD_data};
load(i)={load_data};
time(i)={time_data};
stroke(i)={stroke_data};
if i==number_of_files
    break
    
end
end