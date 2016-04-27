filename = 'TX3_4.wav';
%filename = 'test_1.wav';
%filename = 'test.wav';
[y ,fs] = audioread(filename);
figure;
subplot(2,1,1);
plot(y)
time = 0.8;
x = y(fs * time:(fs * time+255));
subplot(2,1,2);
plot(x)
wavFrame = x;
save('frameData.mat','fs','wavFrame');