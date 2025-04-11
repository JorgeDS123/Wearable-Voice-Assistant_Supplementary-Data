clc
clear all
close all

load muestras_gracias.mat

for i = 1: 120
    close all
    figure
    plot(muestras(i).v_tiempo,muestras(i).amplitud)
%Selecciona la mejor zancada
fprintf('Selecciona donde comienza y termina el evento\n');
fprintf('Porfavor selecciona solamente de izquierda a derecha\n');
p1=0;
P2=0;

[p1,p2]=ginput(2);
%Se identifica en que puntos inicia y termina la señal
inicio=p1(1);
fin=p1(2);
c = 1;
indicador=v(c,1);
inicia=1;
while indicador<inicio
    c = c+1;
    inicia=inicia+1;
    indicador=v(c,1);
end % end while inicio
termina=inicia;
indicador=v(c,1);
while indicador<fin
    c = c+1;
    indicador=v(k,1);
    termina=termina+1;
end % end while fin
% guarda y grafica la señal recortada
muestra(:,1) = muestras(i).v_tiempo(inicio:fin);
muestra(:,2) = muestras(i).amplitud(inicio:fin);
%% modificar dependiendo de la palabra
JJAL_trim_gracias(i).v_tiempo = muestra(:,1);
JJAL_trim_gracias(i).amplitud = muestra(:,2);
JJAL_trim_gracias(i).fs = muestras(i).fs;
%writematrix(JJAL_trim_gracias);
%%
figure
plot(muestra(:,1),muestra(:,2))
input('Presiona enter para continuar\n', 's');

muestra = [];
end % end for i

