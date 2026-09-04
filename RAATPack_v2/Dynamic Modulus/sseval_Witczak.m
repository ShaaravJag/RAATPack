function sse=sseval_Witczak(x,frequency,viscosity_WitczakVTS,logE_measured_WitczakVTS,EMAX,viscosity_ref_WitczakVTS)
delta=x(1);
beta=x(2);
gamma=x(3);
C=x(4);
sse=sum(((delta+((log10(EMAX)-delta)./(1+exp(beta+gamma*(log10(1./frequency)-C.*(log10(viscosity_WitczakVTS)-log10(viscosity_ref_WitczakVTS)))))))-logE_measured_WitczakVTS).^2);
