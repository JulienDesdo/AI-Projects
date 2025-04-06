%-------------------------------------------------------------------------%
% ------------------- Comparaison des Frontières pour Différents C -------%
%-------------------------------------------------------------------------%

clear all; close all;

% ------------------------------------------------------------------------
% Chargement et préparation des données
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
% Paramètres à tester
C_values = [0.1, 1, 10, 100]; % Différentes valeurs de régularisation

% Préparation de la figure
figure;

% Couleurs et styles pour les différentes valeurs de C
colors = ['m', 'g', 'b', 'k'];
line_styles = {'--', '-.', '-', ':'};

for c_idx = 1:length(C_values)
    C = C_values(c_idx);
    
    % --------------------------------------------------------------------
    % Définition du problème dual
    % --------------------------------------------------------------------
    Q = zeros(N, N);
    for i = 1:N
        for j = 1:N
            Q(i, j) = class_labels(i) * class_labels(j) * (data(i, :) * data(j, :)');
        end
    end

    f = -ones(N, 1);
    lb = zeros(N, 1); % alpha >= 0
    ub = C * ones(N, 1); % alpha <= C
    Aeq = class_labels'; % somme(alpha_m * y_m) = 0
    beq = 0;

    % Résolution avec quadprog
    alpha = quadprog(Q, f, [], [], Aeq, beq, lb, ub);

    % --------------------------------------------------------------------
    % Calcul de w et w0
    % --------------------------------------------------------------------
    w = sum((alpha .* class_labels) .* data, 1)'; % w = somme(alpha_m * y_m * x_m)
    support_indices = find(alpha > 1e-4 & alpha < C - 1e-4); % Vecteurs supports stricts
    w0 = mean(class_labels(support_indices) - data(support_indices, :) * w);

    % --------------------------------------------------------------------
    % Tracé de la frontière de décision et des vecteurs supports
    % --------------------------------------------------------------------
    subplot(2, 2, c_idx); % Création de sous-graphes
    gscatter(data(:, 1), data(:, 2), class_labels, 'rb', 'xo');
    hold on;

    % Calcul et tracé de la frontière de décision
    x_vals = linspace(min(data(:, 1)), max(data(:, 1)), 100);
    y_vals = -(w0 + w(1) * x_vals) / w(2);
    plot(x_vals, y_vals, 'Color', colors(c_idx), 'LineStyle', line_styles{c_idx}, 'LineWidth', 2);
    
    % Mettre en évidence les vecteurs supports
    scatter(data(support_indices, 1), data(support_indices, 2), 100, 'ks', 'LineWidth', 2);

    % Finalisation de chaque sous-graphe
    title(['C = ', num2str(C)]);
    xlabel('Variable explicative n°3');
    ylabel('Variable explicative n°4');
    legend({'Classe 1', 'Classe -1', 'Hyperplan', 'Vecteurs Supports'}, 'Location', 'best');
    hold off;
end

% Finalisation de la figure
sgtitle('Comparaison des Frontières et Vecteurs Supports pour Différentes Valeurs de C');
