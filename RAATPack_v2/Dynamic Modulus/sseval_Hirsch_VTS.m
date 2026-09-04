function sse=sseval_Hirsch_VTS(x,frequency,viscosity_Hirsch_VTS,logE_measured_Hirsch_VTS,EMAX,viscosity_ref_Hirsch_VTS)
delta=x(1);
beta=x(2);
gamma=x(3);
C=x(4);
sse=sum(((delta+((log10(EMAX)-delta)./(1+exp(beta+gamma*(log10(1./frequency)-C.*(log10(viscosity_Hirsch_VTS)-log10(viscosity_ref_Hirsch_VTS)))))))-logE_measured_Hirsch_VTS).^2);
