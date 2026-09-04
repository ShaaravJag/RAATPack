function [peakload,displacementatpeak,timeatpeak,testduration,Gf, fittedCOD,slope,b] = DCTfinder(time, stroke, load, COD,thickness,ligament);

mdl = fitlm(time,COD);
slope=(mdl.Coefficients.Estimate(2));
b=(mdl.Coefficients.Estimate(1));
fittedCOD=slope.*time;
area=trapz(fittedCOD,load);
peakload=max(load);
[n1,maxxyloc] = find(load==max(load));
n1=n1(1,:);
displacementatpeak=fittedCOD(n1,:);
timeatpeak=time(n1,:);
Gf=10^6 * area / (thickness * ligament);
testduration=time(end,:);

end

