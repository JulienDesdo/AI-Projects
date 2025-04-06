clear all
close all

%%%%----------------------------------------------------------------------%%%%
%%%%----------------- Calcul de J par Monte Carlo et QMC -----------------%%%%
%%%%----------------------------------------------------------------------%%%%

% Nombre d'échantillons
NI = 100; % Réduction à 100 pour MC et QMC
Nk = 100; % Nombre de clusters pour K-means et Kohonen

% Calcul exact pour comparaison
J_exact = exp(1); % Valeur théorique pour comparaison

%%% Monte Carlo
VariableJ = randn(NI, 2); % Tirage gaussien
Val_MC = exp(VariableJ(:, 1) + VariableJ(:, 2)); % Fonction à intégrer

% Estimation Monte Carlo
J_MC = mean(Val_MC);
SigmaMC = sqrt(var(Val_MC)); % Variance
a = 1.96; % Facteur pour l'intervalle de confiance
Int_confMC = [-a * SigmaMC / sqrt(NI) + J_MC, a * SigmaMC / sqrt(NI) + J_MC];

% Affichage des points Monte Carlo
figure;
scatter(VariableJ(:, 1), VariableJ(:, 2), 40, 'b', 'filled');
title(['Monte Carlo (N = ', num2str(NI), ')']);
xlabel('x');
ylabel('y');
axis equal;
grid on;

%%% Quasi Monte Carlo
n = linspace(1, NI, NI);
u1 = n * sqrt(2) - floor(n * sqrt(2));
u2 = n * sqrt(3) - floor(n * sqrt(3));

% Conversion en gaussien via la méthode de Box-Muller
X_QMC = sqrt(-2 * log(u1)) .* cos(2 * pi * u2);
Y_QMC = sqrt(-2 * log(u1)) .* sin(2 * pi * u2);
Val_QMC = exp(X_QMC + Y_QMC); % Fonction à intégrer
J_QMC = mean(Val_QMC);

% Affichage des points Quasi Monte Carlo
figure;
scatter(X_QMC, Y_QMC, 40, 'r', 'filled');
title(['Quasi Monte Carlo (N = ', num2str(NI), ')']);
xlabel('x');
ylabel('y');
axis equal;
grid on;

%%% Résultats Monte Carlo et Quasi Monte Carlo
fprintf('--- Résultats Monte Carlo ---\n');
fprintf('Nombre de points (N) : %d\n', NI);
fprintf('Estimation J_MC      : %.6f\n', J_MC);
fprintf('Intervalle de Confiance [IC_MC] : [%.6f, %.6f]\n\n', Int_confMC(1), Int_confMC(2));

fprintf('--- Résultats Quasi Monte Carlo ---\n');
fprintf('Nombre de points (N) : %d\n', NI);
fprintf('Estimation J_QMC     : %.6f\n\n', J_QMC);

%%%%----------------------------------------------------------------------%%%%
%%%%----------------- Algorithme de Kohonen ------------------------------%%%%
%%%%----------------------------------------------------------------------%%%%

Point_nr = randn(Nk, 2); % Points gaussiens initiaux
Point_o = Point_nr; % Copie pour Kohonen
pas = 0.01; % Pas initial
nk = 100000; % Nombre d'itérations

for k = 1:nk
    personne = randn(1, 2); % Tirage gaussien
    distances = sum((Point_o - personne).^2, 2);
    [~, ind_min] = min(distances);
    Point_o(ind_min, :) = (1 - pas) * Point_o(ind_min, :) + pas * personne;
    pas = 0.01 - (k / nk) * (0.01 - 0.0001); % Décroissance
end

% Affichage des résultats Kohonen
figure;
subplot(1, 2, 1);
scatter(Point_nr(:, 1), Point_nr(:, 2), 40, 'b', 'filled');
title(['Points Initiaux (Nk = ', num2str(Nk), ')']);
xlabel('x');
ylabel('y');
axis equal;

subplot(1, 2, 2);
scatter(Point_o(:, 1), Point_o(:, 2), 40, 'r', 'filled');
title(['Kohonen (Nk = ', num2str(Nk), ')']);
xlabel('x');
ylabel('y');
axis equal;

%%% Calcul de J par Kohonen
Nk = size(Point_o, 1); % Nombre de clusters après Kohonen
alpha_kohonen = ones(Nk, 1) / Nk; % Poids égaux
J_Kohonen = sum(alpha_kohonen .* exp(sum(Point_o, 2)));

%%% Résultats Kohonen
fprintf('--- Résultats Kohonen ---\n');
fprintf('Nombre de clusters (Nk) : %d\n', Nk);
fprintf('Estimation J_Kohonen     : %.6f\n', J_Kohonen);

%%%%----------------------------------------------------------------------%%%%
%%%%----------------- Algorithme de K-means ------------------------------%%%%
%%%%----------------------------------------------------------------------%%%%

Point_m = Point_nr; % Copie pour K-means
Nt = 10000; % Nombre de tirages
compteur_point = ones(Nk, 1);
Tenseur_Point = zeros(1, 2, Nk);

for t = 1:Nt
    Pt = randn(1, 2); % Nouveau point gaussien
    distances = sum((Point_m - Pt).^2, 2);
    [~, ind_min] = min(distances);
    compteur_point(ind_min) = compteur_point(ind_min) + 1;
    Tenseur_Point(compteur_point(ind_min), :, ind_min) = Pt;
end

for k = 1:Nk
    if compteur_point(k) > 0
        x_new = sum(Tenseur_Point(:, 1, k)) / compteur_point(k);
        y_new = sum(Tenseur_Point(:, 2, k)) / compteur_point(k);
        Point_m(k, :) = [x_new, y_new];
    end
end

% Affichage des résultats K-means
figure;
subplot(1, 2, 1);
scatter(Point_nr(:, 1), Point_nr(:, 2), 40, 'b', 'filled');
title(['Points Initiaux (Nk = ', num2str(Nk), ')']);
xlabel('x');
ylabel('y');
axis equal;

subplot(1, 2, 2);
scatter(Point_m(:, 1), Point_m(:, 2), 40, 'g', 'filled');
title(['K-means (Nk = ', num2str(Nk), ')']);
xlabel('x');
ylabel('y');
axis equal;

%%% Calcul de J par K-means
alpha = compteur_point / Nt; % Poids proportionnels à la taille des clusters
J_Kmeans = sum(alpha .* exp(Point_m(:, 1) + Point_m(:, 2)));

%%% Résultats K-means
fprintf('--- Résultats K-means ---\n');
fprintf('Nombre de clusters (Nk) : %d\n', Nk);
fprintf('Estimation J_Kmeans      : %.6f\n', J_Kmeans);
fprintf('Valeur exacte J_exact    : %.6f\n', J_exact);
