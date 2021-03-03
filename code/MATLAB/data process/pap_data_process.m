% CSES-LAP space difference analysis
% Data process
% Author:WangGuangxue wongguangxue@gmail.com 2020-11-27
% 2021-03-03 WangGuangxue Updated
%%
pap_filepath = 'E:\MATLAB\Mycode\Reserch\NNE_of_Laiwui_EQ\PAP_data\PAP_0614_0714';
pap_data_list = dir([pap_filepath,'\*.txt']);%READ the file(.txt)
pap_num_file = length(pap_data_list);
pap_data = [];

for a = 1: pap_num_file
    %location = h5read([filepath filename(k).name],'/LonLat');
    pap_data1 = importdata(pap_data_list(a).name);
    pap_data = [pap_data;pap_data1]; 
end

%% Data selection
Eq_lat = -0.52;
Eq_lon = 128.17;

nStartLat = Eq_lat-20;
nEndLat = Eq_lat+20;
nStartLon = Eq_lon-20;
nEndLon = Eq_lon+20;
%% Selecting the data of JUNE 14th-30th
pap_Select_data1 = []; % JUNE 14th-30th
for j = 1:length(pap_data)
    
if ( (pap_data(j,11) >= nStartLat) && (pap_data(j,11) <= nEndLat) && (pap_data(j,10) >= nStartLon) && (pap_data(j,10) <= nEndLon))%data(j,2) == 1 orbit_on
    
      if pap_data(j,4) == 6 && pap_data(j,5) >= 14
            pap_Select_data1 = [pap_Select_data1;pap_data(j,:)];
      end
     
end

end
%% Selecting the data of JULY 1st- 14th
pap_Select_data2 = []; % JULY 1st- 14th
for j = 1:length(pap_data)
    
if ((pap_data(j,11) >= nStartLat) && (pap_data(j,11) <= nEndLat) && (pap_data(j,10) >= nStartLon) && (pap_data(j,10) <= nEndLon))
    
      if pap_data(j,4) == 7 && pap_data(j,5) <= 14
            pap_Select_data2=[pap_Select_data2;pap_data(j,:)];
      end
end

end
%% The data 30d before the EQ
% Adding Select_data1 and Select_data2 
pap_Select1_data = [pap_Select_data1;pap_Select_data2];
%%  Delete the data with -99999

% Here we need to change the factor

% [c,~] = size(pap_Select1_data);
%  pap_Select_data = [];
% 
% for i = 1:c
%     
%     if Select1_data(i,8) ~= -99999
%         pap_Select_data = [pap_Select_data;pap_Select1_data(i,:)];       
%     end  
%     
% end
 pap_Select_data = pap_Select1_data;

%% orbit_overview
%f1 = figure(1)
figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
 hold on
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
 plotm( pap_Select_data(:,11), pap_Select_data(:,10),'.k')
 
 %%  back ground
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

nLat1 = -20 :nSplitLat:20;
% important

[X1,Y1] = meshgrid(nLon1,nLat1');
[nY1Len,nX1Len] = size(X1);
Z1 = NaN(nY1Len,nX1Len);  
%% Calc value in each cell

[c,~] = size(pap_Select_data);
[e,f] = size(X1);

sum_H = zeros(1,e*f);
sum_He = zeros(1,e*f);
sum_O = zeros(1,e*f);
sum_Ti = zeros(1,e*f);

anv_H = zeros(1,e*f); 
anv_He = zeros(1,e*f);
anv_O = zeros(1,e*f); 
anv_Ti = zeros(1,e*f); 

H_std = zeros(1,e*f);
He_std = zeros(1,e*f);
O_std = zeros(1,e*f);
Ti_std = zeros(1,e*f);

count = zeros(1,e*f); % Every count in each cell
count1 = 0; % Count1 in count


for lon = nStartLon :nSplitLon:nEndLon   
    for lat = nEndLat : -nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0; % For calc the median
        matrix4std_H = []; % For calc the std value
        matrix4std_He = [];
        matrix4std_O = [];
        matrix4std_Ti = [];
        for i = 1: c          
            if  (pap_Select_data(i,10) >= lon )  && (pap_Select_data(i,10) < lon + nSplitLon ) && (pap_Select_data(i,11) >= lat )  && (pap_Select_data(i,11) < lat + nSplitLat )
                ct = ct + 1;
                
                sum_H(1,count1) = sum_H(1,count1) + pap_Select_data(i,12);
                sum_He(1,count1) = sum_He(1,count1) + pap_Select_data(i,13);
                sum_O(1,count1) = sum_O(1,count1) + pap_Select_data(i,14);
                sum_Ti(1,count1) = sum_Ti(1,count1) + pap_Select_data(i,15);
                
                matrix4std_H = [matrix4std_H;pap_Select_data(i,12)];
                matrix4std_He = [matrix4std_He;pap_Select_data(i,13)];
                matrix4std_O = [matrix4std_O;pap_Select_data(i,14)];
                matrix4std_Ti = [matrix4std_Ti;pap_Select_data(i,15)];
            end
            count(1,count1) = ct;
            
            anv_H(1,count1) = sum_H(1,count1) / ct;
            anv_He(1,count1) = sum_He(1,count1) / ct;
            anv_O(1,count1) = sum_O(1,count1) / ct;
            anv_Ti(1,count1) = sum_Ti(1,count1) / ct;
            
            H_std(1,count1) = std(matrix4std_H);
            He_std(1,count1) = std(matrix4std_He);
            O_std(1,count1) = std(matrix4std_O);
            Ti_std(1,count1) = std(matrix4std_He);
        end
    end  
end
%% Changing the one-dimensional anv_Ne(Te) into two-dimensional value_Ne(Te)
% And they are both medians

[e,f] = size(X1);
pap_value_H = zeros(e,f);
pap_value_He = zeros(e,f);
pap_value_O = zeros(e,f);
pap_value_Ti = zeros(e,f);

pap_value_H_std = zeros(e,f);
pap_value_He_std = zeros(e,f);
pap_value_O_std = zeros(e,f);
pap_value_Ti_std = zeros(e,f);

for i = 1:e 
    
    for j = 1:f 
        value_H(i,j) = anv_H((j-1)*e + i);
        value_He(i,j) = anv_He((j-1)*e + i);
        value_O(i,j) = anv_O((j-1)*e + i);
        value_Ti(i,j) = anv_Ti((j-1)*e + i);
        
        value_H_std(i,j) = H_std((j-1)*e + i);
        value_He_std(i,j) = He_std((j-1)*e + i);
        value_O_std(i,j) = O_std((j-1)*e + i);
        value_Ti_std(i,j) = Ti_std((j-1)*e + i);
    end
    
end
%%
figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,value_O,'DisplayType', 'texturemap','FaceColor','flat');
cb = colorbar('vertical');
plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
plotm(pap_Select_data(:,11), pap_Select_data(:,10),'.k')
 % back ground done
 %%  Finding the data of day 0713
 
