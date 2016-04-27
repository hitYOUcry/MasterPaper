clear
%%%%%%%%input%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TrainRatio=0.5;
FoldNum=5;%5 fold CV
TrainTimes=1;
%ClassNum=7;
dnummax=10;%降维后的最大维数
ParNum=20;%交叉验证的参数个数
% NNNum=25;%SDA近邻个数
t1=30;
t2=60;
t3=100;
kdnum=80;%核降维扣去的维数
% pnum=100;
FSNum=100;%特征选择维数
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pnumLLDDP=50;
        pnumLDA=50;
        pnumLPP=50;
        pnumMFA=50;
        NNNumLDDP=50;
        NNNumLPP=50;
        NNNumMFA=50;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RateLLDDP=zeros(dnummax,TrainTimes);
RateK1LDDP=zeros(dnummax,TrainTimes);
RateK2LDDP=zeros(dnummax,TrainTimes);
RateK3LDDP=zeros(dnummax,TrainTimes);
RatePCA=zeros(dnummax,TrainTimes);
RateLDA=zeros(dnummax,TrainTimes);
RateLPP=zeros(dnummax,TrainTimes);
RateMFA=zeros(dnummax,TrainTimes);
RateBaseline=zeros(1,TrainTimes);

load 'featurefear.mat';
load 'featuredisgust.mat';
load 'featurejoy.mat';
load 'featureboredom.mat';
load 'featureneutral.mat';
load 'featuresadness.mat';
load 'featureanger.mat';

%[SampleTrain SampleTest SampleSubTrain LabelTrain LabelTest LabelSubTrain_Train LabelSubTrain_Test]=PartitionBerlin(featurefear,featuredisgust,featurejoy,featureboredom,featureneutral,featuresadness,featureanger,TrainRatio,FoldNum);

%[RateSeq SigmaSeq]=SelSigKNN_SDA(SampleSubTrain,LabelSubTrain_Train,LabelSubTrain_Test,10,10,15);
%[RateSeq SigmaSeq]=SelSigSVM_SDA(SampleSubTrain,LabelSubTrain_Train,LabelSubTrain_Test,40,20,25);



for i=1:TrainTimes%训练次数
    [SampleTrain SampleTest SampleSubTrain LabelTrain LabelTest LabelSubTrain_Train LabelSubTrain_Test]=PartitionBerlin(featurefear,featuredisgust,featurejoy,featureboredom,featureneutral,featuresadness,featureanger,TrainRatio,FoldNum);
    Sigma=1/mean([size(find(LabelTrain==1)),size(find(LabelTrain==2)),size(find(LabelTrain==3)),size(find(LabelTrain==4)),size(find(LabelTrain==5)),size(find(LabelTrain==6)),size(find(LabelTrain==7))]);
%以下Berlin和Enterface相同

    %%%%%%%%Feature Selection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Tem1 SampleTest]=FDR(SampleTrain,SampleTest,LabelTrain,FSNum);
    TempSub=zeros(size(SampleSubTrain,1),FSNum,FoldNum);
    for fn=1:FoldNum
        [Tem2 TempSub(:,:,fn)]=FDR(SampleTrain,SampleSubTrain(:,:,fn),LabelTrain,FSNum);
    end
    SampleSubTrain=TempSub;
    SampleTrain=Tem1;
    %%%%%%%%Feature Selection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for dnum=2:dnummax%降维维数
        times=i
        dnum

%%%%%%%%%%%%%%%%%%%%这里需要修改为LDDP相关的函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        display('Train LLDDP...');
        [RateSeqL SigmaSeqL]=SelSigSVM_LLDDP(SampleSubTrain,LabelSubTrain_Train,LabelSubTrain_Test,ParNum,dnum,NNNumLDDP,pnumLLDDP,Sigma);
        display('Train K1LDDP...');
        [RateSeqK1 SigmaSeqK1]=SelSigSVM_KLDDP(SampleSubTrain,LabelSubTrain_Train,LabelSubTrain_Test,ParNum,dnum,NNNumLDDP,t1,kdnum,Sigma);
        display('Train K2LDDP...');
        [RateSeqK2 SigmaSeqK2]=SelSigSVM_KLDDP(SampleSubTrain,LabelSubTrain_Train,LabelSubTrain_Test,ParNum,dnum,NNNumLDDP,t2,kdnum,Sigma);
        display('Train K3LDDP...');
        [RateSeqK3 SigmaSeqK3]=SelSigSVM_KLDDP(SampleSubTrain,LabelSubTrain_Train,LabelSubTrain_Test,ParNum,dnum,NNNumLDDP,t3,kdnum,Sigma);
