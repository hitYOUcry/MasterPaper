function spl = cal_spl(wav)
p0 = 2 * 10e-5;
power = sum(wav.^2)/length(wav);
spl = 20 * log10(power ^ 0.5 / p0);