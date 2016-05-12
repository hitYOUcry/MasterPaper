clc;clear all;close all
%% 读入语音
load('frameData.mat');
data = wavFrame';
N = length(wavFrame);
midN = mid(N);

%% 谱增强
data_new  = SCE(data,1,fs);
spec =  logSpec(data);
spec_new = logSpec(data_new);

figure;
t = (0:(midN-1))/N *fs;
subplot(2,1,1)
plot(t,spec(1:midN));
subplot(2,1,2);
plot(t,spec_new(1:midN));
figure;
plot(t,spec(1:midN),t,spec_new(1:midN),'r--');
title('频谱对比')
xlabel('Frequency/Hz');
ylabel('Amplitude/dB');
legend('增强前','增强后');