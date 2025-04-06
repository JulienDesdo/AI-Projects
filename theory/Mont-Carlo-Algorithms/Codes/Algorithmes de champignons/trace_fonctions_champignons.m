% Paramètres pour la fonction 1
a = 1; b = 1; c = 1; d = 1;

% Domaine de la fonction
x = linspace(-5, 5, 100); % 100 points pour X
y = linspace(-5, 5, 100); % 100 points pour Y
[X, Y] = meshgrid(x, y);

% Fonction 1
F1 = a * exp(-b * ((X - 1).^2 + (Y - 2).^2)) + c * exp(-d * ((X + 1).^2 + (Y + 3).^2));

% Tracé
figure;
surf(X, Y, F1, 'EdgeColor', 'none');
title('Fonction 1 : Maximisation');
xlabel('x');
ylabel('y');
zlabel('f(x, y)');
colorbar;
view(3); % Vue 3D


% Domaine de la fonction
x2 = linspace(-5.12, 5.12, 100); % 100 points pour X
y2 = linspace(-5.12, 5.12, 100); % 100 points pour Y
[X2, Y2] = meshgrid(x2, y2);

% Fonction 2
F2 = 20 + X2.^2 + Y2.^2 - 10 * (cos(2 * pi * X2) + cos(2 * pi * Y2));

% Tracé
figure;
surf(X2, Y2, F2, 'EdgeColor', 'none');
title('Fonction 2 : Minimisation');
xlabel('x');
ylabel('y');
zlabel('f(x, y)');
colorbar;
view(3); % Vue 3D
