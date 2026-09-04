function sse=sseval(x,frequency,temperature_F,logE_measured_EA,EMAX,reference_temp)
delta=x(1);
beta=x(2);
gamma=x(3);
EA=x(4);
sse=sum(((delta+((log10(EMAX)-delta)./(1+exp(beta+gamma*(log10(frequency)+(EA/19.14714*(1./((temperature_F-32)*5/9+273.15)-1/reference_temp)))))))-logE_measured_EA).^2);
