function inverse_problem_mcmc(N, folder, acc, frame_freq)

% Function that tries to find the shape of unknown 2D asteroid with MCMC and 
% creates the animation that visualizes the process
% 
% The 'unknown' shape of the 'real' asteroid is randomly chosen 
% If you have your own asteroid and control points, you can place those here:

control_points = [];
% for example 
% control_points = [[.45 0];[.35 .5];[.05 .2];[-.45 .5];[-.45 -.5];[0.05 -.1];[0.25 -.5];[.45 0];[.35 .5];[.05 .2]];

%
% parameters:
%   N: number of MCMC iterations
%   folder: folder, where animation frames are saved
%   acc: in light curve simulation, the number of light rays
%   frame_freq: how frequently you want to record a frame 
%   (every frame_freq:th iteration will be recorded. In addition frame will
%   be recorded whenever new maximum value likelihood occurs)

rng('shuffle');

%% Burn-in period
burnin = 1;

%% Prerequisites for asteroid shape
p=3;
tvec=linspace(0,1,15)';
wvec=[1 1 1 1 1 1 1 1 1 1 1];

%% Measured lightcurve and ground truth asteroid
tvec_gt=linspace(0,1,14)';
wvec_gt=[1 1 1 1 1 1 1 1 1 1];
ground_truth = zeros(7,2);
angles = zeros(7,1);
rads = zeros(7,1);
angles(1) = 0;
rads(1) = .5;
ang_prev = 0;
point = [.5 0];
ground_truth(1, 1) = point(1);
ground_truth(1, 2) = point(2);
for iii = 2:7
    % Control point radius not more than 0,5
    radius = rand * .5;
    if radius < .3
        radius = .3;
    end
    ang_r = rand;
    % Control point angle between 0 and 2*pi
    if ang_prev + ang_r * pi/2 < 2*pi
        angl = ang_prev + ang_r * pi/2;
    else
        angl = (ang_prev + 2*pi)/2;
    end
    % To cartesian coordinate
    x = radius * cos(angl);
    y = radius * sin(angl);
    point = [x y];
    ground_truth(iii, 1) = point(1);
    ground_truth(iii, 2) = point(2);
    ang_prev = angl;
    
    angles(iii) = angl;
    rads(iii) = radius;
end
disp(angles)
disp(rads)
% Close the spline
for eee = 1:3
    ground_truth(iii+eee, 1) = ground_truth(eee, 1);
    ground_truth(iii+eee, 2) = ground_truth(eee, 2);
end

if ~isempty(control_points)
    ground_truth = control_points;
end

gt_shape=NURBSCurve(wvec_gt,tvec_gt,ground_truth,p);
measurement = lightCurve(acc, 3*pi/4, gt_shape);
    
%% Initial control point vector, shape and lightcurve
max_likelihood = 0;
% Burn-in
for lll = 1:burnin
    % Initial shape
    ang_prev = 0;
    pvec = zeros(8,2);

    angles = zeros(8,1);
    rads = zeros(8,1);
    angles(1) = 0;
    pvec(1) = ground_truth(1);
    rads(1) = .5;

    for iii = 2:8
        radius = rand * .5;
        if radius < .3
            radius = .3;
        end
        ang_r = rand;
        if ang_prev + ang_r * pi/2 < 2*pi
            angl = ang_prev + ang_r * pi/2;
        else
            angl = (ang_prev + 2*pi)/2;
        end
        x = radius * cos(angl);
        y = radius * sin(angl);
        point = [x y];
        pvec(iii, 1) = point(1);
        pvec(iii, 2) = point(2);
        ang_prev = angl;

        angles(iii) = angl;
        rads(iii) = radius;
    end
    for eee = 1:3
        pvec(iii+eee, 1) = pvec(eee, 1);
        pvec(iii+eee, 2) = pvec(eee, 2);
    end
    shape=NURBSCurve(wvec,tvec,pvec,p);
    lightcurve = lightCurve(acc, 3*pi/4, shape);

    % Alternative lightcurve with phase shifting
    [max_lig, ind_lig] = max(lightcurve);
    [max_meas, ind_meas] = max(measurement);
    shift = ind_meas - ind_lig;
    alt_lightcurve = zeros(length(lightcurve),1);
    for aaa = 1:length(lightcurve)
        if (aaa - shift) <= length(lightcurve) && (aaa - shift) > 0
            alt_lightcurve(aaa) = lightcurve(aaa - shift);
        end
        if (aaa - shift) > length(lightcurve)
            alt_lightcurve(aaa) = lightcurve(aaa - shift - length(lightcurve));
        end
        if (aaa - shift) < 0
            alt_lightcurve(aaa) = lightcurve(aaa - shift + length(lightcurve));
        end
    end
    
    % likelihood
    likelihood = exp(-3*sqrt(sum((lightcurve - measurement) .^ 2)));
    alt_likelihood = exp(-3*sqrt(sum((alt_lightcurve - measurement) .^ 2)));
    if alt_likelihood > likelihood
        lightcurve = alt_lightcurve;
        likelihood = alt_likelihood;
    end
    if likelihood > max_likelihood
        max_likelihood = likelihood;
        max_shape = shape;
        max_lightcurve = lightcurve;
        max_pvec = pvec;
        max_angles = angles;
        max_rads = rads;
    end
