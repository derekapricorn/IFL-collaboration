function [imban_ind] = calc_imbalance(x,y,ind)
%calculate the index of imbalance to help find the inception of inspiration
xx = x;
yy = y;
lhs = 0;
rhs = 0;
for ii = 1:10
    lhs = lhs+yy(ind-ii);
    rhs = rhs+yy(ind+ii);
end
imban_ind = rhs-lhs;

end

