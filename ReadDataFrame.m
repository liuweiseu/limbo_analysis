function [frame] = ReadDataFrame(fp, pkt_type)
    t = fread(fp,2,'uint64');
    cnt = fread(fp,1,'uint64');
    if(pkt_type == 0) %spectra data
        d = fread(fp,2048,'uint16');
    elseif(pkt_type == 1) % voltage data
        d = fread(fp,8192,'uint8');
        d = reshape(d,4,2048);
    elseif(pkt_type == 2) % voltage data
        d = fread(fp,4096,'uint8');
        d = reshape(d,2,2048);
    end
    frame.time = t;
    frame.cnt = cnt;
    frame.data = d;
end