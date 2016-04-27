clc;
clear all;
path = 'F:\实验室相关\wavRecoder\wavRecoder\';
fre = [125,250,500,750,1000,1500,2000,3000,4000,5000,8000];
fre_str = {'125Hz/125Hz_','250Hz/250Hz_','500Hz/500Hz_','750Hz/750Hz_'...
    '1000Hz/1000Hz_','1500Hz/1500Hz_','2000Hz/2000Hz_','3000Hz/3000Hz_'...
    '4000Hz/4000Hz_','5000Hz/5000Hz_','8000Hz/8000Hz_'};
vol_str = {'5.mat','10.mat','20.mat','30.mat','40.mat','50.mat','60.mat'};
result = zeros(7,11);
figure;
for i = 1:size(result,1)
    ploy_point = 240;
    for j = 1:size(result,2)
        load_path = strcat(strcat(path,fre_str(j)),vol_str(i));
        load(load_path{1});
        fs = size(y,1)/2;
        a = 0.5 * fs;
        b = 1.5 * fs;
        y = y(a:b);
        result(i,j) = rms(y);
        subplot(7,11,(i-1) * 11 + j);
        f = fre(j);
        plot_point = 1/f * 4 * fs;
        plot(y(a:(a + plot_point)));
    end
end
figure;
for i = 1:size(result,1)
    subplot(2,4,i)
    plot(result(i,:),fre);
    avg_rms = sum(result(i,:))/size(result,2);
    ylabel(strcat('avg_RMS = ' ,num2str(avg_rms)));
    xlabel(vol_str(i));
end
    