% CSES-LAP space difference analysis
% LAP_Data process
% 2021-03-03 WangGuangxue Updated
%%  Read the data(.txt)  BEGIN!
filepath = 'E:\MATLAB\Mycode\Reserch\NNE_of_Laiwui_EQ\LAP_data';
data_list = dir([filepath,'\*.txt']);%READ the file(.txt)
num_file = length(data_list);
data = [];

for k = 1: num_file
    data_import = importdata(data_list(k).name);
    data = [data;data_import]; 
end
%% Initial
% Location of 2019 Laiwui Earthquake 
Eq_lat = -0.52;
Eq_lon = 128.17;

nStartLat = Eq_lat-15;
nEndLat = Eq_lat+15;
nStartLon = Eq_lon-15;
nEndLon = Eq_lon+15;

%% Selecting the data of 14th JUNE to 14th JULY which is 30 days before the EQ
%% Selecting the data of JUNE 14th-30th
Select_data_JUNE = []; % JUNE 14th-30th
for j = 1:length(data)
    
if ( (data(j,7) >= nStartLat) && (data(j,7) <= nEndLat) && (data(j,6) >= nStartLon) && (data(j,6) <= nEndLon) && data(j,2) == 1)%data(j,2) == 1 orbit_on
    
      if data(j,4) == 6 && data(j,5) >= 14
            Select_data_JUNE = [Select_data_JUNE;data(j,:)];
      end    
      
end

end
%% Selecting the data of JULY 1st- 14th
Select_data_JULY = []; % JULY 1st- 14th
for j = 1:length(data)
    
if ((data(j,7) >= nStartLat) && (data(j,7) <= nEndLat) && (data(j,6) >= nStartLon) && (data(j,6) <= nEndLon) && data(j,2) == 1)
    
      if data(j,4) == 7 && data(j,5) <= 14
            Select_data_JULY=[Select_data_JULY;data(j,:)];
      end
end

end
%% The data 30d before the EQ
% Adding Select_data1 and Select_data2 
Select_data_30d_before = [Select_data_JUNE;Select_data_JULY];
%% Delete the data with -99999 which is not useful
[c,~] = size(Select_data_30d_before);
Select_data = [];

for i = 1:c
    
    if Select_data_30d_before(i,8) ~= -99999
        Select_data = [Select_data;Select_data_30d_before(i,:)];       
    end  
    
end
%% Lap_data READ DONE!



%% Lap_data process BEGIN!
%% orbit_overview 
% test if the orbit is right or not
figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');

hold on
plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
plotm( Select_data(:,7), Select_data(:,6),'.k')
%%  calcing back ground BEGIN!
%经纬度网格划分精度
% nStartLat = Eq_lat-15;
% nEndLat = Eq_lat+15;
% nStartLon = Eq_lon-15;
% nEndLon = Eq_lon+15;
% Eq_lat = -0.52;
% Eq_lon = 128.17;


nSplitLat = 1;
nSplitLon = 2;
% nSplitLat = 2;
% nSplitLon = 4;

nLon1 = nStartLon :nSplitLon:nEndLon;

nLat1 = -15 :nSplitLat:15;
% important

[X1,Y1] = meshgrid(nLon1,nLat1');
[nY1Len,nX1Len] = size(X1);
Z1 = NaN(nY1Len,nX1Len);  
%% Calc background value in each cell

[c,~] = size(Select_data);
[e,f] = size(X1);
sum_Ne = zeros(1,e*f);
sum_Te = zeros(1,e*f);
anv_Te = zeros(1,e*f); 
anv_Ne = zeros(1,e*f);
Ne_std = zeros(1,e*f);
Te_std = zeros(1,e*f);

count = zeros(1,e*f); % Every count in each cell
count1 = 0; % Count1 in count


for lon = nStartLon :nSplitLon:nEndLon   
    for lat = nEndLat : -nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0; % For calc the median
        matrix4std_Ne = [];
        matrix4std_Te = [];
        for i = 1: c          
            if  (Select_data(i,6) >= lon )  && (Select_data(i,6) < lon + nSplitLon ) && (Select_data(i,7) >= lat )  && (Select_data(i,7) < lat + nSplitLat )
                ct = ct + 1;
                sum_Ne(1,count1) = sum_Ne(1,count1) + Select_data(i,8);
                sum_Te(1,count1) = sum_Te(1,count1) + Select_data(i,9);
                matrix4std_Ne = [matrix4std_Ne;Select_data(i,8)];
                matrix4std_Te = [matrix4std_Te;Select_data(i,9)];
            end
            
            count(1,count1) = ct;
            
            anv_Te(1,count1) = sum_Te(1,count1) / ct;
            anv_Ne(1,count1) = sum_Ne(1,count1) / ct;
            Ne_std(1,count1) = std(matrix4std_Ne);
            Te_std(1,count1) = std(matrix4std_Te);
        end
    end  
end
%% Changing the one-dimensional anv_Ne(Te) into two-dimensional value_Ne(Te) of Background
% And they are both medians

[e,f] = size(X1);
value_Ne = zeros(e,f);
value_Te = zeros(e,f);
value_Ne_std = zeros(e,f);
value_Te_std = zeros(e,f);

for i = 1:e 
    
    for j = 1:f 
        value_Ne(i,j) = anv_Ne((j-1)*e + i);
        value_Te(i,j) = anv_Te((j-1)*e + i);
        value_Ne_std(i,j) = Ne_std((j-1)*e + i);
        value_Te_std(i,j) = Te_std((j-1)*e + i);
    end
    
end
%%
figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,value_Ne ,'DisplayType', 'texturemap','FaceColor','flat');

