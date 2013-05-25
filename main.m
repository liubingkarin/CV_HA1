%plot edges and corners too slow
%for loop
%addRequied
%addParamValue()
%0.3s

clear all; close all; clc
%Bild = rand(14,10);
Bild = imread('Bilder/testImage.jpg');
%Bild = imread('Bilder/teddy.png');
%Bild = imread('Bilder/camera.jpg');
Bild = rgb_to_gray(Bild);
%imshow(uint8(Bild));
tic
W = 1/49*ones(7,7);
k = 0.03;
tau = [-5e7;1e8];%tau = [-1e6;8e7];
do_plot = true;
figure;
subplot(1,2,1);
Merkmale1 = harris_detektor(Bild, W, k, tau,[100,100],5, 500,[]);
toc
%% use Gaussian filter before doing harris detection
I=Bild;
%h=fspecial('gaussian',[5 5],1);

%I1 = imfilter(I,h,'conv');
I1 = medfilt2(I);
subplot(1,2,2);
Merkmale2 = harris_detektor(I1, W, k, tau, do_plot);
figure;
imshow(uint8(I1));