function [killLat,killLon]=convertBugZapperToGPSv2
% http://www.gpsvisualizer.com/map?output_google works great with the data.
% http://aprs.gids.nl/nmea/#rmc
% http://aprs.gids.nl/nmea/#gga


% load files
%Voltage = load('Voltage.TXT');
%GPS = load('GPS_parsed.txt');
%fileID = fopen('Voltage.TXT');
%fileID = fopen('DATALOG.TXT');
                        %0.00,1,2.15,0,0.00,1,13:59:32
                             %1.89,0,1.91,0,1.97,0,1:1:6
fileID = fopen('DATALOG.TXT');voltageCell = textscan(fileID,'%f,%f,%f,%f,%f,%f,%f:%f:%f');
%voltage = cell2mat(voltageCell);
fclose(fileID);


fileID = fopen('GPSLOG_parsed.txt');%new: GPSLOG.txt
                        %030316,201002.00,2943.4070 N,9520.5025 W

                        %10135.00,2943.4068 N,9520.5108 W
gpsCell = textscan(fileID,'%f,%f N,%f W');
gps = cell2mat(gpsCell);
fclose(fileID);



[timeGps,gI]=sort(gps(:,1));
%change to same time
timeOffset =  min(timeGps);%10135;

%dateGps       = gps(gI,1);
timeGps       = timeGps-timeOffset;
lat           = gps(gI,2);
lon           = gps(gI,3);

mesh1       = voltageCell{1};
bugCount1   = voltageCell{2};
mesh2       = voltageCell{3};
bugCount2   = voltageCell{4};
mesh3       = voltageCell{5};
bugCount3   = voltageCell{6};
hh          = voltageCell{7};
mm          = voltageCell{8};
ss          = voltageCell{9};
timeInS     = 60*(60*hh+mm)+ss;%-3666;
timeInS = timeInS-min(timeInS);
%correction factor
%timeInS = timeInS*1.5;

% convert voltage data to events and times
kills2 = [diff(bugCount1)~=0;0];
% interpolate GPS readings for each kill event
killLon = interp1(timeGps(1:2:end),lon(1:2:end),timeInS(kills2>0));
killLat = interp1(timeGps(1:2:end),lat(1:2:end),timeInS(kills2>0));

% translate GPS logger data to degrees for plot
latdeg = gpsDataToDegrees(lat);
londeg = gpsDataToDegrees(lon);
killlatdeg = gpsDataToDegrees(killLat);
killlondeg = gpsDataToDegrees(killLon);

% plot timing
figure(1); clf
subplot(2,1,1)
plot(timeGps/60,'.')
ylabel('Time (min)')
xlabel('GPS data points')
subplot(2,1,2)
plot(timeInS(kills2>0)/60,'.')
ylabel('Time (min)')
xlabel('Voltage zap data points')

figure(2); clf
subplot(2,1,1)
plot(timeGps,lat)
%legend('mesh 1','mesh 2','mesh 3')
xlabel('Time (s)')
ylabel('latitude (Deg)')
subplot(2,1,2)
plot(timeGps,lon)
%legend('mesh 1','mesh 2','mesh 3')
xlabel('Time (s)')
ylabel('longitude (Deg)')

figure(3); clf
plot(londeg,latdeg,'.',killlondeg,killlatdeg,'*r')
axis equal
ax=gca;
set(ax, 'xdir','reverse')
%legend('mesh 1','mesh 2','mesh 3')
xlabel('Longitude (^o W)')
ylabel('Latitude (^o N)')

%save data to file:
% $GPRMC,010134.000,A,2943.4065,N,09520.5108,W,0.20,337.08,290316
fileID = fopen('GPSkillData.txt','w');
ph = int16(timeInS/60/60);
pm = int16(timeInS/60 - double(ph)*60);
ps = int16(timeInS - double(ph)*60*60-double(pm)*60);


fprintf(fileID,'latitude,longitude\n')
for i = 1:numel(killlondeg)
    fprintf(fileID,'%f,%f\n',killLat(i),-1*killLon(i));
    %fprintf(fileID,'$GPRMC,%02d%02d%02d,A,%f,N,%f,W,0.20,337.08,290316\n',ph(i),pm(i),ps(i),killlondeg(i),killlatdeg(i));
end
fclose(fileID);


function [gpsDegrees] = gpsDataToDegrees(gpsData)
    degrees = floor(gpsData/100);
    minutes = floor(gpsData-degrees*100);
    seconds = rem(gpsData,1)*100;
    gpsDegrees = degrees + minutes./60 + seconds./3600;
