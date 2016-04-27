function y=differ2(x)
%1st order differ

nx=length(x);
if size(x,2)>1
    x=x';
end

if nx>=3
    xdiffer1=differ1(x);
    y=differ1(xdiffer1);
else
    y=0;
end

end