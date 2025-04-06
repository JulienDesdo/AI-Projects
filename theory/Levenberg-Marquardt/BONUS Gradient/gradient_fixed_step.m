function [x, f, iter] = gradient_fixed_step(y, t, x0, niter, epsilon)
    % Initialisation
    x = x0;
    alpha = 1e-4; % Pas fixe (à ajuster selon le problème)
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

        % Mise à jour des paramètres
        x = x - alpha * grad_f;
        iter = k;
    end
end
