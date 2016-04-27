function y=FrameEnergy(x,fs,f1,f2)
%x:input time signal, 
%fs:sampling frequence
%f1:low fre/ f2:high fre
nx=length(x(:));
frequencylist=zeros(nx,1);%the frequence of every point
kf1=1;
kf2=1;
fftx=abs(fft(x));

for i=1:nx
    if i==1
        frequencylist(i)=0;
    else
        frequencylist(i)=frequencylist(i-1)+fs/2/nx;
    end
end

if nargin<=2   %no fre
    
    if size(fftx,2)>1
        y=ones(1,nx)*abs(x)'/nx;
    else
        y=ones(1,nx)*abs(x)/nx;
    end
    
else
    if nargin==3 %with min fre
        
        for i=1:nx
            if f1<=frequencylist(i)
                kf1=i;
                break
            end
        end
        if kf1==nx
            y=0;
        else
            if size(x,2)>1
                y=ones(1,nx-kf1+1)*abs(fftx(kf1:nx))'/(nx-kf1+1);
            else
                y=ones(1,nx-kf1+1)*abs(fftx(kf1:nx))/(nx-kf1+1);
            end
        end  
        
    else %with min&max fre
        if f2-f1<fs/2/nx
            y=0;
        else
            for i=1:nx
                if f1<=frequencylist(i)
                    kf1=i;
                    break
                end
            end
            for i=nx:-1:1
                if f2>=frequencylist(i)
                    kf2=i;
                    break
                end
            end
            if kf2-kf1<0
                y=0;
            else
                if size(fftx,2)>1
                    y=ones(1,kf2-kf1+1)*abs(fftx(kf1:kf2))'/(kf2-kf1+1);
                else
                    y=ones(1,kf2-kf1+1)*abs(fftx(kf1:kf2))/(kf2-kf1+1);
                end 
            end
%             plot(fftx(kf1:kf2))
%             axis([kf1 kf2 0 4000])
%             hold on
        end
        
    end
end