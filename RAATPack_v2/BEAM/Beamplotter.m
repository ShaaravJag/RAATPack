function Beamplot = Beamplotter(x,y,colors)
Beamplot = loglog(x,y,'Linewidth',3);
set(Beamplot, 'Color',colors);
ax.XScale = 'log';
ax.YScale = 'log';
end