function y=jitter1(x)
%1 order jitter
%
nx=length(x);
if size(x,2)>1
    x=x';
end

if nx>=2
totalx=0;
totaldeltax=0;
for i=1:nx
    totalx=totalx+x(i);
    if i~=nx
        totaldeltax=totaldeltax+abs(x(i+1)-x(i));
    end
end
totaldeltax=totaldeltax/(nx-1);
totalx=totalx/nx;
y=totaldeltax/totalx*100;
else
    y=0;
end

end