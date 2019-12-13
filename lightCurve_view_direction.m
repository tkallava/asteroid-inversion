
function proj_lengths = lightCurve_view_direction(accuracy, folder)

% This function creates the frames for animating the lightcurve in cases
% where the light comes from the viewing direction
%
% parameters:
%   accuracy:    accuracy of the measurement (How many light-rays)
%   folder:      folder where to save the animation frames
%
% Tomi Kallava 2019

% get the asteroid data
load('shape');

% pre-process data
data = preProc(shape);

% rotation matrix
rot = [cos(2*pi/100) -sin(2*pi/100);sin(2*pi/100) cos(2*pi/100)];

proj_lengths = zeros(100,1);

%%
% Here begins the loop jungle, where we rotate the asteroid, go through all
% light rays point by point and see which rays reflect to the viewer.
%
% At each step we call the projLength-function to analyze if the area of 
% asteroid between two consecutive visible points is also visible. So we'll
% find out the projection length.
%
% Rotate the asteroid full circle in 50 steps
for kkk = 1:101
    
    % For visualizations    
    % asteroid figure and settings
    figure(1)
    clf
    subplot(1,2,1)
    patch(data(:,1),data(:,2),[0.5 0.5 0.5])
    hold on
    axis([-1 1 -1 1]);
    set(gca,'visible','off');
    set(gca,'xtick',[]);
    
    subplot(1,2,2)
    patch(data(:,1),data(:,2),[0.5 0.5 0.5])
    hold on
    axis([-1 1 -1 1]);
    x_projs = linspace(-1,1,length(proj_lengths));
    plot(x_projs, proj_lengths, 'white', 'LineWidth',2);
    hold on
    axis([-1 1 -1 1]);
    
    set(gca,'visible','off');
    set(gca,'xtick',[]);

    set(gcf,'Color','black');
    set(gcf,'Position',[350 100 800 450])
      
    x1_0 = -1;
    count = 1;
    visible = zeros(100, 1);
    line_step = 1/accuracy;
        
    % outer loop is for light rayscc
    for iii = 1:200
                
        y1_0 = -1;

        % At first the point is not inside the polygon
        inPolyg = 0;

        % this loop is for points scanning through the light ray
        % the loop runs until the intersection is in the polygon
        lightray_count = 0;
        while(inPolyg==0 && lightray_count<150)
            
            lightray_count = lightray_count + 1;
            subplot(1,2,1)
            plot(x1_0,y1_0,'y.', 'markersize', 13)
            % Inside/outside test
            [in,on] = inpolygon(x1_0,y1_0,data(:,1),data(:,2));
            y_tmp = y1_0;
            
            %%
            if in == 1 || on == 1
                inPolyg = 1;
                count = count + 1;
                
                y_int = y1_0;

                % this while loop finds out if the light ray reflects to the
                % viewer
                obstacle = 0;
                while obstacle == 0
                    y_int = y_int - line_step;
                    [in,on] = inpolygon(x1_0,y_int,data(:,1),data(:,2));
                    
      
                    if in == 1 || on == 1
                        count = count + 1;
                        obstacle = 1;
                    else
                        subplot(1,2,2)
                        plot(x1_0,y_int,'y.', 'markersize', 13);
                        hold on
                        if y_int < -1
                            visible(count) = x1_0;
                            subplot(1,2,2)
                            plot(x1_0,y_tmp,'w*');
                            plot(x1_0,-1,'w.','markersize', 20);
                            hold on
                            count = count + 1;
                            obstacle = 1;
                        end
                    end
                end
            else
                y1_0 = y1_0 + line_step;
            end
        end
        x1_0 = x1_0 + line_step;
    end
    disp(nonzeros(visible))
    proj_lengths(kkk) = (max(nonzeros(visible)) - min(nonzeros(visible)))/1.5;
    
    % Rotate the asteroid
    data = (rot*data.')';
    
    disp([num2str(kkk),' % completed'])
    
    ha=get(gcf,'children');
    set(ha(1),'position',[.55 .1 .4 .8])
    set(ha(2),'position',[.1 .1 .4 .8])
    
    im1 = getframe(gcf);
    filename = [folder,'/frame_',num2str(kkk),'.png'];
    imwrite(frame2im(im1),filename,'png');

end