cb = colorbar('vertical');
plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
plotm(Select_data(:,7), Select_data(:,6),'.k')
%% Calc background DONE!

%% Finding certain day data 0710,0711,0712,0713
%%  Finding the data of day 0713
select_day_data_0713 = [];
[q,~] = size(Select_data);
 
 for g = 1:q
     
        if (Select_data(g,4) == 7) && (Select_data(g,5) == 13) 
            select_day_data_0713 = [select_day_data_0713;Select_data(g,:)];
        end
        
 end
 %%
 
% nStartLat = Eq_lat-15;
% nEndLat = Eq_lat+15;
% nStartLon = Eq_lon-15;
% nEndLon = Eq_lon+15;

nSplitLat = 1;
nSplitLon = 2;
% nSplitLat = 2;
% nSplitLon = 4;

nLon1 = nStartLon :nSplitLon:nEndLon;

nLat1 = 15 :-nSplitLat:-15;
% important
[X1,Y1] = meshgrid(nLon1,nLat1');
[nY1Len,nX1Len] = size(X1);
Z1 = NaN(nY1Len,nX1Len);  
%% Choosing the centain day:0713 
% The same thounghts as Calc each value in every cell
 
[c,~] = size(select_day_data_0713);
[e,f] = size(X1);

sum_Ne_day_0713 = zeros(1,e*f);
sum_Te_day_0713 = zeros(1,e*f);
anv_Te_day_0713 = zeros(1,e*f);
anv_Ne_day_0713 = zeros(1,e*f);
count_day_0713 = zeros(1,e*f);
count1 = 0;

for lon = nStartLon :nSplitLon:nEndLon   
    for lat = nEndLat :-nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0;
        for i = 1: c          
            if  ( select_day_data_0713(i,6) >= lon )  && (select_day_data_0713(i,6) < lon + nSplitLon ) && (select_day_data_0713(i,7) >= lat )  && (select_day_data_0713(i,7) < lat + nSplitLat  )
                ct = ct + 1;
                sum_Ne_day_0713(1,count1) = sum_Ne_day_0713(1,count1) + select_day_data_0713(i,8);
                sum_Te_day_0713(1,count1) = sum_Te_day_0713(1,count1) + select_day_data_0713(i,9);
            end
            count(1,count1) = ct;
            anv_Te_day_0713(1,count1) = sum_Te_day_0713(1,count1) / ct;
            anv_Ne_day_0713(1,count1) = sum_Ne_day_0713(1,count1) / ct;
        end
    end  
end
%% Changing the one-dimensional anv_Ne(Te)_day into two-dimensional value_Ne(Te)_day

value_Ne_day_0713 = zeros(e,f);
value_Te_day_0713 = zeros(e,f);
[e,f] = size(X1);

for i = 1:e
    
    for j = 1:f
        value_Ne_day_0713(i,j) = anv_Ne_day_0713((j-1)*e + i);
        value_Te_day_0713(i,j) = anv_Te_day_0713((j-1)*e + i);
    end
    
en
%% Find data 0713 Done!
%% PLotting day 0713
 figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,(value_Te_day_0713 - value_Te) ./ value_Te_std,'DisplayType', 'texturemap','FaceColor','flat');
 
cb = colorbar('vertical');
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
 plotm(select_day_data_0713(:,7), select_day_data_0713(:,6),'.k')
 hold on 
 title('0713Ne');

