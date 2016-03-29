function image_stack(folder)

% Creates an image stack from the specified directory

% Get current folder
currentfolder=cd;

% Navigate to folder containing images
cd(folder)

% Get file names
files=dir([folder '/w*.tiff']);

% Check number of files to read
zdim=length(files);

% Load first image
im0=imread(files(1).name);

% Converting to double precision
im0=double(im0)/2^16;

% Get dimensions of image
[xdim,ydim]=size(im0);

% Get first wavelength
wavelengths{1}=files(1).name(3:5);

% Get all wavelengths used
for i=1:zdim
    if ~ismember(wavelengths,files(i).name(3:5))
        wavelengths{size(array,2)+1}=files(i).name(3:5);
    end
end

nwave=size(wavelengths,2);
filenum=-ones(zdim/nwave,nwave);

% Fill filenumber matrix
for i=1:zdim
    % Find position of dot
    dot=find(files(i).name=='.');
    
    % Convert char to number
    num=str2num(files(i).name(7:dot));
    
    % Associate numbers to wavelengths
    for ii=1:nwave
        if files(i).name(3:5)==wavelengths{ii}
            ind=find(filenum(:,ii)==-1,1);
            filenum(ind,ii)=num;
        end
    end
end

% Sort numbers associated to files
for i=1:size(filenum,2)
    filenum(:,i)=sort(filenum(:,1));
end

% Create preliminary stack
im_stack=zeros(xdim,ydim,zdim/nwave,nwave);

for i=1:nwave
    for ii=1:size(filenum,1)
        filename=sprintf('w_%s_%03i.tiff',wavelengths{i},filenum(ii,i));
        im_stack(:,:,ii,i)=double(imread(filename))/2^16;
    end
end

for i=1:nwave
    var=sprintf('im_stack_%s',wavelengths{i});
    assignin('base',var,im_stack(:,:,:,i));
end
    
% Go back to initial folder 
cd(currentfolder);


    
    