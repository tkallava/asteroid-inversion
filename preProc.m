
function data = preProc(data)

% Function that preprocess the asteroid so that
% center of mass is in the origin and the maximum width
% of the asteroid is 1
%
% Tomi Kallava 2017

% move center of mass to origin
data(:,1) = data(:,1) - mean(data(:,1));
data(:,2) = data(:,2) - mean(data(:,2));

% max distance of a straight line between two points of asteroid
maxi = 0;
for iii = 1:length(data)
    for j = iii:length(data)
        tmp =  sqrt((data(iii,1)-data(j,1)).^2 + (data(iii,2)-data(j,2)).^2);
        if tmp > maxi
            maxi = tmp;
        end
    end
end

% normalization
data = data/maxi;
