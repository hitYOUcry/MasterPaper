function y=jitter2(x)
%2 order jitter
%
nx=length(x);
if size(x,2)>1
    x=x';
end

if nx>=3
totalx=0;
totaldeltax=0;
for i=1:nx
    totalx=totalx+x(i);
    if i~=nx&i~=1
        totaldeltax=totaldeltax+abs(x(i)*2-x(i+1)-x(i-1));
    end
end
totaldeltax=totaldeltax/(nx-2);
totalx=totalx/nx;
y=totaldeltax/totalx*100;
else
    y=0;
end

end