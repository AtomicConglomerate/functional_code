function write_gif(im_stack, start, nframes, filename)

% Creates a nframes gif starting from a specific frame

if start+nframes > size(im_stack,3)
    fprintf('Start + nframes greater than length of recording, gif will be shortened\n');
    nframes=size(im_stack,3)-start;
end

imwrite(255*im_stack(:,:,start),filename,'gif', 'Loopcount',inf);

for i=1:nframes
    imwrite(255*im_stack(:,:,start+i),filename,'gif','WriteMode','append','DelayTime',0);
end

