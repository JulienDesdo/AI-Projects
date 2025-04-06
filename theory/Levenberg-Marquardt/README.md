# 📈 Optimisation avec Levenberg-Marquardt

Ce projet propose une implémentation complète de l’algorithme **Levenberg-Marquardt**, un compromis entre la descente de gradient et la méthode de Gauss-Newton, appliqué à des problèmes de régression non linéaire.

## 🎯 Objectifs

- Implémenter une optimisation robuste sur des fonctions non linéaires
- Comprendre le rôle du paramètre de régularisation (lambda)
- Observer l’évolution de la convergence et la sensibilité aux points initiaux
- Visualiser l’impact des différentes métriques d’erreur

> 🔍 Basé sur un **TP académique**, reproduit et enrichi dans un cadre personnel. **Les consignes initiales ne sont pas publiées pour respecter la confidentialité des contenus pédagogiques.**

---

## 🧪 Contenu

Le projet est structuré autour de 3 parties principales, chacune testant un cas différent d’optimisation :

### 1. 📐 Ajustement linéaire complexe (EXO 1)
Courbe expérimentale à modéliser à l’aide de fonctions exponentielles. Étude des performances selon différents critères.

### 2. 🧬 Ajustement sigmoïde (EXO 2)
Régression sur une fonction sigmoïde. Analyse de la sensibilité au point initial.

### 3. 🔧 Fonction simple (BONUS)
Régression sur une fonction de type sinus, avec contrôle des paramètres de régularisation. Visualisation de la convergence et des résidus.

---

## 📁 Fichiers clés

- `BONUS Gradient`, `Exerice 1` et `Exercice 2` pour le code. 
- `Document Explicatif Optimisation.pdf` : rapport expliquant les étapes, le raisonnement et les résultats
- `TPfinal_app.pdf` : support original non publié dans le dépôt public

---

## ✅ Résultats observés

- Levenberg-Marquardt offre une **très bonne stabilité** même sur des formes complexes
- Le choix du lambda initial et de son ajustement est **déterminant**
- Les erreurs (MSE, MAE...) peuvent donner des indications complémentaires selon la forme de la fonction cible

---

## 🧠 Ce que j’en retiens

Un excellent TP pour mieux appréhender le lien entre dérivées, ajustement local, et comportement global de l’optimisation. Il permet aussi de mieux sentir les limites des approches purement descendantes ou purement newtoniennes.

---

