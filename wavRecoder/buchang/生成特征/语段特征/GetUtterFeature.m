function y=GetUtterFeature(a,Twindow,Tshift,fs)
%

x=enframe(a,hamming(round(Twindow*fs)),round(Tshift*fs));
y=[UtterEnergy(x,fs)' UtterPitch(x,fs)' UtterZerocross(x)' UtterDurance(x,fs)' UtterFormant(x,3,fs)' UtterMFCC(x,fs)'];

y=y';
end