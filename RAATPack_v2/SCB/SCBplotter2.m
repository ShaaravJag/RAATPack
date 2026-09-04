function SCBplot2 = SCBplotter2(colors,InfPtx,InfPty,x1line,y1line)
SCBplot2 = plot(InfPtx,InfPty,'ro',x1line,y1line,'--','Linewidth',1);
set(SCBplot2, 'Color',colors);
end