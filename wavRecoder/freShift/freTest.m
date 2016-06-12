clc;
clear all;
close all;
%% read wav file
filename = 'sa1.wav';
[y ,fs] = audioread(filename);
y = y(:,1);
n = size(y,1);
N = 256;
midN = mid(N);
f_o_s = 0;
f_o_e = fs / 2;
f_t_s = 0;
f_t_e = fs / 4;
comRatio = (f_o_e - f_o_s) / (f_t_e - f_t_s);
new_N = N * comRatio;
midN_new = mid(new_N);
%% base zero detect
for i = 1:n
    if abs(y(i)) > 10e-04
        break;
    end
end
for j = n:-1:1
     if abs(y(j)) > 10e-04
        break;
    end
end
y = y(i:j);
n = size(y,1);
%% enframe
win_len = 256;
inc = round( 0.5 * win_len);
w = hamming(win_len);
s = enframe(y,win_len,inc);
y = i_enframe(s,inc);
frame_num = size(s,1);

%% frequency shift
for i = 1: frame_num
    x =  s(i,:);
    S = fft(x,N);
    S_new = zeros(1,new_N);
    S_new(1:midN) = S(1:midN);
    if mod(new_N,2) == 1
        for j = midN_new:-1:2
         S_new(2 * midN_new - j + 1) = conj(S_new(j));
        end
    else
        for j = (midN_new-1):-1:2
            S_new(2 * midN_new - j) = conj(S_new(j));
        end
    end
    s_new(i,:) = cal_amp(ifft(S_new));
    %{
    %% µ¥Ö¡plot
    S_amp = abs(S);
    t1 = (0 : (N - 1))/N * fs;
    S_amp_new = abs(S_new);
    t2 = (0 : (new_N - 1))/new_N * fs;
    figure
    subplot(2,1,1)
    plot(t1, S_amp);
    subplot(2,1,2);
    plot(t2,S_amp_new);
    %}
    %{
    %% ³éÑùÑ¹Ëõ
    S_amp = abs(S);
    S_angle = angle(S);
    %% ÆµÆ×°áÒÆ
    S_m = S_amp(1:midN);
    S_m_new = S_m;
    delta_f = fs /2 /(midN - 1);
    index_a = 1 + f_o_s / delta_f;
    index_b = 1 + f_o_e / delta_f;
    index_c = 1 + f_t_s / delta_f;
    index_d = 1 + f_t_e / delta_f;
    for j = 1 : midN
        if j < index_c || j > index_d;
            S_m_new(j) = 0;
        else
            o_j = (j - index_c) / (index_d - index_c) * (index_b - index_a) + index_a;
            S_m_new(j) = S_m(o_j);
        end
    end
    if mod(N,2) == 1
        for j = midN:-1:2
         S_m_new(2 * midN - j + 1) = S_m_new(j);
        end
    else
        for j = (midN-1):-1:2
            S_m_new(2 * midN - j) = S_m_new(j);
        end
    end
    %}
end
%{
figure;
subplot(2,1,1);
t1 = (0 : (N - 1)) * fs;
plot(t1,S_amp);
subplot(2,1,2);
t2 = (0 : (N - 1)) * 2fs;
plot(S_m_new);
%}

