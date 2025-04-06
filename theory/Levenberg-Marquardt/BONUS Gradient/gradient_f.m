function grad_f = gradient_f(y, t, x, h)
    % Calcul du gradient de la fonction coût f par rapport aux paramètres x
    M = length(t);
    grad_f = zeros(4, 1);

    % Calcul des exponentielles pour optimiser les calculs
    exp_x1_t = exp(x(1) * t);
    exp_x2_t = exp(x(2) * t);

    % Dérivée par rapport à x1
    grad_f(1) = -2 * sum(h .* x(3) .* t .* exp_x1_t);

    % Dérivée par rapport à x2
    grad_f(2) = -2 * sum(h .* x(4) .* t .* exp_x2_t);

    % Dérivée par rapport à x3
    grad_f(3) = -2 * sum(h .* exp_x1_t);

    % Dérivée par rapport à x4
    grad_f(4) = -2 * sum(h .* exp_x2_t);
end
