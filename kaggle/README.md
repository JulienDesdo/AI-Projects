# 🏆 Projets Kaggle – Exercices & Compétitions

Cette section rassemble plusieurs projets réalisés à partir de jeux de données publics et compétitions Kaggle.  
L’objectif est de **pratiquer différents modèles de machine learning** en conditions réalistes, avec un focus sur :

- Le **prétraitement des données**
- La **comparaison de modèles** (XGBoost, réseaux de neurones, etc.)
- Les **enjeux de généralisation et d’interprétabilité**

> 🧠 Ces projets ne visent pas la compétition à tout prix, mais l’expérimentation rigoureuse et l’analyse critique des performances.

---

## 📂 Projets disponibles

- [`Titanic – Survie`](./titanic_survival)  
  ➤ Projet de démarrage typique, pipeline ML complet, arbre de décision

- [`San Francisco – Classification de crimes`](./sf_crime_classification)  
  ➤ Comparaison entre DNN, Dropout et XGBoost (avec support GPU)

- [`Prévisions boursières (LSTM / GRU)`](./market_forecasting)  
  ➤ Séries temporelles financières avec LSTM/GRU, API Alpha Vantage

---

## ⚙️ Configuration & Environnement

Tous les notebooks sont conçus pour être lancés dans un environnement Python ≥ 3.8, idéalement via **Jupyter / Anaconda**.

> 💻 **Conseil** : utiliser [Anaconda](https://www.anaconda.com/) pour gérer les environnements virtuels et les bibliothèques (numpy, pandas, matplotlib, etc.)

Exemple de création d’un environnement :

```bash
conda create -n kaggle-env python=3.9
conda activate kaggle-env
pip install -r requirements.txt  # selon le projet
```

📘 Chaque sous-dossier contient son propre README.md ou rapport PDF pour plus de détails sur les résultats, les choix d'architecture et les scripts utilisés.

