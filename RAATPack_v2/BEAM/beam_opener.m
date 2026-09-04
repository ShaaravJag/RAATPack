function [cycles,flexural_stiffness,E,normalized_modulus] = beam_opener(configfilename,full_file_path,number_of_files);

i=0;
while(1)
    i = i+1;
    p=full_file_path(i);
if contains(p,'.xls') == 1 | contains(p,'.csv') == 1
config_settings_file=table2cell(readtable(configfilename,'ReadVariableNames',false));
str2double(config_settings_file);
if contains(p,'.xls') == 1 
    opts = detectImportOptions(p);
    opts.SelectedVariableNames = [str2double(config_settings_file(1,2)) str2double(config_settings_file(2,2)) str2double(config_settings_file(3,2))];
	opts.DataRange=[str2double(config_settings_file(4,2)) Inf];
opts.Sheet=str2double(config_settings_file(12,2));
    opts.VariableNames= {'Cycles', 'FlexuralStiffness', 'ElasticModulus','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
elseif contains(p,'.csv') == 1
    opts = detectImportOptions(p);
    opts.SelectedVariableNames = [str2double(config_settings_file(1,2)) str2double(config_settings_file(2,2)) str2double(config_settings_file(3,2))];
    opts.DataLines=[str2double(config_settings_file(4,2)) Inf];
    options.VariableNames= {'tabledata','Cycles', 'FlexuralStiffness','ElasticModulus','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler','filler'};
    opts.ExtraColumnsRule = 'ignore';
    opts.Delimiter = config_settings_file(9,2);
end

xy_data=readtable(p,opts);
xy_data=xy_data(~any(ismissing(xy_data),2),:);
cycles_data=xy_data{:,1};
flexural_stiffness_data=xy_data{:,2};
E_data=xy_data{:,3};
normalized_modulus_data=(E_data./(E_data(1,:))).*(cycles_data./cycles_data(1,:));

if cycles_data(1)==10
cycles_data=cycles_data(5:end);    
flexural_stiffness_data=flexural_stiffness_data(5:end);
E_data=E_data(5:end);
normalized_modulus_data=normalized_modulus_data(5:end);
end
%% Units 
flexural_stiffness_units=(config_settings_file(10,2));
E_units=(config_settings_file(11,2));

cycles(i)={cycles_data};
flexural_stiffness(i)={flexural_stiffness_data};
E(i)={E_data};
normalized_modulus(i)={normalized_modulus_data};

if i==number_of_files
    break
end
end
end
