function [peak, L, Str, Gf, Slope, Gf_S, Gf_SL_D2, CTIndex] = CTIndexfinder(x,y,thickness,diameter)


    xy = [x y];
peak = max(xy(:,2));
[n1,maxxyloc] = find(xy==max(xy(:,2)));
N1 = xy(n1:end,:);
[ d, ix ] = min( abs( N1(:,2)-0.85*(N1(1,2))) );
[ d2, ix2 ] = min( abs( N1(:,2)-0.65*(N1(1,2))) );
N18565 = N1(ix:ix2,:);
mdl = fitlm(N18565(:,1),N18565(:,2));
Slope=abs(mdl.Coefficients.Estimate(2));

U=trapz(xy(:,1),xy(:,2));
Data= [xy];
Gf=U ./ (thickness .* diameter)*10^6;
[ L, lx ] = min( abs( N1(:,2)-0.75*(N1(1,2))) );
L=N1(lx);
L_D=L./diameter;
Gf_S= Gf./ Slope;
Gf_SL_D=Gf_S.*L_D.*thickness/62;
Gf_SL_D2=Gf_S.*(L_D).^2.*thickness/62;
Str=(2*peak*10^3)./(pi.*10^-6*diameter.*thickness)./1000;

Gf=U ./ (thickness .* diameter).*10^6;
[ L, lx ] = min( abs( N1(:,2)-0.75*(N1(1,2))) );
L=N1(lx);
L_D=L./diameter;
Gf_S= Gf./ Slope;
Gf_SL_D=Gf_S.*L_D.*thickness/62;
Gf_SL_D2=Gf_S.*(L_D).^2.*thickness/62;

CTIndex=Gf_SL_D;

end

