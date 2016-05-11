t = 1:length(original);
figure;
subplot(2,1,1)
plot(original)
title('original')
subplot(2,1,2)
plot(spec);
title('spec');
t = 1:length(logOriginal);
figure;
plot(t,logOriginal,t,logSpec);
