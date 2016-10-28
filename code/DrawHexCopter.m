hexDiam = 1;
sparDiam = 0.03;
figure(1); clf
[X,Y,Z] = cylinder(1,4);
s1=surf(sparDiam*X,sparDiam*Y,hexDiam*Z);
set(s1,'CData',ones(size(get(s1,'CData'))))
hold on
s2=surf(sparDiam*X,sparDiam*Y,hexDiam*Z);
s3=surf(sparDiam*X,sparDiam*Y,hexDiam*Z);



ax = axes;
s = hgtransform('Parent',ax);

 m = makehgtform('zrotate',pi/3);
 set(s,'Matrix',m)

axis equal

