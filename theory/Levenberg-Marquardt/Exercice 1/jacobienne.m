function [J] = jacobienne(data,x)
    % Calcul via les formules analytiques pour simplifier la problématique.
    [M,~] = size(data(:,1));
    J = zeros(M,4);
    t = data(:,1); 

    for m=1:M
        % Attention conditions initiales, si x3,x4 nulles, alors J non
        % inversibles. D'où l'ajout du eye. 
        J(m,1) = -x(3)*t(m)*exp(x(1)*t(m));
        J(m,2) = -x(4)*t(m)*exp(x(2)*t(m));
        J(m,3) = -exp(x(1)*t(m)); 
        J(m,4) = -exp(x(2)*t(m));
    end 
end 