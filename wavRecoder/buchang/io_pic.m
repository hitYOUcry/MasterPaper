clc;
clear all;
close all;
k_fs =  [125 250 500 750 1000 1500 2000 3000 4000 5000 8000];
thr_gb  =   [45   25.5    11.5   7.5   7    6.5    9   10    9.5   13   13];
thr  =   [70   68    66   67    69    75    80   85    90   96   100];%dB SPL
%thr = thr - thr_gb;% dB HL
thr = [30 40 50 60 60 70 70 75 80 80 85];
%% hearing thresold fig
figure;
plot(thr,'ro');
grid on;
set(gca, 'GridLineStyle','-');
set(gca,'YLim',[0 120]);
set(gca,'ydir','reverse');
set(gca,'xaxislocation','top')
set(gca,'XTickLabel',{'125','250','500','750','1000','1500','2000','3000','4000','5000','8000'}) 
xlabel('frequency(Hz)');
ylabel('hearing threshold (dB HL)');

%% I/O pic
%f = 125:(8000/256):8000;
f = 3000;
n = length(f);
for k = 1 : n
    f_t = f(k);
    amp = 0;
    for i = 1 : 121
        out_spl(k,i) = cal_outSpl(f_t,amp);
        amp = amp + 1;
    end
end
figure;
mesh(0:120,f,out_spl);
xlabel('Input(dB SPL)');
ylabel('Frequency(Hz)');
zlabel('Output(dB SPL)');

%{
figure;
plot(0:120,out_spl,'-');
grid on;
xlabel('Input (dB SPL)');
ylabel('Output (dB SPL)');
title('I/O curves')
%}