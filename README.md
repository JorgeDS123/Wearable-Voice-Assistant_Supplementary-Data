# Recuperación del Habla con Asistente de Voz Portátil - Archivos Suplementarios

En la carpeta "lectura" se encuentra el código .ino implementado en el ESP32 para adquirir las muestras durante las sesiones de registros.

Los archivos .m contenidos en la carpeta "codigo matlab" contienen las funciones del código elaborado para llevar a cabo sesiones de registros, capturando 120 muestras para cada clase, aplicando un procesamiento digital a las muestras mediante un filtro pasa bajas Chebyshev tipo 2 de orden 6, con una frecuencia de corte de 30 Hz y un ripple de atenuación de 80 dB. Para garantizar uniformidad en la duración de las muestras, "trim.m" fue utilizado para recortar las muestras en ventanas de 2 segundos. Las muestras con una gran cantidad de ruido o cuyo evento fuera mayor a 2 segundos fueron descartadas del conjunto de datos, reduciendo la cantidad total de muestras utilizadas de 2,400 a 1,521. 

La carpeta "spectro_4p_3p" contiene la librería que permite compilar y ejecutar en Arduino el modelo de clasificación entrenado en Edge Impulse. Asimismo, se incluye el código utilizado para llevar a cabo la implementación continua del modelo en el dispositivo ("conDFP") y dos códigos utilizados para llevar a cabo pruebas con el modelo ("prueba_Modelo" y "static_buffer"), sin implementar la reproducción auditiva de las palabras predichas.

El proyecto del modelo entrenado en Edge Impulse es público y puede ser accedido a través de la siguiente liga:
https://studio.edgeimpulse.com/public/657936/live
