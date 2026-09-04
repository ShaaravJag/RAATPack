function [Cx1_R, Cy1_R, Sx1_R, Sy1_R, InfPtx1_R, InfPty1_R, Cx1_L, Cy1_L, Sx1_L, Sy1_L, InfPtx1_L, InfPty1_L,Max_Rut_left,Stripping_Slope_left,Creeping_Slope_left,SIP_Ratio_left,Inf_Pt_left,Max_Rut_right,Stripping_Slope_right,Creeping_Slope_right,SIP_Ratio_right,Inf_Pt_right,Avg_Rut1,Avg_CS1,Avg_SS1,Avg_InfPt1,Avg_SIP_Ratio] = HAMfinder(cyclesL,cyclesR,left,right,specimenID)
left=-left;
right=-right;

%-------------------------------------------------------
%LEFT WHEEL
%-------------------------------------------------------

%Create Deformation Curve by Fitting to 6th Order Polynomial
%--------------------------------------------------------------------------
poly_left = polyfit(cyclesL,left,6);
Poly1 = @(x) poly_left(1)*x.^6+poly_left(2)*x.^5+poly_left(3)*x.^4+poly_left(4)*x.^3+poly_left(5)*x.^2+poly_left(6)*x+poly_left(7);

%Get the First Derivative of the Deformation Curve
%--------------------------------------------------------------------------
deriv_left = @(x) 6*poly_left(1)*x.^5+5*poly_left(2)*x.^4+4*poly_left(3)*x.^3+3*poly_left(4)*x.^2+2*poly_left(5)*x+poly_left(6);

%Get Minimum of 1st Derivative
%--------------------------------------------------------------------------
min_left = fminbnd(deriv_left,cyclesL(end)/2,cyclesL(end));

%Find the Value of the 1st Derivative at the Selected Min
%--------------------------------------------------------------------------
deriv_at_min_left = deriv_left(min_left);

%Stripping Slope
%--------------------------------------------------------------------------
%Find Values +/- 10 from the Calculated 1st Derivative
%--------------------------------------------------------------------------
x1 = min_left;

x11 = x1-10;
x21 = x1+10;

%Plug into the Polynomial
%--------------------------------------------------------------------------
y11 = (poly_left(1)*x11.^6)+(poly_left(2)*x11.^5)+(poly_left(3)*x11.^4)+(poly_left(4)*x11.^3)+(poly_left(5)*x11.^2)+(poly_left(6)*x11)+poly_left(7);
y21 = (poly_left(1)*x21.^6)+(poly_left(2)*x21.^5)+(poly_left(3)*x21.^4)+(poly_left(4)*x21.^3)+(poly_left(5)*x21.^2)+(poly_left(6)*x21)+poly_left(7);

%Calculate the Stripping Slope from the x and y Values
%--------------------------------------------------------------------------
Sslope1_L = (y21-y11)/(x21-x11); %should be equal to Sdxdy

%Calculate the y-Intercepts Using Point-Slope Equation
%--------------------------------------------------------------------------
Sint1_L = -(x11*Sslope1_L)+y11;

%Get the Second Derivative of the Deformation Curve
%--------------------------------------------------------------------------
Cf1_L = @(x) 6*5*poly_left(1)*x.^4+5*4*poly_left(2)*x.^3+4*3*poly_left(3)*x.^2+3*2*poly_left(4)*x+2*poly_left(5);

%Get Zero of 2nd Derivative Prior to Min of 1st
%--------------------------------------------------------------------------
Cm1_L = roots([6*5*poly_left(1),5*4*poly_left(2),4*3*poly_left(3),3*2*poly_left(4),2*poly_left(5)]);
for n = 1:length(Cm1_L)
    if isreal(Cm1_L(n))==0
        Cm1_L(n) = 0;
    end
end
Cm1_L = Cm1_L(Cm1_L~=0);
diffCm1Sm1 = Cm1_L-min_left;
Cm1_L = Cm1_L(find(diffCm1Sm1<-1));
derivatives = deriv_left(Cm1_L);
Cm1_L = Cm1_L(derivatives==max(derivatives));

%Find the Value of the 1st Derivative at the Zero
%--------------------------------------------------------------------------
Cdxdy1_L = deriv_left(Cm1_L);

%Creeping Slope
%-------------------------------------------------------
%Find Values +/- 10 from the Calculated 2nd Derivative
%-------------------------------------------------------
xc1 = Cm1_L;

