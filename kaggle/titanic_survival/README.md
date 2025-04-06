# 🛳️ Titanic - Kaggle Starter Project

Ce projet explore la compétition classique *Titanic: Machine Learning from Disaster*. Il sert de point de départ pour appliquer un pipeline complet de machine learning sur un dataset public.

## 📦 Contenu

- `Titanic_preprocessing.ipynb` : Nettoyage, feature engineering (Cabin, Ticket, Embarked, etc.), encodage.
- `Titanic_model.ipynb` : Entraînement du modèle
- Données d’origine : `train.csv`, `test.csv`
- Données transformées : `train_net.csv`, `test_net.csv`
🔗 [DATA LINK](https://huggingface.co/datasets/0wI/titanic-survival)

## ✅ Techniques utilisées

- OneHotEncoder (Cabin, Embarked)
- Encodage binaire (Sex)
- Normalisation des tickets
- Gestion des valeurs manquantes par classes
- TfidfVectorizer sur les noms
- Split train/test avec `train_test_split`
- Modèle basique `DecisionTreeClassifier`

## 🔧 Dépendances

Lister avec `pip freeze` ou via l'environnement conda (cf. `commandes_conda.txt` si utile).

---

> 💬 Une version améliorée avec cross-validation, grid search ou neural nets (via Keras) pourrait suivre !
