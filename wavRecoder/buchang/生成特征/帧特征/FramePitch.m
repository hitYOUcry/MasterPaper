function y=FramePitch(x,fs)
%x:input frame
%fs:sampling frequence
if size(x,2)>1
    x=x';
end
nx=length(x);

R=zeros(nx,1);
temp=[];
for i=1:nx %corre
    for j=1:nx-1-i
        R(i)=R(i)+x(j)*x(j+i);
    end
end

freq=abs(fft(R,fs));
maxa=0;
maxp=1;
for i=1:fix(fs/2)
    if freq(i)>maxa
        maxa=freq(i);
        maxp=i;
    end
end
y=maxp;
% count=0;
% for i=2:nx-1
%     if R(i-1)<=R(i)&R(i)>=R(i+1)
%         count=count+1;
%     end
% end
% temp=zeros(count,1);
% count=0;
% for i=2:nx-1
%     if R(i-1)<=R(i)&R(i)>=R(i+1)
%         count=count+1;
%         temp(count)=R(i);
%     end
% end
% m=min(find(R==max(temp)));
% y=fs/m;

end