function spec = SPLCompen(fs,original)
pa = 2e-5;
N = length(original);

midN = mid(N);
spec = original;
for i = 1:midN
    f = fs * i/N;
    if f < 125
        continue;
    end
    logOriginal = 20 * log10(original(i)/pa);
    logSpec = cal_outSpl(f,logOriginal) ;
    spec(i) = pa * 10 ^ (logSpec/20);
  % spec(i) = original(i) * (1 + f/fs);
end

if mod(N,2) == 1
    for j = midN:-1:2
        spec(2 * midN - j + 1) = spec(j);
    end
else
    for j = (midN-1):-1:2
        spec(2 * midN - j) = spec(j);
    end
end

%{
logOriginal = 20 * log10(original./pa);
logSpec = cal_outSpl2(fs,logOriginal);
spec =  pa * power(10, logSpec./20);
%}