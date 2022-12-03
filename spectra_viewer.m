clear;
clc;
close all;

fs = 1000;
N = 4096;
df = fs/N;
%--------------------Select data file-------------------------%
[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    'Please select the PSR data file',...
    './');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end
%-------------------------------------------------------------%

pkt_type = prase_pkt_type(filename0);
fp = fopen(filename,'r');

obs_settings = ReadHeader(fp)

x=((1:N/2)-1)*df;
i = 0;
cho = 0;
while cho ~= 1
    frame = ReadDataFrame(fp,pkt_type);
    i = i + 1;
    frame.time
    frame.cnt
    plot(x,frame.data);
    xlabel("MHz");
    title(["Spectra Data--FrameNo: ",num2str(i)]);
    cho = input('Pls input choice: 0(or none) for next;1 for exit:');
    if(cho == 1)
        cho = 1;
    else
        cho = 0;
    end
end
fclose(fp);