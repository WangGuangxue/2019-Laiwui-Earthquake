% CSES-PAP space difference analysis
% Data process
% 2020-11-27 WangGuangxue 
% 2021-03-03 WangGuangxue Updated
% Because the pap_data is different from lap _data 
% So we choose the other way to converting into .txt
clear
clc
%%   
pap_filepath = 'E:\Projects\EQ\Yahama\PAP\PAP\';
pap_data_parent_list = dir(pap_filepath);
pap_num_file_parent1= length(pap_data_parent_list);
%%
pap_data_parent_list = pap_data_parent_list(3:pap_num_file_parent1,:);
pap_num_file_parent = length(pap_data_parent_list);
pap_file = strcat({pap_data_parent_list.name});
%%
   for a = 1: pap_num_file_parent
    % For the 1st time you run the code 
    % The next sentence is necessary
    % But if you have run before
    % Do Not Forget to commentary the sentense
    
    
%         pap_file(a) = strcat(pap_filepath,pap_file(a),'\',pap_file(a),'.h5');

    
        filename = cell2mat(pap_file(a));
        A = h5read(filename,'/UTC_TIME');
        data = zeros(length(A),16); % Setting a matrix to save name of the orbit, mode of the orbit, time of the orbot and parameter of TEC
        
        year = floor(A / (1.0e+13));   % Time of the orbit(year)

        month = floor(A / (1.0e+11)) - year * (1.0e+2);    % Time of the orbit(year)

        day = floor(A / (1.0e+9)) - year * (1.0e+4) - month * (1.0e+2);    % Time of the orbit(day)
        hour = floor(A / (1.0e+7)) - year * (1.0e+6) - month * (1.0e+4) - day * (1.0e+2);  % Time of the orbit(hour)
        minute = floor(A / (1.0e+5)) - year * (1.0e+8) - month * (1.0e+6) - day * (1.0e+4) - hour * (1.0e+2);  % Time of the orbit(minute)            
        second = floor(A / (1.0e+3)) - year * (1.0e+10) - month * (1.0e+8) - day * (1.0e+6) - hour * (1.0e+4) - minute * (1.0e+2); % Time of the orbit(second)           
        millisecond = 10*(floor(A /(1.0e+1)) - year * (1.0e+12) - month * (1.0e+10) - day * (1.0e+8) - hour * (1.0e+6) - minute * (1.0e+4) - second * (1.0e+2));   % Time of the orbit(millisecond)

         for r = 1:length(A)
                  if hour(r) == 24
                      hour(r) = hour(r) -1;
                      minute(r) = minute(r) + 100;
                  end
         end
         for j = 1:length(A)
                  if minute(j) < 0
                      minute(j) = minute(j) + 100;
                      hour(r) = hour(r) -1;
                  end
         end
         for k = 1:length(A)
                 if second(k) < 0
                     second(k) = second(k) + 100;
                     minute(k) = minute(k) - 1;
                 end
         end
         for v = 1:length(A)
                 if millisecond(v) < 0
                     millisecond(v) = millisecond(v) + 1000;
                     second(v) = second(v) -1;
                 end
         end
         
        data(1:length(A),1) = str2double(filename(53:57));  % orbit
        data(1:length(A),2) = str2double(filename(57)); %Éý½µ¹ìµÀ
        data(1:length(A),3) = year;
        data(1:length(A),4) = month;
        data(1:length(A),5) = day;
        data(1:length(A),6) = hour;
        data(1:length(A),7) = minute;
        data(1:length(A),8) = second;
        data(1:length(A),9) = millisecond;
        data(1:length(A),10) = h5read(filename,'/GEO_LON');     % The Geo_longitude
        data(1:length(A),11) = h5read(filename,'/GEO_LAT');     % The Geo_Latitude       
        data(1:length(A),12) = h5read(filename,'/A313');    % H
        data(1:length(A),13) = h5read(filename,'/A314');    % He
        data(1:length(A),14) = h5read(filename,'/A315');    % O
        data(1:length(A),15) = h5read(filename,'/A322');    % Tempereture ion
        data(1:length(A),16) = h5read(filename,'/A317');    % £¨¦¤Ni/Ni£©
%         data(1:length(A),17) = h5read(filename,'/WORKMODE'); 
                      
          filename1 = strcat(strcat('E:\MATLAB\Mycode\Reserch\NNE_of_Laiwui_EQ\PAPothers\',filename(95:end-3)),'.txt'); 
    
          file_id = fopen(filename1,'a+');
          dlmwrite(filename1,data,'\t');
          fclose(file_id);
        
  end










