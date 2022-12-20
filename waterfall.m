clear;
clc;
close all;
% add the path of lf_rw
addpath(genpath('./lf_rw'));
%-------------------------------------------------------------%
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
%---------prase filename and read obs_settings----------------%
pkt_type = prase_pkt_type(filename0);
fp = fopen(filename,'r');
obs_settings = ReadHeader(fp)
%-------------------------------------------------------------%
%-----------------------set parameters------------------------%
% Sampling Freq
fs = 500;
% FFT points
N = 4096;
% df and dt
df = fs/N;                  %MHz
% 127 is from obs_setting.AccLen
dt = obs_settings.AccLen*N/(fs*10^6)*1000;  %ms
% We don't show all of the freq channels
% We just show 1600 channels, which starts from ch155.
% Note: make sure the ch is multiples of baseline_ch.
start_ch = 155;
ch = 1600;
baseline_ch = 100;
% readout frames and integrated frames
total_frames = 4000;
integrated_frames = 5;
%-------------------------------------------------------------%
%-----------------------start processing----------------------%
i = 0;
j = 1;
i_power = zeros(ch,total_frames/integrated_frames);
while ~feof(fp)
    frame = ReadDataFrame(fp,pkt_type);
    i = i + 1;
    % cal power
    p = frame.data;
    % select the channels we want 
    s_power = p(start_ch:(start_ch + ch -1));
    % remove baseline
    tmp = reshape(s_power,baseline_ch,ch/baseline_ch);
    s_power = reshape(tmp - mean(tmp),ch,1);
    % integrated power
    i_power(:,j) =  i_power(:,j) + s_power;
    if(mod(i,integrated_frames)==0)
        j = j + 1;
    end
    if(i == total_frames)
        break;
    end
end
fclose(fp);
% plot the figure
colormap(jet(128));
x = (1:total_frames/integrated_frames)*dt*integrated_frames;
y = (1:ch)*df;
h = pcolor(x,y,i_power);
set(h,'edgecolor','none','facecolor','interp');
xlabel('ms');
ylabel('MHz');
plottitle = insertBefore(filename0,'_','\');
title(plottitle);
colorbar;
