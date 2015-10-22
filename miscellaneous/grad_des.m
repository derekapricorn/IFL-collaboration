function [next] = grad_des(previous, current, learning_rate)
%calculate next value by using gradient descent approach
next = current - learning_rate * (current - previous);
end