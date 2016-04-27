function y=FrameMFCC(x,fs)
%input: x,fs
%output: y
coe=mfcc(x,fs);
y=sum(coe,2)/size(coe,2);
if size(y,2)>1
    y=y';
end

end    
