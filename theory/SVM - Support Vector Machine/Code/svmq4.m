%-------------------------------------------------------------------------%
% ------------------- TP3 : SVM Linéairement Séparable ------------------ %
%-------------------------------------------------------------------------%


clear all
close all
rng(1); % For reproducibility


r = sqrt(rand(100,1)); % Radius
t = 2*pi*rand(100,1);  % Angle
data1 = [r.*cos(t), r.*sin(t)]; % Points
%Generate 100 points uniformly distributed in the annulus. The radius is again proportional to a square root, this time a square root of the uniform distribution from 1 through 4.
r2 = sqrt(3*rand(100,1)+1); % Radius
t2 = 2*pi*rand(100,1);      % Angle
data2 = [r2.*cos(t2), r2.*sin(t2)]; % points


%Plot the points, and plot circles of radii 1 and 2 for comparison.
figure;
plot(data1(:,1),data1(:,2),'r.','MarkerSize',15)
hold on
plot(data2(:,1),data2(:,2),'b.','MarkerSize',15)
ezpolar(@(x)1);ezpolar(@(x)2);
axis equal
hold off

% Données 
X = [data1;data2];
c = ones(200,1);
c(1:100) = -1;


[N, d] = size(X); % N = Nombre d'échantillons, d = dimensions des données

% ------------------------------------------------------------------------%
% Paramètres
sigma = 0.01; % Paramètre du noyau gaussien
C = inf;   % Paramètre de régularisation (Inf pour marge dure)


% ------------------------------------------------------------------------%
% Calcul de la matrice H (noyau gaussien)
K = zeros(N, N); % Matrice de noyau
for i = 1:N
    for j = 1:N
        K(i, j) = exp(-norm(X(i,:) - X(j,:))^2 / (2 * sigma^2));
    end
end
Q = (c * c') .* K; % Matrice H


% ------------------------------------------------------------------------%
% Vecteur f
f = -ones(N, 1);

% Contraintes sous forme de bornes
lb = zeros(N, 1);        % alpha >= 0
ub = C * ones(N, 1);     % alpha <= C (Inf pour marge dure)

% ------------------------------------------------------------------------%
% Résolution avec quadprog
alpha = quadprog(Q, f, [], [], [], [], lb, ub, []);


% ------------------------------------------------------------------------%
% Calcul de w0
% Identifier un vecteur support avec 0 < alpha < C
index = find(alpha > 1e-4 & alpha < C - 1e-4, 1); 

% Calcul de w0
w0 = c(index) - sum(alpha .* c .* K(:, index));

% ------------------------------------------------------------------------%
% Affichage des résultats
disp('Résultats :');
disp(['w0 (biais) : ', num2str(w0)]);


% ------------------------------------------------------------------------%
% Tracer les données et la frontière de décision
figure;
gscatter(X(:, 1), X(:, 2), c, 'rb', 'xo');
hold on;

% Calcul et affichage de la frontière de décision
x1min = min(X(:, 1));
x1max = max(X(:, 1));
x2min = min(X(:, 2));
x2max = max(X(:, 2));
x1 = x1min:0.01:x1max;
x2 = x2min:0.01:x2max;
[Xg, Yg] = meshgrid(x1, x2);

% Calcul de la fonction de décision
f = zeros(size(Xg));
for i = 1:N
    f = f + alpha(i) * c(i) * exp(-((Xg - X(i,1)).^2 + (Yg - X(i,2)).^2) / (2 * sigma^2));
end
f = f + w0;

% Superposer l'image binaire
fp = -ones(size(Xg));
fp(f >= 0) = 1;
imagesc(x1, x2, fp);
axis xy;
colormap('summer');
colorbar;

% Affichage de la frontière de décision
contour(Xg, Yg, f, [0 0], 'k-', 'LineWidth', 2);

% ------------------------------------------------------------------------%
% Identifier les vecteurs supports
% support_indices = find(alpha > 1e-4); % Indices des vecteurs supports
% scatter(X(support_indices, 1), X(support_indices, 2), 100, 'ks', 'LineWidth', 2);

title(['SVM Non Linéaire avec Noyau Gaussien (\sigma = ', num2str(sigma), ')']);
xlabel('x_1');
ylabel('x_2');
legend({'Classe 1', 'Classe -1', 'Frontière de décision'});
hold off;



