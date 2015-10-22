function [ output_arg ] = rank_transform( input_arg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rank = tiedrank( input_arg );
p = rank / ( length(rank) + 1 ); %# +1 to avoid Inf for the max point
newdata = norminv( p, 0, 1 );
output_arg = newdata;
end

