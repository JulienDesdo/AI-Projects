function [xOPT, fOPT, xintermed1, xintermed2] = LM2(data, niter, epsilon, mu0, gamma_seuil, x0)
    N = length(x0);

    % Initialisation de h et f
    model_x0 = zeros(size(data(:, 2)));
    for p = 1:(N/2)
        model_x0 = model_x0 + x0(N/2 + p) * exp(x0(p) * data(:, 1));
    end
    h = data(:, 2) - model_x0;
    f = sum(abs(h).^2);

    % Initialisation des autres variables
    ecart = 100;
    compteur = 0;
    mu = mu0;
    x = x0;

    % Boucle principale de l'algorithme de Levenberg-Marquardt
    while compteur < niter 
        [mu_new, f_new, h_new, x_new] = dirLM2(mu, f, h, x, gamma_seuil, data);

        % Mise à jour des critères d'arrêt et des variables
        ecart = abs(f - f_new);
        f = f_new;
        h = h_new;
        mu = mu_new;
        x = x_new;

        % Enregistrement des solutions intermédiaires
        if compteur == 1
            xintermed1 = x;
        elseif compteur == 2
            xintermed2 = x;
        end

        compteur = compteur + 1;
    end

    % Résultats finaux
    fOPT = f;
    xOPT = x;
end
