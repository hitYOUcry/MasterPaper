function [FR BW]=FrameFormant(x,fs)
%x: input
%FormantNum
%y: output, frequence

p = 24;

a=lpc(x,p);
N = length(x);

%ffta=abs(fft(a));
% 
%FR=ffta;

rts = roots(a);
rts = rts(imag(rts)>=0);
angz = atan2(imag(rts),real(rts));

%nonzero angz%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nonzero=0;
angznew=[];
rtsnew=[];
for i=1:length(angz)
    if angz(i)*(fs/(2*pi))>90&&(-1/2*(fs/(2*pi))*log(abs(rts(i)))<400)
        nonzero=nonzero+1;
        angznew(nonzero)=angz(i);
        rtsnew(nonzero)=rts(i);
    end
end
switch nonzero
    case 0
        angznew=angz;
        rtsnew=rts;
    case 1
        angznew=[angznew(1) angznew(1) angznew(1)];
        rtsnew=[rtsnew(1) rtsnew(1) rtsnew(1)];
    case 2
        rtsnew=[rtsnew(1) rtsnew(1) rtsnew(2)];
        angznew=[angznew(1) angznew(1) angznew(2)];
end
if size(angznew,2)>1
    angznew=angznew';
end
if size(rtsnew,2)>1
    rtsnew=rtsnew';
end
angz=angznew;
rts=rtsnew;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[frqs,indices] = sort(angz.*(fs/(2*pi)));
bw = -1/2*(fs/(2*pi))*log(abs(rts(indices)));



b = [1 zeros(1,p)];
[h,~] = freqz(b,a,2*N);
h =10 * log10(abs(h));
[indexs , ~] = findpeaks(h);
frs = indexs/length(h) * fs /2;
j = 1;
formantNum = length(frs);
for k = 1:formantNum
    [~,min_ind] = min(abs(frqs - frs(k)));
    FR(k) = frs(k);
    BW(k) = bw(min_ind);
end

end

% nn = 1;
% for kk = 1:length(frqs)
%     if (frqs(kk) > 90 && bw(kk) <400)
%         formants(nn) = frqs(kk);
%         nn = nn+1;
%     end
% end
% FR=formants;