clc
clear all
close all
 % ---------------------------- PREAMBULE --------------------------

I = double(imread('pool.tif'));

% Composante rouge
R = I(:,:,1);
% Composante verte
G = I(:,:,2);
% Composante bleue
B = I(:,:,3);

Y = 0.299*R + 0.587*G + 0.114*B;
Cb = 0.564* (B-Y) + 128;
Cr = 0.713* (R-Y) + 128;

figure, imshow(uint8(I))
figure, subplot(311), imshow(uint8(R))
subplot(312), imshow(uint8(G))
subplot(313), imshow(uint8(B))
figure, subplot(311), imshow(uint8(Y))
subplot(312), imshow(uint8(Cb))
subplot(313), imshow(uint8(Cr))

% Avec la méthode RGB, l'information que l'on souhaite obtenir n'est pas
% complète. Par exemple, la composante blanche possède une composante
% bleue. On ne peut pas faire la différence entre la composante bleue et la
% composante contenant du bleue. 
% C'est pourquoi la méthode YCbCr nous permet d'obtenir la complétude de
% cette information. Lorsque l'on isole la composante bleue par exmpemple, elle est
% la seul à bien apparaitre sur la figure.

% QUESTION 2
clear all
close all
% Fusion d'image

B = double(imread('background.jpg'));
F = double(imread('foreground.jpg'));

% Création d'un masque

Rb = B(:,:,1);
Gb = B(:,:,2);
Bb = B(:,:,3);

Yb = 0.299*Rb + 0.587*Gb + 0.114*Bb;
Cbb = 0.564* (Bb-Yb) + 128;
Crb = 0.713* (Rb-Yb) + 128;

Rf = F(:,:,1);
Gf = F(:,:,2);
Bf = F(:,:,3);

Yf = 0.299*Rf + 0.587*Gf + 0.114*Bf;
Cbf = 0.564* (Bf-Yf) + 128;
Crf = 0.713* (Rf-Yf) + 128;


M = Cbf<145; % La valeur de Cb doit être inférieur à un seuil
M2 = Cbf>145; 

 % Ici, on récupere la partie de l'image en arrière-plan qui nous intéresse
 % pour les composantes R, G et B

Rf1 = uint8(M).*uint8(Rf);
Gf1 = uint8(M).*uint8(Gf);
Bf1 = uint8(M).*uint8(Bf);
Imfor = cat(3,Rf1,Gf1,Bf1);

Rb1 = uint8(M2).*uint8(Rb);
Gb1 = uint8(M2).*uint8(Gb);
Bb1 = uint8(M2).*uint8(Bb);
Imback = cat(3,Rb1,Gb1,Bb1);

Im = Imfor + Imback;
figure
imshow(Im)

M_1 = Bf<145; % On raisonne sur la composante Bleue
M_2 = Bf>145;

Rf_1 = uint8(M_1).*uint8(Rf);
Gf_1 = uint8(M_1).*uint8(Gf);
Bf_1 = uint8(M_1).*uint8(Bf);
Im_for = cat(3,Rf_1,Gf_1,Bf_1);

Rb_1 = uint8(M_2).*uint8(Rb);
Gb_1 = uint8(M_2).*uint8(Gb);
Bb_1 = uint8(M_2).*uint8(Bb);
Im_back = cat(3,Rb_1,Gb_1,Bb_1);

Im_1 = Im_for + Im_back;
figure
imshow(Im_1)

%Necessité d'utiliser l'espace YCbCr. La composante bleue du blanc a été
%prise en compte dans la fusion des deux images.

%  --------------------------- FILTRAGE -----------------------------

clear all
close all

Mo = double(imread('monument.bmp'));
imagesc(Mo), colormap(gray(256))
title('Monument')
figure, imshow(uint8(Mo))
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

[x,y] = meshgrid(-24:24,-24:24);
length(x);
length(y);
fx = 0.1;
fy = -0.4;
sigma=1/sqrt(fx^2+fy^2);
dirac=zeros(length(x),length(y));
dirac(ceil(length(x)/2),ceil(length(y)/2))=1;

fmax = 3/sigma;
fech = 2*sqrt(fx^2+fy^2);

%Domaine temporel

G = 1/(2*pi*sigma^2)*exp(-(x.^2+y.^2)/(2*sigma^2));
G1 = G/sum(sum(G)); % Normalisation du filtre

%2eme étape
%Filtre passe bande
G2 = 2*G1.*(cos((2*pi*fx.*x)+(2*pi*fy.*y)));

%3eme étape 
%Filtre coupe Bande
G3=dirac-G2;

%Tracé

figure, freqz2(G1), colorbar, title('Filtre Gaussien')
axis([-0.5 0.5 0 1])
figure, freqz2(G), colorbar, title('Représentation fréquentielle du filtre passe-bas')
figure, surf(x,y, G), colorbar, title('Représentation spatiale du filtre passe-bas')
figure, freqz2(G2), colorbar, title('Représentation fréquentielle du filtre passe-bande')
figure, surf(x,y, G2), colorbar, title('Représentation spatiale du filtre passe-bande')
figure, surf(x,y, G3), colorbar, title('Représentation spatiale du filtre coupe-bas')
figure(),freqz2(G3), colorbar, title('Représentation fréquentielle du filtre coupe-bande')

%Convolution de G3 et de l'image

Mo_f = conv2(Mo,G3,'same');
figure(), imagesc(uint8(Mo_f)), colormap(gray(256)), title('Image filtrée');
figure(), imagesc(uint8(Mo)), colormap(gray(256)), title('Image non filtrée');
%Affichage du spectre final

[hf,wf] = size(Mo_f);
fx=linspace(-0.5,0.5-1/w,w);
fy=linspace(-0.5,0.5-1/h,h);
IfMo_f=fftshift(log10(abs(fft2(Mo_f))));

figure,
imagesc(fx,fy,IfM),title('Representation frequentielle non filtrée')
figure,
imagesc(fx,fy,IfMo_f), title('Representation frequentielle filtrée pour sigma = 8')













