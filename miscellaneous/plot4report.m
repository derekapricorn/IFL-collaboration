function [r,p] = plot4report(x,y,ax,ay,N)
%plot 2-D graph used in the report format, with N degress of interpolation,
%assuming normal distribution
%inputs: x,y,x-axis name,y-axis name,order of interpolation

%chope off the NaN entries
bf = ~isnan(x.*y);
X = x(bf);
Y = y(bf)*100;
[r,p] = corr(X.^N,Y);
figure
set(plot(X,Y,'o'),'Markersize',9,'Linewidth',1,'Color','k','MarkerFaceColor','r')%plot the original scatterplot;: 'MarkerFaceColor','r'
hold on

margin = 0.1 * (max(X) - min(X));%plot the interpolating curve
xx = min(X)-margin:margin/50:max(X)+margin;
t = polyfit(X,Y,N);
set(plot(xx,polyval(t,xx),'b'),'Linewidth',3)

hold off
set(gca,'Fontsize',16,'Fontweight','Bold')
set(xlabel(ax),'Fontsize',16,'Fontweight','Bold')
set(ylabel(ay),'Fontsize',16,'Fontweight','Bold')
% axis tight
% set(text(txt_loc(1),txt_loc(2),sprintf('r = %1.2f \np =
% %1.3f',r,p)),'Fontsize',16,'Fontweight','Bold')  
set(text(32,30,sprintf('r = %1.2f \np = %1.3f',r,p)),'Fontsize',16,'Fontweight','Bold')
%  set(gca,'YLim',[0 100]) % use this line
%  set(gca,'XLim',[10 35]) % use this line
% set(gca,'XLim',[xx(1),xx(end)],'YLim',[min(Y),max(Y)])  % use this line
%only when necessary

%saveas(gcf,'UAXSA-Flatten-Per','tif')
%title('Second-Order Correlation')

end

%some sample code for NC, NFV and XSA
% [r,p] = plot4report(dNC,flatten_nrem2,'\DeltaNC, %','Flow-limited Inspirations, %',1)
% [r,p] = plot4report(Pct_diff_NC2,flatten2,'\DeltaNC,mm','Flow-limited Inspirations, %',1)
% [r,p] = plot4report(dXSA(3:end),flatten_nrem2(3:end),'\DeltaUA-XSA, %','Flow-limited Inspirations, %',1)
% [r,p] = plot4report(dNFV,flatten_nrem2,'\DeltaNFV, %','Flow-limited Inspirations, %',1)
% [r,p] = plot4report(PreXSA(3:end),flatten(3:end),'Baseline UA-XSA, mm^{2}','Flow-limited Inspirations, %',1)

%conceal the ticks and axis
% this will remove the lines/tick marks
%      box off;
%      set(gca,'xcolor',get(gcf,'color'));
%      set(gca,'xtick',[]);

% this will remove labels/title as well
%      set(gca,'visible','off');
%      pause;
%      set(gca,'visible','on');

%add labels
% xlabel('-2\pi < x < 2\pi') % x-axis label
% ylabel('sine and cosine values') % y-axis label