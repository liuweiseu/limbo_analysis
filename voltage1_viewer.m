clear;
clc;
close all;

fs = 500;
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
    cho = input('Pls input choice: 0(or none) for next;1 for exit:');
    if(cho == 1)
        cho = 1;
    else
        cho = 0;
    end
end
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