function out_amp = cal_outSpl(f,amp)
%      125  250   500  750 1K    1.5K 2K   3K  4K   5K  8K £¨dB SPL£©
k_fs =  [125 250 500 750 1000 1500 2000 3000 4000 5000 8000];
k_amp = [0 40 65 95 120];
%% GB4854-84
thr_gb  =   [45   25.5    11.5   7.5   7    6.5    9   10    9.5   13   13];
%% personal
%ucl  =   [110  112  109  113  114  111  112  110 109 112 111];
%mcl =   [80   81    85    90    96    97    98   99   101 105 108];
thr  =   [60   58    56    57    59    65    70   75    80   86   90];%dB SPL
thr = thr - thr_gb;% dB HL

a = 1;
b = 2;
while f>k_fs(b)
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
    outSpl(i) = k_amp(i) + getGain(thr_f, k_amp(i));
end
if amp<= 40
    k = amp/40;
    out_amp = linearInterp(k,outSpl(1),outSpl(2));
else if amp <= 65
       k = (amp - 40)/25;
       out_amp = linearInterp(k,outSpl(2),outSpl(3));
    else if amp <= 95
             k = (amp -65)/30;
             out_amp = linearInterp(k,outSpl(3),outSpl(4));
        else
              k = (95 -65)/30;
             out_amp = linearInterp(k,outSpl(3),outSpl(4));
    end
    end
end

end

%% gain cal
 function gain = getGain(thr_f,amp)
if amp <= 45
    % low 
    gain = low_g(thr_f);
else if amp <= 85
        % mid
        gain = mid_g(thr_f);
    else
    % loud
     gain = loud_g(thr_f);
end
end
 end

%% FIG6 low
function gain = low_g(hl)
if hl < 20
    gain = 0;
else if 20 <= hl && hl <= 60
        gain = hl - 20;
    else
        gain = hl - 20 - 0.5*(hl - 60);
    end
end
end

%% FIG6 mid
function gain = mid_g(hl)
if hl < 20
    gain = 0;
else if 20 <= hl && hl <= 60
        gain = 0.6 * (hl - 20);
    else
        gain = 0.8 * (hl - 23);
    end
end
end

%% FIG6 loud
function gain = loud_g(hl)
if hl < 40
    gain = 0;
else
    gain = 0.1 * (hl - 40)^1.4;
end
end

