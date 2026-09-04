function [left,right,cyclesL,cyclesR] = HAMopen(full_file_path,number_of_files);

i=0;
while(1)
    i = i+1;
    p=full_file_path{i};
[num text raw]=xlsread(p,2);

cycles_data=num(:,22);
cyclesL_data=num(3:end,2);
cyclesR_data=num(3:end,14);
[lmax, lidx]=max(cyclesL_data);
[rmax, ridx]=max(cyclesR_data);
left_data=num(3:lidx,23);
right_data=num(3:ridx,25);
cyclesL_data=num(3:lidx,2);
cyclesR_data=num(3:ridx,14);


right(i)={right_data};
left(i)={left_data};
cyclesL(i)={cyclesL_data};
cyclesR(i)={cyclesR_data};

if i==number_of_files
    break
end
end
