clc
clear all
close all

%% Formes dérivatives

A = imread('batiment.bmp');
figure, imagesc(A), colormap(gray(256))

% Masque de dérivation

S_x = 1/8*[ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ];
S_y = S_x';

% Masque horizontale;

A_x = conv2(double(A),double(S_x))
figure, imagesc(A_x), colormap(gray(256))
title('Filtre avec masque de dérivation horizontale')

% Masque verticale;

A_y = conv2(double(A),double(S_y))
figure, imagesc(A_y), colormap(gray(256))
title('Filtre avec masque de dérivation verticale')

% Calcul de la norme euclidienne
Mod_A = sqrt((A_x).^2 + (A_y).^2);
figure, imagesc(double(Mod_A)), colormap(gray(256))
title('Filtre avec norme euclidienne')

%% Rehaussement;

%close all
%clear all

A = double(imread('batiment.bmp'));
figure, imagesc(A), colormap(gray(256))
title('Batiment')

% Masque Laplacien

L = [ 1 1 1 ; 1 -8 1 ; 1 1 1 ];

A_l = conv2(A,L,'same');
figure, imagesc(double(A_l)), colormap(gray(256))
title('Filtre avec opérateur Laplacien')

% On trouve alpha = 4
%alpha = 4;

alpha_1 = A - 0.1.*A_l;
alpha_2 = A - 0.2.*A_l;
alpha_3 = A - 0.5.*A_l;
alpha_4 = A - 1.*A_l;
alpha_5 = A - 2.*A_l;
alpha_6 = A - 4.*A_l;

figure,
subplot(231), image(alpha_1), colormap(gray(256))
title('Filtre pour a = 0,1')
subplot(232), image(alpha_2), colormap(gray(256))
title('Filtre pour a = 0,2')
subplot(233), image(alpha_3), colormap(gray(256))
title('Filtre pour a = 0,5')
subplot(234), image(alpha_4), colormap(gray(256))
title('Filtre pour a = 1')
subplot(235), image(alpha_5), colormap(gray(256))
title('Filtre pour a = 2')
subplot(236), image(alpha_6), colormap(gray(256))
title('Filtre pour a = 4')

figure,
subplot(131), imagesc(A), colormap(gray(256))
title('Batiment')
subplot(132),  image(2.*A_l), colormap(gray(256))
title('Filtrage Laplacien sans retrancher à l image original')
subplot(133), image(alpha_5), colormap(gray(256))
title('Filtre pour a = 2')