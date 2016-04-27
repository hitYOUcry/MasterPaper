clear
%读Enterface库数据，选择“enterface_database_new”文件夹
pathname = uigetdir(cd, '请选择文件夹');
if pathname == 0
    msgbox('您没有正确选择文件夹');
    return;
end

%各类情感定义%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%anger
fileswavanger = ls(strcat(pathname,'\anger\*.wav'));
filesanger = [cellstr(fileswavanger)]; % 得到文件路径
lenanger = length(filesanger); % 文件个数
%disgust
fileswavdisgust = ls(strcat(pathname,'\disgust\*.wav'));
filesdisgust = [cellstr(fileswavdisgust)]; % 得到文件路径
lendisgust = length(filesdisgust); % 文件个数
%fear
fileswavfear = ls(strcat(pathname,'\fear\*.wav'));
filesfear = [cellstr(fileswavfear)]; % 得到文件路径
lenfear = length(filesfear); % 文件个数
%happy
fileswavhappy = ls(strcat(pathname,'\happy\*.wav'));
fileshappy = [cellstr(fileswavhappy)]; % 得到文件路径
lenhappy = length(fileshappy); % 文件个数
%sadness
fileswavsadness = ls(strcat(pathname,'\sadness\*.wav'));
filessadness = [cellstr(fileswavsadness)]; % 得到文件路径
lensadness = length(filessadness); % 文件个数
%surprise
fileswavsurprise = ls(strcat(pathname,'\surprise\*.wav'));
filessurprise = [cellstr(fileswavsurprise)]; % 得到文件路径
lensurprise = length(filessurprise); % 文件个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%各类数据赋值%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs=48000;%采样频率Hz
framelength=0.028;%帧长s
frameshift=0.014;%帧移s
hwin=hamming(framelength*fs)';%窗型
featurenum=408;%初始特征维数
%各个类别情感的特征矢量，行数为该类别样本数，列数为初始特征维数
Enterfeatureanger=zeros(lenanger,featurenum);
Enterfeaturedisgust=zeros(lendisgust,featurenum);
Enterfeaturefear=zeros(lenfear,featurenum);
Enterfeaturehappy=zeros(lenhappy,featurenum);
Enterfeaturesadness=zeros(lensadness,featurenum);
Enterfeaturesurprise=zeros(lensurprise,featurenum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for i = 1:lenanger
    tempfile=readwav(strcat(pathname,'\anger\',char(filesanger(i))));
    tempfile=tempfile(:,1);
    Enterfeatureanger(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lendisgust
    tempfile=readwav(strcat(pathname,'\disgust\',char(filesdisgust(i))));
    tempfile=tempfile(:,1);
    Enterfeaturedisgust(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lenfear
    tempfile=readwav(strcat(pathname,'\fear\',char(filesfear(i))));
    tempfile=tempfile(:,1);
    Enterfeaturefear(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lenhappy
    tempfile=readwav(strcat(pathname,'\happy\',char(fileshappy(i))));
    tempfile=tempfile(:,1);
    Enterfeaturehappy(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lensadness
    tempfile=readwav(strcat(pathname,'\sadness\',char(filessadness(i))));
    tempfile=tempfile(:,1);
    Enterfeaturesadness(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lensurprise
    tempfile=readwav(strcat(pathname,'\surprise\',char(filessurprise(i))));
    tempfile=tempfile(:,1);
    Enterfeaturesurprise(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end


save Enterfeatureanger 'Enterfeatureanger';
save Enterfeaturedisgust 'Enterfeaturedisgust';
save Enterfeaturefear 'Enterfeaturefear';
save Enterfeaturehappy 'Enterfeaturehappy';
save Enterfeaturesadness 'Enterfeaturesadness';
save Enterfeaturesurprise 'Enterfeaturesurprise';

% clear
% 
% load 'featurefear.mat';
% load 'featuredisgust.mat';
% load 'featurejoy.mat';
% load 'featureboredom.mat';
% load 'featureneutral.mat';
% load 'featuresadness.mat';
% load 'featureanger.mat';
