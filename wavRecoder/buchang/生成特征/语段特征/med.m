function y=med(x)
%median digit
x0=sort(x);
if mod(length(x),2)~=0
    y=x((length(x)+1)/2);
else
    y=(x(length(x)/2)+x(length(x)/2+1))/2;
end