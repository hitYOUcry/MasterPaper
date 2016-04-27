function y = cal_amp(y)
n = length(y);
flag = 0;
if(size(y,1) == 1)
    y = y';
    flag = 1;
end
for i = 1 : n
     temp = y (i,1);
    if(imag(temp) == 0)
        continue;
    end
    id = -1;
    if (real(temp) * imag(temp)) >= 0
        id = 1;
    end
    y (i,1) = id * abs(temp);
end
if flag == 1
    y = y';
end