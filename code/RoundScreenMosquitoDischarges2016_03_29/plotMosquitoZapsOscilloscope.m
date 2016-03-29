function plotMosquitoZapsOscilloscope
figure(1)
clf
loadAndPlotFile('scope_3.csv', 'scope_52.csv','b');
loadAndPlotFile('scope_6.csv', 'scope_55.csv','r');
loadAndPlotFile('scope_7.csv', 'scope_56.csv','m');
loadAndPlotFile('scope_9.csv', 'scope_58.csv','c');
loadAndPlotFile('scope_15.csv', 'scope_64.csv','k');
    function dataArray = loadOscopeFile(filename)
        startRow = 3;
    endRow = inf;
    delimiter = ',';
        formatSpec = '%f%f%f%[^\n\r]';
        % Open the text file.
        fileID = fopen(filename,'r');
        
        % Read columns of data according to format string.
        % This call is based on the structure of the file used to generate this
        % code. If an error occurs for a different file, try regenerating the code
        % from the Import Tool.
        dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
        for block=2:length(startRow)
            frewind(fileID);
            dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
            for col=1:length(dataArray)
                dataArray{col} = [dataArray{col};dataArrayBlock{col}];
            end
        end
        
        % Close the text file.
        fclose(fileID);
    end

    function loadAndPlotFile(fnCurr, fvVolt,c)
        
        dataArray = loadOscopeFile(['BatteryCurrentScreenVoltage/',fnCurr]);
        secondC = dataArray{:, 1};
        screenVoltage = dataArray{:, 2}*1000;
        batCurrent = dataArray{:, 3}/0.208; %I = V/R, R = 0.208 Ohm
        
        dataArray = loadOscopeFile(['BatteryVoltageScreenVoltage/',fvVolt]);
        secondV = dataArray{:, 1};
        screenVoltage2 = dataArray{:, 2}*1000;
        batVoltage = dataArray{:, 3}; 
        ts = -.1;
        te = 0.6;
        
        % load data sets
        smfac = 15; %smoothing factor
        figure(1)
        subplot(4,1,1) %battery current
        hold on
        plot(secondC,smooth(batCurrent,smfac),c)
        hold off
        %xlabel('Time (s)')
        ylabel('Battery Current (A)')
        axis([ts,te,0.31,0.46])
        subplot(4,1,2) %battery voltage
        hold on
        plot(secondV,smooth(batVoltage,smfac),c)
        hold off
        %xlabel('Time (s)')
        ylabel('Battery Voltage (V)')
        axis([ts,te,2.37,2.53])
        subplot(4,1,3) %screen voltage
        hold on
        plot(secondC,screenVoltage,c)
        hold off
        %xlabel('Time (s)')
        ylabel('Screen Voltage (V)')
        axis([ts,te,1090,2000])
        subplot(4,1,4) %power
        hold on
        plot(secondC,smooth(batVoltage.*batCurrent,smfac),c)
        hold off
        xlabel('Time (s)')
        ylabel('Circuit power (J)')
        axis([ts,te,0.5,1.127])
        
        figure(2)
        hold on
        plot(secondC,cumsum(smooth(batVoltage.*batCurrent,smfac)),c)
        xlabel('Time (s)')
        ylabel('Circuit energy (W)')
        hold off
    end

end