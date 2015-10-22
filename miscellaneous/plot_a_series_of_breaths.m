%which subject??
tt = t-5535;
figure
plot(tt(168:1540),nasalP_g(168:1540),'Markersize',7,'Linewidth',1.5,'Color','b','MarkerFaceColor','k')
hold on
plot(tt(168:1540),nasalPincr(168:1540),'Markersize',7,'Linewidth',1,'Color','r','MarkerFaceColor','k')
legend('filtered','original');
hline = refline(0,0);
set(hline,'Color','k')
hold off
set(gca,'Fontsize',16,'Fontweight','Bold')
ax = 'Time[s]';
ay = 'Nasal airflow';
set(xlabel(ax),'Fontsize',16,'Fontweight','Bold')
set(ylabel(ay),'Fontsize',16,'Fontweight','Bold')
