% BiSIPL Lab 4 - Part 3
% Loading data  
data = load("FiveClass_EEG.mat");
fs = 256;  
t_end = int32(10*fs);
trial = int32(data.trial);
X = data.X;
y = int32(data.y);

% Delta Theta Alpha Beta
band_names = {'Delta', 'Theta', 'Alpha', 'Beta'};
fbands = [[1, 4]; [4, 8]; [8, 13]; [13, 30]];

% Band-pass filtered signals
X_bpf = zeros([4 size(X)]);

for i=1:4
    fs = 256; % Sampling Frequency
    N = 4; % Order
    Fpass1 = fbands(i, 1); % First Passband Frequency
    Fpass2 = fbands(i, 2); % Second Passband Frequency
    Apass = 1; % Passband Ripple (dB)
    % Construct an FDESIGN object and call its CHEBY1 method.
    h = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, fs);
    Hd = design(h, 'cheby1');

    for c=1:30
        X_bpf(i, :, c) = filter(Hd, X(:, c));
    end
end

figure
t = (0: 5*fs-1)/fs;
subplot(5, 1, 1)
plot(t, X(1:5*fs, 1))
ylabel('EEG(uV)')
xlabel("Time(s)")
title('raw signal')
for i=1:4
   subplot(5, 1, i+1)
   plot(t, X_bpf(i, 1:5*fs, 1))
   ylabel('EEG(uV)')
   xlabel("Time(s)")
   title(band_names(i))
end
sgtitle('before and after filtering - channel 1 (first 5 seconds)')
saveas(gcf, 'raw and filtered signal.png')

X_trial = zeros(length(trial), 4,  t_end, 30);

% Splitting trials
for i=1:length(trial)
    X_trial(i, :, :, :) = X_bpf(:, trial(i): trial(i) + t_end-1, :);
end

% Calculating power of signals
X_trial = X_trial.^2;

X_avg = zeros(4, 2560, 30, 5);
N = zeros([5,1]);

% Calculating average signal per class and frequency
for t=1:200
    for b=1:4
        X_avg(b, :, :, y(t)) = squeeze(X_avg(b, :, :, y(t))) + squeeze(X_trial(t, b, :, :));
    end
    N(y(t)) = N(y(t)) + 1;
end

% All classes have 40 trials
disp(N)
X_avg = X_avg/40;

X_smooth = zeros(size(X_avg));
newWin = ones(1, 200)/sqrt(200);

% Smoothing average signals by using convolution
for b=1:4
    for ch=1:30
        for c=1:5
            smooth = conv(squeeze(X_avg(b, :, ch, c)), newWin, 'same');
            X_smooth(b, :, ch, c) = smooth;
        end
    end
end

% Plotting data
cz = 12;
t = (0:size(X_smooth, 2)-1)/fs;
figure;
for i=1:4
    subplot(4, 1, i);
    hold on
    for c=1:5
        plot(t, X_smooth(i, :, cz, c))
        xlabel("Time(s)")
        ylabel('EEG(uV)^2')
    end
    legend({'class 1', 'class 2', 'class 3', 'class 4', 'class 5'}, 'Location','eastoutside')
    title(band_names(i))
    hold off
end

sgtitle("Average Power Per Class")
saveas(gcf, "Average Power Per Class.png")