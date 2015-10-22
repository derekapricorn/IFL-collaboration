function [ v_out ] = chop_off( v_in, n )
%chop off the entries specified
v_temp = v_in;
len = length(v_temp);
v_ind = ones(1,len);
v_ind(n) = 0;
v_temp = v_temp(v_ind);
v_out = v_temp;
end

