# AI-Projects
!!!! DATA FILES FROM KAGGLE WILL ARRIVE SOON on HUGGING FACE !!!!


Projets d’IA couvrant l’optimisation, Kaggle, le machine learning, le deep learning et autres expérimentations.

Certains sont à vocation purement expérimentale, d’autres plus académiques — mais bien sûr, tous participent à l’acquisition de compétences 🧩

Le dépôt est organisé par thématique d’application.  
Chaque projet contient soit un **README explicatif**, soit un **rapport PDF**, soit un peu des deux !

---

## 📁 Structure du dépôt

```
AI-Projects/
├── audio/                  ← Reconnaissance de sons
├── kaggle/                 ← Compétitions, datasets publics
├── practical/              ← Tests de frameworks, prototypes techniques
├── simulation/             ← Environnements interactifs, apprentissage par renforcement
├── theory/                 ← Projets mathématiques, académiques, optimisations
└── README.md
```
--- 

## 🚀 Résumé des projets
 ### Kaggle

- [`Titanic`](./kaggle/titanic_survival) — Prédiction de survie, pipeline ML de base

- [`Crime Classification`](./kaggle/sf_crime_classification) — Deep learning vs XGBoost sur données spatio-temporelles

- [`Market Forecast`](./kaggle/market_forecasting) — Prédiction de séries financières via LSTM & GRU


--- 

## Simulations & Reinforcement Learning

### 🚗 Car DQN Learning
- Environnement Pygame + DQN avec StableBaselines3
- Contrôle d’un véhicule sur différentes pistes
- 🎮 [Voir le dossier](./simulation/carsDQLN)



## Théorie & optimisation

### 🧠 MLP Optimizer Comparison (Adam vs SGD)
- Implémentation manuelle d’un MLP (forward et backpropagation)
- Comparaison des performances d’Adam vs SGD sur des données synthétiques
- 📁 [Voir le projet](./theory/ADAM-MLP-Implementation)

### 📎 SVM linéaires & non-linéaires
- Implémentations *bas niveau* en MATLAB (sans boîte noire)
- Étude progressive : primal, dual, marge souple, noyaux *gaussien* et *polynomial*
- 🔍 Analyse de l’impact des hyperparamètres *(C, σ, degré du noyau)*
- 📁 [Voir le dossier](./theory/SVM%20-%20Support%20Vector%20Machine)


### 🧮 Levenberg-Marquardt Optimisation
- Implémentation de l’algorithme de Levenberg-Marquardt pour la régression non linéaire
- Comparaison sur différents jeux de données (bonus + exos) avec visualisations
- 📊 [Voir le dossier](./Levenberg-Marquardt)

### 🎲 Monte Carlo & Quasi-Monte Carlo

- Approches numériques d’intégration, d’estimation et d’optimisation par échantillonnage
- Visualisation des effets de clustering, méthodes QMC, algorithmes de type mimétique
- 📊 [Voir le dossier](./Mont-Carlo-Algorithms)

<!--
---

🧰 Pratique & Frameworks (à venir)

    - [YOLO - détection objet (C++)]()

    - [TensorFlow en C++]()

    - [Intro GPU Programming]()
-->
<!--
--- 

🔊 Audio (à venir)

    - RTF - Sons de baleines / chauves-souris

-->
---

📚 Tous les projets sont commentés, accompagnés de visuels et de tests reproductibles.

