function [] = gradient_methods()
    % Nombre de points de données
    M = 101;

    % Génération des données
    t = linspace(0, 1, M)';
    xv = [-4; -1; 4; -5]; % [x1, x2, x3, x4]
    y = xv(3) * exp(xv(1) * t) + xv(4) * exp(xv(2) * t) + 0.01 * randn(M, 1);

    % Vecteur initial des paramètres à estimer
    x0 = [0; 0; 3; 0];

    % Paramètres de l'algorithme
    niter = 1000; % Nombre maximal d'itérations
    epsilon = 1e-6; % Critère d'arrêt pour la norme du gradient

    % Appel des méthodes de descente de gradient
    %disp('--- Descente de gradient à pas fixe ---');
    [x_fixed, f_fixed, iter_fixed] = gradient_fixed_step(y, t, x0, niter, epsilon);

    %disp('--- Descente de gradient avec recherche linéaire ---');
    [x_linesearch, f_linesearch, iter_linesearch] = gradient_line_search(y, t, x0, niter, epsilon);

    %disp('--- Descente de gradient avec pas optimal ---');
    [x_optimal, f_optimal, iter_optimal] = gradient_optimal_step(y, t, x0, niter, epsilon);

    % Affichage des résultats
    disp('--- Résultats ---');
    disp('Paramètres réels xv :');
    disp(xv');
    disp('Paramètres estimés par descente de gradient à pas fixe :');
    disp(x_fixed');
    disp(['Nombre d''itérations : ', num2str(iter_fixed), ', f(x) = ', num2str(f_fixed)]);
    disp('Paramètres estimés par descente de gradient avec recherche linéaire :');
    disp(x_linesearch');
    disp(['Nombre d''itérations : ', num2str(iter_linesearch), ', f(x) = ', num2str(f_linesearch)]);
    disp('Paramètres estimés par descente de gradient avec pas optimal :');
    disp(x_optimal');
    disp(['Nombre d''itérations : ', num2str(iter_optimal), ', f(x) = ', num2str(f_optimal)]);
end
