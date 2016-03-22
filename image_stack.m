function [stack]=image_stack(folder)

% Creates an image stack from the specified directory

% Get current folder
currentfolder=cd;

% Navigate to folder containing images
cd(folder)

% Get file names
files=dir([folder 'w_*']);

% Check number of files to read
zdim=length(files)-2;

% Load first image
im0=imread(files(3).name);

% Converting to double precision
im0=double(im0)/2^16;

% Get dimensions of image
[xdim,ydim]=size(im0);

% Create preliminary stack
stack=zeros(xdim,ydim,zdim);

for i=1:zdim
    % Name of file
    name=sprintf('w_568_%03i.tiff',i-1);
    
    % Convert image to double and add to stack
    stack(:,:,i)=double(imread(name))/2^16;  
end

% Go back to initial folder 
cd(currentfolder);


    
    