function [im]=phantom()
% This function returns a software phantom made to test the functional imaging code

close all

% Time and FPS
time=9*60; %seconds
fps=5;  

% Size of images phantom
xdim=540;
ydim=640;
zdim=time*fps;

% Gray values of images
gray_back=100*2^16/2^12;
gray_cortex=2000*2^16/2^12;

% Meshes to create shapes later on
x=meshgrid(1:540,1:640);
y=meshgrid(1:640,1:540)';

% Modulation amplitude
amp=0.001;

% Creation of black cube
im=uint16(gray_back*ones(ydim,xdim,zdim));

% Temporal response pattern (1/60 Hz)
trp_freq=1/60;
t=0:1/fps:time;
sq=square(2*pi*trp_freq*t);
    
ga=(1-exp(-1/1.5)).^2*(t+1).*exp(-t/1.5);
fsq=fft(sq);
fga=fft(ga);
trp=ifft(fsq.*fga);
trp=amp*gray_cortex*trp;

% Heartbeat (55/min)
hb_freq=55/60;
hb=3*amp*gray_cortex*sin(2*pi*hb_freq*t);

% Respiration (12/min)
resp_freq=12/60;
resp=3*amp*gray_cortex*sin(2*pi*resp_freq*t);

% Decreasing trend
delta=-320;
trend=round(delta/t(end).*t);

% Addidion of signals and trends
tot=trp+hb+resp;

% Cortex area
cort_bool=(x-xdim/2).^2/(((xdim-40)/2)^2) + (y-ydim/2).^2/(((ydim-40)/2)^2) <= 1;

% Activation area
act_bool=(x-xdim/2).^2 + (y-ydim/2).^2 <= 50^2;
 
 
for i=1:zdim
slice=im(:,:,i);

% Exposed cortex
slice(cort_bool)=gray_cortex;

% Intensity modulation of activated area
slice(act_bool)=gray_cortex+tot(i);

% Shot noise
slice=imnoise(slice,'gaussian',0,(10/4096)^2);

im(:,:,i)=slice;
end



