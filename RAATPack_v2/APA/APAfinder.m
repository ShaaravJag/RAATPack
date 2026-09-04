function [left_rutting,center_rutting,right_rutting,average_rutting] = APAfinder(left,center,right,avg);
left_rutting=nonzeros(left(end,:));
center_rutting=nonzeros(center(end,:));
right_rutting=nonzeros(right(end,:));

wheels=[3-isempty(left_rutting)-isempty(center_rutting)-isempty(right_rutting)];
l=left_rutting;
c=center_rutting;
r=right_rutting;

if isempty(left_rutting)==1
    l=0;
end
if isempty(right_rutting)==1
    r=0;
end
if isempty(center_rutting)==1
    c=0;
end

average_rutting=[l+c+r]/wheels;

