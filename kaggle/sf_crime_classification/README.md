# 🕵️‍♂️ Crime Classification – San Francisco (Kaggle)

Ce projet vise à prédire la catégorie d’un crime à San Francisco à partir de données spatio-temporelles (horodatage, jour de la semaine, position GPS, etc.).

---

## 📊 Résumé des approches

Trois méthodes principales ont été testées :

| Modèle | Description | Score LogLoss Kaggle |
|--------|-------------|----------------------|
| 🧠 **MLP simple** | Modèle de réseau de neurones à architecture fully connected (dense) avec 2-3 couches. | **2.63835** ✅ |
| 🧠 **DNN + Dropout** | Version plus complexe du MLP avec régularisation Dropout. | 2.68046 |
| ⚡ **XGBoost (GPU)** | Implémentation de XGBoost optimisée avec `cudnn` + `cuda`. | 2.96496 |

Les notebooks correspondants sont disponibles dans le dossier racine du projet.

---

## 📦 Données

Les données proviennent du [`Kaggle Competition San Fransisco Crime Classification`](https://www.kaggle.com/competitions/sf-crime/submissions#).

Les datasets (raw & processed) sont disponibles sur mon compte [huggingface](https://huggingface.co/datasets/0wI/sf-crime-classification).

---