pap_select_day_data_0713 = [];
 [q,~] = size(pap_Select_data);
 
 for g = 1:q
     
        if (pap_Select_data(g,4) == 7) && (pap_Select_data(g,5) == 13) 
            pap_select_day_data_0713 = [pap_select_day_data_0713;pap_Select_data(g,:)];
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

nLat1 = 20 :-nSplitLat:-20;
% important
[X1,Y1] = meshgrid(nLon1,nLat1');
[nY1Len,nX1Len] = size(X1);
Z1 = NaN(nY1Len,nX1Len);  

%% Choosing the centain day:0713 
% The same thounghts as Calc each value in every cell
 
[c,~] = size(pap_select_day_data_0713);
[e,f] = size(X1);

sum_H_day_0713 = zeros(1,e*f);
sum_He_day_0713 = zeros(1,e*f);
sum_O_day_0713 = zeros(1,e*f);
sum_Ti_day_0713 = zeros(1,e*f);

anv_H_day_0713 = zeros(1,e*f);
anv_He_day_0713 = zeros(1,e*f);
anv_O_day_0713 = zeros(1,e*f);
anv_Ti_day_0713 = zeros(1,e*f);

count_day_0713 = zeros(1,e*f);
count1 = 0;

for lon = nStartLon :nSplitLon:nEndLon   
    for lat = nEndLat :-nSplitLat: nStartLat
        count1 = count1 + 1;
        ct = 0;
        for i = 1: c          
            if  ( pap_select_day_data_0713(i,10) >= lon )  && (pap_select_day_data_0713(i,10) < lon + nSplitLon ) && (pap_select_day_data_0713(i,11) >= lat )  && (pap_select_day_data_0713(i,11) < lat + nSplitLat  )
                ct = ct + 1;
                sum_H_day_0713(1,count1) = sum_H_day_0713(1,count1) + pap_select_day_data_0713(i,12);
                sum_He_day_0713(1,count1) = sum_He_day_0713(1,count1) + pap_select_day_data_0713(i,13);
                sum_O_day_0713(1,count1) = sum_O_day_0713(1,count1) + pap_select_day_data_0713(i,14);
                sum_Ti_day_0713(1,count1) = sum_Ti_day_0713(1,count1) + pap_select_day_data_0713(i,15);
            end
            count(1,count1) = ct;
            anv_H_day_0713(1,count1) = sum_H_day_0713(1,count1) / ct;
            anv_He_day_0713(1,count1) = sum_He_day_0713(1,count1) / ct;
            anv_O_day_0713(1,count1) = sum_O_day_0713(1,count1) / ct;
            anv_Ti_day_0713(1,count1) = sum_Ti_day_0713(1,count1) / ct;
        end
    end  
end
%% Changing the one-dimensional anv_Ne(Te)_day into two-dimensional value_Ne(Te)_day

value_H_day_0713 = zeros(e,f);
value_He_day_0713 = zeros(e,f);
value_O_day_0713 = zeros(e,f);
value_Ti_day_0713 = zeros(e,f);
[e,f] = size(X1);

for i = 1:e
    
    for j = 1:f
        value_H_day_0713(i,j) = anv_H_day_0713((j-1)*e + i);
        value_He_day_0713(i,j) = anv_He_day_0713((j-1)*e + i);
        value_O_day_0713(i,j) = anv_O_day_0713((j-1)*e + i);
        value_Ti_day_0713(i,j) = anv_Ti_day_0713((j-1)*e + i);
    end
    
end
 %%
 figure('Position',[40,40,900,600],'Visible','on');
colormap Jet
ax = usamap([nStartLat,nEndLat],[nStartLon,nEndLon]);
setm(ax,'PLabelMeridian','west','MLabelParallel','south');%横纵坐标轴位置
geoshow('landareas.shp', 'FaceColor', 'none');
hold on
geoshow(Y1,X1,(value_O_day_0713 - value_O) ./ value_O,'DisplayType', 'texturemap','FaceColor','flat');
 
cb = colorbar('vertical');
 plotm(Eq_lat,Eq_lon,'rp','MarkerFaceColor','r','LineWidth',2 )
 plotm(pap_select_day_data_0713(:,11), pap_select_day_data_0713(:,10),'.k')
 hold on 
 title('0713 O');