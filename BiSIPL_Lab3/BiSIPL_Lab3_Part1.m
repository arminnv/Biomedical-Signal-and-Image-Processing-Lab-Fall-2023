%% Q1
clc
clear

D(1,:) = load ('data/mecg1.dat'); %Mother's ECG
D(2,:) = load ('data/fecg1.dat'); %Fetus' ECG
D(3,:) = load ('data/noise1.dat'); %Noise
D(4,:) = D(1,:) + D(2,:) + D(3,:); %Combined Signal

name = ["Mother","Fetus","Noise","Combined"];
fs = 256; %Sample freq = 256
t = 0:1/fs:(size(D,2)-1)/fs; %Time vector

%Plotting the 4 time series
figure('WindowState', 'maximized');
for i = 1:4
    ax = subplot(4,1,i);
    plot(t, D(i,:));
    title(name(i));
    xlabel('Time(s)');
    ylabel('ECG(mV)');
end
%saveas(gcf, '4 time series.png');

%Plotting 4 Welch estimates
nfft = 2048;
figure('WindowState', 'maximized');
for i = 1:4
    ax = subplot(4,1,i);
    [psd,w] = pwelch(D(i,:),[],[],nfft,fs);
    plot(w,log(psd)); % Plotting the PSD(normalized) in normal scale
    title(name(i));
    xlim([0,60]);
    xlabel('Freq(Hz)');
    ylabel('PSD (Power/Freq)');
end
%saveas(gcf, '4 PSDs.png');

%Plotting the 3 PDFs
figure('WindowState', 'maximized');
for i = 1:3
    ax = subplot(3,1,i);
    h = histogram(D(i,:));
    k = kurtosis(D(i,:));
    m = mean(D(i,:));
    v = var(D(i,:));
    py = 350;
    if(i==3)
        py = 150;
    elseif (i==2)
        py = 1000;
    end
    text(2 ,py ,{['Mean: ',num2str(m)],['Variance: ',num2str(v)], ['Kurt: ',num2str(k)]});
    title(name(i));
    xlabel('Time(s)');
    ylabel('ECG(mV)');
end
%saveas(gcf, 'Distributions.png');