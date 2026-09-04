function tailplot = Tailplotter(x,y,colors)
tailplot = plot(x,y,'Linewidth',1);
set(tailplot, 'Color',colors);
set(tailplot, 'LineStyle','--');
end