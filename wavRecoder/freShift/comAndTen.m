function y = comAndTen(x,fa,fb,f_cut,fc,fd,fs)
N = length(x);
X = fft(x);
X_amp = abs(X);
X_angle = angle(X);
midN = mid(N);
delta_f = fs / 2 / (midN - 1);
X_amp_new = zeros(1,midN);
X_angle_new = zeros(1,midN);
for i = 1:midN
    f = (i - 1) * delta_f;
    if f > f_cut
        continue;
    end
    f_o =  getF(fa,fb,fc,fd,fs,f);
    
    index = floor(f_o /delta_f) + 1;
    v_a = X_amp(index);
    angle_a = X_angle(index);
    v_b = X_amp(index + 1);
     angle_b = X_angle(index);
    f_a = delta_f * (index - 1);
    f_b = delta_f * index;
    X_amp_new(i) = v_a + (v_b - v_a) * (f_o - f_a) / (f_b-f_a);
    X_angle_new(i) =  angle_a + (angle_b - angle_a) * (f_o - f_a) / (f_b-f_a);
end
if mod(N,2) == 1
        for j = midN:-1:2
         X_amp_new(2 * midN - j + 1) = X_amp_new(j);
         X_angle_new(2 * midN - j + 1) = -X_angle_new(j);
        end
    else
        for j = (midN-1):-1:2
            X_amp_new(2 * midN - j) = X_amp_new(j);
             X_angle_new(2 * midN - j) = -X_angle_new(j);
        end
end
new_fft = X_amp_new.*exp(1i*X_angle_new);
y = cal_amp(ifft(new_fft));
end

function f_o = getF(fa,fb,fc,fd,fs,f_i)
if f_i <= fa
    f_o = fc * f_i / fa;
else if f_i <= fb
        f_o = fc + (f_i - fa) * (fd - fc) / (fb - fa);
    else
         f_o = fd + (f_i - fb) * (fs/2 - fd) / (fs/2 - fb);
    end
end
end