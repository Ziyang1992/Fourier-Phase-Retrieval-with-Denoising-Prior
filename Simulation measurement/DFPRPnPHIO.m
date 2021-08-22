function output = DFPRPnPHIO(Y,B,DFPRPnPHIO_opts)
m = DFPRPnPHIO_opts.m;
n = DFPRPnPHIO_opts.n;
oversamplesize = m-n;
Pre = Y;
for k = 1 : length(DFPRPnPHIO_opts.level)
    for j = 1: DFPRPnPHIO_opts.iteration
            ftpre = fft2(Y);
            inter = ifft2(ftpre./abs(ftpre).*B);
            range1 = oversamplesize+1:oversamplesize+n;
            range2 = oversamplesize+1:oversamplesize+n;
            Y = Pre - DFPRPnPHIO_opts.beta*inter;
            Y(range1,range2)=reshape(denoise(real(inter(range1,range2)),DFPRPnPHIO_opts.level{k},n,n,'DnCNN'),n,n);
            Pre = Y;
            if DFPRPnPHIO_opts.vision == 1
               pic = convert(real(Y(range1,range2)),[0,255]);
               imshow(pic)
               pause(0.01)
            end
     end
end
output = convert(real(Y(range1,range2)),[0,255]);
end