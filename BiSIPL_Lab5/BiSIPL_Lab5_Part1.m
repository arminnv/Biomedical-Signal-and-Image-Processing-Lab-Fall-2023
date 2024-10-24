close all
normal = load('normal.mat').normal;
t = double(normal(:, 1));
x = double(normal(:, 2));
fs = 1/(t(2)-t(1));

figure;
subplot(2, 1, 1)
plot(t(1:fs*10), x(1:fs*10))
title('clean')
xlabel('Time(s)')
ylabel('ECG(V)')
subplot(2, 1, 2)
plot(t(end-10*fs:end), x(end-10*fs:end))
title('noisy')
xlabel('Time(s)')
ylabel('ECG(V)')
xlim([290 300])
saveas(gcf, 'time domain.png')

figure;
subplot(2, 1, 1)
[Pxx, f] = pwelch(x(1:fs*10), [], [], [], fs);
plot(f, Pxx)
title('clean')
xlabel('frequency(Hz)')
ylabel('Power Spectral Density')
xlim([1 120])
subplot(2, 1, 2)
[Pxx, f] = pwelch(x(end-10*fs:end), [], [], [], fs);
plot(f, Pxx)
title('noisy')
xlabel('frequency(Hz)')
ylabel('Power Spectral Density')
xlim([1 120])
saveas(gcf, 'psd.png')

figure
subplot(2, 1, 1)
[Pxx, f] = pwelch(x(1:fs*10), [], [], [], fs);
plot(f,  mag2db(Pxx))
title('clean')
xlabel('frequency(Hz)')
ylabel('Power Spectral Density(dB)')
xlim([1 120])
subplot(2, 1, 2)
[Pxx, f] = pwelch(x(end-10*fs:end), [], [], [], fs);
plot(f, mag2db(Pxx))
title('noisy')
xlabel('frequency(Hz)')
ylabel('Power Spectral Density(dB)')
xlim([1 120])
saveas(gcf, 'psd_dB.png')

fcutlow=10;   %low cut frequency in Hz
fcuthigh=40;   %high cut frequency in Hz
% Creating butterworth filter 
[b,a] = butter(7, [1 35]/(fs/2));

figure
% Plotting impulse response
impz(b,a,50)
title('impulse response')
saveas(gcf, 'impz.png')

figure
freqz(b,a,256,fs)
% Plotting frequency response
[h, f] = freqz(b,a,256,fs);
saveas(gcf, 'freq.png')

x_noisy_filtered = filter(b, a, x(int32(240*fs):int32(250*fs)));
x_filtered = filter(b, a, x(1:int32(10*fs)));

[Pxx, f] = pwelch(x(1:int32(10*fs)), [], [], [], fs);
[Pxx_filtered, f] = pwelch(x_filtered, [], [], [], fs);
% Calculating energy loss
loss_rate = 1 - sum(Pxx_filtered(int32(1*4): int32(50*4)))/sum(Pxx(int32(1*4): int32(50*4)));
disp(loss_rate)

% Plotting signals before and after filtering
figure;
subplot(4, 1, 1)
plot(t(int32(240*fs):int32(250*fs)), x(int32(240*fs):int32(250*fs)))
title('noisy signal before filtering')
xlabel('Time(s)')
ylabel('ECG(V)')
subplot(4, 1, 2)
plot(t(int32(240*fs):int32(250*fs)), x_noisy_filtered)
title('noisy signal after filtering')
xlabel('Time(s)')
ylabel('ECG(V)')
subplot(4, 1, 3)
plot(t(1:int32(10*fs)), x(1:int32(10*fs)))
title('clean signal before filtering')
xlabel('Time(s)')
ylabel('ECG(V)')
subplot(4, 1, 4)
plot(t(1:int32(10*fs)), x_filtered)
title('clean signal after filtering')
xlabel('Time(s)')
ylabel('ECG(V)')
saveas(gcf, 'before and after filtering.png')