end
prev_likelihood = max_likelihood;
shape = max_shape;
lightcurve = max_lightcurve;
pvec = max_pvec;
angles = max_angles;
rads = max_rads;

likelihoods = max_likelihood;

figure(1)
clf
subplot(2,2,1)
patch(shape(:,1),shape(:,2),[0.5 0.5 0.5])
axis([-.5 .5 -.5 .5])
title(['Estimated Shape                                       Iterations: ', num2str(1)])
hold on
set(gca,'xtick',[]);
set(gca,'visible','off');
set(findall(gca, 'type', 'text'), 'visible', 'on')
plot(pvec(:,1), pvec(:,2), 'ro:')
hold on
axis([-.5 .5 -.5 .5])
set(gca,'xtick',[]);
set(gca,'visible','off');
set(findall(gca, 'type', 'text'), 'visible', 'on')
subplot(2,2,2)
title('Real Shape')
patch(gt_shape(:,1),gt_shape(:,2),[0.5 0.5 0.5])
hold on
plot(ground_truth(:,1), ground_truth(:,2), 'ro:')
hold on
axis([-.5 .5 -.5 .5])
set(gca,'xtick',[]);
set(gca,'visible','off');
set(findall(gca, 'type', 'text'), 'visible', 'on')
subplot(2,2,3)
plot(lightcurve)
title('Light Curves')
hold on
set(gca,'xtick',[]);
plot(measurement, 'r')
legend('Simulated Light Curve', 'Measured Light Curve')
subplot(2,2,4)
plot(likelihoods)
title('Likelihood')
hold on
set(gca,'xtick',[]);
set(gcf,'Color','white');
set(gcf,'Position',[350 50 800 600])
im1 = getframe(gcf);

