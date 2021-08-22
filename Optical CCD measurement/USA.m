% Test the performance of DFPR based algorithm recovering optical CCD measurements
clear
clc
close all
addpath(genpath('..'))
addpath('~/matconvnet/matlab');
addpath(genpath('~/D-AMP_Toolbox'));
denoiser_RED='DnCNN';
SamplingRate=4;
n_DnCNN_layers=17;
LoadNetworkWeights(n_DnCNN_layers);
%% Setup
spectrumpath = '.\3000.tif';
c=480;
r=c;
iteration=810;
beta=0.9;
alpha = eps;
%==============================================

%% Read spectrum
y1=imread(spectrumpath);
y1 = y1(784:1263,784:1263);
y=double(y1);
y=y-mean(y(:));%extra the mean noise
y(find(y<0))=0;
y=y.^(1/2);
ymn=fftshift(y);

%% Initialization
Ogn0 = zeros(c,r);
Ogn0(175:255,175:255)=1;
t=1;
initialization = Ogn0;
%% DFPR-PnP HIO
while t<=iteration
       Phaign=fft2(Ogn0);
       Phaicn= ymn.*Phaign./(abs(Phaign)+alpha);
       phaicn=ifft2(Phaicn);
       phaicn(phaicn<0)=Ogn0(phaicn<0)-beta*phaicn(phaicn<0);           
       region = real(phaicn(175:255,175:255));
       min1 = min(min(region));
       max1 = max(max(region));
       region1 = double(uint8((region-min1)/(max1-min1)*255));
       region1 = reshape(denoise(region1,40,81,81,'DnCNN'),81,81);
       region1 = min1 + region1/255*(max1-min1);         
       phaicn(175:255,175:255) = region1;
       Ogn0=phaicn;
       xx=abs(Ogn0);
       t = t + 1;
end
imshow(xx,[]), axis image, title('DFPR-PnP HIO Recoverd image');
t=1;
Ogn0 = initialization;
%% HIO
while t<=iteration
           Phaign=fft2(Ogn0);
           Phaicn= ymn.*Phaign./(abs(Phaign)+alpha);
           phaicn=ifft2(Phaicn);
           phaicn(phaicn<0)=Ogn0(phaicn<0)-beta*phaicn(phaicn<0);  
           Ogn0=phaicn;
           xx=abs(Ogn0);
           t = t + 1;
end
figure
imshow(xx,[]), axis image, title('HIO Recoverd image');