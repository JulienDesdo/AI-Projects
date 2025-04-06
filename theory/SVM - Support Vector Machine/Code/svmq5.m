%-------------------------------------------------------------------------%
% ------------------- TP3 : SVM Non Linéaire (Noyau Polynomial) --------- %
%-------------------------------------------------------------------------%

clear all; close all;

% ------------------------------------------------------------------------
% Question 1 : Chargement et préparation des données

fichieriris = load('fisheriris.mat');
data = fichieriris.meas(:, 3:4);
species = fichieriris.species;

% Suppression des individus de la classe 'setosa'
setosa_indices = strcmp(species, 'setosa');
data(setosa_indices, :) = [];
species(setosa_indices) = [];

% Attribution des classes
class_labels = ones(100, 1); 
class_labels(51:end) = -1;

% Dimensions
[N, d] = size(data);

% ------------------------------------------------------------------------
% Question 2 : Définition des paramètres et calcul du noyau polynomial

C = 100; % Régularisation
degree = 3; % Degré du noyau polynomial

% Calcul du noyau polynomial
K = (data * data' + 1).^degree;

% Matrice Q
Q = (class_labels * class_labels') .* K;

% Vecteur f
f = -ones(N, 1);

% Contraintes
lb = zeros(N, 1);
ub = C * ones(N, 1);

% ------------------------------------------------------------------------
% Question 3 : Résolution du problème dual avec quadprog

alpha = quadprog(Q, f, [], [], class_labels', 0, lb, ub);

% ------------------------------------------------------------------------
% Question 4 : Calcul de w0

support_indices = find(alpha > 1e-4);
w0 = mean(class_labels(support_indices) - sum(alpha .* class_labels .* K(:, support_indices), 1)');

% Affichage des résultats
disp('Résultats :');
disp(['w0 (biais) : ', num2str(w0)]);

% ------------------------------------------------------------------------
% Question 5 : Tracé des données et de la frontière de décision

figure;
gscatter(data(:, 1), data(:, 2), class_labels, 'rb', 'xo');
hold on;

% Calcul de la fonction de décision
x1_vals = linspace(min(data(:, 1)), max(data(:, 1)), 100);
x2_vals = linspace(min(data(:, 2)), max(data(:, 2)), 100);
[X1, X2] = meshgrid(x1_vals, x2_vals);
decision_values = zeros(size(X1));

for i = 1:size(X1, 1)
    for j = 1:size(X1, 2)
        x_test = [X1(i, j), X2(i, j)];
        K_test = (data * x_test' + 1).^degree;
        decision_values(i, j) = sum(alpha .* class_labels .* K_test) + w0;
    end
end

% Frontière de décision
contour(X1, X2, decision_values, [0 0], 'k-', 'LineWidth', 2);

% Afficher les vecteurs supports
scatter(data(support_indices, 1), data(support_indices, 2), 100, 'ks', 'LineWidth', 2);

title(['SVM avec Noyau Polynomial (C = ', num2str(C), ', Degré = ', num2str(degree), ')']);
xlabel('x_1');
ylabel('x_2');
legend({'Classe 1', 'Classe -1', 'Frontière de décision', 'Vecteurs Supports'});
hold off;
