function [f,fourier]=fast_fourier(vec, fps, graph)
% Convert to double
vec=double(vec);

% Subtract constant value of signal
vec=vec-mean(vec);

% Length of vector
L=length(vec);

% Next power of 2 for faster computing
np2=2^nextpow2(L);

% FFT 
fourier=abs(fft(vec,np2)/np2);

% Frequency range
f = (0:(np2/2))*(fps/np2);

if graph==1 
    plot(f,fourier(1:length(fourier)/2+1));
end