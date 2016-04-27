% 运行平台：Windows 7 64bit，MATLAB R2013a
% 录音录5秒钟
recObj = audiorecorder(22100,16,1);
disp('Start speaking.')
recordblocking(recObj, 1);
disp('End of Recording.');
% 回放录音数据
play(recObj);
% 获取录音数据
myRecording = getaudiodata(recObj);
% 绘制录音数据波形
plot(myRecording);