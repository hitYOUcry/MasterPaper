clc;
clear all;close all;
load('formantWav.mat');

%% LPC ana
p = 24;
a=lpc(x,p);
N = length(x);

%% spec
fft_x = 10 * log10(abs(fft(x)));

%% LPC spec
b = [1 zeros(1,p)];
[h,~] = freqz(b,a,2*N);
h =10 * log10(abs(h));

t = ((1:mid(N))-1)/N * fs;
figure;
plot(t,fft_x(1:mid(N)),(1:length(h))/length(h)*fs/2,h);
title('¹²Õñ·å¼ì²â');
xlabel('Frequency/Hz');
ylabel('Amplitude/dB');
legend('·ù¶ÈÆ×','LPCÆ×');