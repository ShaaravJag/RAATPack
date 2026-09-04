function [left,center,right,cyclesL,cyclesC,cyclesR,cyclesA,avg] = APAopen(full_file_path,number_of_files);

i=0;
while(1)
    i = i+1;
    p=full_file_path{i};
[num text raw]=xlsread(p,2);

cycles_data=num(:,22);
left_data=num(:,23);
center_data=num(:,24);
right_data=num(:,25);
OGleft_data=left_data;
OGright_data=right_data;
OGcenter_data=center_data;

FL = find(left_data~=0);
    EndL = max(FL);
    cyclesL_data = cycles_data(FL);
    cyclesL_data=[cyclesL_data(~isnan(cyclesL_data))];
    left_data = left_data(FL);  
    left_data=[0; left_data(~isnan(left_data))];
FR = find(right_data~=0);
    EndR = max(FR);
    cyclesR_data = cycles_data(FR);
    cyclesR_data=[cyclesR_data(~isnan(cyclesR_data))];
    right_data = right_data(FR);
    right_data=[0; right_data(~isnan(right_data))];
FC = find(center_data~=0);
    EndC = max(FC);
    cyclesC_data = cycles_data(FC);
    cyclesC_data=[cyclesC_data(~isnan(cyclesC_data))];
    center_data = center_data(FC);
    center_data=[0; center_data(~isnan(center_data))];
    


Data=[OGleft_data,OGcenter_data,OGright_data];

emptycolumncheck=Data(1,:);
value_columns=emptycolumncheck(emptycolumncheck~=0);
size_columns=size(value_columns);
size_columns=size_columns(2);

TableData=Data;

if Data(100,3)==0
    TableData(:,3)=[];

end
if Data(100,2)==0
    TableData(:,2)=[];
end
if Data(100,1)==0
   TableData(:,1)=[];
end

cmax=max(cyclesC_data);
lmax=max(cyclesL_data);
rmax=max(cyclesR_data);
if lmax==0
    lmax=[];
end
if cmax==0
    cmax=[];
end
if rmax==0
    rmax=[];
end
amax=min([cmax,lmax,rmax]);
cyclesA_data=[1:amax]';

TableData=TableData(1:amax,:);
datasize=size(TableData);
average_rutting=sum(TableData(end,:))./(datasize(2));
avg_data=sum(TableData,2)./(datasize(2));

wheels=[3-isempty(nonzeros(cyclesL_data(end)))-isempty(nonzeros(cyclesC_data(end)))-isempty(nonzeros(cyclesR_data(end)))];

right(i)={right_data};
left(i)={left_data};
center(i)={center_data};
cyclesL(i)={cyclesL_data};
cyclesC(i)={cyclesC_data};
cyclesR(i)={cyclesR_data};
cyclesA(i)={cyclesA_data};
avg(i)={avg_data};

if i==number_of_files
    break
end
end
