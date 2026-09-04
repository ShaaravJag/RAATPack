function [SCBplot,color] = SCBcolors(x,y,InfPtx,InfPty,x1line,y1line)
SCBplot = plot(x,y,'Linewidth',2);
color = get(SCBplot, 'Color');
end