%%  Finding data of day:0711
select_day_data_0711 = [];
 [q,~] = size(Select_data);
 for g = 1:q
        if (Select_data(g,4) == 7) && (Select_data(g,5) == 11) 
            select_day_data_0711 = [select_day_data_0711;Select_data(g,:)];
        end
 end
 %%
 %经纬度网格划分精度
% nStartLat = Eq_lat-15;
% nEndLat = Eq_lat+15;
% nStartLon = Eq_lon-15;
% nEndLon = Eq_lon+15;
nSplitLat = 1;
nSplitLon = 2;
% nSplitLat = 2;
% nSplitLon = 4;

nLon1 = nStartLon :nSplitLon:nEndLon;

nLat1 = 15 :-nSplitLat:-15 ;
% important
[X1,Y1]=meshgrid(nLon1,nLat1');
[nY1Len,nX1Len]= size(X1);
Z1 = NaN(nY1Len,nX1Len);  
 %%
[c,~] = size(select_day_data_0711);
[e,f] = size(X1);
sum_Ne_day_0711 = zeros(1,e*f);
sum_Te_day_0711 = zeros(1,e*f);
anv_Te_day_0711 = zeros(1,e*f);
anv_Ne_day_0711 = zeros(1,e*f);
count_day_0711 = zeros(1,e*f);
count1 = 0;
for lon = nStartLon :nSplitLon:nEndLon   
    for lat =  nEndLat : -nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0;
        for i = 1: c          
            if  (select_day_data_0711(i,6) >= lon)  && (select_day_data_0711(i,6) < lon + nSplitLon ) && (select_day_data_0711(i,7) >= lat)  && (select_day_data_0711(i,7) < lat + nSplitLat )
                ct = ct + 1;
                sum_Ne_day_0711(1,count1) = sum_Ne_day_0711(1,count1) + select_day_data_0711(i,8);
                sum_Te_day_0711(1,count1) = sum_Te_day_0711(1,count1) + select_day_data_0711(i,9);
            end
            count(1,count1) = ct;
            anv_Te_day_0711(1,count1) = sum_Te_day_0711(1,count1) / ct;
            anv_Ne_day_0711(1,count1) = sum_Ne_day_0711(1,count1) / ct;
        end
    end  
end
%%
value_Ne_day_0711 = zeros(e,f);
value_Te_day_0711 = zeros(e,f);
for i = 1:e
    for j = 1:f
        value_Ne_day_0711(i,j) = anv_Ne_day_0711((j-1)*e + i);
        value_Te_day_0711(i,j) = anv_Te_day_0711((j-1)*e + i);
    end
end
%%  Finding data of day:0711 DONE!
%% Plotting data 0711
 figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,(value_Te_day_0711 - value_Te)/stdTe,'DisplayType', 'texturemap','FaceColor','flat');
cb = colorbar('vertical');
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
 plotm( select_day_data_0711(:,7), select_day_data_0711(:,6),'.k')
 title('0711');
%% Finding data of day:0712
select_day_data_0712 = [];
 [q,~] = size(Select_data);
 for g = 1:q
        if (Select_data(g,4) == 7) && (Select_data(g,5) == 12) 
            select_day_data_0712 = [select_day_data_0712;Select_data(g,:)];
        end
 end
 %%
 %经纬度网格划分精度
% nStartLat = Eq_lat-15;
% nEndLat = Eq_lat+15;
% nStartLon = Eq_lon-15;
% nEndLon = Eq_lon+15;
nSplitLat = 1;
nSplitLon = 2;
% nSplitLat = 2;
% nSplitLon = 4;

nLon1 = nStartLon :nSplitLon:nEndLon;

