function out_amp = cal_outSpl(f,amp)
%      125  250   500  750 1K    1.5K 2K   3K  4K   5K  8K £¨dB SPL£©
k_fs =  [125 250 500 750 1000 1500 2000 3000 4000 5000 8000];
k_amp = [0 40 65 95 120];
%% GB4854-84
thr_gb  =   [45  25.5    11.5   7.5   7    6.5    9   10    9.5   13   13];
%% personal
%ucl  =   [110  112  109  113  114  111  112  110 109 112 111];
%mcl =   [80   81    85    90    96    97    98   99   101 105 108];
thr  =   [70   68    66   67    69   65    70   75    80   86   90];%dB SPL
thr = thr - thr_gb - 10;% dB HL
thr = [50 40 50 50 50 60 60 65 70 70 75];

a = 1;
b = 2;
while b < length(k_fs) && f>k_fs(b)
    a = a + 1;
    b = b + 1;
end
k = (f - k_fs(a)) / (k_fs(b) - k_fs(a));
%ucl_f = linearInterp(k,ucl(a),ucl(b));
%mcl_f = linearInterp(k,mcl(a),mcl(b));
thr_f = linearInterp(k,thr(a),thr(b));
outSpl = zeros(1,length(k_amp));
outSpl(1) = 0;
outSpl(end) = 120;
for i = 2:(length(k_amp)-1)
    outSpl(i) = k_amp(i) + getGain(thr_f, k_amp(i)) / 5;
end
if amp<=  k_amp(2)
    k = (amp - k_amp(1)) /(k_amp(2) - k_amp(1));
    out_amp = linearInterp(k,outSpl(1),outSpl(2));
else if amp <=  k_amp(3)
       k = (amp - k_amp(2)) /(k_amp(3) - k_amp(2));
       out_amp = linearInterp(k,outSpl(2),outSpl(3));
    else if amp <=  k_amp(4)
             k = (amp - k_amp(3)) /(k_amp(4) - k_amp(3));
             out_amp = linearInterp(k,outSpl(3),outSpl(4));
        else
              k = 1;
             out_amp = linearInterp(k,outSpl(3),outSpl(4));
        end
    end
end

if f <= 4000
    out_amp  = out_amp +   12;
else
    out_amp  = out_amp +   12 * (1 + f/ 8000);
end

end

