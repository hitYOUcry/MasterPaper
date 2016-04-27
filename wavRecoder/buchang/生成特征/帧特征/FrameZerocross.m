function y=FrameZerocross(x)
%input: x
%output: y
nx=length(x);
[t,s]=zerocros(x);
y=length(t)/(nx-1);

end