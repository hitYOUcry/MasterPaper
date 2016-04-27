function y=slope(x)
%calculate slope of x

if size(x,2)>1
    x=x';
end
nx=length(x);

[P,S] = polyfit(1:nx,x',1);
y=P(1);

end