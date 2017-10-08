
function R = rationalFunc(w,t,tvec,p,i,n)

% funtion that returns the value of rational function
% based on given parameters.
%
% input parameters
%   w:      weight vector
%   t:      parameter value t between [0,1]
%   tvec:   knot vector
%   p:      degree of function
%   i:      integer value between [0,n]
%   n:      the number of control points
%           K is knot vector length, where K=n+p+1
%
% Tomi Kallava 2017

numer = w(i)*basisFunc(t,tvec,p,i);

denom = 0;

for iii = 1:n
    denom = denom + w(iii)*basisFunc(t,tvec,p,iii);
end 

R = numer/denom;
