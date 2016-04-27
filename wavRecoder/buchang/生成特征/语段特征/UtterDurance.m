function y=UtterDurance(x,fs)
%dimensionality: 11

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
flagnum=sum(flag);%the number of voiced frame


if flag(1)==0
    firstsign=1;
else
    firstsign=0;
end
if flag(fnum)==0
    lastsign=1;
else
    lastsign=0;
end


[UnvoicedSegmentTime VoicedSegmentTime]=segment0_1(flag);
switch length(UnvoicedSegmentTime)
    case 1
        if firstsign==0|lastsign==0
            UnvoicedSegmentTime=0;
        end
    case 2
        if firstsign==0&lastsign==0
            UnvoicedSegmentTime=0;
        else
            if firstsign==0
                UnvoicedSegmentTime=UnvoicedSegmentTime(2);
            end
            if lastsign==0
                UnvoicedSegmentTime=UnvoicedSegmentTime(1);
            end
        end
    otherwise
        if firstsign==0
            UnvoicedSegmentTime=UnvoicedSegmentTime(2:length(UnvoicedSegmentTime));
        end
        if lastsign==0
            UnvoicedSegmentTime=UnvoicedSegmentTime(1:length(UnvoicedSegmentTime)-1);
        end
end

VoicedFrameNum=sum(VoicedSegmentTime);
UnvoicedFrameNum=sum(UnvoicedSegmentTime);
VoicedSegmentNum=length(VoicedSegmentTime);
UnvoicedSegmentNum=length(UnvoicedSegmentTime);
VoicedSegmentMax=max(VoicedSegmentTime);
UnvoicedSegmentMax=max(UnvoicedSegmentTime);

UVFrameRate=abs(atan(UnvoicedFrameNum/VoicedFrameNum))/(pi/2);%arctan to avoid inf
VTFrameRate=abs(atan(VoicedFrameNum/(VoicedFrameNum+UnvoicedFrameNum)))/(pi/2);
UVSegmentRate=abs(atan(UnvoicedSegmentNum/VoicedSegmentNum))/(pi/2);
UTSegmentRate=abs(atan(VoicedSegmentNum/(VoicedSegmentNum+UnvoicedSegmentNum)))/(pi/2);

SpeechRate=(VoicedFrameNum+UnvoicedFrameNum)/VoicedSegmentNum;

y=[VoicedFrameNum UnvoicedFrameNum VoicedSegmentNum UnvoicedSegmentNum VoicedSegmentMax UnvoicedSegmentMax UVFrameRate VTFrameRate UVSegmentRate UTSegmentRate SpeechRate]';

end