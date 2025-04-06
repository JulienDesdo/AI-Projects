%%% ------------------------------------------------------------------- %%%
%%% ------- TP Methodes Optimisation numeriques deterministes --------- %%%
%%% ------------------------------------------------------------------- %%%

function []= tp1()
    M = 101; 

    % Création du DataSet 
    data = zeros(M,2); 
    t = transpose(0:0.01:1); % Attention peut être induit (à cause du 0) un truc qui diverge. Alors commencer à 0.01.
    data(:,1) = t(:,:); 

    x1 = -4; 
    x2 = -1; 
    x3 = 4; 
    x4 = -5; 

    xv = [x1, x2, x3, x4];
     
    
    
    y = x3 * exp(x1*t) + x4 * exp(x2*t) + 1 * randn(101,1); % Construction du modèle réel !
    data(:,2) = y; 

    % Vecteur Initiale x0 & h0 
    x0 = [0,0,3,0]; % Valeurs Initiales de x1,x2,x3,x4 pour le calcul d'optimisation. 
    h0 = data(:,2) - (x0(3)*exp(x0(1)*data(:,1)) + x0(4)*exp(x0(2)*data(:,1))); % h0 vecteur des hm (défini grâce au tm dans le dataset) tel que vecteur_des_x=x0. Dimension Mx1. 
    
    % Nombre d'itérations maximum    
    niter = 10*M;
    % Critère d'arrêt 
    epsilon = 10^(-5);
    % Valeur Intiale Coefficient d'amortissement 
    Jx0 = jacobienne(data,x0);
    tau = 10^-3;
    %mu0 = tau*max(diag(transpose(Jx0)*Jx0)); % /!\ max sur la diagonale! max(...)n,n.
     %disp(mu0)
    mu0 = 10000; 
    % Seuils pour GAMMA 
    gammaMin = 0.25;
    gammaMax = 0.75; 
    gamma_seuil = [gammaMin, gammaMax];

    % Appel de LM pour estimer 
    [xOPT,fOPT,xintermed1,xintermed2] = LM(data,niter,epsilon,mu0,gamma_seuil,x0); % Retourne x* et f_finale







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
    plot(data(:,1), data(:,2), 'ko', 'MarkerSize', 5, 'DisplayName', 'Données observées');
    hold on;
    
    % Prédictions du modèle avec les paramètres initiaux x0
    y_init = x0(3)*exp(x0(1)*data(:,1)) + x0(4)*exp(x0(2)*data(:,1));
    plot(data(:,1), y_init, 'b-', 'LineWidth', 2, 'DisplayName', 'Modèle initial');

    % Prédictions du modèle avec les paramètres initiaux xk
    y_init = xintermed1(3)*exp(xintermed1(1)*data(:,1)) + xintermed1(4)*exp(xintermed1(2)*data(:,1));
    plot(data(:,1), y_init, 'c-', 'LineWidth', 2, 'DisplayName', 'Modèle intermédiaire it=1');

    % Prédictions du modèle avec les paramètres initiaux xk
    y_init = xintermed2(3)*exp(xintermed2(1)*data(:,1)) + xintermed2(4)*exp(xintermed2(2)*data(:,1));
    plot(data(:,1), y_init, 'g-', 'LineWidth', 2, 'DisplayName', 'Modèle intermédiaire it=2');
    
    % Prédictions du modèle avec les paramètres optimisés xOPT
    y_opt = xOPT(3)*exp(xOPT(1)*data(:,1)) + xOPT(4)*exp(xOPT(2)*data(:,1));
    plot(data(:,1), y_opt, 'r-', 'LineWidth', 2, 'DisplayName', 'Modèle optimisé');
    
    % Configuration du graphique
    xlabel('t');
    ylabel('y');
    title('Ajustement du modèle aux données');
    legend('Location', 'best');
    grid on;
    hold off;

end 