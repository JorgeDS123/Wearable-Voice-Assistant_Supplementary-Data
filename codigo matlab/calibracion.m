function calibracion
clc
% Ask user for recording time
validInput = false;
while ~validInput
    opc = input('1) Calibrar\n2) Regresar\n', 's'); % Leer como string
    opc = str2double(opc); % Convertir a número
    if isnan(opc) || opc < 1 || opc > 2
        disp('Error: Las opciones son 1 y 2.');
    else
        validInput = true; % El input es válido
    end
end



while opc == 1
%tf = input('¿Cuánto tiempo deseas registrar (s)? ', 's');
%tf = str2double(tf);
% Ask for the correct COM port
%com = input('Introduce el nombre del puerto (ej. COM3, /dev/ttyUSB0): ', 's');
com = 'COM4';

%disp('Conectando con ESP32...');
baudrate = 115200; % Match the baud rate in Arduino IDE
s = serialport(com, baudrate);

flush(s); % Clear serial buffer
% Calibración de 5 segundos
tf = 5;

% Adquirir señal
[amplitud1, ti1, fs1] = captura(s, tf);

% Plot the signal
plot(ti1, amplitud1);
title('Señal Cruda');
xlabel('Tiempo (s)');
ylabel('Voltaje (V)');


% filtro pasa bajas 30hz
fc = [30]; % frecuencia de corte 
N = 6; % orden del filtro
Rs = 80; % ripple (atenuación) en dB en la banda de rechazo
Wn = 2 * fc / fs1;
[b, a] = cheby2(N, Rs, Wn, 'low');
% Aplicar filtro IIR a la señal con ruido
yIIR1 = filter(b, a, amplitud1);

figure
plot(ti1,yIIR1)
title('señal filtrada')
xlabel('Tiempo (s)');
ylabel('Voltaje (V)');

% Close serial connection
clear s;
% Mostrar espectro frecuencial
% Cantidad total de muestras
%{
N = length(ti1);
f = fs1 * (0:(N/2)) / N;  

figure
x = yIIR1;
% Calcular la fft
X = fft(x);
% Magnitud normalizada para mostrar solo las frecuencias positivas
M = (2/N) * abs(X(1:N/2));
% Graficar espectro de frecuencias del canal
plot(f(2:end),M(:))
%xlim([0 50])
title('Espectro frecuencial de la señal')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud')
xlim([0 65])
%}

% Repetir?
validInput = false;
while ~validInput
    opc = input('1) Calibrar\n2) Regresar\n', 's'); % Leer como string
    opc = str2double(opc); % Convertir a número
    if isnan(opc) || opc < 1 || opc > 2
        disp('Error: Las opciones son 1 y 2.');
    else
        validInput = true; % El input es válido
    end
end
clc
close all
end


end