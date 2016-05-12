function [new_wav] = SCE(wavFrame,factor,fs)
pa = 1;
if size(wavFrame,2) > size(wavFrame,1)
    wavFrame = wavFrame';
end
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
%% fft data && log Spec
fft_data = fft(wavFrame,N);
fft_data_amp = abs(fft_data);
fft_data_amp(find(fft_data_amp<inf_th)) = inf_th;

midN = mid(N);
y = 20 * log10(fft_data_amp(1:midN)./pa);
y_en = y;

%% get formants && enhence
[FR BW] = FrameFormant(wavFrame,fs);
formantNum = length(FR);
if formantNum > 3
    formantNum = 3;
end
p = 1;
for i = 1 : midN
     f = fs * i / N;

    for k = 1:formantNum
        if abs(f - FR(k)) < BW(k)
           tempM(p) = i;
           p = p + 1;
            break;
        end
    end
end
if p ~= 1
    y(tempM) =  y(tempM) +10;
end
%% mins && maxs
diff_y = diff(y,1);
[maxIndex,maxVal] = findpeaks(y);
[minIndex,minVal] =  findpeaks(-y);
minVal = -minVal;

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
%{
way one
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
%}
minVal_new = minVal;
n = 1;
if diff_y(1) > 0
    n = 2;
end

%BW= 5 * BW;
%% cal new mins && maxs
for m = 1:length(maxIndex)
    if n > length(minVal) || m >length(maxIndex)
        break;
    end
    minVal_new(n) = maxVal(m) - (1 + sc_f) * (maxVal(m) - minVal(n));
    n = n + 1;
end

%% cal new specs 
for k= 2 : midN
    index_max = maxIndex(i);
    index_min = minIndex(j);
    val_max = y(index_max);
    val_min = y(index_min);
    sc = val_max - val_min;
     y_en(k) = (val_max - minVal_new(j))* (y(k) - val_min)/sc + minVal_new(j);
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

%% 

new_fft_amp = pa * power(10,y_en./20);

%spec_t = 20 * log10(abs(fft_data_amp(1:midN)));
new_fft_amp = SPLCompen(fs,new_fft_amp);
%new_fft_amp = SPLCompen(fs,fft_data_amp);

new_fft = new_fft_amp.*exp(1i*angle(fft_data));
new_wav = cal_amp(ifft(new_fft));

%{
figure;
t = (1:midN)/N *fs;
plot(t,y(1:midN),t,y_en(1:midN),'r--');
%}
