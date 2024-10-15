% Part 4: EMG signals
% 4.1)
% load data
data = load("EMG_sig.mat");
fs = data.fs;

% Plot EMG-Time signals
figure;
subplot(3, 1, 1)
plot((0:length(data.emg_healthym)-1)/fs, data.emg_healthym)
title("Healthy")
xlabel('Time(s)')
ylabel('EMG(uV)')

subplot(3, 1, 2)
plot((0:length(data.emg_myopathym)-1)/fs, data.emg_myopathym)
title("Myopathy")
xlabel('Time(s)')
ylabel('EMG(uV)')

subplot(3, 1, 3)
plot((0:length(data.emg_neuropathym)-1)/fs, data.emg_neuropathym)
title("Neuropathy")
xlabel('Time(s)')
ylabel('EMG(uV)')

sgtitle('EMG-Time')
saveas(gcf, 'Part 4.1 - EMG-time.png')

% 4.2)

figure;
% Plot fft of healthy
subplot(3,1,1)
N = length(data.emg_healthym);
X_healthy = fft(data.emg_healthym);
plot((0:N/2-1)*fs/N, abs(X_healthy(1:N/2)));
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Healthy')

% Plot fft of myopathy
subplot(3,1,2)
N = length(data.emg_myopathym);
X_myo = fft(data.emg_myopathym);
plot((0:N/2-1)*fs/N, abs(X_myo(1:N/2)));
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Myopathy')

% Plot fft of neuropathy
subplot(3,1,3)
N = length(data.emg_neuropathym);
X_neuro = fft(data.emg_neuropathym);
plot((0:N/2-1)*fs/N, abs(X_neuro(1:N/2)));
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Neuropathy')

sgtitle('EMG-Frequency')
saveas(gcf, 'Part 4.2 - EMG-frequency.png')

% Plot the spectrogram of the signal using pspectrum
figure('Name', "Part 4.2 -  time-frequency spectrum");
subplot(3, 1, 1);
pspectrum(data.emg_healthym,fs,'spectrogram','FrequencyLimits',[0 2000]); % limit the frequency range to 0-2000 Hz
title("Healthy");
subplot(3, 1, 2);
pspectrum(data.emg_myopathym,fs,'spectrogram','FrequencyLimits',[0 2000]); % limit the frequency range to 0-2000 Hz
title("Myopathy")
subplot(3, 1, 3);
pspectrum(data.emg_neuropathym,fs,'spectrogram','FrequencyLimits',[0 2000]); % limit the frequency range to 0-2000 Hz
title("Neuropathy")

sgtitle('EMG-spectrogram')
saveas(gcf, 'Part 4.2 - EMG-spectrogram.png')
