function [demon_stack]=demon_stack(stack,N)

% Runs Demon's registration algorithm on the images contained in a
% directory and returns an image stack of the registered images. 

demon_stack=zeros(size(stack));

parfor i=1:size(stack,3);
    [~,demon_stack(:,:,i)]=imregdemons(stack(:,:,i),stack(:,:,1),N);
end
[~,demon_stack(:,:,i)]=imregdemons(stack(:,:,i),stack(:,:,1),N);    