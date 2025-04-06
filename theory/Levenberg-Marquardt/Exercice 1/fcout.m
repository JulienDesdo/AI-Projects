%%% ------------------------------------------------------------------- %%%
%%% --------- Algorithme de Levenbrg-Marquardt (fonction coût) -------- %%%
%%% ------------------------------------------------------------------- %%%

function [J,f,g] = fcout(data,x,h)

    [J] = jacobienne(data,x); % Jacobienne pour le vecteur x à l'itération k : J(h)(xk). 

    f = sum(abs(h).^2); % f(xk). xk vecteur de R4.   
    g = gradient(f); 
    

end 