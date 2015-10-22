function [x_n, v_n] = Gaussian_gen()
%Generate normalized gaussian membership function of window size
% 118 to be used as a standard
x = linspace(-10,10,1000);v = gaussmf(x,[1,0]);
% plot(x,v,'b')
% hold on
x = find(v > 0.5);
v_n = v(x);
v_n = v_n - min(v_n);
v_n = v_n / max(v_n);
x_n = (x - x(1))/(x(end)-x(1));
% plot(x_n,v_n,'k')
end

