function [flag] = is_continuous(v)
%This boolean function determines if the input vector is continuous e.g. 
%[0 0 0 1 1 1 1 0 0 0 0]. It returns 1 if it's continuous 0 otherwise
flag = sum(abs(diff(v)))==2;
end

