clear all; close all; clc;

X = imread('./Lena128.png');
I = im2double(X);

subplot(1,5,1); imshow(I); title('original');

h = fspecial('laplacian');
h_fft = fft2(h, size(I,1), size(I,2));
h_fft_amp = sqrt(real(h_fft)*real(h_fft)+imag(h_fft)*imag(h_fft));

Y = fftshift(fft2(I));

Amp = sqrt(real(Y)*real(Y)+imag(Y)*imag(Y)); % log(abs(Y)); 
Angle = angle(Y);

subplot(1,5,2); imshow(Amp); title('fft2');

Z = Amp .* h_fft;

subplot(1,5,3); imshow(Z); title('after filter');

R = ifft2(Z);

subplot(1,5,4); imshow(R); title('ifft2');

R2 = imfilter(I,h);

subplot(1,5,5); imshow(R2); title('imfilter');
