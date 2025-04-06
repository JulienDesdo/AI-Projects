function [x, f, iter] = gradient_optimal_step(y, t, x0, niter, epsilon)
    % Initialisation
    x = x0;
    iter = 0;

    for k = 1:niter
        % Calcul du résidu et de la fonction coût
        h = y - (x(3) * exp(x(1) * t) + x(4) * exp(x(2) * t));
        f = sum(h .^ 2);

        % Calcul du gradient
        grad_f = gradient_f(y, t, x, h);

        % Critère d'arrêt
        if norm(grad_f) < epsilon
            disp(['Convergence atteinte en ', num2str(k), ' itérations.']);
            iter = k;
            break;
        end

        % Calcul du pas optimal (résolution analytique)
        alpha = compute_optimal_step(y, t, x, grad_f, h);

        % Mise à jour des paramètres
        x = x - alpha * grad_f;
        iter = k;
    end
end

function alpha = compute_optimal_step(y, t, x, grad_f, h)
    % Calcul du pas optimal alpha qui minimise f(x - alpha * grad_f)
    % Ici, nous allons utiliser une méthode simple pour approximer alpha
    % car la résolution analytique exacte peut être complexe.

    % Pour simplifier, nous utilisons une recherche linéaire exacte sur alpha
    % en supposant que f(alpha) est quadratique le long de la direction du gradient.

    % Calcul des coefficients pour une parabole f(alpha) = a * alpha^2 + b * alpha + c
    % f(0) = f_current
    % f'(0) = -grad_f' * grad_f
    % Nous pouvons approximer f(alpha) ~ f(0) - alpha * grad_f' * grad_f + (1/2) * alpha^2 * grad_f' * H * grad_f
    % Mais le calcul de H (Hessienne) est complexe, donc nous pouvons utiliser une méthode numérique.

    % Pour simplifier, on peut faire une recherche linéaire par méthode des moindres carrés
    % Ici, nous utilisons une méthode simple pour trouver alpha

    % Intervalle initial pour alpha
    alpha_min = 0;
    alpha_max = 1;

    % Nombre de points pour la recherche
    num_points = 100;

    % Échantillonnage de alpha
    alpha_values = linspace(alpha_min, alpha_max, num_points);
    f_values = zeros(num_points, 1);

    for i = 1:num_points
        alpha_i = alpha_values(i);
        x_new = x - alpha_i * grad_f;
        h_new = y - (x_new(3) * exp(x_new(1) * t) + x_new(4) * exp(x_new(2) * t));
        f_values(i) = sum(h_new .^ 2);
    end

    % Trouver le alpha qui minimise f_values
    [~, idx_min] = min(f_values);
    alpha = alpha_values(idx_min);
end
