clear
%读berlin库数据
pathname = uigetdir(cd, '请选择文件夹');
if pathname == 0
    msgbox('您没有正确选择文件夹');
    return;
end

%各类情感定义%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fear
fileswavfear = ls(strcat(pathname,'\A(fear)\*.wav'));
filesfear = [cellstr(fileswavfear)]; % 得到文件路径
lenfear = length(filesfear); % 文件个数
%disgust
fileswavdisgust = ls(strcat(pathname,'\E(disgust)\*.wav'));
filesdisgust = [cellstr(fileswavdisgust)]; % 得到文件路径
lendisgust = length(filesdisgust); % 文件个数
%joy
fileswavjoy = ls(strcat(pathname,'\F(joy)\*.wav'));
filesjoy = [cellstr(fileswavjoy)]; % 得到文件路径
lenjoy = length(filesjoy); % 文件个数
%boredom
fileswavboredom = ls(strcat(pathname,'\L(boredom)\*.wav'));
filesboredom = [cellstr(fileswavboredom)]; % 得到文件路径
lenboredom = length(filesboredom); % 文件个数
%neutral
fileswavneutral = ls(strcat(pathname,'\N(neutral)\*.wav'));
filesneutral = [cellstr(fileswavneutral)]; % 得到文件路径
lenneutral = length(filesneutral); % 文件个数
%sadness
fileswavsadness = ls(strcat(pathname,'\T(sadness)\*.wav'));
filessadness = [cellstr(fileswavsadness)]; % 得到文件路径
lensadness = length(filessadness); % 文件个数
%anger
fileswavanger = ls(strcat(pathname,'\W(anger)\*.wav'));
filesanger = [cellstr(fileswavanger)]; % 得到文件路径
lenanger = length(filesanger); % 文件个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%各类数据赋值%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs=16000;%采样频率Hz
framelength=0.028;%帧长s
frameshift=0.014;%帧移s
hwin=hamming(framelength*fs)';%窗型
featurenum=408;%初始特征维数
%各个类别情感的特征矢量，行数为该类别样本数，列数为初始特征维数
featurefear=zeros(lenfear,featurenum);
featuredisgust=zeros(lendisgust,featurenum);
featurejoy=zeros(lenjoy,featurenum);
featureboredom=zeros(lenboredom,featurenum);
featureneutral=zeros(lenneutral,featurenum);
featuresadness=zeros(lensadness,featurenum);
featureanger=zeros(lenanger,featurenum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for i = 1:lenfear
    tempfile=wavread(char(filesfear(i)));
    featurefear(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lendisgust
    tempfile=wavread(char(filesdisgust(i)));
    featuredisgust(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lenjoy
    tempfile=wavread(char(filesjoy(i)));
    featurejoy(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lenboredom
    tempfile=wavread(char(filesboredom(i)));
    featureboredom(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lenneutral
    tempfile=wavread(char(filesneutral(i)));
    featureneutral(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lensadness
    tempfile=wavread(char(filessadness(i)));
    featuresadness(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end
for i = 1:lenanger
    tempfile=wavread(char(filesanger(i)));
    featureanger(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%读入的样本
end

save featurefear 'featurefear';
save featuredisgust 'featuredisgust';
save featurejoy 'featurejoy';
save featureboredom 'featureboredom';
save featureneutral 'featureneutral';
save featuresadness 'featuresadness';
save featureanger 'featureanger';

% clear
% 
% load 'featurefear.mat';
% load 'featuredisgust.mat';
% load 'featurejoy.mat';
% load 'featureboredom.mat';
% load 'featureneutral.mat';
% load 'featuresadness.mat';
% load 'featureanger.mat';
