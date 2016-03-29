function [p_cube,f]=power_cube(im_stack,fps)


tic
% Get size of image stack
[xdim, ydim, zdim]=size(im_stack);

% Frequency vector
f = (0:(2^nextpow2(zdim))/2 - 1)*(fps/(2^nextpow2(zdim)));

% Create power cube and freq vector
p_cube=zeros(xdim,ydim,length(f));

%parpool

% Loop on each pixel
parfor i=1:xdim
    for ii=1:ydim
        vec=squeeze(im_stack(i,ii,:));
        [~,fourier]=fast_fourier(vec,fps,0); 
        p_cube(i,ii,:)=fourier(1:length(fourier)/2+1);
    end
end
toc