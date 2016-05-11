clc
clear all;
close all;
%% read in wav file
%filename = 'test_1.wav';
%filename = 'test.wav';
filename = 'TX5_4.wav';
filename = 'sa2.wav';
[y ,fs] = audioread(filename);
y = y(:,1);
n = size(y,1);
%% add noise
%y =  awgn(y,55);
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
%y = y(1:fs*0.2);
n = size(y,1);

%% enframe
win_len = round( 20 / 1000 * fs);
inc = round( 0.5 * win_len);
w = hamming(win_len);
s = enframe(y,win_len,inc);
y = i_enframe(s,inc);
frame_len = size(s,1);
fft_res = zeros(frame_len,win_len/2 + 1);
%% deal with the enframed data
N = mid(win_len);
s_new = zeros(frame_len,win_len);
formantNum = 5;
FR = zeros(frame_len,formantNum);
BW =  zeros(frame_len,formantNum);
delta_diff =.6;

for j = 1:frame_len
    frame_data = s(j,:);
    fft_data = fft(frame_data,win_len);
    fft_res(j,:) = abs(fft_data(1:win_len/2 + 1));
  %  [FR(j,:) ,BW(j,:)] = FrameFormant(frame_data ,formantNum,fs);
   diff_1 = diff(fft_res(j,:),1);
    power_sum = sum(fft_res(j,:));
    if power_sum < 10e-03
          s_new(j,:) = frame_data;
          continue;
    end
 %{   
    %¼ÆËãµ±Ç°Ö¡¹²Õñ·å²ÎÊý
    [fr,bw] = FrameFormant(frame_data ,formantNum,fs);
    FR(j,:) = fr;
    BW(j,:) = bw;
    for i = 2 : N
        f = fs * i / win_len;
        %{
        if f <= 2000
            gain =0.5;
        elseif f <= 4000
            gain = 10;
        else
            gain = 0.5;
        end
        %}
        gain = 1;
        %{
        %¹²Õñ·å1+cos(deltaf)²¹³¥
        bw_i = 2;
        delta_f = 1;
        if f > (fr(1) - 0.5 * bw(1)) &&  f < (fr(1) + 0.5 * bw(1))
            bw_i = bw(1);
            delta_f = f - fr(1) ;
        elseif f > (fr(2) - 0.5 * bw(2)) &&  f < (fr(2) + 0.5 * bw(2))
            bw_i = bw(2);
            delta_f = f - fr(2) ;
        elseif f > (fr(3) - 0.5 * bw(3)) &&  f < (fr(3) + 0.5 * bw(3))
            bw_i = bw(3);
            delta_f = f - fr(3) ;
        elseif f > (fr(4) - 0.5 * bw(4)) &&  f < (fr(4) + 0.5 * bw(4))
            bw_i = bw(4);
            delta_f = f - fr(4) ;
        elseif f > (fr(5) - 0.5 * bw(5)) &&  f < (fr(5) + 0.5 * bw(5))
            bw_i = bw(5);
            delta_f = f - fr(5) ;
        end
        gain = gain + cos(delta_f / bw_i * pi);
        %}
        a = diff_1(i-1);
        b = diff_1(i);
        gain_add = 1;
       if a*b < 0
           if a > 0
               gain_add = 1/delta_diff;
           else
                gain_add = delta_diff;
                %gain_add = 1;
           end
       end
        %¹²Õñ·åÌÞ³ý²âÊÔ
         if f > (fr(1) - 0.5 * bw(1)) &&  f < (fr(1) + 0.5 * bw(1)) || f > (fr(2) - 0.5 * bw(2)) &&  f < (fr(2) + 0.5 * bw(2))...
                 || f > (fr(3) - 0.5 * bw(3)) &&  f < (fr(3) + 0.5 * bw(3)) || f > (fr(4) - 0.5 * bw(4)) &&  f < (fr(4) + 0.5 * bw(4))...
                 || f > (fr(5) - 0.5 * bw(5)) &&  f < (fr(5) + 0.5 * bw(5))
             gain =1.3;
             %fprintf('%fHz \n',f);
         else
  %           delta_f = min(abs(fr - f));
   %          gain = sin(2*pi*delta_f/fs*2);
             gain = 1;
         end
         gain = gain * gain_add;
        fft_data(i) = gain * fft_data(i);
        fft_data(win_len + 2 - i) =  conj(fft_data(i));
    end
    %}
     s_new(j,:) = SCE(frame_data,1,fs);
end
y_new = i_enframe(s_new,inc);

fft_res_avg = sum(fft_res)/frame_len;
fft_res_avg = (fft_res_avg - min(fft_res_avg))./(max(fft_res_avg) - min(fft_res_avg));

x = (1:(win_len/2+1))./(win_len/2+1).*fs/2;
figure;
plot(x,fft_res_avg);
figure;
subplot(2,2,1)
plot(y);
subplot(2,2,2)
plot_spec(y,win_len,fs);

subplot(2,2,3)
plot(y_new);
subplot(2,2,4)
plot_spec(y_new,win_len,fs);

%{
fprintf('Press any key to play the first wav...\n');
pause;
p = audioplayer(y, fs);
play(p);

fprintf('Press any key to play the second wav...\n');
pause;
p = audioplayer(y_new, fs);
play(p);
%}
