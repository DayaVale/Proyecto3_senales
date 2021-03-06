clear all
structur = load('Muestras\PruebaECG_8','-mat');
%load('14149m','-mat')
Fs = structur.Fs;
val = structur.val;
L = length(val);
%plot(val)
T = L/Fs;        
%f_complete = (-L/2:L/2-1)*Fs/L;
t = linspace(0, T, L);
plot(t,val)
xlim([0,10])
grid on
title('\textbf{Original}', 'Interpreter', 'latex')
xlabel('\textbf{Tiempo}  \textit{[sec]}', 'Interpreter','latex')
ylabel('\textbf{Amplitud} \textit{[mV]} ', 'Interpreter','latex')

%%

[y_m,y_d] = pan_tompkins(Fs,val);
%plot(y_d)
[tI,tF,picostime_qrs,complejos_qrs,PEAKQRS,PEAKtime] = detector_QRS2(y_m,y_d,Fs);
detectorQRS(y_m,y_d,Fs)


plot(tF,y_d)
xlim([0,20])

% Verdader tiempos 


%%% Referencias
% https://en.wikipedia.org/wiki/Pan%E2%80%93Tompkins_algorithm


%%
 %------------------------ Grafica -------------------------
    
    k = 1;
    u = 1;
    
    subplot(2,1,1)
    h = animatedline;
    axis([0,21,0,1])
    
    while(k <= length(y_m))
        addpoints(h,tI(k),y_m(k));
        hold on
        if u <= length(PEAKtime)
            if tI(k) == PEAKtime(u)
                    plot(PEAKtime(u),PEAKQRS(u),'O')
                    u = u+1;
            end
        end    
        k = k+1;
        drawnow 
        pause(0.00000001)
    end     
    
    k = 1;
    u = 1;
    subplot(2,1,2);
    g = animatedline;
    axis([0,21,-1,1])
    
    while(k <= length(y_d))
        addpoints(g,tF(k),y_d(k));
        hold on
        if u <= length(picostime_qrs)
            if tF(k) == picostime_qrs(u)
               plot(picostime_qrs(u),complejos_qrs(u),'O')
               u = u+1;
            end
        end    
        k = k+1;
        drawnow 
        pause(0.000000001)
    end  

%%
parar = 0;
while (~parar)
   disp('e')
   if parar == 0
       parar = 1;
   end    
end    
    








