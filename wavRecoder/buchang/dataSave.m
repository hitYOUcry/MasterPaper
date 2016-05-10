clc;
clear all;
close all;
filename='TX5_4.wav';
%filename = 'a.mp3';
%filename = 'TX3_4.wav';
%filename = 'test_1.wav';
%filename = 'test.wav';
[y ,fs] = audioread(filename);
wlen = 20 /1000* fs;
inc = 0.5 * wlen;
midN = mid(wlen);
s = enframe(y,wlen,inc);
%{
%% SPL 
for i = 1 : size(s,1)
    spl(i) = cal_spl(s(i,:));
end
%% FFT SPL
x = s(10,:);
X = fft(x);
X = abs(X);
X_spl = 10*log10(X./2 * 10e5);
figure;
subplot(2,1,1)
plot((1:length(spl))/length(spl) * length(y)/fs,spl);
subplot(2,1,2)
plot(((1:midN) - 1)/wlen * fs,X_spl(1:midN));
%}
figure;
subplot(2,1,1);
t = (1:length(y))/fs;
plot(t,y)
time =1.84;
x = y(fs * time:(fs * time+255));
subplot(2,1,2);
plot(x)
wavFrame = x;
save('formantWav.mat','fs','x');
%save('frameData.mat','fs','wavFrame');