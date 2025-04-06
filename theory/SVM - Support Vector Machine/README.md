# 🧪 SVM linéaires & non linéaires

Ce projet explore les différentes formes de SVM (Support Vector Machines) à travers cinq approches, du plus simple au plus complexe. L'ensemble du code est structuré autour de questions de TP, avec un rapport technique joint décrivant chaque étape théorique.

## 🎯 Objectif

L'idée est d'analyser en détail les performances de différents classifieurs SVM selon le type de séparation (linéaire ou non), et selon les paramètres influents (C, type de noyau, degré du polynôme...).

Le projet est à but académique : le but est la compréhension du fonctionnement théorique et pratique des SVM à travers des implémentations MATLAB low-level (sans boîte noire).

Chaque script est associé à une partie du rapport. 

## 🧠 Méthodologie

Le travail est organisé en 5 grandes parties :

    1. SVM linéairement séparable (primal) : résolution directe via optimisation quadratique (avec quadprog) pour obtenir l’hyperplan.

    2. SVM linéairement séparable (dual) : utilisation des multiplicateurs de Lagrange, facilite l’introduction des noyaux.

    3. SVM linéairement non séparable (marge souple) : ajout d’un paramètre C pour tolérer des erreurs, compromis entre marge et erreurs.

    4. SVM non linéaire avec noyau gaussien : pour des données en anneau, impossibles à séparer linéairement.

    5. SVM non linéaire avec noyau polynomial : analyse combinée de l’influence du degré d et de la régularisation C.

## 🧪 Résultats observés

    - Le noyau gaussien permet des séparations complexes mais peut entraîner du sur-apprentissage si mal paramétré (sigma trop petit).

    - Le noyau polynomial offre une belle démonstration du compromis entre complexité (degré) et généralisation.

    - L'effet du paramètre C est central : plus il est élevé, plus on favorise la précision sur les données d'entraînement, au détriment de la généralisation.

## 📁 Contenu

    - svmq1.m : cas primal linéaire

    - svmq2.m : cas dual linéaire

    - swmq3.m : cas non linéairement séparable

    - svmq4.m : noyau gaussien

    - svmq5.m et variantes : noyau polynomial (C, d, etc.)

    - TP SVM linéaires et non linéaires.pdf : rapport complet avec explications mathématiques et figures