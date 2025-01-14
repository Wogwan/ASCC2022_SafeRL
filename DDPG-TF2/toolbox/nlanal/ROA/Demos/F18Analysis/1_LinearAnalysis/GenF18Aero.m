%
% Aerodynamic Plot for F/A-18 A/B
%
% This file generates the Aerodynamic Charactesitics of the F/A-18 A/B
% aircraft. The Data have been coolected from multiple papers and they are
% referenced below.  This data is not comprehensive and lack sideslip
% direction data. To plot the aerodynamic charcatersitics insert the
% plotson index. The index of plotson are: 
% 
% 1:Clb    2:Cldr    3:Clda   4:Clp    5:Clr    6:Cnb   7:Cndr    8:Cnda
% 9:Cnr    10:Cnp    11:Cyb   12:Cyda   13:Cydr   14:Cma   15:Cmds   16:Cmq
% 17:CLds   18:CDds
%
% NOTE:  MULTIPOLY Toolbox is required to use this file.  However, the data
% are provided and user can take the data and use other simple Least Square
% fit to come up with the polynomial expression for the data. 
% Dr. Foster have provided input on this model. Some comments have been
% made on the data set to address his remarks. 
%
%  Also, the aerodynamic data will be saved in a MAT File. 
% 
%==========================================================================
% Aerodynamic Model 
% 
% General Trend should make sense from 0 to 60 degree aoa
% Aerodynamic Data have been extracted from the following references. 
%
% References: 
%
% 
% (1) Marcello R. Napolitano and Alfonso C. Paris and Brad A. Seanor,
%     Estimation of the lateral-directional aerodynamic parameters from 
%     flight data for the NASA F/A-18 HARV.
%     AIAA Atmospheric Flight Mechanics Conference,
%     AIAA-96-3420-CP, 1996, 479-489. 
%
% (2) Marcello R. Napolitano and Alfonso C. Paris and Brad A. Seanor,
%     Estimation of the longitudinal aerodynamic parameters from flight 
%     data for the NASA F/A-18 HARV
%     AIAA Atmospheric Flight Mechanics Conference,
%     AIAA-96-3420-CP, 1996, 469-478.
%
% (3) Kenneth W. Iliff and Kon-sheng Charles Wang: Flight-Determined 
%     Subsonic Longitudinal Stability and Control
%     Derivatives of the F-18 High Angle of Attack Research Vehicle 
%     (HARV) With Thrust Vectoring
%
% (4) Marcello R. Napolitano and Joelle M. Spagnuolo,
%     Determination of the stability and control derivatives of the 
%     NASA F/A-18 HARV using flight data, NASA CR-194838, 1993.
%
% (5) Lulch C. Daniel, Analysis of the Out-of-Control Falling Leaf Motion
%     using a Rotational Axis Coordinate System. MS thesis
%     Virginia Polytechnic Institue and State University, 1998.
%
% (6) Benjamin R. Carter, Time-Optimization of high perfromance combat
%     maneuvers. MS Thesis. Naval Post Graduate School, 2004.
%
% (7) Kenneth W. Iliff and Kon-sheng Charles Wang: Flight-Determined 
%     Subsonic, Lateral-Directional Stability and Control Derivatives 
%     of the Thrust-Vectoring F-18 High Angle of Attack Research Vehicle
%    (HARV), and Comparisons to the Basic F-18 and Predicted Derivatives
% 
%==========================================================================



close all 


%------------------------------------------------------------------------
% Physical Data

f18_data; 


%-----------------------------------------------------------------------

plotson =[5 9 10];   % Show Plots

Npts = 20;     % Number of Points to plot the polynomial fit


%-----------------------------------------------------------------
% Lateral Directional Aerodynamic Characteristics
% Ref (1)
% Unless otherwise Noted
%-----------------------------------------------------------------

% ========================================================
% Rolling Moment Coefficient 
% ========================================================

% ------------------------------------------------------------------------
% Rolling Moment due to Sideslip as function of AoA: Basic Airframe


% Original F18 Data
ClbdataF18  =  [-0.0012  -0.0025   -0.0031   -0.003  -0.0028   -0.0025  -0.0020  -0.0016  -0.0012  -0.0011  -0.0016  ]*r2d;   % Unit was 1/deg
adataF18    =  [  5        10       15        20        25       30        35       40       45       50        60 ]*d2r;

% Artifical Data
% F-16 data shows Clb is negative upto -10 degree AoA and its also decreasing.   
% Artifical data has been added to preserve negativity of Clb upto -10
% degree AoA. F16 has similar trend. 

