clc;clear all;close all
load('frameData.mat');
data = wavFrame;
N = length(wavFrame);

%% original data
figure;
plot((1:N)/fs,wavFrame);
title('wav data');
xlabel('time/s');
ylabel('amplitude');

%% formants cal
formantNum = 5;
[fr,bw] = FrameFormant(data ,formantNum,fs);


%% fft data 
fft_data = fft(data);
fft_data_amp = abs(fft_data);
diff_1 = diff(fft_data_amp,1);

fft_data_en = zeros(N,1);
midN = mid(N);

delta_diff = 0.6;


for i = 2 : midN
        f = fs * i / N;
        a = diff_1(i-1);
        b = diff_1(i);
        gain_add = 0;
       if a*b < 0
           if a > 0
               gain_add = delta_diff;
           else
                gain_add = -delta_diff;
           end
       end
        gain = 1;
         if f > (fr(1) - 0.5 * bw(1)) &&  f < (fr(1) + 0.5 * bw(1)) || f > (fr(2) - 0.5 * bw(2)) &&  f < (fr(2) + 0.5 * bw(2))...
                 || f > (fr(3) - 0.5 * bw(3)) &&  f < (fr(3) + 0.5 * bw(3)) || f > (fr(4) - 0.5 * bw(4)) &&  f < (fr(4) + 0.5 * bw(4))...
                 || f > (fr(5) - 0.5 * bw(5)) &&  f < (fr(5) + 0.5 * bw(5))
             gain =1.2;
         else 
             gain =1;
         end
         gain = gain + gain_add;
        fft_data_en(i) = gain * fft_data(i);
        fft_data_en(N + 2 - i) =  conj(fft_data_en(i));
end
fft_data_en_amp = abs(fft_data_en);
y1 = 10 * log10(fft_data_amp);
y2 = 10 * log10(fft_data_en_amp);


figure;
t = (1:midN)/N *fs;
subplot(2,1,1)
plot(t,y1(1:midN));
subplot(2,1,2);
plot(t,y2(1:midN));
figure;
plot(t,y1(1:midN),t,y2(1:midN),'r--');