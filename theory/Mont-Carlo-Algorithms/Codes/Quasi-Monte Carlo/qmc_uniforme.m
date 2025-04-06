clear all
close all

% Paramètres
N_values = 10.^(1:6); % N = 10, 100, ..., 10^6
a = 1.96; % Facteur pour intervalle de confiance (95%)
I_exact = (exp(1) - 1)^2; % Valeur exacte de l'intégrale

% Initialisation des résultats
results_MC = [];
results_QMC = [];

% Fonction pour les suites quasi-Monte Carlo
qmc_points = @(n, alpha) mod((1:n)' * sqrt(alpha), 1);

% Boucle sur les valeurs de N
for N = N_values
    %% Méthode Monte Carlo
    X_MC = rand(N, 2); % Points aléatoires uniformes
    Val_MC = exp(sum(X_MC, 2)); % Fonction à intégrer
    I_MC = mean(Val_MC); % Estimation
    sigma_MC = sqrt(var(Val_MC)); % Variance
    IC_MC = [-a * sigma_MC / sqrt(N) + I_MC, a * sigma_MC / sqrt(N) + I_MC]; % Intervalle de confiance
    results_MC = [results_MC; N, I_MC, sigma_MC, IC_MC];
    
    %% Méthode quasi-Monte Carlo
    X_QMC = [qmc_points(N, 2), qmc_points(N, 3)]; % Suite quasi-Monte Carlo
    Val_QMC = exp(sum(X_QMC, 2)); % Fonction à intégrer
    I_QMC = mean(Val_QMC); % Estimation
    sigma_QMC = sqrt(var(Val_QMC)); % Variance
    IC_QMC = [-a * sigma_QMC / sqrt(N) + I_QMC, a * sigma_QMC / sqrt(N) + I_QMC]; % Intervalle de confiance
    results_QMC = [results_QMC; N, I_QMC, sigma_QMC, IC_QMC];
end

%% Affichage des résultats

% Résultats Monte Carlo
disp('Résultats pour la méthode Monte Carlo (MC) :');
disp(array2table(results_MC, 'VariableNames', {'N', 'I_MC', 'Variance_MC', 'IC_Lower_MC', 'IC_Upper_MC'}));

% Résultats quasi-Monte Carlo
disp('Résultats pour la méthode quasi-Monte Carlo (QMC) :');
disp(array2table(results_QMC, 'VariableNames', {'N', 'I_QMC', 'Variance_QMC', 'IC_Lower_QMC', 'IC_Upper_QMC'}));

%% Affichage graphique des points MC et QMC

% Points pour N = 10
figure;
subplot(1, 2, 1);
scatter(rand(10, 1), rand(10, 1), 40, 'filled');
title('10 premiers points Monte Carlo');
xlabel('x');
ylabel('y');
axis([0 1 0 1]);
grid on;

subplot(1, 2, 2);
scatter(qmc_points(10, 2), qmc_points(10, 3), 40, 'filled');
title('10 premiers points quasi-Monte Carlo');
xlabel('x');
ylabel('y');
axis([0 1 0 1]);
grid on;

% Points pour N = 100
figure;
subplot(1, 2, 1);
scatter(rand(100, 1), rand(100, 1), 20, 'filled');
title('100 premiers points Monte Carlo');
xlabel('x');
ylabel('y');
axis([0 1 0 1]);
grid on;

subplot(1, 2, 2);
scatter(qmc_points(100, 2), qmc_points(100, 3), 20, 'filled');
title('100 premiers points quasi-Monte Carlo');
xlabel('x');
ylabel('y');
axis([0 1 0 1]);
grid on;

%% Comparaison des erreurs

figure;
loglog(N_values, abs(results_MC(:, 2) - I_exact), '-o', 'DisplayName', 'Erreur MC', 'LineWidth', 1.5);
hold on;
loglog(N_values, abs(results_QMC(:, 2) - I_exact), '-s', 'DisplayName', 'Erreur QMC', 'LineWidth', 1.5);
grid on;
legend('show');
title('Comparaison des erreurs entre MC et QMC');
xlabel('Nombre de tirages N');
ylabel('Erreur absolue');
set(gca, 'FontSize', 12);