xc11 = xc1-10;
xc21 = xc1+10;

%Plug into the Polynomial
%-------------------------------------------------------
yc11 = (poly_left(1)*xc11.^6)+(poly_left(2)*xc11.^5)+(poly_left(3)*xc11.^4)+(poly_left(4)*xc11.^3)+(poly_left(5)*xc11.^2)+(poly_left(6)*xc11)+poly_left(7);
yc21 = (poly_left(1)*xc21.^6)+(poly_left(2)*xc21.^5)+(poly_left(3)*xc21.^4)+(poly_left(4)*xc21.^3)+(poly_left(5)*xc21.^2)+(poly_left(6)*xc21)+poly_left(7);

%Calculate the Creeping Slope from the x and y Values
%-------------------------------------------------------
Cslope1_L = (yc21-yc11)/(xc21-xc11);

%Calculate the y-Intercepts Using Point-Slope Equation
%--------------------------------------------------------------------------
Cint1_L = -(xc11*Cslope1_L)+yc11;

%Calculate the Inflection Point as the Difference Between
%Intercepts/Difference Between Slopes
%--------------------------------------------------------------------------
InfPtx1_L = (Sint1_L-Cint1_L)/(Cslope1_L-Sslope1_L);
InfPty1_L = Sslope1_L*InfPtx1_L+Sint1_L;

%Create a Line through the Inflection Point with the Stripping Slope
%---------------------------------------------------------------------
Sx1_L = linspace(InfPtx1_L-(0.25*10.^4),cyclesL(end));
Sy1_L = Sslope1_L*(Sx1_L-InfPtx1_L)+InfPty1_L;

%Create a Line from the Inflection Point to the Last Stroke Value with the
%Creeping Slope
%-------------------------------------------------------------------------
Cx1_L = linspace(0,InfPtx1_L+(0.25*10.^4));
Cy1_L = Cslope1_L*(Cx1_L-InfPtx1_L)+InfPty1_L;

%Calculate Metrics
%-------------------------------------------------------
Max_Rut_left =-(poly_left(1)*20000.^6+poly_left(2)*20000.^5+poly_left(3)*20000.^4+poly_left(4)*20000.^3+poly_left(5)*20000.^2+poly_left(6)*20000+poly_left(7));
    %Max_Rut_left = max(-left);
    Stripping_Slope_left = Sslope1_L;
    Creeping_Slope_left = Cslope1_L;
    SIP_Ratio_left = Stripping_Slope_left/Creeping_Slope_left;
    if SIP_Ratio_left<2
        Inf_Pt_left=[];
    else
    Inf_Pt_left = InfPtx1_L;
    end
    %-------------------------------------------------------
%RIGHT WHEEL
%-------------------------------------------------------

%Create Deformation Curve by Fitting to 6th Order Polynomial
%--------------------------------------------------------------------------
poly_right = polyfit(cyclesR,right,6);
Poly1 = @(x) poly_right(1)*x.^6+poly_right(2)*x.^5+poly_right(3)*x.^4+poly_right(4)*x.^3+poly_right(5)*x.^2+poly_right(6)*x+poly_right(7);

%Get the First Derivative of the Deformation Curve
%--------------------------------------------------------------------------
deriv_right = @(x) 6*poly_right(1)*x.^5+5*poly_right(2)*x.^4+4*poly_right(3)*x.^3+3*poly_right(4)*x.^2+2*poly_right(5)*x+poly_right(6);

%Get Minimum of 1st Derivative
%--------------------------------------------------------------------------
Sm1_R = fminbnd(deriv_right,cyclesR(end)/2,cyclesR(end));

%Find the Value of the 1st Derivative at the Selected Min
%--------------------------------------------------------------------------
Sdxdy1_R = deriv_right(Sm1_R);

%Stripping Slope
%--------------------------------------------------------------------------
%Find Values +/- 10 from the Calculated 1st Derivative
%--------------------------------------------------------------------------
x1 = Sm1_R;

x11 = x1-10;
x21 = x1+10;

%Plug into the Polynomial
%--------------------------------------------------------------------------
y11 = (poly_right(1)*x11.^6)+(poly_right(2)*x11.^5)+(poly_right(3)*x11.^4)+(poly_right(4)*x11.^3)+(poly_right(5)*x11.^2)+(poly_right(6)*x11)+poly_right(7);
y21 = (poly_right(1)*x21.^6)+(poly_right(2)*x21.^5)+(poly_right(3)*x21.^4)+(poly_right(4)*x21.^3)+(poly_right(5)*x21.^2)+(poly_right(6)*x21)+poly_right(7);

