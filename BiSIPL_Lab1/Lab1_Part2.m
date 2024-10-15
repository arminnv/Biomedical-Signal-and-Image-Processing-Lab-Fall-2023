%Loading ECG data
load('ECG_sig');

time = TIME(1:size(Sig,1)); %time vector
ab = ANNOTD(ANNOTD ~= 1); %Exctracting abnormality codes
codes = [4,5,6,7,8,11,14,28,37]; %All the abnormalities in this recording
labels = ["ABERR", "PVC", "FUSION", "NPC", "APC", "NESC", "NOISE", "RYTHM", "NAPC"]; %Abnormality labels


%Plotting channel 1 recordings
figure('WindowState', 'maximized');
subplot(2,1,1);
plot(time, Sig(:,1));
xlim([60,70]);
ylim([-1.2,2]);
title('II');
xlabel('Time(s)');
ylabel('ECG(mV)');
%Labeling the abnormalities
for i = 1:size(codes,2)
    ind = ATRTIMED(ANNOTD == codes(i));
    text(ind,zeros(size(ind,1),1)+1.5,labels(i));
end

%Plotting channel 2 recordings
subplot(2,1,2);
plot(time, Sig(:,2));
xlim([60,70]);
ylim([-2.5,0.5]);
title('V1');
xlabel('Time(s)');
ylabel('ECG(mV)');
%Labeling the abnormalities
for i = 1:size(codes,2)
    ind = ATRTIMED(ANNOTD == codes(i));
    text(ind,zeros(size(ind,1),1)-2,labels(i));
end
%saveas(gcf, 'Annotated.png');

%Morphological analysis
figure('WindowState', 'maximized');
for i = [1,2,3,4,5,6] %Plotting abnormalities
    ind = ATRTIMED(ANNOTD == codes(i));
    hold on;
    plot(((1:101)+101*(i-1))/sfreq, Sig(ind(end,1)*sfreq-50:ind(end,1)*sfreq+50,1));
    text((50+101*(i-1))/sfreq,1.2,labels(i));
end
hold on; %Plotting a normal wave sample
plot(((1:101)+101*(i))/sfreq, Sig(ATRTIMED(10)*sfreq-50:ATRTIMED(10)*sfreq+50,1));
text((50+101*(i))/sfreq,1.2,'Normal');
saveas(gcf, 'Morpholgy.png');

%Extracting a three-sample normal and abnormal signal
%To change between normal and abnormal plots, we choose the corresponding
%... tsample and change the tag for appropriate plotting
%tsample = 115:1/sfreq:117; %Normal
tsample = 477:1/sfreq:479; %Abnormal
rsample = find(ATRTIMED<479 & ATRTIMED>477.3);
tag = 'Abnormal';
N = 1024; %N_fft
f = (0:N-1)*sfreq/N;
sample = Sig(tsample*sfreq,:);
dft = 20*log10(abs(fft(sample, N)));
[psd,w] = pwelch(sample,[],[],N,sfreq);


figure('WindowState', 'maximized');
%Plotting time series
subplot(2,3,1);
plot(tsample, sample(:,1));
title(['II: ' tag]);
ylim([-0.8,0.6]);
xlabel('Time(s)');
ylabel('ECG(mV)');
%Adding abnormal annotations
for i = 1:size(rsample)
    text(ATRTIMED(rsample(i)),0.5,labels(codes == ANNOTD(rsample(i))));
end
subplot(2,3,4);
plot(tsample, sample(:,2));
title(['V1: ' tag]);
ylim([-2.5,0.5]);
xlabel('Time(s)');
ylabel('ECG(mV)');
for i = 1:size(rsample)
    text(ATRTIMED(rsample(i)),-2.2,labels(codes == ANNOTD(rsample(i))));
end

%Plotting DFTs (FFT or Welch)
subplot(2,3,2);
%plot(f(1:(N/2)),dft(1:(N/2),1));
plot(w(:,1),psd(:,1));
title(['II: ' tag]);
xlim([0,30]);
xlabel('Freq(Hz)');
ylabel('PSD (Power/Freq)');
subplot(2,3,5);
%plot(f(1:(N/2)),dft(1:(N/2),2));
plot(w(:,1),psd(:,2));
title(['V1: ' tag]);
xlim([0,30]);
xlabel('Freq(Hz)');
ylabel('PSD (Power/Freq)');

%Plotting Spectrograms
subplot(2,3,3);
spectrogram(sample(:,1),128,64,128,sfreq,'yaxis');
title(['II: ' tag]);
ylim([0,135]);
subplot(2,3,6);
spectrogram(sample(:,2),128,64,128,sfreq,'yaxis');
title(['V1: ' tag]);
ylim([0,135]);
%saveas(gcf, [tag '.png']);