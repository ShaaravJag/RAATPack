function multiplot = multiplotter(x,y,colors)
multiplot = plot(x,y,'Linewidth',3);
set(multiplot, 'Color',colors);
end