%Calculate the Stripping Slope from the x and y Values
%--------------------------------------------------------------------------
Sslope1_R = (y21-y11)/(x21-x11); %should be equal to Sdxdy

%Calculate the y-Intercepts Using Point-Slope Equation
%--------------------------------------------------------------------------
Sint1_R = -(x11*Sslope1_R)+y11;

%Get the Second Derivative of the Deformation Curve
%--------------------------------------------------------------------------
Cf1_R = @(x) 6*5*poly_right(1)*x.^4+5*4*poly_right(2)*x.^3+4*3*poly_right(3)*x.^2+3*2*poly_right(4)*x+2*poly_right(5);

%Get Zero of 2nd Derivative Prior to Min of 1st
%--------------------------------------------------------------------------
Cm1_R = roots([6*5*poly_right(1),5*4*poly_right(2),4*3*poly_right(3),3*2*poly_right(4),2*poly_right(5)]);
for n = 1:length(Cm1_R)
    if isreal(Cm1_R(n))==0
        Cm1_R(n) = 0;
    end
end
Cm1_R = Cm1_R(Cm1_R~=0);
diffCm1_RSm1 = Cm1_R-Sm1_R;
Cm1_R = Cm1_R(find(diffCm1_RSm1<-1));

derivatives = deriv_right(Cm1_R);

Cm1_R = Cm1_R(derivatives==max(derivatives));

%Find the Value of the 1st Derivative at the Zero
%--------------------------------------------------------------------------
Cdxdy1_R = deriv_right(Cm1_R);

%Creeping Slope
%-------------------------------------------------------
%Find Values +/- 10 from the Calculated 2nd Derivative
%-------------------------------------------------------
xc1 = Cm1_R;

xc11 = xc1-10;
xc21 = xc1+10;

%Plug into the Polynomial
%-------------------------------------------------------
yc11 = (poly_right(1)*xc11.^6)+(poly_right(2)*xc11.^5)+(poly_right(3)*xc11.^4)+(poly_right(4)*xc11.^3)+(poly_right(5)*xc11.^2)+(poly_right(6)*xc11)+poly_right(7);
yc21 = (poly_right(1)*xc21.^6)+(poly_right(2)*xc21.^5)+(poly_right(3)*xc21.^4)+(poly_right(4)*xc21.^3)+(poly_right(5)*xc21.^2)+(poly_right(6)*xc21)+poly_right(7);

%Calculate the Creeping Slope from the x and y Values
%-------------------------------------------------------
Cslope1_R = (yc21-yc11)/(xc21-xc11);

%Calculate the y-Intercepts Using Point-Slope Equation
%--------------------------------------------------------------------------
Cint1_R = -(xc11*Cslope1_R)+yc11;

%Calculate the Inflection Point as the Difference Between
%Intercepts/Difference Between Slopes
%--------------------------------------------------------------------------
InfPtx1_R = (Sint1_R-Cint1_R)/(Cslope1_R-Sslope1_R);
InfPty1_R = Sslope1_R*InfPtx1_R+Sint1_R;

%Create a Line from 0 to the Inflection Point with the Stripping Slope
%---------------------------------------------------------------------
Sx1_R = linspace(InfPtx1_R-(0.25*10.^4),cyclesR(end));
Sy1_R = Sslope1_R*(Sx1_R-InfPtx1_R)+InfPty1_R;

%Create a Line from the Inflection Point to the Last Stroke Value with the
%Creeping Slope
%-------------------------------------------------------------------------
Cx1_R = linspace(0,InfPtx1_R+(0.25*10.^4));
Cy1_R = Cslope1_R*(Cx1_R-InfPtx1_R)+InfPty1_R;

%Calculate Metrics
%-------------------------------------------------------
Max_Rut_right =-(poly_right(1)*20000.^6+poly_right(2)*20000.^5+poly_right(3)*20000.^4+poly_right(4)*20000.^3+poly_right(5)*20000.^2+poly_right(6)*20000+poly_right(7));
    %Max_Rut_right = max(-right);
    Stripping_Slope_right = Sslope1_R;
    Creeping_Slope_right = Cslope1_R;
    SIP_Ratio_right = Stripping_Slope_right/Creeping_Slope_right;
    if SIP_Ratio_right<2
        Inf_Pt_right=[];
    else
    Inf_Pt_right = InfPtx1_R;
    end
