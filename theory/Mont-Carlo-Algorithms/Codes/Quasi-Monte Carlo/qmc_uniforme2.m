clear all
close all

%%%%----------------------------------------------------------------------%%%%
%%%%----------------- Paramètres généraux --------------------------------%%%%
%%%%----------------------------------------------------------------------%%%%
Nk_values = [10, 100]; % Nombre de points à placer pour Kohonen et k-means
I_exact = (exp(1) - 1)^2; % Valeur exacte de l'intégrale

results_Kohonen = [];
results_kmeans = [];

figure_count = 1; % Compteur pour les figures

%%%%----------------------------------------------------------------------%%%%
%%%%----------------- Algorithme de Kohonen et K-means -------------------%%%%
%%%%----------------------------------------------------------------------%%%%
for Nk = Nk_values
    %% Initialisation des points
    Point_nr = rand(Nk, 2); % Points aléatoires initiaux
    
    %% Kohonen
    Point_o = Point_nr; % Copie pour Kohonen
    pas = 0.01; % Pas initial
    nk = 100000; % Nombre d'itérations
    
    for k = 1:nk
        personne = rand(1, 2); % Tirage d'une personne
        distances = sum((Point_o - personne).^2, 2);
        [~, ind_min] = min(distances);
        Point_o(ind_min, :) = (1 - pas) * Point_o(ind_min, :) + pas * personne;
        pas = 0.01 - (k / nk) * (0.01 - 0.0001); % Décroissance du pas
    end
    
    % Calcul de I pour Kohonen
    alpha_Kohonen = ones(Nk, 1) / Nk; % Poids uniformes pour simplifier
    I_Kohonen = sum(alpha_Kohonen .* exp(sum(Point_o, 2)));
    results_Kohonen = [results_Kohonen; Nk, I_Kohonen, abs(I_Kohonen - I_exact)];
    
    %% K-means
    Nt = 20000; % Nombre de points aléatoires
    Point_m = Point_nr; % Points initiaux pour k-means
    compteur_point = ones(Nk, 1);
    Tenseur_Point = zeros(1, 2, Nk);
    
    for n = 1:35
        for t = 1:Nt
            Pt = rand(1, 2); % Nouveau point
            distances = sum((Point_m - Pt).^2, 2);
            [~, ind_min] = min(distances);
            compteur_point(ind_min) = compteur_point(ind_min) + 1;
            Tenseur_Point(compteur_point(ind_min), :, ind_min) = Pt;
        end
        
        % Mise à jour des centres
        for k = 1:Nk
            x_new = sum(Tenseur_Point(:, 1, k)) / compteur_point(k);
            y_new = sum(Tenseur_Point(:, 2, k)) / compteur_point(k);
            Point_m(k, :) = [x_new, y_new];
        end
    end
    
    % Calcul de I pour k-means
    alpha_kmeans = compteur_point / sum(compteur_point);
    I_kmeans = sum(alpha_kmeans .* exp(Point_m(:, 1) + Point_m(:, 2)));
    results_kmeans = [results_kmeans; Nk, I_kmeans, abs(I_kmeans - I_exact)];
    
    %% Affichage pour les points initiaux, Kohonen et k-means
    figure(figure_count);
    subplot(1, 3, 1);
    scatter(Point_nr(:, 1), Point_nr(:, 2));
    title(['Points Initiaux (', num2str(Nk), ' Points)']);
    xlabel('x');
    ylabel('y');
    axis equal;
    
    subplot(1, 3, 2);
    scatter(Point_o(:, 1), Point_o(:, 2), 'red');
    title(['Kohonen (', num2str(Nk), ' Points)']);
    xlabel('x');
    ylabel('y');
    axis equal;
    
    subplot(1, 3, 3);
    scatter(Point_m(:, 1), Point_m(:, 2), 'green');
    title(['K-means (', num2str(Nk), ' Points)']);
    xlabel('x');
    ylabel('y');
    axis equal;
    
    % Incrémenter le compteur de figure
    figure_count = figure_count + 1;
end

%%%%----------------------------------------------------------------------%%%%
%%%%----------------- Résultats d'intégration ----------------------------%%%%
%%%%----------------------------------------------------------------------%%%%

disp('Résultats Kohonen :');
disp(array2table(results_Kohonen, 'VariableNames', {'Nk', 'I_Kohonen', 'Erreur_Absolue'}));

disp('Résultats K-means :');
disp(array2table(results_kmeans, 'VariableNames', {'Nk', 'I_kmeans', 'Erreur_Absolue'}));
