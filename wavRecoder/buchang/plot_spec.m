function plot_spec(y, win_len, fs,a,b)
[s, f] = specgram(y, win_len, fs);
%[s ,f] = spectrogram(y,hamming(win_len),0.5 * win_len,win_len,fs);
img = 20 * log10(abs(s));
t=(1:length(y))/fs;
imagesc(t,f,img);
 axis xy; 
 colormap(jet)
 if nargin == 5
     caxis([a, b])
 end
 %