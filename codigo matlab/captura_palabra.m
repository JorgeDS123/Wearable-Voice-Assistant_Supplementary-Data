function [amplitud, ti, fs] = captura_palabra(s, tf, i)
    clc    
    disp('********************************');
    fprintf('   INICIA CAPTURA  %d \n', i);
    disp('********************************');
    tic;
    t = 0;
    c = 1;
    amplitud = []; % Initialize empty array

    while t <= tf
        if s.NumBytesAvailable > 0  % Read only if data is available
            data = readline(s); % Read a line from ESP32
            value = str2double(data); % Convert to number

            if ~isnan(value)
                % Convert ESP32's 12-bit ADC value (0-4095) to voltage (0-3.3V)
                amplitud(c) = (value / 4095) * 3.3;
                c = c + 1;
            end
        end
        t = toc;
    end

    % Calculate sampling frequency
    fs = floor(length(amplitud) / tf);

    % Adjust the number of samples in case more were acquired
    amplitud = amplitud(1:fs * tf);
    ti = (1/fs : 1/fs : tf);
end
