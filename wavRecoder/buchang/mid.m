function m = mid(n)
if mod(n - 1,2) ~= 0
    m = round ((n - 1) / 2 )- 1;
else
    m = (n - 1) / 2;
end