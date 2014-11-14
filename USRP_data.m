N_fft = 4096;
BW = 8;
[c r] = size(IQ);


for k=1:r
    Y_f(k,:) = 20*log(abs(fft(IQ(:,k),N_fft)));
end

Y_t = [];

for k=1:c
    Y_t = cat(2,Y_t,Y_f(k,:));
end

figure;
hold on;
grey = [238 233 233]/256;
axis([0 length(X_t) -110 110]);

for k=1:2:39
    n = (8/BW)*N_fft
    area([0+n*(k-1) n+n*(k-1)],[110 110], 'FaceColor', grey, 'EdgeColor', 'none');
    area([0+n*(k-1) n+n*(k-1)],[-110 -110], 'FaceColor', grey, 'EdgeColor', 'none');
end

title('Power Spectrum of TV Band');
xlabel('UHF Channel');
ylabel('Spectral Power (dB)');

set(gca,'XTick',n/2:n:N_fft*N_freq+2048);
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','9','10','11','12','13', ...
    '14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31', ...
    '32','33','34','35','36','37','38','39','40',' '});

plot(X_t, 'red');
plot(Y_t, 'blue');