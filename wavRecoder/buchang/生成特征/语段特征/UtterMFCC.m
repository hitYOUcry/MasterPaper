function y=UtterMFCC(x,fs)
%%dimensionality: 156(including differ1)

[fnum flen]=size(x);

ZCR=zeros(fnum,1);
E=zeros(fnum,1);

%gate of voiced frames
for i=1:fnum
    ZCR(i)=FrameZerocross(x(i,:)');
    E(i)=FrameEnergy(x(i,:)',fs);
end
gZCR=mean(ZCR);
gE=mean(E);

flag=zeros(fnum,1);
for i=1:fnum
    if (ZCR(i)>=gZCR|E(i)>=gE)&FramePitch(x(i,:)',fs)>65.4&FramePitch(x(i,:)',fs)<1177.2
        flag(i)=1;
    end
end
flagnum=sum(flag);

M=zeros(13,flagnum);%for voiced frames
flagnum=0;
for i=1:fnum
    if flag(i)==1
        flagnum=flagnum+1;
        M(:,flagnum)=FrameMFCC(x(i,:)',fs);
    end
end

M=M';

y=[];
for i=1:13
    y(i*6-5:i*6)=[max(M(:,i)) min(M(:,i)) mean(M(:,i)) std(M(:,i)) med(M(:,i)) range(M(:,i))]';%MFCC
    y((i+13)*6-5:(i+13)*6)=[max(differ1(M(:,i))) min(differ1(M(:,i))) mean(differ1(M(:,i))) std(differ1(M(:,i))) med(differ1(M(:,i))) range(differ1(M(:,i)))]';%MFCC differ1
end
y=y';


end