%%%%%%%%%%%%%%%%%%%%这里需要修改为LDDP相关的函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        [MaxRateL StepLNum]=max(RateSeqL);
        [MaxRateK1 StepK1Num]=max(RateSeqK1);
        [MaxRateK2 StepK2Num]=max(RateSeqK2);
        [MaxRateK3 StepK3Num]=max(RateSeqK3);
        StepL=SigmaSeqL(StepLNum);%交叉验证选择参数
        StepK1=SigmaSeqK1(StepK1Num);
        StepK2=SigmaSeqK2(StepK2Num);
        StepK3=SigmaSeqK3(StepK3Num);

%          SigmaL=1;%交叉验证选择参数
%          SigmaK1=1;
%          SigmaK2=1;
%          SigmaK3=1;
        
        display('Dimensionality Reduction...');
        
%%%%%%%%%%%%%%%%%%%%这里需要修改为LDDP相关的函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Train_DR_LLDDP Test_DR_LLDDP]=DR_LLDDP(SampleTrain,SampleTest,LabelTrain,dnum,NNNumLDDP,StepL,pnumLLDDP,Sigma);
        [Train_DR_K1LDDP Test_DR_K1LDDP]=DR_KLDDP(SampleTrain,SampleTest,LabelTrain,dnum,NNNumLDDP,StepK1,t1,kdnum,Sigma);
        [Train_DR_K2LDDP Test_DR_K2LDDP]=DR_KLDDP(SampleTrain,SampleTest,LabelTrain,dnum,NNNumLDDP,StepK2,t2,kdnum,Sigma);
        [Train_DR_K3LDDP Test_DR_K3LDDP]=DR_KLDDP(SampleTrain,SampleTest,LabelTrain,dnum,NNNumLDDP,StepK3,t3,kdnum,Sigma);
%%%%%%%%%%%%%%%%%%%%这里需要修改为LDDP相关的函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        [Train_DR_PCA Test_DR_PCA]=DR_PCA(SampleTrain,SampleTest,dnum);
        [Train_DR_LDA Test_DR_LDA]=DR_LDA(SampleTrain,SampleTest,LabelTrain,dnum,pnumLDA);
        [Train_DR_LPP Test_DR_LPP]=DR_LPP(SampleTrain,SampleTest,dnum,NNNumLPP,10,pnumLPP);
        [Train_DR_MFA Test_DR_MFA]=DR_MFA(SampleTrain,SampleTest,LabelTrain,dnum,NNNumMFA,NNNumMFA,pnumMFA);
