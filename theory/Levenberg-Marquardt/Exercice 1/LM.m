%%% ------------------------------------------------------------------- %%%
%%% ------------ LM : Algorithme de Levenbrg-Marquardt ---------------- %%%
%%% ------------------------------------------------------------------- %%%

function [xOPT,fOPT,xintermed1,xintermed2] = LM(data,niter,epsilon,mu0,gamma_seuil,x0)

    h = data(:,2) - (x0(3)*exp(x0(1)*data(:,1)) + x0(4)*exp(x0(2)*data(:,1))); % h pour le vecteur x d'initialisation (x0)  
    f = sum(abs( data(:,2) - (x0(3)*exp(x0(1)*data(:,1)) + x0(4)*exp(x0(2)*data(:,1)))   ).^2); % f pour x0. 
    ecart = 100; % Valeurs initiale pour le critère d'arrêt, prise au hasard. 

    compteur = 0; 
    mu = mu0; 
    x = x0; 

    while compteur<niter %ecart > epsilon 
        [mu_new,f_new,h_new,x_new] = dir_LM(mu,f,h,x,gamma_seuil,data); % Maj du vecteur paramètres + calcule de la nouvelle fonction coût + Test sortie de boucle 
        
          if compteur>niter 
               break; 
          end 
          ecart = abs(f-f_new);


          f = f_new;
          h = h_new; 
          mu = mu_new;
          x = x_new;

%           if (ecart == 0)
%               ecart = 100; % Cas où la routine de gamma retourne x=x_new.
%           end 
           
          
          compteur = compteur + 1; 
          %disp(f)

          if (compteur == 2)
              xintermed1 = x; 
          end
          if (compteur == 1)
              xintermed2 = x; 
          end
          
    end 

    disp("--------- Nombre d'itérations avant convergence ------------")
    disp(compteur)

    fOPT = f; 
    xOPT = x; 
  
end 