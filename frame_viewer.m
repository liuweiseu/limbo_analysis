clear;
clc;
close all;
% add the path of lf_rw
addpath(genpath('./lf_rw'));

fs = 500;
N = 4096;
df = fs/N;
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
while cho ~= 1
    frame = ReadDataFrame(fp,pkt_type);
    i = i + 1;
    if(pkt_type == 0)
        plot(x,10*log10(frame.data));
        xlabel("MHz");
        title(["Spectra Data--FrameNo: ",num2str(i)]);
    elseif(pkt_type == 1)
        power = [];
        re = [];
        im = [];
        for j=1:4
            [re(j,:),im(j,:)] = get_voltage(frame.data(j,:));
            power(j,:) = re(j,:).^2 + im(j,:).^2;
        end
        subplot(2,2,1);
        plot(x,power(1,:));
        xlabel("MHz");
        title(["a_i--FrameNo: ",num2str(i)]);
        subplot(2,2,2);
        plot(x,power(2,:));
        xlabel("MHz");
        title(["a_q--FrameNo: ",num2str(i)]);  
        subplot(2,2,3);
        plot(x,power(3,:));
        xlabel("MHz");
        title(["b_i--FrameNo: ",num2str(i)]);
        subplot(2,2,4);
        plot(x,power(4,:));
        xlabel("MHz");
        title(["b_q--FrameNo: ",num2str(i)]);
    elseif(pkt_type == 2)
        power = [];
        re = [];
        im = [];
        for j=1:2
            [re(j,:),im(j,:)] = get_voltage(frame.data(j,:));
            power(j,:) = re(j,:).^2 + im(j,:).^2;
        end
        subplot(2,1,1);
        plot(x,power(1,:));
        xlabel("MHz");
        title(["in_i--FrameNo: ",num2str(i)]);
        subplot(2,1,2);
        plot(x,power(2,:));
        xlabel("MHz");
        title(["in_q--FrameNo: ",num2str(i)]); 
    else
        disp('Unrecognized file type!')
    end
    cho = input('Pls input choice: 0(or none) for next;1 for exit:');
    if(cho == 1)
        cho = 1;
    else
        cho = 0;
    end
end
fclose(fp);