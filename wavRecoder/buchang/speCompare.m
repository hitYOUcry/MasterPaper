function y = speCompare(x,fs)
frameLen = length(x);
fft_x = abs(fft(x));
figure;
plot(fft_x);
end