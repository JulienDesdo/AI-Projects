%%% ------------------------------------------------------------------- %%%
%%% -------- Algorithme de Levenbrg-Marquardt (DIRECTION) ------------- %%%
%%% ------------------------------------------------------------------- %%%


function [mu_new,f_new,h_new,x_new] = dir_LM(mu,f,h,x,gamma_seuil,data)

    [J,~,~] = fcout(data,x,h); % Calcul Jacobien, fonction de coût, gradient 

    % Equation de Levenberg-Marquardt pour obtenir dLM 
    A = transpose(J)*J + mu*eye(size(J,2)); 

           %direction = -inv(A)*transpose(J)*h; % Direction à k. Dk_LM 
    direction = -A \ (transpose(J) * h); 


    % Calcul de Gamma 

    h = data(:,2) - (x(3)*exp(x(1)*data(:,1)) + x(4)*exp(x(2)*data(:,1))); 
    f = sum(abs(h).^2); % f(xk) 

    h_Dkxk = data(:,2) - ((direction(3)+x(3)) .* exp((direction(1)+x(1)) .* data(:,1)) + (direction(4)+x(4)) .* exp((direction(2)+x(2)) .* data(:,1)));
    f_Dkxk = sum(abs(h_Dkxk).^2); 

    gamma = (f - f_Dkxk) / (0.5 * (norm(h)^2 - norm(h + J * direction)^2));


    % Mise à jour de mu avec gamma 
    if gamma > 0
        x_new = x + direction'; % Calcul du nouveau x : x_new
        if gamma < gamma_seuil(1) 
            mu_new = 2 * mu;
        end 
        if  gamma > gamma_seuil(2)
            mu_new = mu/3; 
        else
        mu_new = mu; % Ajouter cette ligne pour assigner mu_new lorsque gamma est entre les seuils
        end 
    else 
       mu_new = 2 * mu; 
       x_new = x;
    end 

    h_new = data(:,2) - (x_new(3)*exp(x_new(1)*data(:,1)) + x_new(4)*exp(x_new(2)*data(:,1))); 
    f_new = sum(abs( data(:,2) - (x_new(3)*exp(x_new(1)*data(:,1)) + x_new(4)*exp(x_new(2)*data(:,1)))   ).^2);   

end 

