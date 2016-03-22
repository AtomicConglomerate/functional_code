% clear all,close all,clc

pathdir = '/jumbo/brainidb_archive/live/Hemodynamics/Data/Columbia_all/Phantoms/';
path_phantom = fullfile('ph_1.mat');
load(path_phantom);

[xdim,ydim,zdim] = size(im);
time_course = (1:zdim)';

stack_demon_ph_cor = zeros(xdim,ydim,zdim); %create a new blank image

%------------------Power Spectrum Analysis Setup---------------------------
L = zdim; % sampled data length
fs = 5;   % sampling frequency
tw = 0:0.3:0.3*L-0.3;    % time window
n2p = nextpow2(L);
Lm = pow2(n2p);         % modified sample data length for speeding
df = fs/Lm; % frequency increment
fw = df*(0:Lm/2-1);             % frequency window
power = zeros(xdim,ydim,Lm/2);  % frequency matrix
P_sti = floor(1/60/df);         % stimulation frequency 1/60(0.016) Hz
% P_sti = ceil(1/60/df);        % test it with upper value and average
% P_sti = (floor(1/60/df)+ceil(1/60/df))/2;
P_vlf_r = 1:floor(0.01/df);     % very low frequency range
P_lf_r = 1:floor(0.1/df);         % low frequency range
P_n_r = 1:floor(1/df);            % noise frequency range

% P_im_svlf_470 = zeros(row,col);      %power image sti/vlf 470
% P_im_slf_470 = P_im_svlf_470;
% P_im_sn_470 = P_im_svlf_470;
% P_im_svlf_ph = zeros(row,col);      %power image sti/vlf ph
% P_im_slf_530 = P_im_svlf_530;
% P_im_sn_530 = P_im_svlf_530;
% P_im_svlf_625 = zeros(row,col);      %power image sti/vlf 625
% P_im_slf_625 = P_im_svlf_625;
% P_im_sn_625 = P_im_svlf_625;
%---------------------set up ends------------------------------------------





%----------------------------fitting start---------------------------------
tic;
parpool
parfor ii = 1:xdim
% for ii = 1:row
    for jj = 1:ydim
%-----------------------------470------------------------------------------
%         raw_pix_course_470 = stack_demon_470(ii,jj,:);
%         raw_pix_course_s_470 = squeeze(raw_pix_course_470); %rid of singleton dimensions
%         pix_fit_470 = fit(time_course,raw_pix_course_s_470,'poly3');
%         cor_pix_course_470 = raw_pix_course_s_470-pix_fit_470(time_course);
%         stack_demon_470_cor(ii,jj,:) = cor_pix_course_470;
%         
%         f_470 = fft(cor_pix_course_470,Lm);
%         p_470 = f_470.*conj(f_470)/Lm;
%         power_470(ii,jj,:) = p_470(1:Lm/2);
%-----------------------------470 ends-------------------------------------

%-----------------------------530------------------------------------------
        raw_pix_course_ph = im(ii,jj,:);
        raw_pix_course_s_ph = squeeze(raw_pix_course_ph); %rid of singleton dimensions
%         pix_fit_530 = fit(time_course,raw_pix_course_s_530,'poly3');
%         cor_pix_course_530 = raw_pix_course_s_530-pix_fit_530(time_course);
        stack_demon_ph_cor(ii,jj,:) = raw_pix_course_ph
        
        f_ph = fft(raw_pix_course_ph,Lm);
        p_ph = f_ph.*conj(f_ph)/Lm;
        power_ph(ii,jj,:) = p_ph(1:Lm/2);
%-----------------------------530 ends-------------------------------------

%-----------------------------625------------------------------------------
%         raw_pix_course_625 = stack_demon_625(ii,jj,:);
%         raw_pix_course_s_625 = squeeze(raw_pix_course_625); %rid of singleton dimensions
%         pix_fit_625 = fit(time_course,raw_pix_course_s_625,'poly3');
%         cor_pix_course_625 = raw_pix_course_s_625-pix_fit_625(time_course);
%         stack_demon_625_cor(ii,jj,:) = cor_pix_course_625;
%         
%         f_625 = fft(cor_pix_course_625,Lm);
%         p_625 = f_625.*conj(f_625)/Lm;
%         power_625(ii,jj,:) = p_625(1:Lm/2);
%-----------------------------625 ends-------------------------------------
    end
end
% 
% %-----------------------------fitting ends---------------------------------
% 
% %---------------------------power spectrum analysis start------------------
% 
% 
% %---------------------------power spectrum analysis ends-------------------
% 
% delete(gcp);
% t=toc/60;

