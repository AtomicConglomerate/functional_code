function [cropped_stack]=crop_stack(im_stack)

% Crops a stack of images

% Crop first image of the stack and acquire rectangle
[im0 rect] = imcrop(im_stack(:,:,1));

% Initalise stack of cropped images
cropped_stack=zeros(size(im0,1),size(im0,2),size(im_stack,3));
cropped_stack(:,:,1)=im0;

% Iterate over stack
for i=2:size(im_stack,3)
    cropped_stack(:,:,i)=imcrop(im_stack(:,:,i),rect);
end

close(clf)