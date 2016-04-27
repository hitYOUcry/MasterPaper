function y=differ1(x)
%1st order differ

nx=length(x);
if size(x,2)>1
    x=x';
end

if nx>=2
    y=zeros(nx-1,1);
    for i=2:nx
        y(i-1)=x(i)-x(i-1);
    end
else
    y=0;
end

end
