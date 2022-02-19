function sys = s4_opt_lya_bar(sys)
pvar x1 x2 u htol epsi;
x = [x1;x2];
%%
% dom = 15;
% V = 0.27761530973907616592910585495702*x1 + 0.28916923872954758412134879108635*x2 - 0.097197146692290778413614305009105*x1^2*x2^2 + 0.16409346533219781871792974925484*x1*x2 - 0.0067107957184185072774251779037513*x1*x2^2 + 0.0039474994197178196742026301535589*x1^2*x2 - 0.014031494938999576269078595203155*x1*x2^3 - 0.00061930885322093666596476868591026*x1^3*x2 + 0.23174538663646407354868017591798*x1^2 - 0.0040444947534192298224664519068483*x1^3 + 0.24289451203744766294434498377086*x2^2 + 0.056072867694129807647485108645924*x1^4 - 0.0014805460738564312894033347944855*x2^3 + 0.066405746174927976488433500890096*x2^4 + 9.4479264108289715551336485077627;
% C0 = 16.18343934060665;
% f = [x2-x1
%     -0.39306944559376340297962570957679*x1^4+0.30314332186361650500749931325117*x1^3+x1^2*x2+0.46065476097217313011800143840446*x1^2-0.45469239127041680137431001185178*x1+0.049252630679030955096475707932768*x2^4+0.045789722029436145944725211620607*x2^3-0.063117281796006285965461302112089*x2^2+0.009401592216201428570121478855981*x2+0.0023141262623443403789735839382047
%     ];
% gg = [1;1];
% C1 = (x1+4)^2+(x2-5)^2-4;
% C2 = (x1+0)^2+(x2+5)^2-4;
% C3 = (x1-5)^2+(x2-0)^2-4;
% C = [C1;C2;C3];
k = ['r','g','b','m','c','k','y'];
% B_1 = 205.39988836883230760577134788036*x1^2*x2^2 - 15.733076483919825605539699608926*x2 - 32.343368076002114719358360162005*x1 - 16.702690567188692938316307845525*x1*x2 + 58.06348388736881105387510615401*x1*x2^2 - 0.88882356086419722629443640471436*x1^2*x2 + 27.919011189967342545514839002863*x1*x2^3 + 2.3432143317831926054850555374287*x1^3*x2 - 16.00443066513419054786027118098*x1^2 - 4.0245318441951161148040227999445*x1^3 + 21.787467874077073304306395584717*x2^2 - 119.2190088341546641004242701456*x1^4 + 0.47139802020367055357397134685016*x2^3 - 139.72095091473158845474245026708*x2^4 + 10005.142017583266351721249520779;
%%
dom = sys.dom; domain = sys.domain;
f = s2p(sys.f);
gg = sys.gg;
V = sys.V_opt;
C0 = sys.cv_opt;
C = sys.us_region;
B_1 = sys.perm_b;
%%
sol_B = C0 - V; solh = sol_B;
k_u = 4; k_h = 4; L_us = 4; gamma = 0; L_au = 6; % L_au = 2; % L_au = 4;
trace_Q1 = 1; trace_Q = 0; mm = 0; kk = 1; i = 0;
TRACE = []; Barrier = []; Control = [];
figure_id = 12;
%%
% figure_id = 12; figure(figure_id);clf;hold on;
% domain = [-dom dom -dom dom]; xlim([-dom dom]); ylim([-dom dom]); hold on;
% [~,~]=pcontour(V,C0,domain,'b'); hold on;
% [~,~]=pcontour(C1,0,domain,'k'); hold on;
% [~,~]=pcontour(C2,0,domain,'k'); hold on;
% if length(C) == 3
%     [~,~]=pcontour(C(3),0,domain,'r');
% end
% [~,h31]=pcontour(B_1,0,domain,'m'); hold on; h31.LineStyle = '-'; h31.LineWidth = 1.4; axis(domain);
%%
for j = 1:148
    % while 1
    i = i+1
    record_Q = trace_Q
    %%
    [SOLu1,SOLu2,SOL1,SOL2,kk] = sos_function_b1(f,k_u,L_au,solh,V,gamma,gg);
    if kk == 0
        break
    end
    Control = [Control; [SOLu1 SOLu2]];
    %%
    [solh,trace_Q,kk] = sos_function_b2(i,f,k_h,SOLu1,SOLu2,SOL1,SOL2,gamma,V,C,dom,gg,L_us);
    if kk == 0
        break
    end
    figure(figure_id+1);clf;hold on;
    [~,h31]=pcontour(B_1,0,domain,'m'); hold on; h31.LineStyle = '-'; h31.LineWidth = 1.4;
    [~,~]=pcontour(V,C0,domain,'r'); hold on;
    %     [~,~]=pcontour(C1,0,domain,'k'); hold on;
    %     [~,~]=pcontour(C2,0,domain,'k'); hold on;
    %     [~,~]=pcontour(C3,0,domain,'k');
    if mod(i,7) == 0
        [~,~]=pcontour(solh,0,domain,k(7)); hold on;
    else
        [~,~]=pcontour(solh,0,domain,k(mod(i,7))); hold on;
    end
    refreshdata; drawnow;
    TRACE = [TRACE; double(trace_Q)];
    Barrier = [Barrier; solh];
end
fprintf('Optimal B(x) is \n%s \n\n',char(vpa(p2s(Barrier(147)))));
