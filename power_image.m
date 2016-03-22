function [p_im]=power_image(im_stack,freq)

tic
% Get size of image stack
[xdim, ydim, zdim]=size(im_stack);

% Create power image
p_im=zeros(xdim,ydim);

%parpool

% Loop on each pixel
parfor i=1:xdim
    for ii=1:ydim
        vec=squeeze(im_stack(i,ii,:));
        [f,fourier]=fast_fourier(vec,5,0);
        p_im(i,ii)=mean(abs(fourier(abs(f-freq)==min(abs(f-freq)))));
    end
end
toc