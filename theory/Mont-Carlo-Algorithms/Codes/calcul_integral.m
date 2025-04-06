clear all
close all

% Paramètres
N_values = [1e3, 1e4, 1e5, 1e6]; % Differents nombres de tirages
a = 1.96;  % Facteur pour intervalle de confiance (95%)
I_exact = (exp(1) - 1)^4; % Valeur exacte pour I

% Initialisation des tableaux de resultats
results_I = [];
results_J = [];
results_Jf = [];
results_Jg = [];

% Boucle sur les valeurs de N
for N = N_values
    %% Calcul de I
    VariableI = rand(N, 4);
    Val_I = exp(sum(VariableI, 2));
    I_estime = mean(Val_I);
    sigmaI = sqrt(var(Val_I));
    Int_confI = [-a * sigmaI / sqrt(N) + I_estime, a * sigmaI / sqrt(N) + I_estime];
    results_I = [results_I; N, I_estime, I_exact, sigmaI, Int_confI];
    
    %% Calcul de J
    VariableJ = rand(N, 4);
    Val_J = exp(prod(VariableJ, 2));
    J_estime = mean(Val_J);
    sigmaJ = sqrt(var(Val_J));
    Int_confJ = [-a * sigmaJ / sqrt(N) + J_estime, a * sigmaJ / sqrt(N) + J_estime];
    results_J = [results_J; N, J_estime, sigmaJ, Int_confJ];
    
    %% Calcul de J avec controle f = xyzt
    f = prod(VariableJ, 2);
    Val_Jf = exp(f) - f;
    Jf_estime = mean(Val_Jf) + 1/16;
    sigmaf = sqrt(var(Val_Jf));
    Int_confJf = [-a * sigmaf / sqrt(N) + Jf_estime, a * sigmaf / sqrt(N) + Jf_estime];
    results_Jf = [results_Jf; N, Jf_estime, sigmaf, Int_confJf];
    
    %% Calcul de J avec controle g = xyzt + (xyzt)^2 / 2
    g = f + (f.^2) / 2;
    Val_Jg = exp(f) - g;
    Jg_estime = mean(Val_Jg) + 1/16 + (1/3)^4 / 2;
    sigmag = sqrt(var(Val_Jg));
    Int_confJg = [-a * sigmag / sqrt(N) + Jg_estime, a * sigmag / sqrt(N) + Jg_estime];
    results_Jg = [results_Jg; N, Jg_estime, sigmag, Int_confJg];
end

%% Affichage des resultats

% Resultats pour I
disp('Resultats pour I :');
disp(array2table(results_I, 'VariableNames', {'N', 'I_Estime', 'I_Exact', 'Variance', 'IC_Lower', 'IC_Upper'}));

% Resultats pour J sans controle
disp('Resultats pour J (sans controle) :');
disp(array2table(results_J, 'VariableNames', {'N', 'J_Estime', 'Variance', 'IC_Lower', 'IC_Upper'}));

% Resultats pour J avec controle f
disp('Resultats pour J avec controle f = xyzt :');
disp(array2table(results_Jf, 'VariableNames', {'N', 'Jf_Estime', 'Variance', 'IC_Lower', 'IC_Upper'}));

% Resultats pour J avec controle g
disp('Resultats pour J avec controle g = xyzt + (xyzt)^2 / 2 :');
disp(array2table(results_Jg, 'VariableNames', {'N', 'Jg_Estime', 'Variance', 'IC_Lower', 'IC_Upper'}));

%% Affichage graphique pour montrer la reduction de variance

figure;
loglog(N_values, results_J(:, 3), '-o', 'DisplayName', 'J (sans controle)', 'LineWidth', 1.5);
hold on;
loglog(N_values, results_Jf(:, 3), '-s', 'DisplayName', 'J (controle f = xyzt)', 'LineWidth', 1.5);
loglog(N_values, results_Jg(:, 3), '-d', 'DisplayName', 'J (controle g = xyzt + (xyzt)^2 / 2)', 'LineWidth', 1.5);
grid on;
legend('show');
title('Reduction de la variance avec les variables de controle');
xlabel('Nombre de tirages N');
ylabel('Variance');
set(gca, 'FontSize', 12);