%-------------------------------------------------------
%Metrics
%-------------------------------------------------------

%Average Metrics for Both Wheels
%-------------------------------------------------------
    Avg_Rut1 = (Max_Rut_left+Max_Rut_right)/2;
    Avg_CS1 = (Creeping_Slope_left+Creeping_Slope_right)/2;
    Avg_SS1 = (Stripping_Slope_left+Stripping_Slope_right)/2;
    Avg_InfPt1 = (Inf_Pt_left+Inf_Pt_right)/2;
    Avg_SIP_Ratio = (SIP_Ratio_left+SIP_Ratio_right)/2;
    
%Store Average Metrics and Raw Data for Later Use
    
    

while(1)
%Ask the User if the Slope if Fine
%-----------------------------------------------------------
%Set axes1 as the Display Axes




plot(cyclesL,left,'b-',Cx1_L,(Cy1_L),'g-',Sx1_L,Sy1_L,'r-',InfPtx1_L,(InfPty1_L),'ko','LineWidth',2);
axis([0 20000 -18 0]);
title(specimenID);
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
 axP = get(gca,'Position'); 
legend('Left Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');
set(gca, 'Position', axP)       
opts.Interpreter = 'none';
opts.Default = 'Yes';
IPcheck1 = questdlg('Are the left wheel slopes okay?',...
    'Slope Check',...
    'Yes','No','Cancel',opts);
switch IPcheck1
    case 'Yes'
        %-------------------------------------------------------

        break;
%If No, Then Allow the User to Select the Inflection Point By Hand
%-----------------------------------------------------------------
    case 'No'
        msg1 = msgbox('Sample 1: Please Select Stripping Slope Point.');
        uiwait(msg1)
        [StripPt_L,yIP] = getpts;
        Sdxdy1_L = deriv_left(StripPt_L);
        
        %Find Values +/- 10 from the Calculated 1st Derivative
        %--------------------------------------------------------------------------
        x1 = StripPt_L;

        x11 = x1-10;
        x21 = x1+10;

        %Plug into the Polynomial
        %--------------------------------------------------------------------------
        y11 = (poly_left(1)*x11.^6)+(poly_left(2)*x11.^5)+(poly_left(3)*x11.^4)+(poly_left(4)*x11.^3)+(poly_left(5)*x11.^2)+(poly_left(6)*x11)+poly_left(7);
        y21 = (poly_left(1)*x21.^6)+(poly_left(2)*x21.^5)+(poly_left(3)*x21.^4)+(poly_left(4)*x21.^3)+(poly_left(5)*x21.^2)+(poly_left(6)*x21)+poly_left(7);

        %Calculate the Stripping Slope from the x and y Values
        %--------------------------------------------------------------------------
        Sslope1_L = (y21-y11)/(x21-x11); %should be equal to Sdxdy

        %Calculate the y-Intercepts Using Point-Slope Equation
        %--------------------------------------------------------------------------
        Sint1_L = -(x11*Sslope1_L)+y11;
        
        msg1 = msgbox('Sample 1: Please Select Creep Slope Point.');
        uiwait(msg1)
        [CreepPt_L,yIP] = getpts;
        Cdxdy1_L = deriv_left(CreepPt_L);
        
        %Find Values +/- 10 from the Calculated 2nd Derivative
        %-------------------------------------------------------
        xc1 = CreepPt_L;

        xc11 = xc1-10;
        xc21 = xc1+10;

        %Plug into the Polynomial
        %-------------------------------------------------------
        yc11 = (poly_left(1)*xc11.^6)+(poly_left(2)*xc11.^5)+(poly_left(3)*xc11.^4)+(poly_left(4)*xc11.^3)+(poly_left(5)*xc11.^2)+(poly_left(6)*xc11)+poly_left(7);
        yc21 = (poly_left(1)*xc21.^6)+(poly_left(2)*xc21.^5)+(poly_left(3)*xc21.^4)+(poly_left(4)*xc21.^3)+(poly_left(5)*xc21.^2)+(poly_left(6)*xc21)+poly_left(7);

        %Calculate the Creeping Slope from the x and y Values
        %-------------------------------------------------------
        Cslope1_L = (yc21-yc11)/(xc21-xc11);

        %Calculate the y-Intercepts Using Point-Slope Equation
        %--------------------------------------------------------------------------
        Cint1_L = -(xc11*Cslope1_L)+yc11;

        %Calculate the Inflection Point as the Difference Between
        %Intercepts/Difference Between Slopes
        %--------------------------------------------------------------------------
        InfPtx1_L = (Sint1_L-Cint1_L)/(Cslope1_L-Sslope1_L);
        InfPty1_L = Sslope1_L*InfPtx1_L+Sint1_L;

        %Create a Line from 0 to the Inflection Point with the Stripping Slope
        %---------------------------------------------------------------------
        Sx1_L = linspace(InfPtx1_L-(0.25*10.^4),cyclesL(end));
        Sy1_L = Sslope1_L*(Sx1_L-InfPtx1_L)+InfPty1_L;

        %Create a Line from the Inflection Point to the Last Stroke Value with the
        %Creeping Slope
        %-------------------------------------------------------------------------
        Cx1_L = linspace(0,InfPtx1_L+(0.25*10.^4));
        Cy1_L = Cslope1_L*(Cx1_L-InfPtx1_L)+InfPty1_L;
        
        %Store Average Metrics and Raw Data for Later Use
        %-------------------------------------------------------

        %Calculate Metrics
