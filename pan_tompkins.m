function [y_m, y_d] = pan_tompkins(Fs,val)
    % Primer paso Filtrado
    % Filto paso bajo corte en 11 Hz
    Wn1 = 12/(Fs/2);
    n = 2; % Segundo orden
    [b,a] = butter(n,Wn1,"low");
    y = filter(b,a,val);
    y = y./max(abs(y));

    % Filtro pasa altos corte en 5 Hz
    n2 = 1; % Primer orden
    Wn2 = 5/(Fs/2); 
    [b,a] = butter(n2,Wn2,"High");
    y1 = filter(b,a,y);
    y1 = y1./max(abs(y1));
  
    % Derivación  H(z) = (1/8*T)(-z^{-2}-2z^{1}+2z^{1}+z^{2})
    int_c = 4/(Fs*1/40);
    b1 = interp1(1:5,[1 2 0 -2 -1].*(1/8)*Fs,1:int_c:5);
    y_d = filter(b1,1,y1);
    y_d = y_d./max(abs(y_d));
    
    %Square 
    y_s = y_d.^2;
    y_s = y_s./max(abs(y_s));

    % Integración 
    m = round(0.150*Fs);
    y_m = conv(y_s ,ones(1 ,m)/m);
    y_m = y_m./max(abs(y_m));
end