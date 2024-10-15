% Part three: EOG signals
% 3.1)
% Loading data
data = load("EOG_sig.mat");
signal = data.Sig;
labels = data.Labels;
fs = data.fs;

% Plotting EOG signals
% Left eye
t = (0:length(signal)-1)/fs;
figure;
subplot(2, 1, 1)
plot(t, signal(1, :))
title(labels(1))
xlabel('Time(s)')
ylabel('EOG(uV)')

% Right eye
subplot(2, 1, 2)
plot(t, signal(2, :))
xlabel('Time(s)')
ylabel('EOG(uV)')
title(labels(2))

sgtitle('EOG-Time')
saveas(gcf, 'Part 3.1 - EOG-time.png')

% 3.2)
% Compute and plot the FFT of the signal before and after filtering
N = length(signal);
f = (0:N/2-1)*fs/N; % Frequency vector
X = fft(signal(1, :)); % FFT of left eye signal
Y = fft(signal(2, :)); % FFT of right eye signal
Xmag = abs(X(1:N/2)); % Magnitude of FFT of left eye signal
Ymag = abs(Y(1:N/2)); % Magnitude of FFT of right eye signal
figure
subplot(2,1,1)
plot(f,Xmag)
xlim([0 20])
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT of left eye signal')
subplot(2,1,2)
plot(f,Ymag)
xlim([0 20])
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT of right eye signal')

sgtitle('FFT of EOG')
saveas(gcf, 'Part 3.2 - EOG-frequency.png')

% Plot the spectrogram of the signal using pspectrum
figure('Name', "Part 3.2 -  time-frequency spectrum");
subplot(2, 1, 1);
pspectrum(signal(1, :),fs,'spectrogram','FrequencyLimits',[0 40]); % limit the frequency range to 0-40 Hz
title(labels{1});
subplot(2, 1, 2);
pspectrum(signal(2, :),fs,'spectrogram','FrequencyLimits',[0 40]); % limit the frequency range to 0-40 Hz
title(labels{2})

sgtitle('Spectrogram of EOG')
saveas(gcf, 'Part 3.2 - EOG-spectrogram.png')