%-------------------------------------------------------
    Max_Rut_left = max(-left);
    Stripping_Slope_left = Sslope1_L;
    Creeping_Slope_left = Cslope1_L;
    SIP_Ratio_left = Stripping_Slope_left/Creeping_Slope_left;
    if SIP_Ratio_left<2
        Inf_Pt_left=[];
    else
    Inf_Pt_left = InfPtx1_L;
    end
        %If a File Has Been Selected, Define Handles for Later Use
    %-------------------------------------------------------
 
    %Create Min Cycle Line

    plot(cyclesL,(left),'b-',Cx1_L,(Cy1_L),'g-',Sx1_L,Sy1_L,'r-',InfPtx1_L,(InfPty1_L),'ko','LineWidth',2);
    axis([0 20000 -18 0]);
    title(specimenID);
    xlabel('Loading Cycles (n)');
    ylabel('Vertical Deformation (mm)');
     axP = get(gca,'Position');

    legend('Left Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');
    set(gca, 'Position', axP)  

    case 'Cancel'
        break
    end
end
while(1)
%Ask the User if the Slope if Fine
%-----------------------------------------------------------
%Set axes1 as the Display Axes




plot(cyclesR,right,'m-',Cx1_R,(Cy1_R),'g-',Sx1_R,Sy1_R,'r-',InfPtx1_R,(InfPty1_R),'ko','LineWidth',2);
axis([0 20000 -18 0]);
xlabel('Loading Cycles (n)');
ylabel('Vertical Deformation (mm)');
title(specimenID);
axP = get(gca,'Position'); 
legend('Right Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');
set(gca, 'Position', axP)       
opts.Interpreter = 'none';
opts.Default = 'Yes';
IPcheck1 = questdlg('Are the right wheel slopes okay?',...
    'Slope Check',...
    'Yes','No','Cancel',opts);
switch IPcheck1
    case 'Yes'
        %-------------------------------------------------------

        break;
