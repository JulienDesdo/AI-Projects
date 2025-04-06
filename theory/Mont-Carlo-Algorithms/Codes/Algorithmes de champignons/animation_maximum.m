clear all
close all

% Paramètres
a = 1;
b = 1;
c = 0.8;
d = 1;

N = 1000; % Nombre d'individus
Nb_etape = 5000; % Réduire pour tester l'animation
epsilon = 1e-3;

Individus = -5 + 10 * rand(N, 2); % Initialisation des individus
fonction2_individus = Individus;

% Stockage des étapes pour l'animation
frames = {}; % Stocke les positions des individus pour chaque étape d'animation
capture_interval = 50; % Capture toutes les 50 itérations

% Boucle principale
for i = 1:Nb_etape

    % Sélection de deux individus au hasard
    indices = randperm(N, 2);

    % Calcul des valeurs de la fonction associée aux individus
    recherche1 = a * exp(-b * ((fonction2_individus(indices(1), 1) - 1)^2 + ...
                               (fonction2_individus(indices(1), 2) - 2)^2)) ...
                 + c * exp(-d * ((fonction2_individus(indices(1), 1) + 1)^2 + ...
                                 (fonction2_individus(indices(1), 2) + 3)^2));

    recherche2 = a * exp(-b * ((fonction2_individus(indices(2), 1) - 1)^2 + ...
                               (fonction2_individus(indices(2), 2) - 2)^2)) ...
                 + c * exp(-d * ((fonction2_individus(indices(2), 1) + 1)^2 + ...
                                 (fonction2_individus(indices(2), 2) + 3)^2));

    % Mise à jour des coordonnées
    alpha = (1 - epsilon)^i;
    if recherche1 > recherche2
        fonction2_individus(indices(2), :) = fonction2_individus(indices(1), :) + ...
                                             [alpha * randn(1), alpha * randn(1)];
    else
        fonction2_individus(indices(1), :) = fonction2_individus(indices(2), :) + ...
                                             [alpha * randn(1), alpha * randn(1)];
    end

    % Capturer les positions pour l'animation
    if mod(i, capture_interval) == 0
        frames{end+1} = fonction2_individus; % Sauvegarder les positions
    end
end

% Création de l'animation
figure;
hold on;
axis([-5 5 -5 5]); % Domaine de visualisation
title('Évolution des individus - Algorithme mimétique (Maximum)');

for k = 1:length(frames)
    scatter(frames{k}(:, 1), frames{k}(:, 2), 10, 'blue', 'filled');
    drawnow;
    pause(0.1); % Pause pour simuler l'animation
    cla; % Efface la figure pour le prochain frame
end

% Création de la vidéo
video = VideoWriter('evolution_maximum.avi');
open(video);

for k = 1:length(frames)
    scatter(frames{k}(:, 1), frames{k}(:, 2), 10, 'blue', 'filled');
    axis([-5 5 -5 5]);
    title('Évolution des individus - Algorithme mimétique (Maximum)');
    frame = getframe(gcf); % Capture le frame actuel
    writeVideo(video, frame); % Ajoute le frame à la vidéo
    cla;
end

close(video);
disp('Animation exportée sous forme de vidéo.');
