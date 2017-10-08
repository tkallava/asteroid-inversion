
function S = NURBSFunc(t,wvec,tvec,pvec,p)

% funtion that returns the NURBS value at point t
% based on given parameters.
%
% input parameters
%   pvec:   control points as a vector
%   wvec:   weight vector
%   t:      parameter value between [0,1]
%   tvec:   knot vector
%   p:      degree of function
%           K is knot vector length, where K=n+p+2
%           n+1 is the number of control points
%
% Tomi Kallava 2017


S = zeros(1,2);

for iii = 1:length(pvec)
    S = S + pvec(iii,:) .* rationalFunc(wvec,t,tvec,p,iii,length(pvec));
end