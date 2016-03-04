# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

NMEAfile = open('GPS.TXT');
GPSoutfile = open('GPS_parsed.txt','w');
for line in NMEAfile:
    NMEAstring = NMEAfile.readline();
    NMEAdata = NMEAstring.split(',');
    #date,time,lat NS,long EW\n
    GPSoutfile.write('{0:.0f},{1:.2f},{2:.4f} {3},{4:.4f} {5}\n'.
                        format(float(NMEAdata[9]),float(NMEAdata[1]),
                        float(NMEAdata[3]),NMEAdata[4],float(NMEAdata[5]),NMEAdata[6]));


