function [j] = ReadHeader(fp)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% read file header
d = fread(fp,1024,'uint8');
l = length(find(d));
s = sprintf("%s",d(1:l));
j = jsondecode(s);
end