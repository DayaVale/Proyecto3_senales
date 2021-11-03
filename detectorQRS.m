function detectorQRS(senal_I,senal_F,fs)
    % Datos de la señal integrada
    LI = length(senal_I);
    TI = LI/fs;        
    tI = linspace(0, TI, LI);
    
    %Datos de la señal filtrada (Derivada)
    LF = length(senal_F);
    TF = LF/fs;        
    tF = linspace(0, TF, LF);

    SPKI_list = [];
    %SPKF = [];
    NPKI_list = [];
    %NPKF = [];
    picos_qrs = []; %Arreglo que almacena los tiempos de los complejos QRS
    complejos_qrs = [];
    indp = 1; %Inicialización
    picos_noise = []; %Arreglo que almacena los tiempos de el ruido
    indn = 1; %Inicialización
    THRESHOLDI1_list = [];
    %THRESHOLDI2 = [];
    %THRESHOLDF1 = [];
    
    [PEAKSI, IDEXTI] = findpeaks(senal_I,'MinPeakDistance',round(0.2*fs));
    %[PEAKSF, IDEXTF] = findpeaks(senal_F);
    
    RR_AVERANGE1 = [];
    RR_AVERANGE2 = [];
    RR_LOW_LIMIT = [];
    RR_HIGH_LIMIT = [];
    RR_MISSED_LIMIT =[];
    
    %-------------------------- Primera Fase ------------------------------
    % Estrategia I se realiza sobre la señal integrada
    % Inicialización Estrategia I
    %Fase de inicialización en 2 segundos de la señal
    SPKI = max(senal_I(1:2*fs))/3; %Maximo de las amplitudes de los picos de la señal Integrada en los primeros dos segundos.
    NPKI = mean(senal_I(1:2*fs))/2; %Media de las amplitudes de los picos de la señal Integrada en los primeros dos segundos.
    THRESHOLDI1 = NPKI + (0.25)*(SPKI-NPKI);
    
    L1 = length(PEAKSI);
    
    for i = 1:L1
        PEAKI = PEAKSI(i);
        if PEAKI > THRESHOLDI1
            ind = IDEXTI(i);
            picos_qrs(indp) = tI(ind);
            complejos_qrs(indp)= PEAKI; 
            SPKI = (0.125)*PEAKI + (0.875)*SPKI;
            SPKI_list(indp)= SPKI;
            indp = indp + 1;
        else
            ind = IDEXTI(i);
            picos_noise(indn) = tI(ind);
            NPKI = (0.125)*PEAKI + (0.875)*NPKI;
            NPKI_list(indn)= NPKI;
            indn = indn + 1;
        end
        THRESHOLDI1 = NPKI + (0.25)*(SPKI-NPKI);
        THRESHOLDI1_list(i)= THRESHOLDI1;
        
    end
    
    
    %------ Graficar la primera parte -----------------------------------
    
    plot(tI,senal_I)
    hold on
    plot(picos_qrs,complejos_qrs,'*')
    plot(picos_qrs,SPKI_list,'o')
    plot(picos_noise,NPKI_list,'-*')
    plot(tI(IDEXTI),THRESHOLDI1_list,'x')
    hold off
    
    % Estrategia II sobre la señal filtrada(derivada)
    % Inicialización Estrategia II
    SPKF = max(senal_F(1:2*fs))/3; %Maximo de las amplitudes de los picos de la señal Filtrados en los primeros dos segundos.
    NPKF = mean(senal_F(1:2*fs))/2; %Media de las amplitudes de los picos de la señal Filtrados en los primeros dos segundos.
    THRESHOLDF1 = NPKF + (0.25)*(SPKF-NPKF);

end