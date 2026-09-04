function [export_Gf,pre_peak_load,pre_peak_stroke,pre_peak,post_peak,peak,time_at_peak,slope_pre_peak,b_pre_peak,stiffness_x,stiffness_y,Uc,stiffness,K,W,W_tail,W_total,Gf,Gf_without_tail,slope,b,Tail_x,Tail_y,tail_success] = ColdSCBfinder(time, stroke, load,COD,thickness,radius,notch);

stroke=stroke;
load=load;
graph_data=[stroke,load];
peak = max(graph_data(:,2));
[n1_sample1,maxxyloc] = find(graph_data==max(graph_data(:,2)));
pre_peak = graph_data(1:n1_sample1,:);
pre_peak_load=pre_peak(:,2);
pre_peak_stroke=pre_peak(:,1);
post_peak = graph_data(n1_sample1:end,:);

time_at_peak=time(n1_sample1,:);
time_at_peak=time_at_peak(end,:);

W=trapz(graph_data(:,1),graph_data(:,2));
mdl_sample1 = fitlm(pre_peak(:,1),pre_peak(:,2));
slope_pre_peak=abs(mdl_sample1.Coefficients.Estimate(2));
b_pre_peak=abs(mdl_sample1.Coefficients.Estimate(1));
stiffness=slope_pre_peak*1000;
Y=4.782 + 1.219 * (notch/radius) + 0.063 * exp(7.045*(notch/radius));
K= Y * peak /1000 / (2 * radius/1000 * thickness/1000) * sqrt( pi * notch/1000);
post=post_peak(1,2)*.6;
[ d2, ix ] = min( abs( post_peak(:,2)-0.6*(post_peak(1,2))));
sixty_percent_to_end=post_peak(ix:end,:);
options = fitoptions('power1', 'Lower', [0 -2]);
options = fitoptions('power1', 'Upper', [Inf -2]);
f_sample1 = fit(sixty_percent_to_end(:,1),sixty_percent_to_end(:,2),'power1',options);
coefficients_sample1=coeffvalues(f_sample1);
A=coefficients_sample1(:,1);
B=coefficients_sample1(:,2);
Tail_x=sixty_percent_to_end(end,1);
end_x=Tail_x;
Tail_y=sixty_percent_to_end(end,2);
end_y=Tail_y;
n=0;
while Tail_y>=.001
Tail_x=(end_x+.001*n);
Tail_y=A*Tail_x^B;
tail_success=1;
if n> 10000
    tail_success=0;
    break
else
n=n+1;
end
end

if tail_success==1
ii=((0:n)*.001)';
Tail_x=(end_x+ii);
Tail_y=A.*Tail_x.^B;
Tail_xy=[Tail_x,Tail_y];
W_tail=trapz(Tail_xy(:,1),Tail_xy(:,2));
W_total=W+W_tail;
Alig=(radius-notch)*thickness;
Gf=W_total/Alig*10^6;
Gf_without_tail=W/Alig*10^6;
Uc=graph_data(end,1);

mdl = fitlm(time,COD);
slope=(mdl.Coefficients.Estimate(2));
b=(mdl.Coefficients.Estimate(1));
export_Gf= Gf;
elseif tail_success==0;
ii=[];
Tail_x=[];
Tail_y=[];
Tail_xy=[];
W_tail=[];
W_total=W;
Alig=(radius-notch)*thickness;
Gf=[];
Gf_without_tail=W/Alig*10^6;
Uc=graph_data(end,1);

mdl = fitlm(time,COD);
slope=(mdl.Coefficients.Estimate(2));
b=(mdl.Coefficients.Estimate(1));

export_Gf=Gf_without_tail;

end

stiffness_x=linspace(0,pre_peak_stroke(end)+1)';
stiffness_y=slope_pre_peak.*stiffness_x+b_pre_peak;
[stiffness_x,stiffness_y];


