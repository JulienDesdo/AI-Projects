%-------------------------------------------------------------------------%
% ------------------- TP3 : SVM Linéairement Séparable ------------------ %
%-------------------------------------------------------------------------%

% 2. Résoltion du problème Dual

% Question 1 
fichieriris = load('fisheriris.mat');
data = fichieriris.meas(:, 3:4);
species = fichieriris.species; 

% Suppression des individus de la classe 'virginica'
virginica_indices = strcmp(species, 'virginica');
data(virginica_indices, :) = [];
species(virginica_indices) = [];

% Classe 1 pour les 50 premiers, Classe -1 pour les suivants
class_labels = ones(100, 1); 
class_labels(51:end) = -1; 

% Dimensions 
[N, d] = size(data); % N : Nombre d'échantillons, d : Nombre de dimensions des données

%-------------------------------------------------------------------------%
% Question 2 

% Matrice Q 
Q = (class_labels * class_labels') .* (data * data'); % Taille N x N

% Vecteur f 
f = -ones(N, 1);  

% Contraintes
Aeq = class_labels'; % somme(alpha_m * y_m) = 0
beq = 0;           
A = -eye(N);
lb = zeros(N, 1);    % alpha >= 0

%-------------------------------------------------------------------------%
% Question 3 

alpha = quadprog(Q, f, A, zeros(size(A,1),1), Aeq, beq);

%-------------------------------------------------------------------------%
% Question 4

w = sum((alpha .* class_labels) .* data, 1)'; % w = somme(alpha_m * y_m * x_m)

% Utilisation d'un vecteur support pour calculer w0
support_indices = find(alpha > 1e-4); % Indices des vecteurs supports
w0 = mean(class_labels(support_indices) - data(support_indices, :) * w);

% Affichage
disp('Résultats :');
disp(['w0 (biais) : ', num2str(w0)]);
disp(['w (poids) : ', num2str(w')]);

%-------------------------------------------------------------------------%
% Question 5 

figure;
gscatter(data(:, 1), data(:, 2), class_labels, 'rb', 'xo');
hold on;


x_vals = linspace(min(data(:, 1)), max(data(:, 1)), 100);
y_vals = -(w0 + w(1) * x_vals) / w(2);
plot(x_vals, y_vals, 'k-', 'LineWidth', 2);

%-------------------------------------------------------------------------%
% Question 6 

% Identifier les vecteurs supports grâce aux alphas.
scatter(data(support_indices, 1), data(support_indices, 2), 100, 'ks', 'LineWidth', 2);

%-------------------------------------------------------------------------%
% Question 7 

% Script imagefbinaire
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

% Superposition image binaire
imagesc(x1, x2, fp);
axis xy;
colormap('summer');
colorbar;

title('SVM Linéairement Séparable - Problème Dual');
xlabel('Variable explicative n°3');
ylabel('Variable explicative n°4');
legend({'Classe 1 : Setosa', 'Classe -1 : Versicolor', 'Hyperplan', 'Vecteurs Supports'});
hold off;