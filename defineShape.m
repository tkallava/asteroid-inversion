
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

% % convex
% pvec = [[0 0];[0.5 0];[1 0];[1 .5];[1 1];[.5 1];[0 1];[0 0];[0.5 0];[1 0]];

% non-convex
pvec = [[0 0];[0.5 .8];[0.5 0];[1 .5];[1 1];[.5 1];[0 1];[0 0];[0.5 .8];[0.5 0]];

tvec=linspace(0,1,14)';
p=3;

wvec=[1 1 1 1 1 1 1 1 1 1];

% take a look at the shape and control points
shape=NURBSCurve(wvec,tvec,pvec,p);
clf
figure(1)
plot(shape(:,1),shape(:,2))
hold on
plot(pvec(:,1),pvec(:,2),'ro:')
axis([-1 2 -1 2]);

% save the shape
save shape