frame_n = 0;
%% Iteration rounds
for kkk = 1:N
    likelihoods = [likelihoods; likelihood];
    
    % Previous values
    prev_shape = shape;
    prev_pvec = pvec;
    prev_curve = lightcurve;
    prev_likelihood = likelihood;
    prev_angles = angles;
    prev_rads = rads;
    rand_point = randi([2,8]);
    
    err = rand/20-0.025;
    erra = rand/10-0.05;
    
    % Random noise to one of the control points
    
    angl = prev_angles(rand_point);
    
    new_ang = angl + erra;
    
    % Checking that control point angles between 0 and 2*pi
    
    if new_ang > 2*pi
        new_ang = 2*pi - .01;
    end
    if new_ang < 0 
        new_ang = .01;
    end
    
    % Make sure that control points angles don't pass each others 
    if rand_point ~= 8 
        if new_ang <= prev_angles(rand_point-1) || new_ang >= prev_angles(rand_point+1)
            new_ang = (prev_angles(rand_point+1) + prev_angles(rand_point-1)) / 2;
        end
    end
    if rand_point == 8 
        if new_ang <= prev_angles(7)
            new_ang = (2*pi + prev_angles(7)) / 2;
        end
    end
    
    % Keeping the radius on a sufficient level
    new_rad = prev_rads(rand_point) + err;
    if new_rad < .3
        new_rad = .31;
    end
    if new_rad > .5
        new_rad = .49;
    end
    
    rads(rand_point) = new_rad;
    angles(rand_point) = new_ang;
    
    x = new_rad * cos(new_ang);
    y = new_rad * sin(new_ang);
        
    pvec(rand_point, 1) = x;
    pvec(rand_point, 2) = y;
    
    for eee = 1:3
        pvec(8+eee, 1) = pvec(eee, 1);
        pvec(8+eee, 2) = pvec(eee, 2);
    end
    
    % new shape
    shape=NURBSCurve(wvec,tvec,pvec,p);
    
    % new lightcurve
    lightcurve = lightCurve(acc, 3*pi/4, shape);
    
    % Alternative lightcurve with phase shifting
    [max_lig, ind_lig] = max(lightcurve);
    [max_meas, ind_meas] = max(measurement);
    shift = ind_meas - ind_lig;
    alt_lightcurve = zeros(length(lightcurve),1);
    for aaa = 1:length(lightcurve)
        if (aaa - shift) <= length(lightcurve) && (aaa - shift) > 0
            alt_lightcurve(aaa) = lightcurve(aaa - shift);
        end
        if (aaa - shift) > length(lightcurve)
            alt_lightcurve(aaa) = lightcurve(aaa - shift - length(lightcurve));
        end
        if (aaa - shift) < 0
            alt_lightcurve(aaa) = lightcurve(aaa - shift + length(lightcurve));
        end
    end
    
    % likelihood
    likelihood = exp(-3*sqrt(sum((lightcurve - measurement) .^ 2)));
    alt_likelihood = exp(-3*sqrt(sum((alt_lightcurve - measurement) .^ 2)));
    
    if alt_likelihood > likelihood
        lightcurve = alt_lightcurve;
        likelihood = alt_likelihood;
    end
    
    % approved or not
    if likelihood < prev_likelihood
        s = rand/5 + .8;
        if s > (likelihood/prev_likelihood)
            pvec = prev_pvec;
            likelihood = prev_likelihood;
            shape = prev_shape;
            lightcurve = prev_curve;
            angles = prev_angles;
            rads = prev_rads;
        end
    end
    
    if rem(kkk, frame_freq) == 0
        
        x_lik = 1:length(likelihoods); 
        P = polyfit(x_lik,likelihoods.',1);
        yfit = P(1)*x_lik+P(2);
        
        frame_n = frame_n+1;
        
        clf
        subplot(2,2,1)
        patch(shape(:,1),shape(:,2),[0.5 0.5 0.5])
        axis([-.5 .5 -.5 .5])
        title({['                                        Iterations: ', num2str(kkk)]
            ['Estimated Shape                           Linear fit slope: ', num2str(P(1))]})
        hold on
        set(gca,'xtick',[]);
        set(gca,'visible','off');
        set(findall(gca, 'type', 'text'), 'visible', 'on')
        plot(pvec(:,1), pvec(:,2), 'ro:')
        hold on
        axis([-.5 .5 -.5 .5])
        set(gca,'xtick',[]);
        set(gca,'visible','off');
        set(findall(gca, 'type', 'text'), 'visible', 'on')
        subplot(2,2,2)
        title('Real Shape')
        patch(gt_shape(:,1),gt_shape(:,2),[0.5 0.5 0.5])
        hold on
        plot(ground_truth(:,1), ground_truth(:,2), 'ro:')
        hold on
        set(gca,'xtick',[]);
        set(gca,'visible','off');
        set(findall(gca, 'type', 'text'), 'visible', 'on')
        subplot(2,2,3)
        plot(lightcurve)
        title('Light Curves')
        hold on
        set(gca,'xtick',[]);
        %set(gca,'visible','off');
        plot(measurement, 'r')
        legend('Simulated Light Curve', 'Measured Light Curve')
        subplot(2,2,4)
        plot(likelihoods)
        title('Likelihood')
        hold on
        
        
        plot(x_lik,yfit,'r-.');
        hold on;
        
        
        set(gca,'xtick',[]);
        set(gcf,'Color','white');
        set(gcf,'Position',[350 50 800 600])
        im1 = getframe(gcf);

        filename = [folder,'/frame_',num2str(frame_n),'.png'];
        imwrite(frame2im(im1),filename,'png');
    end
end
disp(ground_truth)
disp(pvec)