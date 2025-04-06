%%% ------------------------------------------------------------------- %%%
%%% ----------------- Jacobienne pour vecteur x de dimension 10 ------- %%%
%%% ------------------------------------------------------------------- %%%

function [J] = jacobienne2(data, x)
    % Calcul via les formules analytiques pour simplifier la problématique
    [M, ~] = size(data(:, 1));
    N = length(x);
    J = zeros(M, N);
    t = data(:, 1);

    for m = 1:M
        for p = 1:(N/2)
            J(m, p) = -x(N/2 + p) * t(m) * exp(x(p) * t(m));  % Dérivée par rapport à x1, x2, ..., x5
            J(m, N/2 + p) = -exp(x(p) * t(m));                 % Dérivée par rapport à x6, x7, ..., x10
        end
    end
end
