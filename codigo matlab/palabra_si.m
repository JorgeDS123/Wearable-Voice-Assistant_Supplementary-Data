function palabra_si(datos, folderName)

% -----Preparación del microcontrolador

% Duración de cada muestra
tf = 3;


% -----Definir muestra inicial, en caso de que se haya suspendido la sesión
n_muestra = input('Muestra inicial? ', 's');
n_muestra = str2double(n_muestra);
m_final = 120;

iniciar = input('Presiona enter para iniciar\n','s');
for i=n_muestra:m_final
% Definir puerto
com = 'COM4';

%disp('Conectando con ESP32...');
baudrate = 115200; % Match the baud rate in Arduino IDE
s = serialport(com, baudrate);

flush(s); % Clear serial buffer
    
    % Adquirir señal

[amplitud1, ti1, fs1] = captura_palabra(s, tf, i);


% filtro pasa bajas 30hz
fc = [30]; % frecuencia de corte 
N = 6; % orden del filtro
Rs = 80; % ripple (atenuación) en dB en la banda de rechazo
Wn = 2 * fc / fs1;
[b, a] = cheby2(N, Rs, Wn, 'low');
% Aplicar filtro IIR a la señal con ruido
yIIR1 = filter(b, a, amplitud1);

% Guardar muestra
muestras(i).v_tiempo = ti1;
muestras(i).amplitud = yIIR1;
muestras(i).fs = fs1;

% Close serial connection
clear s;
end % end for

% Guardar estructura con muestras y sus fss
f_name = 'muestras_si.mat';
save (fullfile(folderName, f_name), "muestras");
% Guardar registros en archivos txt
Prefijo = datos.iniciales;
for i = n_muestra:m_final
    % Create full file path for the text file
    muestra_name = sprintf('%s_si_%d.txt', Prefijo, i);
    filePath = fullfile(folderName, muestra_name);

    % Prepare data for writing
    muestra(:,1) = muestras(i).v_tiempo;
    muestra(:,2) = muestras(i).amplitud; % Fix: Column 2 for amplitud

    % Write to file in the same folder as 'muestras.mat'
    writematrix(muestra, filePath);
    % Limpiar dimensiones de la matriz para guardar la muestra
    muestra = [];
end % end guardar registros

disp('Terminó el registro');

end % end function