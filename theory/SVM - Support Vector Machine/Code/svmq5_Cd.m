%-------------------------------------------------------------------------%
% ------------------- TP3 : SVM Non Linéaire (Noyau Polynomial) --------- %
%-------------------------------------------------------------------------%

clear all; close all;

% Chargement des données
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

% Paramètres à tester
C_values = [1, 100]; % Régularisation forte et modérée
degrees = [2, 3, 5]; % Différents degrés du noyau polynomial

% Préparation des subplots
figure;
plot_idx = 1;

for c_idx = 1:length(C_values)
    for d_idx = 1:length(degrees)
        C = C_values(c_idx);
        degree = degrees(d_idx);
        
        % Calcul du noyau polynomial
        K = (data * data' + 1).^degree;
        Q = (class_labels * class_labels') .* K;
        f = -ones(N, 1);
        lb = zeros(N, 1);
        ub = C * ones(N, 1);
        
        % Résolution du problème dual
        alpha = quadprog(Q, f, [], [], class_labels', 0, lb, ub);
        
        % Calcul de w0
        support_indices = find(alpha > 1e-4);
        w0 = mean(class_labels(support_indices) - sum(alpha .* class_labels .* K(:, support_indices), 1)');
        
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
        
        % Affichage dans un subplot
        subplot(length(C_values), length(degrees), plot_idx);
        gscatter(data(:, 1), data(:, 2), class_labels, 'rb', 'xo');
        hold on;
        contour(X1, X2, decision_values, [0 0], 'k-', 'LineWidth', 2);
        scatter(data(support_indices, 1), data(support_indices, 2), 100, 'ks', 'LineWidth', 2);
        hold off;
        
        % Titre du subplot
        title(['C = ', num2str(C), ', Degré = ', num2str(degree)]);
        xlabel('x_1');
        ylabel('x_2');
        plot_idx = plot_idx + 1;
    end
end

% Finalisation de la figure
sgtitle('Combinaison des paramètres C et Degré du noyau polynomial');
