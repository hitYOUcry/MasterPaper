fs=44100;           %取样频率
duration=2;         %录音时间
fprintf('Press any key to start %g seconds of recording...\n',duration);
pause;
fprintf('Recording...\n');
y=wavrecord(duration*fs,fs);         %duration*fs 是总的采样点数
fprintf('Finished recording.\n');
fprintf('Press any key to play the recording...\n');
pause;
wavplay(y,fs);
plot(y(1000:1500));