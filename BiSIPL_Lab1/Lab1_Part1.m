clc
clear

%% Q1
%Loadind EEG data
load('EEG_sig');

name = des.channelnames; %names of the electrodes
fs = des.samplingfreq; %samlping freq
len = des.nbsamples; %time series' sample number
time = (1:len)/fs; %time vector (for plots)

%Plotting individual channels (Currently channel 5)
figure('WindowState', 'maximized');
ax = axes('Position',[0.10 0.50 0.85 0.10]);
plot(time, Z(5,:));
xlim([0,len/fs]);
title(name{5});
xlabel('Time(s)');
ylabel('EEG(uV)');
%saveas(gcf, [name{5} '.png']);

%Plotting all channels
offset = max(max(abs(Z)))/5 ;
feq = 256 ; % = fs
ElecName = des.channelnames ;
disp_eeg(Z,offset,feq,ElecName) ;
%saveas(gcf, 'All Channels.png');

%Seperating 4 time ranges from channel 5
t(1,:) = 2*fs:7*fs;
t(2,:) = 30*fs:35*fs;
t(3,:) = 42*fs:47*fs;
t(4,:) = 50*fs:55*fs;

%Plotting the 4 time series
figure('WindowState', 'maximized');
for i = 1:4
    ax = subplot(4,1,i);
    ax.Position(3) = 0.75;
    ax.Position(4) = 0.10;
    plot(t(i,:)/fs, Z(5,t(i,:)));
    title([name{5} ': Range' num2str(i)]);
    ylim([-50,80]);
    xlabel('Time(s)');
    ylabel('EEG(uV)');
end
%saveas(gcf, '4 time series.png');

%Plotting 4 DFTs
N = 1281; % number of time samples
f = (0:N-1)*fs/N; % frequency vector (for plots)
figure('WindowState', 'maximized');
for i = 1:4
    ax = subplot(4,1,i);
    dft = abs(fft(Z(5,t(i,:))));
    plot(f(1:(N+1)/2),dft(1:(N+1)/2));
    title(['Range' num2str(i) ': DFT']);
    xlim([0,60]); % Displaying up to 60 Hz (higher frequencies are irrelevant)
    xlabel('Freq(Hz)');
    ylabel('Amplitude');
end
%saveas(gcf, '4 DFTs.png');

%Plotting 4 Welch estimates
%Welch default: 8 segments, len:320, sift:160, nfft:512
nfft = [];
figure('WindowState', 'maximized');
for i = 1:4
    ax = subplot(4,1,i);
    [psd,w] = pwelch(Z(5,t(i,:)),[],[],nfft,fs);
    plot(w,psd); % Plotting the PSD(normalized) in normal scale
    title(['Range' num2str(i) ': Welch']);
    xlim([0,60]);
    xlabel('Freq(Hz)');
    ylabel('PSD (Power/Freq)');
end
%saveas(gcf, '4 PSDs.png');

%Plotting 4 spectrograms
figure('WindowState', 'maximized');
for i = 1:4
    ax = subplot(4,1,i);
    [s,fspec,tspec] = spectrogram(Z(5,t(i,:)),128,64,128,fs,'yaxis');
    pcolor(tspec + t(i,1)/fs,fspec,20*log10(abs(s)));
    title(['Range' num2str(i) ': Spectro']);
    xlabel('Time(s)');
    ylabel('Freq(Hz)');
end
%saveas(gcf, '4 Spectrograms.png');

%Downsampling range 2
ds_coef = 4; %Downsampling coefficient
filtered = lowpass(Z(5,t(2,:)),100,fs); %low pass filter
down = filtered((t(2,1):ds_coef:t(2,end))-t(2,1)+1); %downsampling with step = ds_coef
[psd_ds,w_ds] = pwelch(down,[],[],[],fs/ds_coef); %Downsampled Welch PSD
[psd,w] = pwelch(Z(5,t(2,:)),[],[],[],fs); %Original Welch PSD
dft = abs(fft(Z(5,t(2,:)))); %Original DFT
dft_ds = abs(fft(down)); %Downsampled DFT
N_ds = size(down,2); %number of new time samples
f_ds = (0:N_ds-1)*(fs/ds_coef)/N_ds; %new frequency vector

%Plotting original and downsampled time series
figure('WindowState', 'maximized');
ax = subplot(3,1,1);
plot((t(2,1):4:t(2,end))/fs,down);
hold on
plot(t(2,:)/fs, Z(5,t(2,:)));
legend('Downsampled', 'Original');
title('Range2');
ylim([-50,80]);
xlabel('Time(s)');
ylabel('EEG(uV)');

%Plotting original and downsampled DFTs
subplot(3,1,2);
plot(f_ds(1:(N_ds+1)/2),dft_ds(1:(N_ds+1)/2));
hold on
plot(f(1:(N+1)/2),dft(1:(N+1)/2));
legend('Downsampled', 'Original');
xlim([0,32]);
title('Range2: DFT');
xlabel('Freq(Hz)');
ylabel('Amplitude');

%Plotting original and downsampled spectrograms
subplot(3,1,3);
plot(w_ds,psd_ds);
hold on
plot(w,psd);
title('Range2: Welch');
legend('Downsampled', 'Original');
xlim([0,32]);
xlabel('Freq(Hz)');
ylabel('PSD (Power/Freq)');
saveas(gcf, 'Downsampling.png');

