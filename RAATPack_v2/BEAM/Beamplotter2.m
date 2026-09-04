function Beamplot = Beamplotter2(x,fit_values_AASHTO,colors)
Beamplot = loglog(x,fit_values_AASHTO,'Linewidth',1);
set(Beamplot, 'Color',colors);
set(Beamplot, 'LineStyle','--');
ax.XScale = 'log';
ax.YScale = 'log';
end