% P_im_svlf_470 = power_470(:,:,P_sti)./sum(power_470(:,:,P_vlf_r),3);
% P_im_slf_470 = power_470(:,:,P_sti)./sum(power_470(:,:,P_lf_r),3);
% P_im_sn_470 = power_470(:,:,P_sti)./sum(power_470(:,:,P_n_r),3);
% 
% P_im_svlf_530 = power_530(:,:,P_sti)./sum(power_530(:,:,P_vlf_r),3);
% P_im_slf_530 = power_530(:,:,P_sti)./sum(power_530(:,:,P_lf_r),3);
% P_im_sn_530 = power_530(:,:,P_sti)./sum(power_530(:,:,P_n_r),3);
% 
% P_im_svlf_625 = power_625(:,:,P_sti)./sum(power_625(:,:,P_vlf_r),3);
% P_im_slf_625 = power_625(:,:,P_sti)./sum(power_625(:,:,P_lf_r),3);
% P_im_sn_625 = power_625(:,:,P_sti)./sum(power_625(:,:,P_n_r),3);

%-------------------multi stimulation frequency----------------------------
% P_im_svlf_470 = (power_470(:,:,P_sti)+power_470(:,:,P_sti+1))./sum(power_470(:,:,P_vlf_r),3);
% P_im_slf_470 = (power_470(:,:,P_sti)+power_470(:,:,P_sti+1))./sum(power_470(:,:,P_lf_r),3);
% P_im_sn_470 = (power_470(:,:,P_sti)+power_470(:,:,P_sti+1))./sum(power_470(:,:,P_n_r),3);

P_im_svlf_ph = (power_ph(:,:,P_sti)+power_ph(:,:,P_sti+1))./sum(power_ph(:,:,P_vlf_r),3);
P_im_slf_ph = (power_ph(:,:,P_sti)+power_ph(:,:,P_sti+1))./sum(power_ph(:,:,P_lf_r),3);
P_im_sn_ph = (power_ph(:,:,P_sti)+power_ph(:,:,P_sti+1))./sum(power_ph(:,:,P_n_r),3);

% P_im_svlf_625 = (power_625(:,:,P_sti)+power_625(:,:,P_sti+1))./sum(power_625(:,:,P_vlf_r),3);
% P_im_slf_625 = (power_625(:,:,P_sti)+power_625(:,:,P_sti+1))./sum(power_625(:,:,P_lf_r),3);
% P_im_sn_625 = (power_625(:,:,P_sti)+power_625(:,:,P_sti+1))./sum(power_625(:,:,P_n_r),3);
%-----------------------------end------------------------------------------

% path_470s = fullfile(pathdir,'wave_470','stack_demon_470_cor'); %save path for corrected stack
path_phs = fullfile(pathdir,'wave_ph','stack_demon_ph_cor');
% path_625s = fullfile(pathdir,'wave_625','stack_demon_625_cor');

% path_P_svlf_470 = fullfile(pathdir,'wave_470','P_im_svlf_470');
% path_P_slf_470 = fullfile(pathdir,'wave_470','P_im_slf_470');
% path_P_sn_470 = fullfile(pathdir,'wave_470','P_im_sn_470');
% path_power_470 = fullfile(pathdir,'wave_470','power_470');
path_P_svlf_ph = fullfile(pathdir,'wave_ph','P_im_svlf_ph');
path_P_slf_ph = fullfile(pathdir,'wave_ph','P_im_slf_ph');
path_P_sn_ph = fullfile(pathdir,'wave_ph','P_im_sn_ph');
path_power_ph = fullfile(pathdir,'wave_ph','power_ph');
% path_P_svlf_625 = fullfile(pathdir,'wave_625','P_im_svlf_625');
% path_P_slf_625 = fullfile(pathdir,'wave_625','P_im_slf_625');
% path_P_sn_625 = fullfile(pathdir,'wave_625','P_im_sn_625');
% path_power_625 = fullfile(pathdir,'wave_625','power_625');
% 
% save(path_470s,'stack_demon_470_cor');
mkdir(path_phs)
save(path_phs,'stack_demon_ph_cor','-v7.3');
% save(path_625s,'stack_demon_625_cor');
% 
% save(path_P_svlf_470,'P_im_svlf_470');
% save(path_P_slf_470,'P_im_slf_470');
% save(path_P_sn_470,'P_im_sn_470');
% save(path_power_470,'power_470');
save(path_P_svlf_ph,'P_im_svlf_ph');
save(path_P_slf_ph,'P_im_slf_ph');
save(path_P_sn_ph,'P_im_sn_ph');
save(path_power_ph,'power_ph','-v7.3');
% save(path_P_svlf_625,'P_im_svlf_625');
% save(path_P_slf_625,'P_im_slf_625');
% save(path_P_sn_625,'P_im_sn_625');
% save(path_power_625,'power_625');
% 

