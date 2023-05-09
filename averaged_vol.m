clear;
clc;
close all;
% add the path of lf_rw
addpath(genpath('./lf_rw'));

fs = 500;
N = 4096;
df = fs/N;

acc = 1000;
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

x=((1:N/2)-1)*df;
i = 0;
cho = 0;
power = zeros(2,2048);
while ~feof(fp)
    frame = ReadDataFrame(fp,pkt_type);
    i = i + 1;
    re = [];
    im = [];
    for j=1:2
        [re(j,:),im(j,:)] = get_voltage(frame.data(j,:));
        power(j,:) = power(j,:) + re(j,:).^2 + im(j,:).^2;
    end 
    if(i==acc)
        break;
    end
end

subplot(2,1,1);
plot(x,power(1,:)/acc);
xlabel("MHz");
title(["averaged i"]);
subplot(2,1,2);
plot(x,power(2,:)/acc);
xlabel("MHz");
title(["averaged q"]); 
fclose(fp);


function [re,im]=get_voltage(d)
    N = length(d);
    for i = 1:N
        tmp = bitand(d(i),15);
        if(tmp > 7)
            re(i) = tmp-16;
        else
            re(i) = tmp;
        end
        tmp = bitshift(d(i),-4);
        if(tmp > 7)
            im(i) = tmp-16;
        else
            im(i) = tmp;
        end
    end

end