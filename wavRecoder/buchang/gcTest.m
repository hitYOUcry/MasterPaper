load('chapter4_sa2.mat');
load('y_original.mat');
load('y_formant.mat');
load('y_sce.mat');
load('y_new.mat');

t = (1:length(y))/fs;
% wav graph
figure;
subplot(4,1,1)
plot(t,y);
title('原始 语音');
xlabel('时间')
ylabel('幅度')
subplot(4,1,2)
plot(t,y_formant);
title('共振峰增强 语音');
xlabel('时间')
ylabel('幅度')
subplot(4,1,3)
plot(t,y_sce);
title('共振峰增强&SCE 语音');
xlabel('时间')
ylabel('幅度')
subplot(4,1,4)
plot(t,y_new);
title('输出（共振峰增强 && SCE && 响度补偿）语音');
xlabel('时间')
ylabel('幅度')


figure;
subplot(4,1,1)
plot_spec(y,win_len,fs,-70,15);
title('原始 语谱');
xlabel('时间 / s')
ylabel('频率 / Hz')
subplot(4,1,2)
plot_spec(y_formant,win_len,fs,-70,15);
title('共振峰增强 语谱');
xlabel('时间 / s')
ylabel('频率 / Hz')
subplot(4,1,3)
plot_spec(y_sce,win_len,fs,-70,15);
title('共振峰增强&&SCE 语谱');
xlabel('时间 / s')
ylabel('频率 / Hz')
subplot(4,1,4)
plot_spec(y_new,win_len,fs,-70,15);
title('输出（共振峰增强 && SCE && 响度补偿）语谱');
xlabel('时间 / s')
ylabel('频率 / Hz')


