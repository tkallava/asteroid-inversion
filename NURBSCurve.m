
function NURBS = NURBSCurve(wvec,tvec,pvec,p)

% funtion that returns the NURBS curve
% based on given parameters.
%
% input parameters
%   pvec:   control points as a vector
%   wvec:   weight vector
%   tvec:   knot vector
%   p:      degree of function

% K=n+p+2, where K is a knot vector length
% and n+1 is the number of control points
%
% Tomi Kallava 2017

if length(tvec) ~= length(pvec)+p+1 || length(pvec)~=length(wvec)
    error('vector lengths dont match')
end

xvec = linspace(0,1,1000);
NURBS = zeros(1000,2);

for iii = 1:length(xvec)
    NURBS(iii,:) = NURBSFunc(xvec(iii),wvec,tvec,pvec,p);
end

% trimming
NURBS =NURBS(end/4.5:end-end/4.5,:);
