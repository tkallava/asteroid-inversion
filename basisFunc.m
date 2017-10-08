
function N = basisFunc(t,tvec,p,i)

% Recursive funtion that returns a basis function
% value based on given parameters.
%
% input parameters 
%   t:      parameter value t between [0,1]
%   tvec:   knot vector
%   p:      degree of function
%   i:      integer value between [0,n], where K=n+p+1,
%           where n is the number of control points and
%           K is knot vector length
%
% Tomi Kallava 2017

% basis function
N = 0;

if p == 0
    if t >= tvec(i) && t < tvec(i+1) 
        N = 1;
    end
else
    N = (t-tvec(i))/(tvec(i+p)-tvec(i)) * basisFunc(t,tvec,p-1,i) + ...
    (tvec(i+p+1)-t)/(tvec(i+p+1)-tvec(i+1)) * basisFunc(t,tvec,p-1,i+1);
end

         

