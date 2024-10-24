% BiSIPL Lab 3 - Part 2
% Loading data
X = load('X.dat');
fs = 256;
t = (0:length(X)-1)/fs;

% Plotting data
plot3ch(X, fs);
saveas(gcf, 'X.png')

% SVD decomposition on 3-channel data
[U, S, V] = svd(X);
U = U(:, 1:3);
S = S(1:3, 1:3);
V = V(:, 1:3);
% Saving matrices
save('U.mat', 'U')
save('S.mat', 'S')
save('V.mat', 'V')

colors = ['b', 'g', 'r'];
hold on
for i=1:3
    plot3dv(V(:, i), S(i, i), colors(i));
end
hold off
saveas(gcf, 'V columns.png')
saveas(gcf, 'V columns.fig')

% Plotting columns of U
figure
for i=1:3
    subplot(3, 1, i)
    plot(t, U(:, i))
    title(num2str(i))
    xlabel("Time(S)")
    ylabel(num2str(i))
end
sgtitle("Columns of U")
saveas(gcf, 'Columns of U.png')

eig = [S(1, 1), S(2, 2), S(3, 3)]';
figure
stem(eig)
title("eigenspectrum")
ylabel("eigenvalue")
xlabel("index")
saveas(gcf, 'eigenspectrum.png')

% Reconstructing fetal signal
X_denoised = U(:, 2) * S(2, 2) * V(:, 2)';

% Plotting reconstructed signal
figure
for i=1:3
    subplot(3, 1, i)
    plot(t, X_denoised(:, i))
    title(num2str(i))
    ylabel("ECG(mV)")
    xlabel('Time(s)')
end
sgtitle('Reconstructed Fetal ECG')
saveas(gcf, 'Reconstructed Fetal ECG.png')
