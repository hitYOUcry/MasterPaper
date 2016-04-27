function y=UtterPitch(x,fs)
%dimensionality: 21
%calculate pitch features
%max,min,mean,std,med,range
%x is the num of frames¡Áframe length 

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

P=zeros(flagnum,1);%for voiced frames
flagnum=0;
for i=1:fnum
    if flag(i)==1
        flagnum=flagnum+1;
        P(flagnum)=FramePitch(x(i,:)',fs);
    end
end

P_differ1=differ1(P);
P_differ2=differ2(P);

y=zeros(21,1);
y(1:6)=[max(P) min(P) mean(P) std(P) med(P) range(P)]';
y(7:12)=[max(P_differ1) min(P_differ1) mean(P_differ1) std(P_differ1) med(P_differ1) range(P_differ1)]';
y(13:18)=[max(P_differ2) min(P_differ2) mean(P_differ2) std(P_differ2) med(P_differ2) range(P_differ2)]';
y(19:20)=[jitter1(P) jitter2(P)]';
y(21)=slope(P);

end