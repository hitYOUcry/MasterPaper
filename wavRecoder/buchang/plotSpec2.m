function plotSpec2(x,win_len,fs)
inc = round(0.2 * win_len);
s = enframe(x,hanning(win_len),inc);
frame_num = size(s,1);
midN = mid(win_len);
spec = zeros(frame_num,midN);

for i = 1:frame_num
    temp = s(i,:);
    fft_amp = abs(fft(temp));
    spec(i,:) = 20 * log10( fft_amp(1:midN)+ eps);
end
t = (1:length(x))/fs;
f = (1:midN)*fs/win_len;
imagesc(t,f,spec');
 axis xy; 
 colormap(jet)
 caxis([-30,10])