%If No, Then Allow the User to Select the Inflection Point By Hand
%-----------------------------------------------------------------
    case 'No'
        msg1 = msgbox('Sample 1: Please Select Stripping Slope Point.');
        uiwait(msg1)
        [StripPt_R,yIP] = getpts;
        Sdxdy1_R = deriv_right(StripPt_R);
        
        %Find Values +/- 10 from the Calculated 1st Derivative
        %--------------------------------------------------------------------------
        x1 = StripPt_R;

        x11 = x1-10;
        x21 = x1+10;

        %Plug into the Polynomial
        %--------------------------------------------------------------------------
        y11 = (poly_right(1)*x11.^6)+(poly_right(2)*x11.^5)+(poly_right(3)*x11.^4)+(poly_right(4)*x11.^3)+(poly_right(5)*x11.^2)+(poly_right(6)*x11)+poly_right(7);
        y21 = (poly_right(1)*x21.^6)+(poly_right(2)*x21.^5)+(poly_right(3)*x21.^4)+(poly_right(4)*x21.^3)+(poly_right(5)*x21.^2)+(poly_right(6)*x21)+poly_right(7);

        %Calculate the Stripping Slope from the x and y Values
        %--------------------------------------------------------------------------
        Sslope1_R = (y21-y11)/(x21-x11); %should be equal to Sdxdy

        %Calculate the y-Intercepts Using Point-Slope Equation
        %--------------------------------------------------------------------------
        Sint1_R = -(x11*Sslope1_R)+y11;
        
        msg1 = msgbox('Sample 1: Please Select Creep Slope Point.');
        uiwait(msg1)
        [CreepPt_R,yIP] = getpts;
        Cdxdy1_R = deriv_right(CreepPt_R);
        
        %Find Values +/- 10 from the Calculated 2nd Derivative
        %-------------------------------------------------------
        xc1 = CreepPt_R;

        xc11 = xc1-10;
        xc21 = xc1+10;

        %Plug into the Polynomial
        %-------------------------------------------------------
        yc11 = (poly_right(1)*xc11.^6)+(poly_right(2)*xc11.^5)+(poly_right(3)*xc11.^4)+(poly_right(4)*xc11.^3)+(poly_right(5)*xc11.^2)+(poly_right(6)*xc11)+poly_right(7);
        yc21 = (poly_right(1)*xc21.^6)+(poly_right(2)*xc21.^5)+(poly_right(3)*xc21.^4)+(poly_right(4)*xc21.^3)+(poly_right(5)*xc21.^2)+(poly_right(6)*xc21)+poly_right(7);

        %Calculate the Creeping Slope from the x and y Values
        %-------------------------------------------------------
        Cslope1_R = (yc21-yc11)/(xc21-xc11);

        %Calculate the y-Intercepts Using Point-Slope Equation
        %--------------------------------------------------------------------------
        Cint1_R = -(xc11*Cslope1_R)+yc11;

        %Calculate the Inflection Point as the Difference Between
        %Intercepts/Difference Between Slopes
        %--------------------------------------------------------------------------
        InfPtx1_R = (Sint1_R-Cint1_R)/(Cslope1_R-Sslope1_R);
        InfPty1_R = Sslope1_R*InfPtx1_R+Sint1_R;

        %Create a Line from 0 to the Inflection Point with the Stripping Slope
        %---------------------------------------------------------------------
        Sx1_R = linspace(InfPtx1_R-(0.25*10.^4),cyclesR(end));
        Sy1_R = Sslope1_R*(Sx1_R-InfPtx1_R)+InfPty1_R;

        %Create a Line from the Inflection Point to the Rast Stroke Value with the
        %Creeping Slope
        %-------------------------------------------------------------------------
        Cx1_R = linspace(0,InfPtx1_R+(0.25*10.^4));
        Cy1_R = Cslope1_R*(Cx1_R-InfPtx1_R)+InfPty1_R;
        
        %Store Average Metrics and Raw Data for Rater Use
        %-------------------------------------------------------

        %Calculate Metrics
%-------------------------------------------------------
    Max_Rut_right = max(-right);
    Stripping_Slope_right = Sslope1_R;
    Creeping_Slope_right = Cslope1_R;
    SIP_Ratio_right = Stripping_Slope_right/Creeping_Slope_right;
    if SIP_Ratio_right<2
        Inf_Pt_right=[];
    else
    Inf_Pt_right = InfPtx1_R;
    end
        %If a File Has Been Selected, Define Handles for Rater Use
    %-------------------------------------------------------
 
    %Create Min Cycle Line

    plot(cyclesR,(right),'b-',Cx1_R,(Cy1_R),'g-',Sx1_R,Sy1_R,'r-',InfPtx1_R,(InfPty1_R),'ko','LineWidth',2);
    axis([0 20000 -18 0]);
    xlabel('Loading Cycles (n)');
    title(specimenID);
    ylabel('Vertical Deformation (mm)');
    axP = get(gca,'Position');

    legend('Right Wheel','Creeping Slope','Stripping Slope','Inflection Point','Max Rutting','Minimum Cycles at Inflection Point','location','NorthEastOutside');
    set(gca, 'Position', axP)  

    case 'Cancel'
        break
    end
end

if 0<Max_Rut_left && Max_Rut_left<20
else
    Max_Rut_left='Max rut';
end
if 0<Max_Rut_right && Max_Rut_left<20
else
    Max_Rut_right='Max rut';
end
Stripping_Slope_left=-Stripping_Slope_left;
Creeping_Slope_left=-Creeping_Slope_left;
Stripping_Slope_right=-Stripping_Slope_right;
Creeping_Slope_right=-Creeping_Slope_right;
Avg_CS1=-Avg_CS1;
Avg_SS1=-Avg_SS1;
