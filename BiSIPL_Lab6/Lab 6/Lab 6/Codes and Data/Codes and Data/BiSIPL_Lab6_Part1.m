close all
clear
% BiSIPL Lab 6
% Part 1
load('ElecPosXYZ') ;

%Forward Matrix
ModelParams.R = [8 8.5 9.2] ; % Radius of diffetent layers
ModelParams.Sigma = [3.3e-3 8.25e-5 3.3e-3]; 
ModelParams.Lambda = [.5979 .2037 .0237];
ModelParams.Mu = [.6342 .9364 1.0362];

% Calculating Gain Matrix
Resolution = 1 ;
[LocMat,GainMat] = ForwardModel_3shell(Resolution, ModelParams) ;
R = 9.2; % Radius of head

% Part 2
% Plotting dipoles and electrodes
figure
scatter3(LocMat(1, :), LocMat(2, :), LocMat(3, :), [], '.')
hold on
for i=1:length(ElecPos)
    electrode = ElecPos{1, i};
    scatter3(R*electrode.XYZ(1), R*electrode.XYZ(2), R*electrode.XYZ(3),'*', 'g')
    text(R*electrode.XYZ(1), R*electrode.XYZ(2), R*electrode.XYZ(3),electrode.Name)
end
hold off
title("Dipoles and Electrodes Positions.png")
saveas(gcf, 'dipoles and electrodes.png')

% Part 3

N = size(LocMat, 2);
forward_inverse(randi(N), 'Random', LocMat, GainMat);
forward_inverse(1299, 'Cz', LocMat, GainMat);
forward_inverse(90, 'T8', LocMat, GainMat);
forward_inverse(483, 'Deep', LocMat, GainMat);



function [error_position, error_direction] = forward_inverse(dipole_number, name, LocMat, GainMat)
    dp_index = dipole_number;
    X = LocMat(:, dp_index);
    e = X/norm(X);
    hold on
    scatter3(X(1), X(2), X(3), 'red', 'filled', 'o')
    hold off
    title(name+" Dipole.png")
    saveas(gcf, [name ' dipole.png'])
    
    % Part 4
    % Loading spikey signal
    Interictal = double(load('Interictal.mat').Interictal);
    q =  Interictal(1, :);
    Q = e * Interictal(1, :);
    % Calculating potentials
    M = GainMat(:, 3*dp_index-2:3*dp_index) * Q;
    fs = 256;
    % Plotting potentials
    %disp_eeg(M, [], fs)
    %title("Electrode Potentials " + name)
    %saveas(gcf, name+" potentials.png")
    
    % Part 5
    T = [1722, 1785, 5385, 5451, 6321, 8328, 9365, 9439]; % seizure moments
    Spike_avg = zeros([size(M, 1), 7]);
    for t=T
        Spike_avg = Spike_avg + M(:, t-3:t+3);
    end
    Spike_avg = sum(Spike_avg, 2)/length(T)/7;
    
    figure
    R = 9.2;
    Display_Potential_3D(R, Spike_avg)
    hold on
    scatter3(X(1), X(2), X(3), 'red', 'filled', 'o')
    scatter3(X(1)+e(1), X(2)+e(2), X(3)+e(3), 'red', 'filled', 'o')
    title("3D Potentials "+name)
    %saveas(gcf, name+" 3D Potentials.png")
    % Part 6
    % Solving inverse problem by MNE
    alpha = 1;
    Q_mne = GainMat'* inv(GainMat*GainMat'+ alpha * eye(size(GainMat, 1))) * M;
    
    % Part 7
    q_max = 0;
    i_max = 0;
    e_max = [0, 0, 0];
    
    % Estimating dipole position
    for i=1:size(Q_mne, 1)/3
        q = sqrt(sum(Q_mne(i*3-2:i*3, :).^2)/size(Q_mne, 2));
        if q>q_max
            q_max = q;
            i_max = i;
            e_max = mean(Q_mne(i*3-2:i*3, :), 2);
            e_max = e_max/norm(e_max);
        end
    end
    
    scatter3(LocMat(1, i_max), LocMat(2, i_max), LocMat(3, i_max), 'green', 'filled', 'o')
    %scatter3(LocMat(1, i_max)+e_max(1), LocMat(2, i_max)+e_max(2), LocMat(3, i_max)+e_max(3), 'green', 'filled', 'o')
    title("Estimated Dipole "+name)
    saveas(gcf, name+" Estimated Dipole.png")
    
    % Part 8
    error_position = @(x, x_pred) norm(x-x_pred);
    error_direction = @(e, e_pred) acos(e'*e_pred)*180/pi;
    
    fprintf("Position Error = %d cm - %s\n", error_position(X, LocMat(:, i_max)), name)
    fprintf("Direction Error = %d degrees %s\n", error_direction(e_max, e), name)
    
    % Part 9 
    
    % Define the objective function
    dir = @(phi, theta) [sin(theta)*cos(phi) sin(theta)*sin(phi) cos(theta)]';
    m = mean(abs(M), 2);
    fun = @(q) -norm((q(2)-0.1)*GainMat(3*q(1)-2: 3*q(1))*dir(q(3), q(4)) - m);
    % q = [index amplitude phi theta]
    
    % Define the number of variables
    nvars = 4;
    
    % Define the lower and upper bounds for the variables
    lb = [1, -norm(m)*30, 0, 0];
    ub = [1317, norm(m)*30, 2*pi, pi];
    
    % Set the options for the genetic algorithm
    intcon = 1;
    options = optimoptions('ga','PopulationSize',100,'MaxGenerations',200);
    
    % Run the genetic algorithm
    [x,fval] = ga(fun,nvars,[],[],[],[],lb,ub,[],intcon,options);
    
    % Display the results
    disp('The optimal solution is:')
    disp(x)
    disp('The objective function value at the optimal solution is:')
    disp(fval)
    e_opt = dir(x(3), x(4));
    i_opt = x(1);
    scatter3(LocMat(1, i_opt), LocMat(2, i_opt), LocMat(3, i_opt), 'yellow', 'filled', 'o')
    %scatter3(LocMat(1, i_opt)+e_opt(1), LocMat(2, i_opt)+e_opt(2), LocMat(3, i_opt)+e_opt(3), 'yellow', 'filled', 'o')
    fprintf("GA Position Error = %d cm - %s\n", error_position(X, LocMat(:, i_opt)), name)
    fprintf("GA Direction Error = %d degrees %s\n", error_direction(e_opt, e), name)
    hold off
end
