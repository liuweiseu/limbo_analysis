function [pkt_type] = prase_pkt_type(filename)
    if(strncmp(filename,'Spectra',7) == 1)
        pkt_type = 0;
    elseif(strncmp(filename,'VoltageV1',9)==1)
        pkt_type = 1;
    elseif(strncmp(filename,'VoltageV2',9)==1)
        pkt_type = 2;
    else
        pkt_type = -1;
    end
end