%% TRAVAIL DEMANDE

clear all
close all

Ce = double(imread('centrale.tif'));
figure, imshow(uint8(Ce))
Mo = double(imshow('monument.bmp'));
figure, imshow(uint8(Ce))
[h,w] = size(Mo);
fx=linspace(-0.5,0.5-1/w,w);
fy=linspace(-0.5,0.5-1/h,h);
IfM=fftshift(log10(abs(fft2(Mo))));
figure, imagesc(fx,fy,IfM)

H1=ones(5)/25;
A=conv2(Mo,H1,'same');
figure, imshow(uint8(A));
IfA=fftshift(log10(abs(fft2(A))));
figure, imagesc(fx,fy,IfA)
B=medfilt2(Mo, [5,5]);
figure, imshow(uint8(B));
IfB=fftshift(log10(abs(fft2(B))));
figure, imagesc(fx,fy,IfB)



