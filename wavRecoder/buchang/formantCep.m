function FRMNT = formantCep(x,fs)
u = x;
wlen = length(x);
cepstL=50;                                        % 倒频率上窗函数的宽度
wlen2=wlen/2;               
freq=(0:wlen2-1)*fs/wlen;                        % 计算频域的频率刻度
u2=u.*hamming(wlen);                                     % 信号加窗函数
U=fft(u2);                                       % 按式(9-2-1)计算
U_abs=log(abs(U(1:wlen2)));                      % 按式(9-2-2)计算
Cepst=ifft(U_abs);                               % 按式(9-2-3)计算
cepst=zeros(1,wlen2);           
cepst(1:cepstL)=Cepst(1:cepstL);                 % 按式(9-2-5)计算
cepst(end-cepstL+2:end)=Cepst(end-cepstL+2:end);
spect=real(fft(cepst));                          % 按式(9-2-6)计算
%%  求spect的包络
[Loc,Val]=findpeaks(spect);                      % 寻找峰值
data = spline(Loc,Val,Loc(1):Loc(length(Loc)));

FRMNT=freq(Loc);                                 % 计算出共振峰频率