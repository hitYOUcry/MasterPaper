% 程序 11-5 AudioAcquisitionInFixedDuration.m
duration = 0.5;  % 数据采集时间长度
ai = analoginput('winsound');
addchannel(ai, 1);
sampleRate = get(ai, 'SampleRate');
requiredSamples = floor(sampleRate * duration); % 数据采集点数
set(ai, 'SamplesPerTrigger', requiredSamples);
waitTime = duration * 1.1 + 0.5;
start(ai)                     % 启动
tic
wait(ai, waitTime);
toc
[data, time] = getdata(ai); % 获取数据
figure;                        %%%% 绘图
plot(time,data);             % 绘图
xlabel('时间(s)');            % 设置x轴
ylabel('信号(V)');            % 设置y轴
title('声卡采集得到的数据');   % 设置标题
grid on;                       % 显示网格
% wavplay(data,sampleRate);   %%%% 播放采集到的信号
delete(ai);
clear ai;