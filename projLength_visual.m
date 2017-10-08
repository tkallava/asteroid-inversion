
function proj_len = projLength_visual(visible,data)

% This function defines the total projection length at a given time
% parameter:
%   visible:    array of points
%
% 'visible' is an array of points, which size is equal to number of light rays.
% If there's an element that's not (0,0), it means that that point is visible
%
% Points that are not visible are also saved as (0,0) so that we know if
% the visible points are consecutive
%
% This also visualizes the projection and visible points
%
% Tomi Kallava 2017

proj_len = 0;

for iii = 2:length(visible)
    
    % projection length increases only if there are consecutive visible
    % points
    if ~(visible(iii,1) == 0 & visible(iii,2) == 0) & ~(visible(iii-1,1) == 0 & visible(iii-1,2) == 0)
        
        x_1 = visible(iii-1,1);
        x_2 = visible(iii,1);
        y_1 = visible(iii-1,2);
        y_2 = visible(iii,2);
        
        % Here we take little steps between those consecutive visible
        % points and make sure the path between those points go through the
        % asteroid
        inp = zeros(20,1);
        k = (y_2 - y_1)/(x_2 - x_1);
        step = (x_2 - x_1)/20;
        for j = 1:20
            x_1 = x_1 + step;
            y_1 = y_1 + k*step;
            [in,on] = inpolygon(x_1,y_1,data(:,1),data(:,2));
            inp(j) = in;
        end
        if all(inp)
            proj_len = proj_len + abs(visible(iii-1)-visible(iii));
            
            % for visuals
            subplot(1,2,1)
            plot([visible(iii-1,1) visible(iii,1)],[visible(iii-1,2) visible(iii,2)],'w*')
            hold on
            plot([visible(iii-1) visible(iii)],[-0.9 -0.9],'y','LineWidth',10)
            hold on

        end
    end
end