# 📈 Optimisation Numérique avec Levenberg-Marquardt

Ce projet met en œuvre l’algorithme **Levenberg-Marquardt**, algorithme d'optimisation. Il s'agit peu ou prou d'un algorithme type Gradient, Newton... si ce n'est qu'il plus performant. 
Ce type d'algorithme sert en IA pour ajuster les paramètres d’un modèle afin de minimiser une fonction de coût, notamment dans l’apprentissage supervisé.

## 🎯 Objectifs

- Implémentation de Levenberg-Marquardt avec jacobienne analytique
- Étude de la sensibilité aux conditions initiales et au bruit
- Exploration de l’impact du paramètre de régularisation (`mu`)
- Comparaison avec les méthodes de descente de gradient

> 🔍 Basé sur un **TP académique**, reproduit et enrichi dans un cadre personnel. **Les consignes initiales ne sont pas publiées pour respecter la confidentialité des contenus pédagogiques.**

---

## 🧪 Expériences

### 1. Modèle à 4 paramètres

- Modèle : `y = x3 * exp(x1 * t) + x4 * exp(x2 * t)`
- Analyse des résultats selon différentes conditions initiales et niveaux de bruit
- Étude des minima locaux et du comportement de la convergence

### 2. Modèle à 10 paramètres

- Problème plus complexe avec un espace de recherche plus large
- Ajustement du nombre d’itérations et contrôle renforcé des paramètres

### Bonus : Méthodes du gradient

- Comparaison directe avec la descente de gradient
- Observation d'une moins bonne robustesse face aux minima locaux

---

## 📁 Fichiers

- Scripts Matlab (`Exercice 1`, `Exercice 2`, `dirLM.m`, etc.)
- `Document Explicatif Optimisation.pdf` : rapport détaillé

---

## 🧠 En résumé

Le TP montre bien l’intérêt de Levenberg-Marquardt comme méthode hybride efficace entre gradient et Gauss-Newton, tout en révélant ses limites face aux mauvaises conditions initiales ou à des problèmes trop bruités.
