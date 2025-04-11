clc
clear all
close all

% Adquirir datos del participante
datos.name = input('Nombre completo: ', 's');
datos.edad = input('Edad: ', 's'); 
datos.iniciales = input('Iniciales: ', 's');
mkdir(datos.iniciales);
folderName = uigetdir ("F: \");
fileName = "datos.mat";
save (fullfile(folderName, fileName), "datos");

% Menú
repetir = 1;

while repetir == 1

% Solicitar al usuario que eliga el experimento a realizar
validInput = false;
while ~validInput
    op = input('Menú:\n1) Calibración\n2) Registar señal\n3) Finalizar sesión\n', 's'); % Leer como string
    op = str2double(op); % Convertir a número
    if isnan(op) || op < 1 || op > 3
        disp('Error: Las opciones son 1 - 3.');
    else
        validInput = true; % El input es válido
    end
end

switch op
    case 1
        % Ejecutar experimento con red neural simulada
        calibracion;
    case 2
        % Ejecutar experimento con registro de señal EEG
        registros(datos, folderName);
    case 3
        % Finalizar sesión
        repetir = 2;
end

end

%Guardar registro
%writematrix(M)
%type 'M.txt'