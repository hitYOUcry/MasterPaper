function y = Inter(x,n)
N = length(x);
y = zeros(1,N * (n + 1));
for i = 1 : N
    y((i - 1) * (n + 1) + 1) = x(i);
end