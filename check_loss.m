clear;
clc;
close all;
% add the path of lf_rw
addpath(genpath('./lf_rw'));
%--------------------Select data file-------------------------%
[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    'Please select the PSR data file',...
    '../data');
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

frameno = input('How many frames do you want to check?\n');
i = 0;
while (~feof(fp) & i~= frameno)
     frame = ReadDataFrame(fp,pkt_type);
     i = i + 1;
     t(i)=frame.time(1) + frame.time(2)/10^6;
     cnt(i) = frame.cnt;
end

subplot(2,2,1);
plot(t,'b');
title('time');
subplot(2,2,2);
plot(diff(t),'r');
title('time difference');
subplot(2,2,3);
plot(cnt,'g');
title('cnt');
subplot(2,2,4);
plot(diff(cnt),'k');
title('cnt difference');