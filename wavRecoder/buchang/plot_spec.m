function plot_spec(y, win_len, fs)
[s, f] = specgram(y, win_len, fs);
img = 10 * log10(abs(s) + eps);
t=(1:length(y))/fs;
imagesc(t,f,img);
 axis xy; 
 colormap(jet)
 caxis([-40 10])