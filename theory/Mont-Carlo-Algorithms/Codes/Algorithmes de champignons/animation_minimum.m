clear all
close all

% Paramètres
N = 1000; % Nombre d'individus
Nb_etape = 8000; % Nombre d'étapes
epsilon = 1e-3;

% Initialisation des individus
Individus2 = -5.12 + 10.24 * rand(N, 2);
fonction1_individus = Individus2;

% Stockage des étapes pour l'animation
frames = {}; % Stocke les positions des individus pour chaque étape d'animation
capture_interval = 50; % Capture toutes les 50 itérations

% Boucle principale
for i = 1:Nb_etape

    % Sélection de deux individus au hasard
    indices = randperm(N, 2);

    % Calcul des valeurs de la fonction associée aux individus
    recherche1 = 20 + fonction1_individus(indices(1), 1)^2 + fonction1_individus(indices(1), 2)^2 - ...
                 10 * (cos(2 * pi * fonction1_individus(indices(1), 1)) + ...
                       cos(2 * pi * fonction1_individus(indices(1), 2)));

    recherche2 = 20 + fonction1_individus(indices(2), 1)^2 + fonction1_individus(indices(2), 2)^2 - ...
                 10 * (cos(2 * pi * fonction1_individus(indices(2), 1)) + ...
                       cos(2 * pi * fonction1_individus(indices(2), 2)));

    % Mise à jour des coordonnées
    alpha = (1 - epsilon)^i;
    if recherche1 < recherche2
        fonction1_individus(indices(2), :) = fonction1_individus(indices(1), :) + ...
                                             [alpha * randn(1), alpha * randn(1)];
    else
        fonction1_individus(indices(1), :) = fonction1_individus(indices(2), :) + ...
                                             [alpha * randn(1), alpha * randn(1)];
    end

    % Capturer les positions pour l'animation
    if mod(i, capture_interval) == 0
        frames{end+1} = fonction1_individus; % Sauvegarder les positions
    end
end

% Création de l'animation
figure;
hold on;
axis([-5.12 5.12 -5.12 5.12]); % Domaine de visualisation
title('Évolution des individus - Algorithme mimétique (Minimum)');

for k = 1:length(frames)
    scatter(frames{k}(:, 1), frames{k}(:, 2), 10, 'blue', 'filled');
    drawnow;
    pause(0.1); % Pause pour simuler l'animation
    cla; % Efface la figure pour le prochain frame
end


% Création de la vidéo
video = VideoWriter('evolution_minimum.avi');
open(video);

for k = 1:length(frames)
    scatter(frames{k}(:, 1), frames{k}(:, 2), 10, 'blue', 'filled');
    axis([-5.12 5.12 -5.12 5.12]);
    title('Évolution des individus - Algorithme mimétique (Minimum)');
    frame = getframe(gcf); % Capture le frame actuel
    writeVideo(video, frame); % Ajoute le frame à la vidéo
    cla;
end

close(video);
disp('Animation exportée sous forme de vidéo.');
