% Test the performance of DFPR-RED and DFPR-HIO
clear;
clc;
%% Setup
addpath(genpath('..'))
addpath('~/matconvnet/matlab');
addpath(genpath('~/D-AMP_Toolbox'));
denoiser_RED='DnCNN';
SamplingRate=4;
n_DnCNN_layers=17;
LoadNetworkWeights(n_DnCNN_layers);
path1 = './boat.png';
path2 = './Barba.png';
img = imread(path1);
img = double(img(:,:,1));
img = convert(img, [0, 255]);
initial=imread(path2);
initial = double(initial(:,:,1));
oversamplesize=64;
n = 128;
m = n+SamplingRate*oversamplesize/2;
SNR = 34;
img = imresize(img,[n,n]);
initial = imresize(initial,[n,n]);
mask = zeros(m,m);
mask(oversamplesize+1:oversamplesize+n,oversamplesize+1:oversamplesize+n) = img;
B = abs(fft2(mask));
noise = randn(m,m);
B = B + (noise)./norm(noise,'fro').*norm(B,'fro')/(10^(SNR/20));
%% DFPRRED
Y = padarray(initial,[oversamplesize,oversamplesize]);
Omega = randn(m,m); 
DFPRRED_opts = [];
DFPRRED_opts.level = {60,40,20};
DFPRRED_opts.n = n;
DFPRRED_opts.m = m;
DFPRRED_opts.beta = 0.95;
DFPRRED_opts.iteration = 200;
DFPRRED_opts.inneriteration = 5;
DFPRRED_opts.vision = 0;
tic;
DFPRRED_output = DFPRRED(Y,B,Omega,DFPRRED_opts);
DFPRRED_t = toc;
DFPRRED_psnr = max(psnr(DFPRRED_output, img), psnr(imrotate(DFPRRED_output,180), img));
display([num2str(SamplingRate*100),'% Sampling DFPR-RED: PSNR=',num2str(DFPRRED_psnr),', time=',num2str(DFPRRED_t)])
%% DFPRPnPHIO
DFPRPnPHIO_opts = [];
DFPRPnPHIO_opts.level = {60,40,20};
DFPRPnPHIO_opts.n = n;
DFPRPnPHIO_opts.m = m;
DFPRPnPHIO_opts.beta = 0.95;
DFPRPnPHIO_opts.iteration = 1000;
DFPRPnPHIO_opts.vision = 0;
tic;
DFPRPnPHIO_output = DFPRPnPHIO(Y,B,DFPRPnPHIO_opts);
DFPRPnPHIO_t = toc;
DFPRPnPHIO_psnr = max(psnr(DFPRPnPHIO_output, img), psnr(imrotate(DFPRPnPHIO_output,180), img));
display([num2str(SamplingRate*100),'% Sampling DFPR-HIO: PSNR=',num2str(DFPRPnPHIO_psnr),', time=',num2str(DFPRPnPHIO_t)])