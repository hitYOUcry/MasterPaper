function y=UtterFormant(x,FormantNum,fs)
%dimensionality: 120(if FormantNum==3)

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

if FormantNum~=1&FormantNum~=2&FormantNum~=3&FormantNum~=4
    FormantNum=1;
end

FR=zeros(FormantNum,flagnum);
BW=zeros(FormantNum,flagnum);
flagnum=0;
for i=1:fnum
    if flag(i)==1
        flagnum=flagnum+1;
        [FR(:,flagnum) BW(:,flagnum)]=FrameFormant(x(i,:)',FormantNum,fs);
    end
end
FR=FR';
BW=BW';

y=[];
for i=1:FormantNum
    y(i*6-5:i*6)=[max(FR(:,i)) min(FR(:,i)) mean(FR(:,i)) std(FR(:,i)) med(FR(:,i)) range(FR(:,i))]';%FR
    y((i+FormantNum)*6-5:(i+FormantNum)*6)=[max(differ1(FR(:,i))) min(differ1(FR(:,i))) mean(differ1(FR(:,i))) std(differ1(FR(:,i))) med(differ1(FR(:,i))) range(differ1(FR(:,i)))]';%FR differ1
    y((i+FormantNum*2)*6-5:(i+FormantNum*2)*6)=[max(differ2(FR(:,i))) min(differ2(FR(:,i))) mean(differ2(FR(:,i))) std(differ2(FR(:,i))) med(differ2(FR(:,i))) range(differ2(FR(:,i)))]';%FR differ2
    y((i+FormantNum*3)*6-5:(i+FormantNum*3)*6)=[max(BW(:,i)) min(BW(:,i)) mean(BW(:,i)) std(BW(:,i)) med(BW(:,i)) range(BW(:,i))]';%BW
    y((i+FormantNum*4)*6-5:(i+FormantNum*4)*6)=[max(differ1(BW(:,i))) min(differ1(BW(:,i))) mean(differ1(BW(:,i))) std(differ1(BW(:,i))) med(differ1(BW(:,i))) range(differ1(BW(:,i)))]';%BW differ1
    y((i+FormantNum*5)*6-5:(i+FormantNum*5)*6)=[max(differ2(BW(:,i))) min(differ2(BW(:,i))) mean(differ2(BW(:,i))) std(differ2(BW(:,i))) med(differ2(BW(:,i))) range(differ2(BW(:,i)))]';%BW differ2
end
y((FormantNum+FormantNum*5)*6+1:(FormantNum+FormantNum*5)*6+6)=[jitter1(FR(:,1)) jitter1(FR(:,2)) jitter1(FR(:,3)) jitter2(FR(:,1)) jitter2(FR(:,2)) jitter2(FR(:,3))]';%FR jitter1,2
y((FormantNum+FormantNum*5)*6+7:(FormantNum+FormantNum*5)*6+12)=[jitter1(BW(:,1)) jitter1(BW(:,2)) jitter1(BW(:,3)) jitter2(BW(:,1)) jitter2(BW(:,2)) jitter2(BW(:,3))]';%BW jitter1,2
y=y';

end