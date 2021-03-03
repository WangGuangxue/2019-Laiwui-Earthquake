% Orbit difference analysis 
%%
Ne_mean=mean(Select_data(:,8));
Te_mean = mean(Select_data(:,9));
%% Ascending
figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%ºá×Ý×ø±êÖáÎ»ÖÃ
geoshow('landareas.shp', 'FaceColor', 'none');
 hold on
scatterm(select_day_data_0712(:,7),select_day_data_0712(:,6),25,(select_day_data_0712(:,8)-Ne_mean)/Ne_mean,'filled')
scatterm(select_day_data_0713(:,7),select_day_data_0713(:,6),25,(select_day_data_0713(:,8)-Ne_mean)/Ne_mean,'filled')
scatterm(select_day_data_0711(:,7),select_day_data_0711(:,6),25,(select_day_data_0711(:,8)-Ne_mean)/Ne_mean,'filled')
scatterm(select_day_data_0710(:,7),select_day_data_0710(:,6),25,(select_day_data_0710(:,8)-Ne_mean)/Ne_mean,'filled')
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
cb = colorbar('vertical','Ticks',[-1,-0.5,0,0.5,1],'ticklabels',{'-100%','-50%','0','50%','100%'});
%% Descending
figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%ºá×Ý×ø±êÖáÎ»ÖÃ
geoshow('landareas.shp', 'FaceColor', 'none');
hold on

scatterm(select_day_data_0710(:,7),select_day_data_0710(:,6),25,(select_day_data_0710(:,8)-Ne_mean)/Ne_mean,'filled')
scatterm(select_day_data_0711(:,7),select_day_data_0711(:,6),25,(select_day_data_0711(:,8)-Ne_mean)/Ne_mean,'filled')
scatterm(select_day_data_0712(:,7),select_day_data_0712(:,6),25,(select_day_data_0712(:,8)-Ne_mean)/Ne_mean,'filled')
scatterm(select_day_data_0713(:,7),select_day_data_0713(:,6),25,(select_day_data_0713(:,8)-Ne_mean)/Ne_mean,'filled')

%%
plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
circlem(Eq_lat,Eq_lon,1248)

set(gca,'Clim',[-1.5,1.5])
cb = colorbar('vertical','Ticks',[-1.5,-1,-0.5,0,0.5,1,1.5],'ticklabels',{'-150%','-100%','-50%','0','50%','100%','150%'});
title('Deviation of NE (Descending Orbits)','fontname','times new roman','fontsize',15)
% title('Electron Density (Ascending Orbits)','fontname','times new roman','fontsize',15)