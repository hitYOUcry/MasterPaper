function [y0 y1]=segment0_1(x)
%x: input 0-1 sequence

if size(x,2)>1
    x=x';
end
nx=length(x);

for i=1:nx%if not 0 or 1
    if x(i)>0
        x(i)=1;
    end
    if x(i)<=0
        x(i)=0;
    end
end

switch nx
    case 1%0 or 1
        if x==0
            y0=1;
            y1=0;
        end
        if x==1
            y0=0;
            y1=1;
        end
    otherwise
        cutpointnum=0;
        for i=1:nx-1
            if (x(i)==0&x(i+1)==1)|(x(i)==1&x(i+1)==0)
                cutpointnum=cutpointnum+1;
            end
        end
        switch cutpointnum
            case 0
                if x(1)==0
                    y0=nx;
                    y1=0;
                end
                if x(1)==1
                    y0=0;
                    y1=nx;
                end
            otherwise
                cutpoint=zeros(cutpointnum,1);
                cutpointnum=0;
                for i=1:nx-1
                    if (x(i)==0&x(i+1)==1)|(x(i)==1&x(i+1)==0)
                        cutpointnum=cutpointnum+1;
                        cutpoint(cutpointnum)=i+1;
                    end
                end
                segmentseq=zeros(cutpointnum+2,1);
                segmentseq(1)=1;
                segmentseq(cutpointnum+2)=nx+1;
                segmentseq(2:cutpointnum+1)=cutpoint;
                segmentlength=zeros(cutpointnum+1);
                for i=1:cutpointnum+1
                    segmentlength(i)=segmentseq(i+1)-segmentseq(i);
                end
                y0num=0;
                y1num=0;
                y0=[];
                y1=[];
                for i=1:cutpointnum+1
                    if x(segmentseq(i))==0
                        y0num=y0num+1;
                        y0(y0num)=segmentlength(i);
                    end
                    if x(segmentseq(i))==1
                        y1num=y1num+1;
                        y1(y1num)=segmentlength(i);
                    end
                end
        end
            
end
y0=y0';
y1=y1';
        
                    
end
                    