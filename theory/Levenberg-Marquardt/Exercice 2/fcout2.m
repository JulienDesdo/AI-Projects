%%% ------------------------------------------------------------------- %%%
%%% --------- Algorithme de Levenberg-Marquardt (fonction coût) ------- %%%
%%% ------------------------------------------------------------------- %%%

function [J, f, g] = fcout2(data, x, h)
    % Calcul du Jacobien avec le vecteur x de dimension 10
    J = jacobienne2(data, x);

    % Calcul de la fonction coût pour le vecteur x de dimension 10
    f = sum(abs(h).^2); 
    g = transpose(J) * h; % Gradient de la fonction coût f
end
