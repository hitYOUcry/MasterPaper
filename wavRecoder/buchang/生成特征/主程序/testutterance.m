%it is used for testing functions of utterances
clear
a=wavread('E:\Matlab7.1\work\emotion\berlin\E(disgust)\11a02Ec.wav');
fs=16000;
framelength=0.028;
b=enframe(a,hamming(fs*framelength),round(fs*framelength/2));
x=b;
%changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y=GetUtterFeature(a,framelength,framelength/2,fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(y)
