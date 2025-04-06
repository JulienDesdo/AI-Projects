function [mu_new, f_new, h_new, x_new] = dirLM2(mu, f, h, x, gamma_seuil, data)
    % Calcul du Jacobien, de la fonction de coût, et du gradient
    [J, ~, ~] = fcout2(data, x, h); 

    % Equation de Levenberg-Marquardt pour obtenir dLM 
    A = transpose(J) * J + mu * eye(size(J, 2));
    direction = -A \ (transpose(J) * h);

    % Calcul de la nouvelle estimation de x et du modèle
    x_new = x + direction';

    % Recalcul de h et f pour x_new
    N = length(x);
    model_x_new = zeros(size(h));
    for p = 1:(N/2)
        model_x_new = model_x_new + x_new(N/2 + p) * exp(x_new(p) * data(:, 1));
    end
    h_new = data(:, 2) - model_x_new;
    f_new = sum(abs(h_new).^2);

    % Calcul de Gamma pour ajustement de mu
    gamma = (f - f_new) / (0.5 * (norm(h)^2 - norm(h + J * direction)^2));

    % Mise à jour de mu en fonction de gamma
    if gamma > 0
        if gamma < gamma_seuil(1) 
            mu_new = 2 * mu;
        elseif gamma > gamma_seuil(2)
            mu_new = mu / 3; 
        else
            mu_new = mu;
        end
    else 
       mu_new = 2 * mu; 
       x_new = x; % Réinitialise x_new si gamma est négatif
    end 
end
