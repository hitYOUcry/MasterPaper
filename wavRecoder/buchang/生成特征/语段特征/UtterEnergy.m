function y=UtterEnergy(x,fs)
%dimensionality: 80
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
    if ZCR(i)>=gZCR|E(i)>=gE
        flag(i)=1;
    end
end
flagnum=sum(flag);

E_=zeros(flagnum,1);%for voiced frames
E_250=zeros(flagnum,1);
E_650=zeros(flagnum,1);
E4000_=zeros(flagnum,1);

flagnum=0;
for i=1:fnum
    if flag(i)==1
        flagnum=flagnum+1;
        E_(flagnum)=E(i);
        E_250(flagnum)=FrameEnergy(x(i,:)',fs,0,250);
        E_650(flagnum)=FrameEnergy(x(i,:)',fs,0,650);
        E4000_(flagnum)=FrameEnergy(x(i,:)',fs,4000);
    end
end
E_differ1=differ1(E_);
E_250differ1=differ1(E_250);
E_650differ1=differ1(E_650);
E4000_differ1=differ1(E4000_);

E_differ2=differ2(E_);
E_250differ2=differ2(E_250);
E_650differ2=differ2(E_650);
E4000_differ2=differ2(E4000_);

%dimensionality: 4*3*6+4*2=80
y=zeros(80,1);
%statistical feature
y(1:6)=[max(E_) min(E_) mean(E_) std(E_) med(E_) range(E_)]';
y(7:12)=[max(E_250) min(E_250) mean(E_250) std(E_250) med(E_250) range(E_250)]';
y(13:18)=[max(E_650) min(E_650) mean(E_650) std(E_650) med(E_650) range(E_650)]';
y(19:24)=[max(E4000_) min(E4000_) mean(E4000_) std(E4000_) med(E4000_) range(E4000_)]';
y(25:30)=[max(E_differ1) min(E_differ1) mean(E_differ1) std(E_differ1) med(E_differ1) range(E_differ1)]';
y(31:36)=[max(E_250differ1) min(E_250differ1) mean(E_250differ1) std(E_250differ1) med(E_250differ1) range(E_250differ1)]';
y(37:42)=[max(E_650differ1) min(E_650differ1) mean(E_650differ1) std(E_650differ1) med(E_650differ1) range(E_650differ1)]';
y(43:48)=[max(E4000_differ1) min(E4000_differ1) mean(E4000_differ1) std(E4000_differ1) med(E4000_differ1) range(E4000_differ1)]';
y(49:54)=[max(E_differ2) min(E_differ2) mean(E_differ2) std(E_differ2) med(E_differ2) range(E_differ2)]';
y(55:60)=[max(E_250differ2) min(E_250differ2) mean(E_250differ2) std(E_250differ2) med(E_250differ2) range(E_250differ2)]';
y(61:66)=[max(E_650differ2) min(E_650differ2) mean(E_650differ2) std(E_650differ2) med(E_650differ2) range(E_650differ2)]';
y(67:72)=[max(E4000_differ2) min(E4000_differ2) mean(E4000_differ2) std(E4000_differ2) med(E4000_differ2) range(E4000_differ2)]';

%jitter(shimmer)
y(73:76)=[jitter1(E_) jitter1(E_250) jitter1(E_650) jitter1(E4000_)]';
y(77:80)=[jitter2(E_) jitter2(E_250) jitter2(E_650) jitter2(E4000_)]';

end
