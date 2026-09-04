function [peak, Str, Gf, Slope, FI, InfPtx, InfPty, x1line, y1line, fittedvals] = FIfinder(x,y,thickness,ligament,specimenID)
%Get and Display the Trimmed Displacement and Load Data (xy)
%-----------------------------------------------------------
xy = [x y];
cla
plot(xy(:,1),xy(:,2),'b-','Linewidth',2);
    xlabel('Displacement (mm)');
    ylabel('Load (kN)');
    legend(specimenID,'location','ne');
    
Success=0;
j=1;
while Success==0
%Find Value and Index of the Maximum Load
%-----------------------------------------------------------
[n1,peakloc] = find(xy==max(xy(:,2)));
peak = max(xy(:,2));

%Find the Area Under the Curve Using the Trapezoid Rule
%-----------------------------------------------------------
Int1=trapz(xy(:,1),xy(:,2));

%Define N1 as the Data from the Maximum to the End
%-----------------------------------------------------------
N1 = xy(n1:end,:);

%Get 10 Percent of the Maximum Load
%-----------------------------------------------------------
tenp1 = 0.1*peak*ones(size(N1));

%Find the N1 Load Value with the Smallest Absolute Distance from the 10% Value
%-----------------------------------------------------------------------------
[c index] = min(abs(N1(:,2)-tenp1(:,2)));

%Cut off N1 at that Value
%-----------------------------------------------------------
O1 = N1(1:index,:);

%Fit a 6th Order Polynomial to the New Data
%-----------------------------------------------------------
x1=O1(:,1);
y1=O1(:,2);
poly1=polyfit(x1,y1,6);
fittedvals=polyval(poly1,x1);

%Get the 1st and 2nd Derivative of the Polynomial
%-----------------------------------------------------------
deriv11=polyder(poly1);
deriv21 = polyder(polyder(poly1));

%Get the Roots of the 2nd Derivative
%-----------------------------------------------------------
r1=roots(deriv21);

%Initialize i as Equal to Zero
%-----------------------------------------------------------
i = 0;

%Create a Zero Matrix the Same Size as the # of Roots
%-----------------------------------------------------------
R1 = zeros(size(r1));

%For i = 1 to # roots
%-----------------------------------------------------------
while(1)
    i = i+1;
    %Check if the ith Root is Real
    if isreal(r1(i))==1
        RealRoot(i)= r1(i);
    else
    %Set the Root Equal to Zero if Not Real
        RealRoot(i)=0;
    end
    if i==length(r1)
        break
    end
end

%Find the Index where the Load is Equal to its Max
%-----------------------------------------------------------
end11 = find(xy(:,2)==peak);

%Find the Index where the Load is Equal to 10% of the Max
%-----------------------------------------------------------
end21 = knnsearch(xy(:,2),j*tenp1(1,1));

if length(end11)>1
    end11 = end11(1);
end

if length(end21)>1
    end21 = end21(1);
end

%Isolate the Real Roots of the 2nd Derivative(Those Not Set to Zero)
%-------------------------------------------------------------------
R1 = RealRoot(find(RealRoot>0));

%Set the Inflection Point to the Root Between the Max and 10% of the Max
%-----------------------------------------------------------------------
InflectionPt1 = R1(find(R1<xy(end21,1) & R1>xy(end11,1)));

%Get the Size of the Inflection Point (0 Means No Point)
%-----------------------------------------------------------
SizeIP1 = size(InflectionPt1);
Success=SizeIP1(2);
j=j+1;
if Success~=0 || j==9
    break
end
end
%Let the User Select an Inflection Point if it is not Found
%-----------------------------------------------------------
if SizeIP1(2)==0
    f1 = msgbox([specimenID ': Could Not Find Inflection Point. Please Select Inflection Point.']);
    uiwait(f1)
    plot(xy(:,1),xy(:,2),'b-','Linewidth',2);
    [InflectionPt1,yIP] = getpts;
end

while(1)

%Find the Absolute Slope at the Inflection Point
%-----------------------------------------------------------
Slope1=@(x) deriv11(1).*x.^5+deriv11(2).*x.^4+deriv11(3).*x.^3+deriv11(4).*x.^2+deriv11(5).*x+deriv11(6);
Slope = Slope1(InflectionPt1);
absSlope1 = abs(Slope);
Slope = Slope(find(absSlope1==max(absSlope1)));
InflectionPt1 = InflectionPt1(find(absSlope1==max(absSlope1)));

%Calculate Table Values
%-----------------------------------------------------------
Area_lig1=1E-6 * thickness * ligament;
Gf=Int1./Area_lig1;
FI=Gf./abs(Slope)*.01;
Str = (peak/(2*(ligament+15)*thickness))*21036021.444;

%Find the X (Displacement) Value of the Inflection Point
%-----------------------------------------------------------
f1 = knnsearch(xy(:,1),InflectionPt1);
InfPtx = xy(f1,1);
InfPty = xy(f1,2);

%Create a Line Through the Inflection Point with the Calculated Slope
%--------------------------------------------------------------------
x1line = linspace(0,round(xy(end,1)));
y1line = (Slope)*x1line+(-InfPtx*Slope+InfPty);

%Plot the Load-Displacement Curve with the Calculated Slope
%-----------------------------------------------------------
plot( xy(:,1), xy(:,2), 'b-',InfPtx,InfPty,'ro',x1line,y1line,'k--','Linewidth',2);
    xlabel('Displacement (mm)');
    ylabel('Load (kN)');
    legend(specimenID,'Inflection Point','Slope','location','ne');
    ylim([0 (max(xy(:,2))+1)]);
    
%Ask the User if the Slope if Fine
%-----------------------------------------------------------
IPcheck1 = questdlg('Is this Slope ok?',...
    'Inflection Point Check',...
    'Yes','No','Yes');

switch IPcheck1
    case 'Yes'
        break;
%If No, Then Allow the User to Select the Inflection Point By Hand
%-----------------------------------------------------------------
    case 'No'
        plot(xy(:,1),xy(:,2),'b-','Linewidth',2);
            xlabel('Displacement (mm)');
            ylabel('Load (kN)');
            legend(specimenID,'location','ne');
            ylim([0 (max(xy(:,2))+1)]);
        msg1 = msgbox([specimenID ': Please Select Inflection Point.']);
        uiwait(msg1)
        [InflectionPt1,yIP] = getpts;
        continue
end
end

%Store Calculated Values for Later
%-----------------------------------------------------------

xy = [xy(:,1)-xy(1,1),xy(:,2)];
end
