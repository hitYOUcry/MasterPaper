function new_wav = SCE(wavFrame,factor)
N = length(wavFrame);
%{
%% original data
figure;
plot((1:N)/fs,wavFrame);
title('wav data');
xlabel('time/s');
ylabel('amplitude');
%}
inf_th = 10e-10;
%% fft data 
fft_data = fft(wavFrame);
fft_data_amp = abs(fft_data);
fft_data_amp(find(fft_data_amp<inf_th)) = inf_th;

midN = mid(N);
y = 10 * log10(fft_data_amp(1:midN));
y_en = zeros(1,midN);

diff_y = diff(y,1);
[maxIndex,maxVal] = findpeaks(y);
[minIndex,minVal] =  findpeaks(-y);
max_len = length(maxIndex);
min_len = length(minIndex);
if diff_y(1) > 0
    minIndex = [1;minIndex];
    minVal = [y(1);minVal];
else
    maxIndex = [1;maxIndex];
    maxVal = [y(1);maxVal];
end
if diff_y(end) > 0
    maxIndex = [maxIndex;length(y)];
    maxVal = [maxVal;y(end)];
else
     minIndex = [minIndex;length(y)];
     minVal = [minVal;y(end)];
end
i = 1;
j = 1;

sc_f = factor;%0~1µ÷½Ú
y_en(1) = y(1);
for k= 2 : midN
    index_max = maxIndex(i);
    index_min = minIndex(j);
    val_max = y(index_max);
    val_min = y(index_min);
    sc = val_max - val_min;
    sr = sc * (1 + sc_f);
     y_en(k) = sr * (y(k) - val_min)/sc + val_max - sr;
    if  index_max > index_min && k == index_max
        j =j + 1;
    else if  index_max < index_min && k == index_min
            i = i + 1;
        end
    end
end

if mod(N,2) == 1
    for j = midN:-1:2
        y_en(2 * midN - j + 1) = y_en(j);
    end
else
    for j = (midN-1):-1:2
        y_en(2 * midN - j) = y_en(j);
    end
end
new_fft_amp = power(10,y_en./10);
new_fft = new_fft_amp.*exp(1i*angle(fft_data));
test = ifft(new_fft);
new_wav = cal_amp(ifft(new_fft));

%{
figure;
t = (1:midN)/N *fs;
plot(t,y(1:midN),t,y_en(1:midN),'r--');
%}
