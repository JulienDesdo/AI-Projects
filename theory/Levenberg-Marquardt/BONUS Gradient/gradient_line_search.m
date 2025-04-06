function [x, f, iter] = gradient_line_search(y, t, x0, niter, epsilon)
    % Initialisation
    x = x0;
    alpha0 = 1;    % Pas initial pour la recherche linéaire
    beta = 0.5;    % Facteur de réduction du pas
    sigma = 1e-4;  % Paramètre pour la condition d'Armijo
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

        % Recherche linéaire pour trouver le pas optimal
        alpha = alpha0;
        while true
            % Calcul du nouveau point
            x_new = x - alpha * grad_f;

            % Calcul du nouveau résidu et de la nouvelle fonction coût
            h_new = y - (x_new(3) * exp(x_new(1) * t) + x_new(4) * exp(x_new(2) * t));
            f_new = sum(h_new .^ 2);

            % Vérification de la condition d'Armijo
            if f_new <= f - sigma * alpha * norm(grad_f)^2
                break; % Condition satisfaite, on sort de la boucle
            else
                % Réduction du pas
                alpha = beta * alpha;
                if alpha < 1e-16
                    warning('Le pas est devenu trop petit.');
                    break;
                end
            end
        end

        % Mise à jour des paramètres
        x = x_new;
        iter = k;
    end
end
