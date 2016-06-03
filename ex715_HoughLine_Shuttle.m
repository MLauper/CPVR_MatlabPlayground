%##########################################################################
% File:       HoughLine_Shuttle.m
% Purpose:    Rotate the shuttle by finding the longest line 
% Author:     Marcus Hudritsch
% Date:       25-MAY-2013
% Copyright:  Marcus Hudritsch, Kirchrain 18, 2572 Sutz
%             THIS SOFTWARE IS PROVIDED FOR EDUCATIONAL PURPOSE ONLY AND
%             WITHOUT ANY WARRANTIES WHETHER EXPRESSED OR IMPLIED.
%##########################################################################
clear all; close all; clc; %clear matrices, close figures & clear cmd wnd.

RGB = imread('./Shuttle2.jpg');
I  = rgb2gray(RGB);     % convert to intensity
BW = edge(I,'canny');   % extract edges
imshow(BW);

% Transform into hough space H with all thetas T and rhos R
[H,T,R] = hough(BW, 'ThetaResolution',0.5, 'RhoResolution', 1); 

% Show the hough space with T & R as axis scales
figure, imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(jet);

% Get the thetas & rhos of the 5 brightest peaks
P = houghpeaks(H,5);
x = T(P(:,2)); y = R(P(:,1));  % Get the x & y coords out of T & P
plot(x,y,'s','color','white');

lines = houghlines(BW,T,R,P);

figure, imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');

angle = radtodeg(tan((xy_long(1,2)-xy_long(2,2)) / (xy_long(1,1)-xy_long(2,1))));
rotI = imrotate(I,angle,'crop');


figure, imshow(rotI)
