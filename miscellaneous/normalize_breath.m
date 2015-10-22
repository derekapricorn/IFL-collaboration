function [u,v] = normalize_breath (x,y)
%normalize the breath to be x->u:[0,1], y->v:[0,1]
%assume x is sequentially increasing 
if ~(x(1)==0 && x(end)==1)
    u = (x - x(1))/(x(end)-x(1));
end
y = y - min(y);
v = y/max(y);
end