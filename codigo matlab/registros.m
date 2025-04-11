function registros(datos, folderName)
clc
repetir = 1;

while repetir == 1

% Elegir la palabra a registrar
validInput = false;
while ~validInput
    palabra = input('Registrar palabra\n1) Sí\n2) No\n3) Hola\n4) Gracias\n5) EB\n', 's'); % Leer como string
    palabra = str2double(palabra); % Convertir a número
    if isnan(palabra) || palabra < 1 || palabra > 6
        disp('Error: Las opciones son 1 - 5.');
    else
        validInput = true; % El input es válido
    end
end

switch palabra
    case 1
        palabra_si(datos, folderName);
    case 2
        palabra_no(datos, folderName);
    case 3
        palabra_hola(datos, folderName);
    case 4
        palabra_gracias(datos, folderName);
    case 5
        EB(datos, folderName);

end % end switch

% Repetir?
validInput = false;
while ~validInput
    opc = input('1) Repetir\n2) Regresar\n', 's'); % Leer como string
    opc = str2double(opc); % Convertir a número
    if isnan(opc) || opc < 1 || opc > 2
        disp('Error: Las opciones son 1 y 2.');
    else
        validInput = true; % El input es válido
    end
end
repetir = opc;
end % end repetir

end % end function