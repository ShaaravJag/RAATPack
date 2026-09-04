function [peak,displacementatpeak,Bond_strength,length_in,diameter_in] = BondStrfinder(x,y,diameter,length)

xy = [x y];
peak = max(xy(:,2));
Bond_strength=peak/(pi()*diameter^2 /4)*145038;


[n1,maxxyloc] = find(y==max(y));
n1=n1(1,:);
displacementatpeak=x(n1,:);

length_in=length*0.0393701;
diameter_in=diameter*0.0393701;

end