nLat1 = 15 :-nSplitLat:-15 ;
% important
[X1,Y1]=meshgrid(nLon1,nLat1');
[nY1Len,nX1Len]= size(X1);
Z1 = NaN(nY1Len,nX1Len);  
 %%
[c,~] = size(select_day_data_0712);
[e,f] = size(X1);
sum_Ne_day_0712 = zeros(1,e*f);
sum_Te_day_0712 = zeros(1,e*f);
anv_Te_day_0712 = zeros(1,e*f);
anv_Ne_day_0712 = zeros(1,e*f);
count_day_0712= zeros(1,e*f);
count1 = 0;
for lon = nStartLon :nSplitLon:nEndLon   
    for lat =  nEndLat : -nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0;
        for i = 1: c          
            if  (select_day_data_0712(i,6) >= lon)  && (select_day_data_0712(i,6) < lon + nSplitLon ) && (select_day_data_0712(i,7) >= lat)  && (select_day_data_0712(i,7) < lat + nSplitLat )
                ct = ct + 1;
                sum_Ne_day_0712(1,count1) = sum_Ne_day_0712(1,count1) + select_day_data_0712(i,8);
                sum_Te_day_0712(1,count1) = sum_Te_day_0712(1,count1) + select_day_data_0712(i,9);
            end
            count(1,count1) = ct;
            anv_Te_day_0712(1,count1) = sum_Te_day_0712(1,count1) / ct;
            anv_Ne_day_0712(1,count1) = sum_Ne_day_0712(1,count1) / ct;
        end
    end  
end
%%
value_Ne_day_0712 = zeros(e,f);
value_Te_day_0712 = zeros(e,f);
for i = 1:e
    for j = 1:f
        value_Ne_day_0712(i,j) = anv_Ne_day_0712((j-1)*e + i);
        value_Te_day_0712(i,j) = anv_Te_day_0712((j-1)*e + i);
    end
end
%% Finding data of day:0712 DONE!
%% plotting data 0712
 figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,(value_Te_day_0712 - value_Te)/stdTe,'DisplayType', 'texturemap','FaceColor','flat');
cb = colorbar('vertical','Ticks',[-1.5,-1,-0.5,0,0.5,1,1.5],'ticklabels',{'-150%','-100%','-50%','0','50%','100%','150%'});
title('Deviation of TE (Descending Orbits)','fontname','times new roman','fontsize',15)
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
 plotm( select_day_data_0712(:,7), select_day_data_0712(:,6),'.k')
 title('0712');
%% Finding data of day:0710
select_day_data_0710 = [];
 [q,~] = size(Select_data);
 for g = 1:q
        if (Select_data(g,4) == 7) && (Select_data(g,5) == 12) 
            select_day_data_0710 = [select_day_data_0710;Select_data(g,:)];
        end
 end
 %%
 %经纬度网格划分精度
% nStartLat = Eq_lat-15;
% nEndLat = Eq_lat+15;
% nStartLon = Eq_lon-15;
% nEndLon = Eq_lon+15;
nSplitLat = 1;
nSplitLon = 2;
% nSplitLat = 2;
% nSplitLon = 4;

nLon1 = nStartLon :nSplitLon:nEndLon;

nLat1 = 15 :-nSplitLat:-15 ;
% important
[X1,Y1]=meshgrid(nLon1,nLat1');
[nY1Len,nX1Len]= size(X1);
Z1 = NaN(nY1Len,nX1Len);  
 %%
[c,~] = size(select_day_data_0710);
[e,f] = size(X1);
sum_Ne_day_0710 = zeros(1,e*f);
sum_Te_day_0710 = zeros(1,e*f);
anv_Te_day_0710 = zeros(1,e*f);
anv_Ne_day_0710 = zeros(1,e*f);
count_day_0710 = zeros(1,e*f);
count1 = 0;
for lon = nStartLon :nSplitLon:nEndLon   
    for lat =  nEndLat : -nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0;
        for i = 1: c          
            if  (select_day_data_0710(i,6) >= lon)  && (select_day_data_0710(i,6) < lon + nSplitLon ) && (select_day_data_0710(i,7) >= lat)  && (select_day_data_0710(i,7) < lat + nSplitLat )
                ct = ct + 1;
                sum_Ne_day_0710(1,count1) = sum_Ne_day_0710(1,count1) + select_day_data_0710(i,8);
                sum_Te_day_0710(1,count1) = sum_Te_day_0710(1,count1) + select_day_data_0710(i,9);
            end
            count(1,count1) = ct;
            anv_Te_day_0710(1,count1) = sum_Te_day_0710(1,count1) / ct;
            anv_Ne_day_0710(1,count1) = sum_Ne_day_0710(1,count1) / ct;
        end
    end  
end
%%
value_Ne_day_0710 = zeros(e,f);
value_Te_day_0710 = zeros(e,f);
for i = 1:e
    for j = 1:f
        value_Ne_day_0710(i,j) = anv_Ne_day_0710((j-1)*e + i);
        value_Te_day_0710(i,j) = anv_Te_day_0710((j-1)*e + i);
    end
end
%% Finding data of day:0710
%% plotting data 0710
 figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,(value_Te_day_0710 - value_Te)/stdTe,'DisplayType', 'texturemap','FaceColor','flat');
cb = colorbar('vertical');
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
 plotm( select_day_data_0710(:,7), select_day_data_0710(:,6),'.k')
 title('0710');