function [fit_values_AASHTO,fit_values_ASTM,x1,x2,x3,x4,x5,x6,rsq_ASTM,rsq_AASHTO,stiffness_N50,E_N50,A,b,nf50_AASHTO,nf50_ASTM,max_normalized_modulus,x_at_max] = Beamfinder(cycles,flexural_stiffness,E,normalized_modulus);
%AASHTO Method
AASHTO_options=fitoptions('exp1','Robust','LAR');
[AASHTO_fit,pp,qq] = fit(cycles,flexural_stiffness,'exp1',AASHTO_options);
ff=coeffvalues(AASHTO_fit);
A=ff(1);
b=ff(2);
fit_values_AASHTO=(A.*exp(b.*cycles));
rsq_AASHTO=pp.rsquare;
nf50_AASHTO=(log(0.5))/b;
nf50_AASHTO=round(nf50_AASHTO);


stiffness_N50=flexural_stiffness(1)
stiffness_N50=round(stiffness_N50);
E_N50=E(1);
E_N50=round(E_N50);
AASHTO_Data=[stiffness_N50,A,b,nf50_AASHTO]';

%ASTM Method

[max_normalized_modulus,max_idx]=max(normalized_modulus);
x_at_max=cycles(max_idx);
ws = warning('off','all');
ASTM_fit = polyfit(cycles,normalized_modulus,6);
warning(ws);
x6= ASTM_fit(:,1);
x5= ASTM_fit(:,2);
x4= ASTM_fit(:,3);
x3= ASTM_fit(:,4);
x2= ASTM_fit(:,5);
x1= ASTM_fit(:,6);
fit_values_ASTM=polyval(ASTM_fit,cycles);
deriv11=polyder(ASTM_fit);
slope1=@(x) deriv11(1).*x.^5+deriv11(2).*x.^4+deriv11(3).*x.^3+deriv11(4).*x.^2+deriv11(5).*x+deriv11(6);
nf50_ASTM=fzero(slope1,100000);
ASTMmdl = fitlm(normalized_modulus,fit_values_ASTM);
rsq_ASTM=ASTMmdl.Rsquared.Ordinary;

ASTM_Data=[nf50_ASTM,max_normalized_modulus,x_at_max]';