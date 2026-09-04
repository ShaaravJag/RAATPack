function [data_plot,color] = colors(x,y)
data_plot = plot(x,y,'Linewidth',2);
color = get(data_plot, 'Color');
end