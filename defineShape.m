
% Define the NURBS asteroid shape
% so that length(tvec) = length(pvec)+p+1
% and length(pvec) = length(wvec)
% 
%   pvec:   control points as a vector
%   wvec:   weight vector
%   tvec:   knot vector
%   p:      degree of function
%
% Tomi Kallava 2017

p=3;

% % convex
% pvec = [[0 0];[0.5 0];[1 0];[1 .5];[1 1];[.5 1];[0 1];[0 0];[0.5 0];[1 0]];
%tvec=linspace(0,1,14)';
%wvec=[1 1 1 1 1 1 1 1 1 1];

% non-convex
pvec = [[0 0];[0.5 .4];[0.7 0];[.9 .5];[.8 1];[.5 .7];[0 1];[0 0];[0.5 .4];[0.7 0]];
tvec=linspace(0,1,14)';
wvec=[1 1 1 1 1 1 1 1 1 1];

% % circle
% pvec = [[1 0];[1 1];[0 1];[-1 1];[-1 0];[-1 -1];[0 -1];[1 -1];[1 0];[1 1];[0 1];[-1 1]];
% tvec=linspace(0,1,16)';
% wvec=[1 sqrt(2)/4 1 sqrt(2)/4 1 sqrt(2)/4 1 sqrt(2)/4 1 sqrt(2)/4 1 sqrt(2)/4];

% % Reuleaux triangle
% pvec = [[1 0];[1 1];[0 sqrt(3)];[-1 1];[-1 0];[0 -.25];[1 0];[1 1]];
% tvec=linspace(0,1,12)';
% wvec=[1 sqrt(2)/4 1 sqrt(2)/4 1 1 1 sqrt(2)/4];

% take a look at the shape and control points
shape=NURBSCurve(wvec,tvec,pvec,p);
clf
figure(1)
plot(shape(:,1),shape(:,2))
hold on
plot(pvec(:,1),pvec(:,2),'ro:')
axis([-1 2 -1 2]);
set(gcf,'Position',[200 100 500 500]);

% save the shape
save shape