%         if dnum==2&i==1
%             Draw2D(Test_DR_PCA,LabelTest);
%             Draw2D(Test_DR_LDA,LabelTest);
%             Draw2D(Test_DR_LPP,LabelTest);
%             Draw2D(Test_DR_MFA,LabelTest);
%             Draw2D(Test_DR_LLDDP,LabelTest);
%         end
        display('Classify...');
        times=i
        dnum
        LabelSeq_LLDDP=VoteSVMclassify(Test_DR_LLDDP, Train_DR_LLDDP, LabelTrain);
        LabelSeq_K1LDDP=VoteSVMclassify(Test_DR_K1LDDP, Train_DR_K1LDDP, LabelTrain);
        LabelSeq_K2LDDP=VoteSVMclassify(Test_DR_K2LDDP, Train_DR_K2LDDP, LabelTrain);
        LabelSeq_K3LDDP=VoteSVMclassify(Test_DR_K3LDDP, Train_DR_K3LDDP, LabelTrain);
        LabelSeq_PCA=VoteSVMclassify(Test_DR_PCA, Train_DR_PCA, LabelTrain);
        LabelSeq_LDA=VoteSVMclassify(Test_DR_LDA, Train_DR_LDA, LabelTrain);
        LabelSeq_LPP=VoteSVMclassify(Test_DR_LPP, Train_DR_LPP, LabelTrain);
        LabelSeq_MFA=VoteSVMclassify(Test_DR_MFA, Train_DR_MFA, LabelTrain);
        RateLLDDP(dnum,i)=1-cerror(LabelSeq_LLDDP,LabelTest);
        RateK1LDDP(dnum,i)=1-cerror(LabelSeq_K1LDDP,LabelTest);
        RateK2LDDP(dnum,i)=1-cerror(LabelSeq_K2LDDP,LabelTest);
        RateK3LDDP(dnum,i)=1-cerror(LabelSeq_K3LDDP,LabelTest);
        RatePCA(dnum,i)=1-cerror(LabelSeq_PCA,LabelTest);
        RateLDA(dnum,i)=1-cerror(LabelSeq_LDA,LabelTest);
        RateLPP(dnum,i)=1-cerror(LabelSeq_LPP,LabelTest);
        RateMFA(dnum,i)=1-cerror(LabelSeq_MFA,LabelTest);
    end
    LabelSeq_Baseline=VoteSVMclassify(SampleTest, SampleTrain, LabelTrain);
    RateBaseline(i)=1-cerror(LabelSeq_Baseline,LabelTest);
end
AvgRateLLDDP=mean(RateLLDDP,2);
AvgRateK1LDDP=mean(RateK1LDDP,2);
AvgRateK2LDDP=mean(RateK2LDDP,2);
AvgRateK3LDDP=mean(RateK3LDDP,2);
AvgRatePCA=mean(RatePCA,2);
AvgRateLDA=mean(RateLDA,2);
AvgRateLPP=mean(RateLPP,2);
AvgRateMFA=mean(RateMFA,2);
AvgRateBaseline=mean(RateBaseline,2);

figure,plot(AvgRateLLDDP,'kv:','LineWidth',3);
hold on
grid on
plot(AvgRateK1LDDP,'kd:','LineWidth',3);
plot(AvgRateK2LDDP,'ks:','LineWidth',3);
plot(AvgRateK3LDDP,'ko:','LineWidth',3);
set(gca,'FontSize',22);
xlabel('Dimension','Fontsize',22);
ylabel('Recognition Rate','Fontsize',22);
h=legend('LLDDP','Kernel1-LDDP','Kernel2-LDDP','Kernel3-LDDP',4);
axis([2 dnummax 0.2 1]);
set(gca,'linewidth',3);

figure,plot(AvgRateLLDDP,'rv:','LineWidth',3);
hold on
grid on
plot(AvgRatePCA,'kd:','LineWidth',3);
plot(AvgRateLDA,'ks:','LineWidth',3);
plot(AvgRateLPP,'kx:','LineWidth',3);
plot(AvgRateMFA,'ko:','LineWidth',3);
set(gca,'FontSize',22);
xlabel('Dimension','Fontsize',22);
ylabel('Recognition Rate','Fontsize',22);
h=legend('LLDDP','PCA','LDA','LPP','MFA',4);
axis([2 dnummax 0.2 1]);
set(gca,'linewidth',3);


% cc=zeros(6,1);
% for i=5:10
% [Train_DR Test_DR]=DR_SDA(SampleTrain,SampleTest,LabelTrain,i,35,0.4);
% % Train_DR=Normalization(Train_DR,Train_DR);
% % Test_DR=Normalization(Train_DR,Test_DR);
% c1 = knnclassify(SampleTest, SampleTrain, LabelTrain,5);
% c2 = knnclassify(Test_DR, Train_DR, LabelTrain,5);
% cc(i)=sum(sign(find(c2-LabelTest==0)))/length(LabelTest);
% end
% plot(cc);
% hold on
% plot(5:10,sum(sign(find(c1-LabelTest==0)))/length(LabelTest)*ones(6),'r');