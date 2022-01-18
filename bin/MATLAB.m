% ATM G2
% > MOHAMED LOUNNAS
% > IKRAM MAMECHE
% > DRAI SELMA

% Exo 1
x = 0:pi/12:2*pi
y1=3*cos(x)
y2=-3*cos(x)
plot(x,y1)
grid
hold on
plot(x,y2)
figure
y=exp(3*sin(x))
plot(x,y)
 
% Exo 1
x = 0:pi/12:2*pi
hold on
y1=cos(x)
y2=cos(x-0.5)
y3=cos(x-1)
plot(x,y1,"r",x,y2,"b",x,y3,"k")

% Exo 3
x = 0:pi/10:2*pi
y1=sin(x)
y2=cos(x)
subplot(1,2,1)
plot(x,y1)
subplot(1,2,2)
plot(x,y2)

% Exo 4
t = 0:pi/20:20*pi
x=cos(t)
y =sin(t)
z =t^2
plot3(x,y,z)

