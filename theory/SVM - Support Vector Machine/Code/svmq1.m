%-------------------------------------------------------------------------%
% ----------------- TP3 : SVM Linéaires et non linéaires -----------------%
%-------------------------------------------------------------------------%

% 1. Cas Linéairement séparable, résolution du problème primal. 

%-------------------------------------------------------------------------%
% Question 1 

fichieriris = load('fisheriris.mat');
data = fichieriris.meas(:, 3:4);
species = fichieriris.species; 

% Suppression des individus de la classe 'virginica'  
virginica_indices = strcmp(species, 'virginica');
data(virginica_indices, :) = [];
species(virginica_indices) = [];

% Classe 1 pour les 50 premiers, Classe -1 pour les suivants
class_labels = ones(100, 1); % setosa 
class_labels(51:end) = -1; % versicolor

% Dimensions 
[N, d] = size(data); % N : Nombre d'échantillons, d : Nombre de dimensions des données

%-------------------------------------------------------------------------%
% Question 2 

% Matrice H 
H = zeros(d + 1); % Taille (d+1) x (d+1)
H(2:end, 2:end) = eye(d); 

% Vecteur f 
f = zeros(d + 1, 1);

% Contraintes A et b
A = zeros(N, d + 1); 
for i = 1:N
    A(i, 1) = -class_labels(i);       
    A(i, 2:end) = -class_labels(i) * data(i, :); 
end
b = -ones(N, 1); 

%-------------------------------------------------------------------------%
% Question 3
x = quadprog(H, f, A, b, [], [], [], [], []);

%-------------------------------------------------------------------------%
% Question 4 

% Extraction des résultats
w0 = x(1);      % Biais w0
w = x(2:end);   % Poids w

% Affichage 
disp('Résultats de l''optimisation :');
disp(['w0 (biais) : ', num2str(w0)]);
disp(['w (poids) : ', num2str(w')]);

% Tracer la frontière de décision
figure;
gscatter(data(:, 1), data(:, 2), class_labels, 'rb', 'xo');
hold on;

% Calcul et affichage de la frontière
x_vals = linspace(min(data(:, 1)), max(data(:, 1)), 100);
y_vals = -(w0 + w(1) * x_vals) / w(2);
plot(x_vals, y_vals, 'k-', 'LineWidth', 2);

title('SVM Linéairement Séparable');
xlabel('Variable Explicative n°3');
ylabel('Variable Explicative n°4');
%-------------------------------------------------------------------------%
% Question 5 

% Calcul de la fonction de décision pour chaque individu
decision_values = w0 + data * w; % f(x) = w0 + wT * x

% Calcul des marges
margins = abs(decision_values ./ sqrt(sum(w.^2))); % distance à la frontière

% Identifier les vecteurs supports à epsilon près. 
support_vectors_indices = find(abs(class_labels .* decision_values - 1) < 1e-4);

% Mettre en évidence les vecteurs supports
scatter(data(support_vectors_indices, 1), data(support_vectors_indices, 2), 100, 'ks', 'LineWidth', 2);

legend({'Classe 1 : Setosa', 'Classe -1 : Versicolor', 'Hyperplan','Vecteurs Supports'});

%-------------------------------------------------------------------------%
% Question 6 

% Script imagefbinaire
x1min = min(data(:, 1));
x1max = max(data(:, 1));
x2min = min(data(:, 2));
x2max = max(data(:, 2));
x1 = x1min:0.01:x1max;
x2 = x2min:0.01:x2max;
[Xg, Yg] = meshgrid(x1, x2);
f = w(1) * Xg + w(2) * Yg + w0; % fonction de décision
fp = -ones(size(Xg));
fp(f >= 0) = 1;

% Superposition de l'image binaire
imagesc(x1, x2, fp);
axis xy;
colormap('summer');
colorbar;

hold off;
