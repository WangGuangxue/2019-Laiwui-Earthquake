% This code is for converting data    .h5 -> .txt
% 2020-11-11 WangGuangxue  1st
% 2021-03-03 WangGuangxue Updated

clear
clc

filepath = 'E:\Projects\EQ\Yahama\CSES£ßLAP\';   % The path of the dir
File = dir(fullfile(filepath,'*.h5'));  % Get the name of document(ending with (.h5))
Filename = strcat({File.name}); 
L = length(Filename);
Eq_lat = -0.52;     % Eq latitude
Eq_lon = 128.17;    % Eq longitude
format long;    % Setting the format
    
for i=1:L

     
        filename = fullfile(filepath,Filename{1,i});   % Saving each name of the document in the dir path
        
        A = h5read(filename,'/UTC_TIME');   % For calculating the length and calculating year, month, day, minute, second and millisecond  
        
        data = zeros(length(A),13); % Setting a matrix to save name of the orbit, mode of the orbit, time of the orbot and parameter of TEC
        
        year = floor(A / (1.0e+13));   % Time of the orbit(year)
        month = floor(A / (1.0e+11)) - year * (1.0e+2);    % Time of the orbit(year)
        day = floor(A / (1.0e+9)) - year * (1.0e+4) - month * (1.0e+2);    % Time of the orbit(day)
        hour = floor(A / (1.0e+7)) - year * (1.0e+6) - month * (1.0e+4) - day * (1.0e+2);  % Time of the orbit(hour)
        minute = floor(A / (1.0e+5)) - year * (1.0e+8) - month * (1.0e+6) - day * (1.0e+4) - hour * (1.0e+2);  % Time of the orbit(minute)            
        second = floor(A / (1.0e+3)) - year * (1.0e+10) - month * (1.0e+8) - day * (1.0e+6) - hour * (1.0e+4) - minute * (1.0e+2); % Time of the orbit(second)           
        millisecond = 10*(floor(A /(1.0e+1)) - year * (1.0e+12) - month * (1.0e+10) - day * (1.0e+8) - hour * (1.0e+6) - minute * (1.0e+4) - second * (1.0e+2));   % Time of the orbit(millisecond)

        % The loops (varition of <r,j,k,v>) used for solving the negative number in time
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
         
        data(1:length(A),1) = str2double(filename(53:end-39));  % orbit
        data(1:length(A),2) = str2double(filename(58)); %Éý½µ¹ìµÀ
        data(1:length(A),3) = year;
        data(1:length(A),4) = month;
        data(1:length(A),5) = day;
        data(1:length(A),10) = hour;
        data(1:length(A),11) = minute;
        data(1:length(A),12) = second;
        data(1:length(A),13) = millisecond;
        data(1:length(A),6) = h5read(filename,'/GEO_LON');     % The Geo_longitude
        data(1:length(A),7) = h5read(filename,'/GEO_LAT');     % The Geo_Latitude       
        data(1:length(A),8) = h5read(filename,'/A311');    % Ne:Electron Density
        data(1:length(A),9) = h5read(filename,'/A321');    % Te:Electron Temperature
        
        % Rename the data with .txt
        filename1 = strcat(strcat('E:\MATLAB\Mycode\Reserch\NNE_of_Laiwui_EQ\LAP',filename(31:end-3)),'.txt'); 
    
        % Close the doc
        file_id = fopen(filename1,'a+');
        dlmwrite(filename1,data,'\t');
        fclose(file_id);
        
            
end
