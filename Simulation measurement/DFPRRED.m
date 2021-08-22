function output = DFPRRED(Y,B,Omega,DFPRRED_opts)
m = DFPRRED_opts.m;
n = DFPRRED_opts.n;
oversamplesize = m-n;
for k = 1 : length(DFPRRED_opts.level)
    for j = 1 : DFPRRED_opts.iteration
        inter = Y - Omega;
        inter1 = inter*0;
        range1 = oversamplesize+1:oversamplesize+n;
        range2 = oversamplesize+1:oversamplesize+n;
        inter1(range1,range2) = inter(range1,range2);
        inter2 = inter1;
        for innerloop = 1 :5
        inter2(range1,range2) = 1/2*(inter1(range1,range2) + reshape(denoise(real(inter2(range1,range2)),DFPRRED_opts.level{k},n,n,'DnCNN'),n,n));
        end
        inter1(range1,range2) = inter2(range1,range2);
        X= inter1;
        ftpre = fft2(X + Omega);
        Y = ifft2(ftpre./abs(ftpre).*B);
        Omega = Omega + DFPRRED_opts.beta*(X-Y);
        if DFPRRED_opts.vision == 1
           pic = convert(real(Y(range1,range2)),[0,255]);
           imshow(pic)
           pause(0.01)
        end
    end
end
output = convert(real(Y(range1,range2)),[0,255]);
end