%% Beamforming
% Amaan Rahman
% ECE 416: Adaptive Algorithms
% Professor Fontaine
% Spring 2022

clc; clear; close all;

%% Sensor Array Signal Model
%
%   Completed via constructing isolated functions
%

%% SVD and MUSIC / MVDR Spectra
r1 = [(-5:5)' zeros(11, 2)];
r2 = r1(r1 ~= 0, :); 
r2 = [fliplr(r2(:, 1:2)) r2(:, end)];
r = [r1; r2];
[M, ~] = size(r);

theta = [10 20 30];
phi = [20 -20 150];
AOA = [theta' phi'];
[L, ~] = size(AOA);

Bpower = [0 -5 -10];    % in dB 
Vpower = -20;           % in dB
N = 100;

[A, S] = genData(N, AOA, r, Bpower, Vpower);
[R, Rhat] = genCoorX(N, S, A, Bpower, Vpower);

%% Part A
[U, SIG, ~] = svd(A);           % computed
[~, D, W] = eig(R);        % theoretical
SIG = diag(SIG);
D = diag(sqrt(D));
sig_comp = abs(SIG) / max(abs(SIG));
sig_theo = abs(D) / max(abs(D));
sig_theo = sort(sig_theo, 'descend');

% Plot Singular Values
figure;
hold on
title("Singular Values");
stem(sig_comp, 'blue', 'o');
stem(sig_theo, 'red', 'x');
hold off
legend('Computed', 'Theoretical');

%% Part B
Ul = U(:, 1:L);
Ps = Ul * Ul';
Pn = eye(size(Ps)) - Ps;
proj = abs(Pn * S);

%% Part C
SNR_1 = 10*log10(mean(SIG.^2)) - Vpower;
SNR_2 = 10*log10(mean(SIG((L+1):end))) - Vpower;
SNR_true = sum(Bpower) - Vpower;

%% Part D
ratio = norm(R - Rhat) / (10^(Vpower/10));

%% Part E
delta = 10;
[THETA, PHI] = meshgrid(0:delta:90, 0:delta:180);
MVDR_S = zeros(size(THETA));
MUSIC_S = zeros(size(THETA));
for i = 1:size(THETA, 1)
    for j = 1:size(THETA, 2)
        [MVDR_S(i, j), MUSIC_S(i, j)] = deal(genSpectra( ...
                                            THETA(i, j), ...
                                            PHI(i, j), ...
                                            r, ...
                                            Rhat, ...
                                            Pn));
    end
end

% Plot the spectra
fig = figure('Position', [300, 100, 1500, 900]);
subplot(2, 2, 1);
contour(THETA, PHI, MVDR_S);
title('MVDR Spectrum Contour');

subplot(2, 2, 3);
surf(THETA, PHI, MVDR_S);
title('MVDR Spectrum Surface');

subplot(2, 2, 2);
contour(THETA, PHI, MUSIC_S);
title('MUSIC Spectrum Contour');

subplot(2, 2, 4);
surf(THETA, PHI, MUSIC_S);
title('MUSIC Spectrum Surface');

%% Part F, G
delta = 0.1;
p = [20, -20];
THETA = 0:delta:90;
MVDR_S = zeros(size(THETA, 2), size(p, 2));
MUSIC_S = zeros(size(THETA, 2), size(p, 2));

for m = 1:size(MVDR_S, 2)
    for i = 1:size(THETA, 2)
        [MVDR_S(i, m), MUSIC_S(i, m)] = deal(genSpectra( ...
                                                THETA(1, i), ...
                                                p(m), ...
                                                r, ...
                                                Rhat, ...
                                                Pn));
    end
    
    % plot the spectra
    figure;
    subplot(2, 1, 1);
    plot(THETA, MVDR_S(:, m));
    title("MVDR Spectrum \phi = " + p(m) + char(176) ...
           + ' 0' + char(176) + " <= \theta <= 90" + char(176));

    subplot(2, 1, 2);
    plot(THETA, MUSIC_S(:, m));
    title("MUSIC Spectrum \phi = " + p(m) + char(176) ...
           + ' 0' + char(176) + " <= \theta <= 90" + char(176));
end

%% Part H

%% Part I

%% Part J

%% Part K

%% Part L

%% Question 4
close all;
N0 = 100;
mu = 1/max(D);
e = lmsMVDR(r, [20, -20], Bpower(2), Vpower, N, N0, mu);
n = 1:N0;
figure;
hold on
plot(n, mean(abs(e).^2, 1));
hold off