function sse=sseval_exp(x,frequency1,frequency2,frequency3,logE_measured_NoConstr,EMAX)
delta=x(1);
beta=x(2);
gamma=x(3);
c=x(4);
ccc=x(5);




frequency_exp1=10^c.*frequency1;
frequency_exp2=10^0.*frequency2;
frequency_exp3=10^ccc.*frequency3;

frequency_exp=[frequency_exp1;frequency_exp2;frequency_exp3];
reduced_T=log10(1./frequency_exp);

sse=sum(((delta+((log10(EMAX)-delta)./(1+exp(beta+gamma.*(reduced_T)))))-logE_measured_NoConstr).^2);