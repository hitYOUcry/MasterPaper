filename='hmmtestwav/ang/m2f2ang1.wav';
[y fs]=wavread(filename);
%y=y(1.5*fs:2.5*fs);
[s,f,t]=specgram(y,256,fs);
img=20*log10(abs(s)+eps);
%imshow(img);
subplot(1,2,1);
t=(1:length(y))/fs;
plot(t,y);
title('‘≠ º”Ô“Ù–≈∫≈');
subplot(1,2,2);
imagesc(t,f,img);
 axis xy; 
 colormap(jet)
 caxis([-40 10])
 colormap(gray) 
 title('”Ô∆◊Õº');