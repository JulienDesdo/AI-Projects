clear all
close all

N = [1e3, 1e4, 1e5, 1e6]; % Nombre d'échantillons
a = 1.96; % Facteur pour les intervalles de confiance

results_cercle = [];
results_ellipse = [];
results_sphere = [];

for n = N
    %% -------- Surface d'un cercle --------
    X_cercle = rand(n, 1);
    Y_cercle = rand(n, 1);

    S_cercle = 0;
    for i = 1:n
        f = (X_cercle(i) - 1/2)^2 + (Y_cercle(i) - 1/2)^2 - 1/4;
        if (f < 0)
            S_cercle = S_cercle + 1;
        end
    end

    Air_cercle_estime = S_cercle / n;
    Air_cercle = pi * (1/2)^2;
    s_cercle = sqrt(Air_cercle_estime * (1 - Air_cercle_estime));
    Int_conf_cercle = [-a * s_cercle / sqrt(n) + Air_cercle_estime, ...
                        a * s_cercle / sqrt(n) + Air_cercle_estime];

    results_cercle = [results_cercle; [n, Air_cercle_estime, Air_cercle, Int_conf_cercle]];

    %% -------- Surface d'une ellipse --------
    demi_grand_axe = 3;
    demi_petit_axe = 5;
    ellipse_center = [demi_grand_axe, demi_petit_axe];

    X_ellipse = (ellipse_center(1) - demi_grand_axe) + ...
                ((ellipse_center(1) + demi_grand_axe) - (ellipse_center(1) - demi_grand_axe)) * rand(n, 1);
    Y_ellipse = (ellipse_center(2) - demi_petit_axe) + ...
                ((ellipse_center(2) + demi_petit_axe) - (ellipse_center(2) - demi_petit_axe)) * rand(n, 1);

    S_ellipse = 0;
    for i = 1:n
        f = ((X_ellipse(i) - ellipse_center(1)) / demi_grand_axe)^2 + ...
            ((Y_ellipse(i) - ellipse_center(2)) / demi_petit_axe)^2 - 1;
        if (f < 0)
            S_ellipse = S_ellipse + 1;
        end
    end

    Air_ellipse_estime = S_ellipse / n * 2 * demi_grand_axe * 2 * demi_petit_axe;
    Air_ellipse = pi * demi_petit_axe * demi_grand_axe;
    s_ellipse = sqrt(Air_ellipse_estime * (1 - Air_ellipse_estime));
    Int_conf_ellipse = [-a * s_ellipse / sqrt(n) + Air_ellipse_estime, ...
                         a * s_ellipse / sqrt(n) + Air_ellipse_estime];

    results_ellipse = [results_ellipse; [n, Air_ellipse_estime, Air_ellipse, Int_conf_ellipse]];

    %% -------- Volume d'une sphère --------
    rayon_sphere = 1;

    X_sphere = -1 + 2 * rand(n, 1);
    Y_sphere = -1 + 2 * rand(n, 1);
    Z_sphere = -1 + 2 * rand(n, 1);

    S_sphere = 0;
    for i = 1:n
        f = X_sphere(i)^2 + Y_sphere(i)^2 + Z_sphere(i)^2 - rayon_sphere^2;
        if (f < 0)
            S_sphere = S_sphere + 1;
        end
    end

    Volume_sphere_estime = S_sphere / n * 8;
    Volume_sphere = 4 / 3 * pi * rayon_sphere^3;
    s_sphere = sqrt(Volume_sphere_estime * (1 - Volume_sphere_estime));
    Int_conf_sphere = [-a * s_sphere / sqrt(n) + Volume_sphere_estime, ...
                        a * s_sphere / sqrt(n) + Volume_sphere_estime];

    results_sphere = [results_sphere; [n, Volume_sphere_estime, Volume_sphere, Int_conf_sphere]];
end

%% -------- Affichage des résultats --------
disp('Cercle : Résultats');
disp(array2table(results_cercle, 'VariableNames', ...
    {'N', 'Air_Estime', 'Air_Exacte', 'IC_Lower', 'IC_Upper'}));

disp('Ellipse : Résultats');
disp(array2table(results_ellipse, 'VariableNames', ...
    {'N', 'Air_Estime', 'Air_Exacte', 'IC_Lower', 'IC_Upper'}));

disp('Sphère : Résultats');
disp(array2table(results_sphere, 'VariableNames', ...
    {'N', 'Volume_Estime', 'Volume_Exacte', 'IC_Lower', 'IC_Upper'}));

%% -------- Graphiques --------

% Cercle
figure;
scatter(X_cercle, Y_cercle, 5, [0.6, 0.8, 1], 'filled'); % Bleu clair pour les points
hold on;
viscircles([0.5, 0.5], 0.5, 'Color', [0, 0.4, 0.8], 'LineWidth', 2); % Cercle en bleu foncé
title('Simulation Monte Carlo : Surface d’un cercle');
xlabel('X');
ylabel('Y');
axis equal;

% Ellipse
figure;
scatter(X_ellipse, Y_ellipse, 5, [0.8, 0.6, 1], 'filled'); % Violet clair pour les points
hold on;
t = linspace(0, 2 * pi, 1000);
plot(ellipse_center(1) + demi_grand_axe * cos(t), ...
     ellipse_center(2) + demi_petit_axe * sin(t), 'Color', [0.4, 0.2, 0.8], 'LineWidth', 2); % Ellipse en violet foncé
title('Simulation Monte Carlo : Surface d’une ellipse');
xlabel('X');
ylabel('Y');
axis equal;

% Sphère
figure;
scatter3(X_sphere, Y_sphere, Z_sphere, 5, [0.6, 1, 0.6], 'filled'); % Vert clair pour les points
hold on;
[x, y, z] = sphere(50);
surf(x, y, z, 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'FaceColor', [0.2, 0.6, 0.2]); % Sphère en vert semi-transparent
title('Simulation Monte Carlo : Volume d’une sphère');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
