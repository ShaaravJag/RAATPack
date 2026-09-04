function sse=sseval_VTS(x,frequency,viscosity_VTS,logE_measured_VTS,EMAX,viscosity_ref_VTS)
delta=x(1);
beta=x(2);
gamma=x(3);
C=x(4);
sse=sum(((delta+((log10(EMAX)-delta)./(1+exp(beta+gamma*(log10(1./frequency)-C.*(log10(viscosity_VTS)-log10(viscosity_ref_VTS)))))))-logE_measured_VTS).^2);