Clb0   = [ -0.0002  -0.0005  -0.0008 ]*r2d; 
adata0 = [  -10        -5        0 ]*d2r; 

Clbdata = [Clb0 ClbdataF18];  adata = [ adata0 adataF18]; 
Na = length(adata);

W = ones(Na,1);  W(  (adata <= 10) ) = 10;
pvar c0 c1 c2 c3 c4 alp;
Clb = c0 + c1*alp + c2*alp^2 + c3*alp^3  + c4*alp^4; 
Clb = pdatafit(Clb,alp,adata,Clbdata,W);
aoarange = linspace(-10,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Clb_0 =Clb.coeff(5,1);  F18Aero.Clb_1 =Clb.coeff(4,1);  
F18Aero.Clb_2 =Clb.coeff(3,1);  F18Aero.Clb_3 =Clb.coeff(2,1); 
F18Aero.Clb_4 =Clb.coeff(1,1); 

% Plot poly fit with original curve
if ismember(1,plotson) 
    figure;
    set(gca,'FontSize',20)
    plot(adataF18*r2d,ClbdataF18*d2r,'ob',adata0*r2d,Clb0*d2r,'ks','MarkerSize',10,'LineWidth',3);
    hold on 
    plot(aoarange*r2d,double(subs(Clb,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',18); ylabel('C_{l_{\beta}}');
    grid on 
    legend('C_{l_{\beta}}','artifical data','Poly Fit');
 end

% ------------------------------------------------------------------------
% Rolling moment Due to Rudder Effect


% Original F18 Data
CldrdataF18 =  [ 0.000227   0.000228   0.00023  0.000227   0.00021  0.00019   0.00015   0.000095  0.00003   -0.000035]*r2d; % Unit was 1/deg
adataF18 =     [       10          15        20        25       30        35       40         45       50          55]*d2r;

% Artifical Data
% Dr. Foster:  Flat-line rolling moment coeff instead of extrapolating.
% hence, the artifical data has been held constant at 0 and 5 degree aoa.
% also, data does not exist for 0 and 5 degree aoa.

Cldr0   = [0.000227   0.000227  ]*r2d; 
adata0  = [  0            5 ]*d2r; 

Cldrdata = [Cldr0 CldrdataF18];  adata = [ adata0 adataF18]; 


Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) ) = 40;
pvar c0 c1 c2 c3 alp;
Cldr = c0 + c1*alp + c2*alp^2 + c3*alp^3; 
Cldr = pdatafit(Cldr,alp,adata,Cldrdata,W);
aoarange = linspace(-10,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cldr_0 =Cldr.coeff(4,1); F18Aero.Cldr_1 =Cldr.coeff(3,1); 
F18Aero.Cldr_2 =Cldr.coeff(2,1); F18Aero.Cldr_3 =Cldr.coeff(1,1); 

% Plot poly fit with original curve
if ismember(2,plotson)
    figure; 
    subplot(221)
    set(gca,'FontSize',20)
    plot(adataF18*r2d,CldrdataF18*d2r,'ob',adata0*r2d,Cldr0*d2r,'ks','MarkerSize',10,'LineWidth',3);
    hold on 
    plot(aoarange*r2d,double(subs(Cldr,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{l_{\delta_{rud}}}');
    grid on 
    legend('C_{l_{\delta_{rud}}}','artifical data','Poly Fit');
end

% ------------------------------------------------------------------------
% Rolling moment Due to Aileron Effect


% original F18 Data
CldadataF18   =  [ 0.0025   0.00225   0.001938  0.00175   0.00145  0.00125   0.001   0.0008125  0.000625  0.0005  0.00045 ]*r2d; % Unit was 1/deg
adataF18      =  [   5        10        15        20        25       30        35       40       45        50       60]*d2r;

% Artifical Data
% F-16 data shows slightly less value for 0 degree compare to 5 degree AoA. 
% Hence, adding 0 degree data slightly less than the 5 degree data
% This causes to flatline the curve rather than extrpolating .
Clda0   = [0.0024 ]*r2d; 
adata0  = [  0    ]*d2r; 

Cldadata = [Clda0 CldadataF18];  adata = [ adata0 adataF18]; 

Na = length(adata);

W = ones(Na,1);  W( (adata <=10)  ) = 40;
pvar c0 c1 c2 c3 c4 alp;
Clda = c0 + c1*alp + c2*alp^2 + c3*alp^3 ;%+ c4*alp^4; 
Clda = pdatafit(Clda,alp,adata,Cldadata,W);
aoarange = linspace(-10,60,Npts)*d2r; 

% Create the coefficients variable 
 F18Aero.Clda_0 = Clda.coeff(4,1); F18Aero.Clda_1 = Clda.coeff(3,1); 
 F18Aero.Clda_2 = Clda.coeff(2,1); F18Aero.Clda_3 = Clda.coeff(1,1); 
 
% Plot poly fit with original curve
if ismember(2,plotson) 
    subplot(222)
    set(gca,'FontSize',20)
    plot(adataF18*r2d,CldadataF18*d2r,'ob',adata0*r2d, Clda0*d2r,'ks','MarkerSize',10,'LineWidth',3);
    hold on 
    plot(aoarange*r2d,double(subs(Clda,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{l_{\delta_{ail}}}');
    grid on 
    legend('C_{l_{\delta_{ail}}}','artifical data','Poly Fit');
end

% ------------------------------------------------------------------------
% Rolling moment Due to Roll Damping

% Original data
ClpdataF18  = [-0.33  -0.31    -0.29     -0.23   -0.20   -0.13 ];   % Unit was 1/rad
adataF18    = [  5      10      20        30        40     50  ]*d2r;

% Artifical data
% Preserve the trend of negative slope as F16 shows. 
Clp0 = [-0.345]; 
adata0 = [0]*d2r; 

adata = [adata0 adataF18]; 
Clpdata = [Clp0 ClpdataF18]; 

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 alp;
Clp = c0 + c1*alp; 
Clp = pdatafit(Clp,alp,adata,Clpdata,W);
aoarange = linspace(-10,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Clp_0 =Clp.coeff(2,1); F18Aero.Clp_1 =Clp.coeff(1,1); 

% Plot poly fit with original curve
if ismember(2,plotson) 
    subplot(223)
    set(gca,'FontSize',20)
    plot(adataF18*r2d,ClpdataF18,'ob',adata0*r2d,Clp0,'ks', 'MarkerSize',10,'LineWidth',3)
    hold on
    plot(aoarange*r2d,double(subs(Clp,alp,aoarange)),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20);ylabel('C_{l_p}');
    grid on 
    legend('C_{l_p}','Artifical Data','Poly Fit');    
end


% -----------------------------------
% Rolling moment Due to Yaw Damping 

% Original F18 Data
% XXX F16 has the similar trend in low AoA
Clrdata  = [0.25  0.30  0.35  0.32   0.225   0    -0.15  ];   % Unit was 1/rad
adata    = [5     10     20    30     40    50      60   ]*d2r;

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 c2 alp;
Clr = c0 + c1*alp + c2*alp^2; 
Clr = pdatafit(Clr,alp,adata,Clrdata,W);
aoarange = linspace(-10,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Clr_0 =Clr.coeff(3,1); F18Aero.Clr_1 =Clr.coeff(2,1); 
F18Aero.Clr_2 =Clr.coeff(1,1);
 
% Plot poly fit with original curve
if ismember(2,plotson) 
    subplot(224) 
    set(gca,'FontSize',20)
    plot(adata*r2d,Clrdata,'ob',aoarange*r2d,double(subs(Clr,alp,aoarange)),'r-', 'MarkerSize',10,'LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{l_r}');
    grid on 
    legend('C_{l_r}','Poly Fit');
end


% ========================================================
% Yawing Moment Coefficient 
% ========================================================

% ------------------------------------------------------------------------
% Yawing Moment due to Sideslip : f(Aoa)

% Original F18 data
CnbdataF18  = [   0.0015   0.0013    0.001    0.0005     0     -0.0005   -0.0016   -0.0020   -0.0040]*r2d;  % Unit was 1/deg
adataF18   =  [     10      15        20        25      30       35        40         45     55]*d2r;

% Artifical Data
% Dr. Foster: Flatline if Data Does not Exist
% Also, F16 has a very flatline trend at low AoA for 0 degree beta
Cnb0   = [0.0015   0.0015 ]*r2d; 
adata0 = [  0       5  ]*d2r; 

Cnbdata = [Cnb0 CnbdataF18];  adata = [ adata0 adataF18]; 

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 c2 alp;
Cnb = c0 + c1*alp + c2*alp^2 ; 
Cnb = pdatafit(Cnb,alp,adata,Cnbdata,W);
aoarange = linspace(-10,60,Npts)*d2r; 
 
% Create the coefficients variable 
F18Aero.Cnb_0 =Cnb.coeff(3,1); F18Aero.Cnb_1 =Cnb.coeff(2,1); 
F18Aero.Cnb_2 =Cnb.coeff(1,1);

% Plot poly fit with original curve
if ismember(3,plotson)    
    figure;
    set(gca,'FontSize',20)
    plot(adataF18*r2d,CnbdataF18*d2r,'ob',adata0*r2d,Cnb0*d2r,'ks', 'MarkerSize',12,'LineWidth',3)
    hold on
    plot(aoarange*r2d,double(subs(Cnb,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20);ylabel('C_{n_\beta}');
    grid on 
    legend('C_{n_\beta}','Artifical Data','Poly Fit');
end

% ------------------------------------------------------------------------
% Yawing Moment Due to Rudder Effect

% Original F18 data
CndrdataF18 = [ -0.00135   -0.0012   -0.001    -0.00085   -0.00070    -0.00062     -0.00055   -0.00055   -0.00062   -0.00070  -0.00085]*r2d;  % Unit was 1/deg
adataF18    = [   5           10       15         20         25          30           35         40          45        50    60]*d2r;

% Artifical Data
% F16 trend shows that the value stays almost constant at low AoA and it
% also does not change sign. 
Cndr0   = [-0.00135  ]*r2d; 
adata0  = [    0     ]*d2r; 

Cndrdata = [Cndr0 CndrdataF18];  adata = [ adata0 adataF18]; 

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) ) = 10;
pvar c0 c1 c2 c3 c4 alp;
Cndr = c0 + c1*alp + c2*alp^2 + c3*alp^3 + c4*alp^4; 
Cndr = pdatafit(Cndr,alp,adata,Cndrdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cndr_0 = Cndr.coeff(5,1); F18Aero.Cndr_1 = Cndr.coeff(4,1); 
F18Aero.Cndr_2 = Cndr.coeff(3,1); F18Aero.Cndr_3 = Cndr.coeff(2,1); 
F18Aero.Cndr_4 = Cndr.coeff(1,1);

% Plot poly fit with original curve
if ismember(4,plotson)
    figure; 
    subplot(221)
    set(gca,'FontSize',20)
    plot(adataF18*r2d,CndrdataF18*d2r,'ob',adata0*r2d,Cndr0*d2r,'ks', 'MarkerSize',12,'LineWidth',3)
    hold on 
    plot(aoarange*r2d,double(subs(Cndr,alp,aoarange)*d2r),'r-','LineWidth',2);
   xlabel('\alpha (deg)','FontSize',20); ylabel('C_{n_{\delta_{rud}}}');
    grid on 
    legend('C_{n_{\delta_{rud}}}','Artifical Data','Poly Fit'); 
end

% ------------------------------------------------------------------------
% Yawing Moment Due to Aileron Effect

% XXX - below 10 degree alp ?  Need Another Reference 
% How to decide on artificial data? F-16 has different trend
% Ref 6 will be used to address the issue
%

CndadataF18  = [ 0.00020   -0.00008    -0.00022   -0.00018    -0.0006    0.0002 ]*r2d;  % Unit was 1/deg
adataF18     = [  10         20           30         40          50       60 ]*d2r;
% Artifical Data
Cnda0   = [ 0.00020   ]*r2d; 
adata0  = [  0   ]*d2r; 

Cndadata = [Cnda0 CndadataF18];  adata = [ adata0 adataF18];

Na = length(adata);
W = ones(Na,1);  W( (adata == 10) & (adata==0) ) = 40;
pvar c0 c1 c2 c3 alp;
Cnda = c0 + c1*alp + c2*alp^2 + c3*alp^3; 
Cnda = pdatafit(Cnda,alp,adata,Cndadata,W);
aoarange = linspace(0,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cnda_0 = Cnda.coeff(4,1); F18Aero.Cnda_1 = Cnda.coeff(3,1); 
F18Aero.Cnda_2 = Cnda.coeff(2,1); F18Aero.Cnda_3 = Cnda.coeff(1,1); 


% Plot poly fit with original curve
if ismember(4,plotson)
   subplot(222)
    set(gca,'FontSize',20) 
    plot(adata*r2d,Cndadata*d2r,'ob',aoarange*r2d,double(subs(Cnda,alp,aoarange)*d2r),'r-','LineWidth',3);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{n_{\delta_{ail}}}');
    grid on
    legend('C_{n_{\delta_{ail}}}','Poly Fit');  
end

% ------------------------------------------------------------------------
% Yawing moment Due to Yaw Damping 

% Original F18 data
% XXX - Seems to capture the genral trend upto 0 deg AoA nicely. 
Cnrdata =  [-0.45     -0.47     -0.5     -0.55  ];   % Unit was 1/deg
adata   =  [  5        20       30        50 ]*d2r;

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 alp;
Cnr = c0 + c1*alp; 
Cnr = pdatafit(Cnr,alp,adata,Cnrdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cnr_0 = Cnr.coeff(2,1); F18Aero.Cnr_1 =Cnr.coeff(1,1); 

% Plot poly fit with original curve
if ismember(4,plotson)
        subplot(223)
    set(gca,'FontSize',20) 
    plot(adata*r2d,Cnrdata,'ob',aoarange*r2d,double(subs(Cnr,alp,aoarange)),'r-','LineWidth',3);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{n_r}');
    grid on 
    legend('C_{n_r}','Poly Fit');
end

% ------------------------------------------------------------------------
% yawing moment Due to Roll Damping

% original F18 Data: negligible contribution    
Cnpdata  =  [0.07  0.05  0.02  0];   % Unit was 1/deg
adata    =  [5     20     40  50 ]*d2r;

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 alp;
Cnp = c0 + c1*alp; 
Cnp = pdatafit(Cnp,alp,adata,Cnpdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cnp_0 = Cnp.coeff(2,1); F18Aero.Cnp_1 =Cnp.coeff(1,1); 


% Plot poly fit with original curve
if ismember(4,plotson) 
    subplot(224)
    set(gca,'FontSize',20) 
    plot(adata*r2d,Cnpdata,'ob',aoarange*r2d,double(subs(Cnp,alp,aoarange)),'r-','LineWidth',3);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{n_p}');
    grid on 
    legend('C_{n_p}','Poly Fit');
end




% ========================================================
% SideForce Coefficient 
% ========================================================

% ------------------------------------------------------------------------
% SideForce due to Sideslip : f(Aoa)

% Original F18 Data
% XXX - The fit is satisfactory as it does not extrpolate to positive value
% at 0 degree AoA. 
% XXX - F16 Data not available 
%
% Ref 7: Wang, Iliff
CybdataF18  = [-0.0125  -0.0130     -0.01125   -0.0105     -0.0112     -0.0130  -0.01     -0.012  ]*r2d ; % Unit was 1/deg
adataF18   =  [  5         10           20       25         30           40      50       60]*d2r; 

% CybdataF18  = [-0.0125      -0.01125      -0.0130   -0.01     -0.012  ]*r2d ; % Unit was 1/deg
% adataF18   =  [  3            20               40      50       60]*d2r; 


% Artifical Data
Cyb0   = [ -0.0125  ]*r2d; 
adata0  = [ 0   ]*d2r; 

Cybdata = [Cyb0 CybdataF18];  adata = [ adata0 adataF18];

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) ) = 1;
pvar c0 c1 c2 c3 c4 alp;
Cyb = c0 + c1*alp + c2*alp^2; %+ c3*alp^3  ; 
Cyb = pdatafit(Cyb,alp,adata,Cybdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
 F18Aero.Cyb_0 = Cyb.coeff(3,1); F18Aero.Cyb_1 =Cyb.coeff(2,1); 
 F18Aero.Cyb_2 = Cyb.coeff(1,1); % F18Aero.Cyb_3 =Cyb.coeff(1,1);

% Plot poly fit with original curve
if ismember(5,plotson) 
    figure;
    set(gca,'FontSize',20) 
    plot(adata*r2d,Cybdata*d2r,'ob', 'MarkerSize',10,'LineWidth',3)
    hold on 
    plot(aoarange*r2d,double(subs(Cyb,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{y_\beta}');
    grid on
    legend('C_{y_\beta}','Poly Fit');
end


% ------------------------------------------------------------------------
% SideForce Data due to Aileron ::  Ref : 4

% XXX - 11/19/09 :  Dr. Foster: "The Cyda values are very small (which is
% typical) so the scatter you are seeing won�t be significant. "


% XXX - 11/25 : Removing the 40^0 and 50^0 datapoint which provides the
% scatter and mess up fitting
CydadataF18     =  [  -0.003  -0.0007   0.00    0.005]*r2d ; % Unit was 1/deg
adataF18        =  [    10     25         30      60]*d2r;

% Artifical Data
Cyda0   = [ -0.003   ]*r2d; 
adata0  = [   5   ]*d2r; 

Cydadata = [Cyda0 CydadataF18];  adata = [ adata0 adataF18];

Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 c2 c3 alp;
Cyda = c0 + c1*alp + c2*alp^2 + c3*alp^3; 
Cyda = pdatafit(Cyda,alp,adata,Cydadata,W);
aoarange = linspace(-0,60,Npts)*d2r; 


% Create the coefficients variable 
 F18Aero.Cyda_0 = Cyda.coeff(4,1); F18Aero.Cyda_1 =Cyda.coeff(3,1); 
 F18Aero.Cyda_2 = Cyda.coeff(2,1);  F18Aero.Cyda_3 =Cyda.coeff(1,1);

% Plot poly fit with original curve
if ismember(6,plotson) 
    figure; 
    subplot(211)
    set(gca,'FontSize',20) 
    plot(adataF18*r2d,CydadataF18*d2r,'ob',adata0*r2d,Cyda0*d2r,'ks', 'MarkerSize',12,'LineWidth',3)
    hold on
    plot(aoarange*r2d,double(subs(Cyda,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{Y_{\delta_{ail}}}');
    grid on 
    legend('Coefficient','Artifical data','Poly Fit');
end

% ------------------------------------------------------------------------
% SideForce Data due to Rudder

% Original F18 data
CydrdataF18    =  [ 0.003753  0.004   0.0037   0.0032   0.0025  0.0017  -0.0005   -0.0010  -0.0025  -0.0025 ]*r2d ; % Unit was 1/deg
adataF18       =  [   5        10      15       20       25      30        40        45        55    60]*d2r; 

% Artifical Data
% Dr. Foster: Hold the value of 5^0 at 0 degree alp
Cydr0   = [  0.003753 ]*r2d; 
adata0  = [    0    ]*d2r; 

Cydrdata = [Cydr0 CydrdataF18];  adata = [ adata0 adataF18];
Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) ) = 3;
pvar c0 c1 c2 c3 alp;
Cydr = c0 + c1*alp + c2*alp^2 + c3*alp^3; 
Cydr = pdatafit(Cydr,alp,adata,Cydrdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cydr_0 = Cydr.coeff(4,1); F18Aero.Cydr_1 = Cydr.coeff(3,1); 
F18Aero.Cydr_2 = Cydr.coeff(2,1);  F18Aero.Cydr_3 =Cydr.coeff(1,1);

% Plot poly fit with original curve
if ismember(6,plotson) 
    subplot(212)
    set(gca,'FontSize',20)  
    plot(adataF18*r2d,CydrdataF18*d2r,'ob',adata0*r2d,Cydr0*d2r,'ks', 'MarkerSize',10,'LineWidth',3)
    hold on
    plot(aoarange*r2d,double(subs(Cydr,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{Y_{\delta_{rud}}}');
    grid on
    %legend('Cydr','Artifical data','Poly Fit');   
end



%-----------------------------------------------------------------
% Longitudinal Directional Aerodynamic Characteristics
% Ref (2)
% Ref (5) : Lift / Drag Basic Airframe
% Unless otherwise Noted
%-----------------------------------------------------------------



% ========================================================
% Pitching Moment Coefficient 
% ========================================================

%--------------------------------------
% Pitching Moment due to Alpha

% XXX 11/01/09 - Dr. Foster:  "doubts if Cma goes positive below 10 degree'' 
%             But the references does provide +ve value. 

% Ref (3):  Kenneth W. Iliff and Kon-sheng Charles Wang : Flight determined 
CmadataF18 =   [ -0.001   -0.00125     -0.0025  -0.00625   -0.011  ]*r2d ; % Unit was 1/deg ;
adataF18   =   [  10         15           30        40        50    ] *d2r;


% Artifical data
% XXX  11/01/09 - adding artifical data to ensure the value 
% remains negative upto 0 deg AoA.
% 
Cma0   = [-0.0004  ]*r2d; 
adata0 = [ 5 ]*d2r; 

Cmadata = [Cma0 CmadataF18];  adata = [ adata0 adataF18];

Na = length(adata);
W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 10;
pvar c0 c1 alp c2;
Cma = c0 + c1*alp + c2*alp^2; 
Cma = pdatafit(Cma,alp,adata,Cmadata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
F18Aero.Cma_0 = Cma.coeff(3,1); F18Aero.Cma_1 =Cma.coeff(2,1); 
F18Aero.Cma_2 = Cma.coeff(1,1);

% Plot poly fit with original curve
if ismember(7,plotson) 
    figure; 
    set(gca,'FontSize',20)
    plot(adataF18*r2d,CmadataF18*d2r,'ob',adata0*r2d,Cma0*d2r,'ks', 'MarkerSize',10,'LineWidth',3)
    hold on 
    plot(aoarange*r2d,double(subs(Cma,alp,aoarange)*d2r),'r-','LineWidth',2);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{m_\alpha}');   
    grid on
    legend('C_{m_\alpha}','Artifical Data','Poly Fit');
end


%--------------------------------------
% Pitching Moment Data due to Elevator Derivatives

% original F18 Data 
% Ref : 3
CmdsdataF18  =   [-0.016    -0.015  -0.016   -0.017   -0.015    -0.0125  -0.0115    -0.008   -0.01 ]*r2d ; % Unit was 1/deg ;
adataF18     =   [   10       15      20       25       30         35       40        45       50   ] *d2r;

% Artifical data
% F-16 trend is different 
Cmds0   = [-0.016  ]*r2d; 
adata0 =  [ 0 ]*d2r; 

Cmdsdata = [Cmds0 CmdsdataF18];  adata = [ adata0 adataF18];
Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 4;
pvar c0 c1 c2 alp;
Cmds = c0 + c1*alp + c2*alp^2 ; 
Cmds = pdatafit(Cmds,alp,adata,Cmdsdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 


% Create the coefficients variable 
  F18Aero.Cmds_0 = Cmds.coeff(3,1); F18Aero.Cmds_1 =Cmds.coeff(2,1); 
  F18Aero.Cmds_2 = Cmds.coeff(1,1); 

% Plot poly fit with original curve
if ismember(8,plotson) 
    figure;subplot(211)
    set(gca,'FontSize',20)  
    plot(adataF18*r2d,CmdsdataF18*d2r,'ob',adata0*r2d,Cmds0*d2r,'ks', 'MarkerSize',10,'LineWidth',3)
    hold on 
    plot(aoarange*r2d,double(subs(Cmds,alp,aoarange)*d2r),'r-','LineWidth',2);
     xlabel('\alpha (deg)','FontSize',20); ylabel('C_{m_{\delta_{stab}}}');
    legend('Coefficient','Artifical Data','Poly Fit');
    grid on
end

%--------------------------------------
% Pitching Moment Data due to Pitch Rate


% XXX 11/01/09 - Dr. Foster: Cmq is near zero at 4 deg AoA. 

% Ref (3):  Kenneth W. Iliff and Kon-sheng Charles Wang:  
CmqdataF18  =   [-4   -5  -8   -9.5   -2  6 ];
adataF18   =    [10   20  30   40     50   60] *d2r;

% Artifical data :  
% F16 has similar values at 0 / 5 deg AoA as in 10 degree AoA  
Cmq0   =  [-4  -4]; 
adata0 =  [0    5 ]*d2r; 

Cmqdata = [Cmq0 CmqdataF18];  adata = [ adata0 adataF18];


Na = length(adata);

W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 10;
pvar c0 c1 c2 c3 alp;
Cmq = c0 + c1*alp+ c2*alp^2 + c3*alp^3; 
Cmq = pdatafit(Cmq,alp,adata,Cmqdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 


% Create the coefficients variable 
 F18Aero.Cmq_0 = Cmq.coeff(4,1); F18Aero.Cmq_1 =Cmq.coeff(3,1); 
 F18Aero.Cmq_2 = Cmq.coeff(2,1); F18Aero.Cmq_3 =Cmq.coeff(1,1); 


% Plot poly fit with original curve
if ismember(8,plotson) 
    subplot(212)
    set(gca,'FontSize',20) 
    plot(adataF18*r2d,CmqdataF18,'ob',adata0*r2d,Cmq0,'ks', 'MarkerSize',10,'LineWidth',3)
    hold on 
    plot(aoarange*r2d,double(subs(Cmq,alp,aoarange)),'r-','LineWidth',3);
    xlabel('\alpha (deg)','FontSize',20); ylabel('C_{m_q}');
    %legend('Cmq','Artificial Data','Poly Fit');
    grid on
end


% ========================================================
% Lift / Drag Force Coefficient 
% ========================================================

%--------------------------------------
% Normal Force Data due to Elevator Deflections

% Ref (3): Flight Determined : 0.01 throughout
CNdedata  =  [0.01   0.01   0.01  0.01 ]*r2d;
adataF18  =    [  10    25     40   50      ] *d2r;

%--------------------------------------
% Axial Force Data due to Elevator Deflections

% Ref (4): 
CAdedata  =  [-0.00083  0.0042  0.0042   0.001]*r2d;
adataF18  =    [  10        25      40      50      ] *d2r;


%------------------ Rotate Coordinate and Form Lift / Drag Data

%--------------------------------------
% Lift Force Data due to Elevator Deflections
CLdsdataF18 = double(CNdedata.*cos(adataF18) - CAdedata.*sin(adataF18)) ; 
CLdsdata = [CLdsdataF18(1) CLdsdataF18];  adata = [ 0 adataF18]; 
Na = length(adata);
W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 100;

pvar c0 c1 c2 alp;
CLds = c0 + c1*alp+ c2*alp^2 + c3*alp^3; 
CLds = pdatafit(CLds,alp,adata,CLdsdata,W);
aoarange = linspace(-0,60,Npts)*d2r; 

% Create the coefficients variable 
 F18Aero.CLds_0 = CLds.coeff(4,1); F18Aero.CLds_1 =CLds.coeff(3,1); 
 F18Aero.CLds_2 = CLds.coeff(2,1);  F18Aero.CLds_3 =CLds.coeff(1,1);

% Plot poly fit with original curve
if ismember(9,plotson)
    figure; set(gca,'FontSize',20) 
    plot(adata*r2d,CLdsdata*d2r,'ob',aoarange*r2d,double(subs(CLds,alp,aoarange)*d2r),'r-', 'MarkerSize',10,'LineWidth',3);
     xlabel('\alpha (deg)','FontSize',20); ylabel('C_{L_{\delta_{stab}}}');
    grid on 
    legend('C_{L_{\delta_{stab}}}','Estimated Fit');
end



%--------------------------------------
% Drag Force Data due to Elevator Deflections
CddsdataF18 = double(CAdedata.*cos(adataF18) + CNdedata.*sin(adataF18)) ;
Cddsdata = [CddsdataF18(1) CddsdataF18];  adata = [ 0 adataF18]; 
W = ones(Na,1);  W( (adata <= 10) & (adata>=0) ) = 10;


pvar c0 c1 c2 c3 alp;
Cdds = c0 + c1*alp+ c2*alp^2 + c3*alp^3; 
Cdds = pdatafit(Cdds,alp,adata,Cddsdata,W);

% Create the coefficients variable 
 F18Aero.Cdds_0 = Cdds.coeff(4,1); F18Aero.Cdds_1 =Cdds.coeff(3,1); 
 F18Aero.Cdds_2 = Cdds.coeff(2,1);  F18Aero.Cdds_3 =Cdds.coeff(1,1);


% Plot poly fit with original curve
if ismember(10,plotson) 
    figure; set(gca,'FontSize',20) 
    plot(adata*r2d,Cddsdata*d2r,'ob',aoarange*r2d,double(subs(Cdds,alp,aoarange)*d2r),'r-', 'MarkerSize',10,'LineWidth',3);
    xlabel('\alpha (deg)','FontSize',20);  ylabel('C_{D_{\delta_{stab}}}')
    grid on 
    legend('C_{D_{\delta_{stab}}}','Estimated Fit');
end


%------------------------------------------------------------------------
% Save Data 

% save F18AeroData F18Aero
%      Clb_0  Clb_1 Clb_2 Clb_3 Clb_4 ...
%      Cldr_0  Cldr_1 Cldr_2 Cldr_3 ...
%      Clda_0 Clda_1 Clda_2 Clda_3 ...
%      Clp_0  Clp_1  Clr_0  Clr_1 Clr_2 ...
%      Cnb_0 Cnb_1 Cnb_2  ...
%      Cndr_0  Cndr_1 Cndr_2 Cndr_3 Cndr_4 ... 
%      Cnda_0 Cnda_1 Cnda_2 Cnda_3  Cnda_4...
%      Cnr_0  Cnr_1  Cnp_0  Cnp_1 ...
%      Cyb_0  Cyb_1  Cyb_2 Cyb_3 ...
%      Cyda_0  Cyda_1 Cyda_2 Cyda_3 ...
%      Cydr_0  Cydr_1 Cydr_2 Cydr_3...
%      Cma_0 Cma_1 Cma_2 ...
%      Cmds_0 Cmds_1 Cmds_2 Cmds_3 Cmds_4...
%      Cmq_0  Cmq_1 Cmq_2 Cmq_3 Cmq_4 ...
%      CLds_0  CLds_1 CLds_2 ...
%      Cdds_0  Cdds_1 Cdds_2


 return

 
