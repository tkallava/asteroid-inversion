function light_intensity(lightcurve, folder)

% Function that records frames for animating the
% brightness changes of distant asteroid + the light curve

a = zeros(length(lightcurve), 1);
x = linspace(0,1,length(a))
for iii = 1:length(a)
    a(iii) = lightcurve(iii);
    figure(1)
    clf
    subplot(1,1,1)
    plot(x, a, 'w')
    axis([0 1 0 .3])
    hold on
    plot(.5, .25, 'w.','markersize', a(iii)*100+.1)
    hold on
    set(gca,'visible','off');
    set(gca,'xtick',[]);
    set(gcf,'Color','black');
    im1 = getframe(gcf);
    filename = [folder, '/frame_',num2str(iii),'.png'];
    imwrite(frame2im(im1),filename,'png');
end