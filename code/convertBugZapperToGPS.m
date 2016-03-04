function convertBugZapperToGPS
% http://www.gpsvisualizer.com/map?output_google works great with the data.
% http://aprs.gids.nl/nmea/#rmc
% http://aprs.gids.nl/nmea/#gga


% load files
%Voltage = load('Voltage.TXT');
%GPS = load('GPS_parsed.txt');
fileID = fopen('Voltage.TXT');
                        %0.00,1,2.15,0,0.00,1,13:59:32
voltageCell = textscan(fileID,'%f,%f,%f,%f,%f,%f,%f:%f:%f');
voltage = cell2mat(voltageCell);
fclose(fileID);


fileID = fopen('GPS_parsed.txt');
                        %030316,201002.00,2943.4070 N,9520.5025 W
gpsCell = textscan(fileID,'%f,%f,%f N,%f W');
gps = cell2mat(gpsCell);
fclose(fileID);
%change to same time
timeOffset = 149648;


[timeGps,gI]=sort(gps(:,2));

dateGps       = gps(gI,1);
timeGps       = timeGps-timeOffset;
lat           = gps(gI,3);
lon           = gps(gI,4);
[x,y,utmzone] = deg2utm(lat,lon) ;

mesh1       = voltage(:,1);
bugCount1   = voltage(:,2);
mesh2       = voltage(:,3);
bugCount2   = voltage(:,4);
mesh3       = voltage(:,5);
bugCount3   = voltage(:,6);
hh          = voltage(:,7);
mm          = voltage(:,8);
ss          = voltage(:,9);
timeInS     = 60*(60*hh+mm)+ss;

% convert voltage data to events and times
kills2 = [diff(bugCount2);0];
% interpolate GPS readings for each event
killx = interp1(timeGps(1:2:end),x(1:2:end),timeInS(kills2>0));
killy = interp1(timeGps(1:2:end),y(1:2:end),timeInS(kills2>0));

% plot path
figure(1); clf
plot(timeInS,mesh2)
legend('mesh 1','mesh 2','mesh 3')
xlabel('Time (s)')
ylabel('Probe Voltage (V)')

figure(2); clf
plot(timeGps-149648,lat)
%legend('mesh 1','mesh 2','mesh 3')
xlabel('Time (s)')
ylabel('Proble Voltage (V)')

figure(3); clf
plot(x,y,'-',killx,killy,'*r')
axis equal
%legend('mesh 1','mesh 2','mesh 3')
xlabel('east-west UTM (m)')
ylabel('north-south UTM (m)')

%plot events