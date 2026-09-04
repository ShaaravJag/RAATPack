function [peak_N,IDT_strength] = IDTStrfinder(x,y,thickness,diameter)

xy = [x y];
peak_kN = max(xy(:,2));
peak_N = peak_kN(1)*1000;
IDT_strength=peak_N*2000/(pi()*thickness*diameter);

end

