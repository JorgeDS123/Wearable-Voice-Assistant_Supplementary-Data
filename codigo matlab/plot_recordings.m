function plot_recordings(folderName, baseName)
    clc 
    %close all
    % folderName: Directory containing the .txt files
    % baseName: Prefix for the files (e.g., 'AEMV_gracias')

    % Get all matching .txt files in the folder
    filePattern = fullfile(folderName, sprintf('%s_*.txt', baseName));
    files = dir(filePattern);

    % Check if files exist
    if isempty(files)
        disp('No matching files found.');
        return;
    end

    % Create figure
    figure;
    hold on;
    title(sprintf('Señales de %s', baseName), 'Interpreter', 'none');
    xlabel('Tiempo (s)');
    ylabel('Amplitud');
    grid on;

    % Iterate through each file and plot the data
    % k=1:length(files)
    for k = 10:13
        filePath = fullfile(folderName, files(k).name);
        
        % Load the data
        data = readmatrix(filePath);

        % Extract time and amplitude
        t = data(:,1); % First column: time
        amp = data(:,2); % Second column: amplitude
        amp = amp/max(amp);
        % Plot the signal
        plot(t, amp, 'DisplayName', files(k).name);
    end

    % Add legend
    legend('show');
    hold off;
end
