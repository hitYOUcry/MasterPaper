function m = mid(n)
if mod(n - 1,2) ~= 0
    m = floor ((n - 1) / 2 )+ 1;
else
    m = (n - 1) / 2;
end
m = m+1;
end