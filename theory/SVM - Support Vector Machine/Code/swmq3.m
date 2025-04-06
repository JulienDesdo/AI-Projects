%-------------------------------------------------------------------------%
% ------------------- TP3 : SVM Non Linéairement Séparable -------------- %
%-------------------------------------------------------------------------%

clear all; close all;

% ------------------------------------------------------------------------
% Question 1 : Chargement et préparation des données
% ------------------------------------------------------------------------
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
% Question 2 : Définition du problème dual avec marge souple
% ------------------------------------------------------------------------
C = 1; % Paramètre de régularisation

% Initialisation de la matrice Q
Q = zeros(N, N);

% Construction élément par élément
for i = 1:N
    for j = 1:N
        Q(i, j) = class_labels(i) * class_labels(j) * (data(i, :) * data(j, :)'); % Produit scalaire
    end
end

% Vecteur f
f = -ones(N, 1);

% Contraintes
lb = zeros(N, 1);        % alpha >= 0
ub = C * ones(N, 1);     % alpha <= C
Aeq = class_labels';     % somme(alpha_m * y_m) = 0
beq = 0;

% ------------------------------------------------------------------------
% Question 3 : Résolution avec quadprog
% ------------------------------------------------------------------------
alpha = quadprog(Q, f, [], [], Aeq, beq, lb, ub);

% ------------------------------------------------------------------------
% Question 4 : Calcul de w et w0
% ------------------------------------------------------------------------
% Calcul de w
w = sum((alpha .* class_labels) .* data, 1)'; % w = somme(alpha_m * y_m * x_m)

% Calcul de w0 à partir des vecteurs supports
support_indices = find(alpha > 1e-4 & alpha < C - 1e-4); % Vecteurs supports stricts
w0 = mean(class_labels(support_indices) - data(support_indices, :) * w);

% Affichage des résultats
disp('Résultats :');
disp(['w0 (biais) : ', num2str(w0)]);
disp(['w (poids) : ', num2str(w')]);

% ------------------------------------------------------------------------
% Question 5 : Tracé des données et de la droite séparatrice
% ------------------------------------------------------------------------
figure;
gscatter(data(:, 1), data(:, 2), class_labels, 'rb', 'xo');
hold on;

% Calcul et tracé de la frontière de décision
x_vals = linspace(min(data(:, 1)), max(data(:, 1)), 100);
y_vals = -(w0 + w(1) * x_vals) / w(2);
plot(x_vals, y_vals, 'k-', 'LineWidth', 2);

% ------------------------------------------------------------------------
% Question 6 : Repérer les vecteurs supports
% ------------------------------------------------------------------------
scatter(data(support_indices, 1), data(support_indices, 2), 100, 'ks', 'LineWidth', 2);

% ------------------------------------------------------------------------
% Question 7 : Superposer une image binaire
% ------------------------------------------------------------------------
x1min = min(data(:, 1));
x1max = max(data(:, 1));
x2min = min(data(:, 2));
x2max = max(data(:, 2));
x1 = x1min:0.01:x1max;
x2 = x2min:0.01:x2max;
[Xg, Yg] = meshgrid(x1, x2);
f = w(1) * Xg + w(2) * Yg + w0; % Calcul de la fonction de décision
fp = -ones(size(Xg));
fp(f >= 0) = 1;

% % Superposition image binaire
% imagesc(x1, x2, fp);
% axis xy;
% colormap('summer');
% colorbar;

title(['SVM Non Linéairement Séparable - Marge Souple (C = ', num2str(C), ')']);
xlabel('Variable explicative n°3');
ylabel('Variable explicative n°4');
legend({'Classe 1', 'Classe -1', 'Hyperplan', 'Vecteurs Supports'});
hold off;
