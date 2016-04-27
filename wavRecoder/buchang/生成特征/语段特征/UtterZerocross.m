function y=UtterZerocross(x)
%dimensionality: 20

[fnum flen]=size(x);
Z=zeros(fnum,1);
for i=1:fnum
    Z(i)=FrameZerocross(x(i,:)');
end

Z_differ1=differ1(Z);
Z_differ2=differ2(Z);

y=zeros(20,1);

y(1:6)=[max(Z) min(Z) mean(Z) std(Z) med(Z) range(Z)]';
y(7:12)=[max(Z_differ1) min(Z_differ1) mean(Z_differ1) std(Z_differ1) med(Z_differ1) range(Z_differ1)]';
y(13:18)=[max(Z_differ2) min(Z_differ2) mean(Z_differ2) std(Z_differ2) med(Z_differ2) range(Z_differ2)]';
y(19:20)=[jitter1(Z) jitter2(Z)]';

end