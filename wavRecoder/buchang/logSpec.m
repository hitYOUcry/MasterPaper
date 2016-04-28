function spec = logSpec(wavFrame)
N = length(wavFrame);
inf_th = 10e-10;
fft_data = fft(wavFrame);
fft_data_amp = abs(fft_data);
fft_data_amp(find(fft_data_amp<inf_th)) = inf_th;

midN = mid(N);
spec = 10 * log10(fft_data_amp(1:midN));