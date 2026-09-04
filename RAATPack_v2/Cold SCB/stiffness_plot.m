function multiplot = stiffness_plot(x,y,colors)
multiplot = plot(x,y,'--','Linewidth',1);
set(multiplot, 'Color',colors);
end