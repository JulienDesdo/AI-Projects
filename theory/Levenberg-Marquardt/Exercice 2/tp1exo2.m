%%% ------------------------------------------------------------------- %%%
%%% ------------------- TP Optimisation Exercice 2 -------------------- %%%
%%% ------------------------------------------------------------------- %%%

function []= tp1exo2()

    % Création du DataSet 
    t = transpose(0:0.01:10);
    M = length(t);
    data = zeros(M,2); 
    data(:,1) = t(:); 

    x1 = -2; 
    x2 = -1.5; 
    x3 = -1; 
    x4 = -0.5;
    x5 = -0.2; 
    x6 = 10; 
    x7 = 5;
    x8 = 2;
    x9 = -5;
    x10 = 10; 

    xv = [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10];
    
    % Construction du modèle réel. 
    y = zeros(M,1);
    N = length(xv);
    for p = 1:(N/2)
        y = y + xv(N/2 + p) * exp(xv(p) * t); % Somme des termes demandés
    end
    y = y ; %+ 0.01 * randn(M, 1);

    data(:,2) = y; 

    % Vecteur Initiale x0 & h0 
    %x0 = [0, 0 ,-1 ,0 ,x5, x6, x7, x8, x9, x10]; % Valeurs Initiales xi pour le calcul d'optimisation.  
    x0 = 0.5 * xv ; % initialisation proche mais légèrement différente de xv
    
    % Paramètres d'optimisation
    niter = M;
    epsilon = 10^(-5);
    Jx0 = jacobienne2(data,x0);
    tau = 10^-3;
    mu0 = tau*max(diag(transpose(Jx0)*Jx0)); % /!\ max sur la diagonale! max(...)n,n.

    % Seuils pour GAMMA 
    gammaMin = 0.1;
    gammaMax = 0.9; 
    gamma_seuil = [gammaMin, gammaMax];

    % Appel de LM pour estimer 
    [xOPT,fOPT,xintermed1,xintermed2] = LM2(data,niter,epsilon,mu0,gamma_seuil,x0); % Retourne x* et f_finale



    disp('---------- xv initial -----------')
    disp(xv)
    disp('---------- x0 initial -----------')
    disp(x0)
    disp('------------ xOPT ---------------')
    disp(xOPT)
    disp('------------ fOPT ---------------')
    disp(fOPT)

    % Tracé des données observées
    figure;
    plot(data(:, 1), data(:, 2), 'ko', 'MarkerSize', 5, 'DisplayName', 'Données observées');
    hold on;

    % Prédictions du modèle avec les paramètres initiaux x0
    y_init = zeros(M, 1);
    for p = 1:(N/2)
        y_init = y_init + x0(N/2 + p) * exp(x0(p) * data(:, 1));
    end
    plot(data(:, 1), y_init, 'b-', 'LineWidth', 2, 'DisplayName', 'Modèle initial');

    % Prédictions du modèle avec les paramètres intermédiaires xintermed1
    y_intermed1 = zeros(M, 1);
    for p = 1:(N/2)
        y_intermed1 = y_intermed1 + xintermed1(N/2 + p) * exp(xintermed1(p) * data(:, 1));
    end
    plot(data(:, 1), y_intermed1, 'c-', 'LineWidth', 2, 'DisplayName', 'Modèle intermédiaire it=1');

    % Prédictions du modèle avec les paramètres intermédiaires xintermed2
    y_intermed2 = zeros(M, 1);
    for p = 1:(N/2)
        y_intermed2 = y_intermed2 + xintermed2(N/2 + p) * exp(xintermed2(p) * data(:, 1));
    end
    plot(data(:, 1), y_intermed2, 'g-', 'LineWidth', 2, 'DisplayName', 'Modèle intermédiaire it=2');

    % Prédictions du modèle avec les paramètres optimisés xOPT
    y_opt = zeros(M, 1);
    for p = 1:(N/2)
        y_opt = y_opt + xOPT(N/2 + p) * exp(xOPT(p) * data(:, 1));
    end
    plot(data(:, 1), y_opt, 'r-', 'LineWidth', 2, 'DisplayName', 'Modèle optimisé');

    % Configuration du graphique
    xlabel('t');
    ylabel('y');
    title('Ajustement du modèle aux données');
    legend('Location', 'best');
    grid on;
    hold off;

end 