# Prévision des marchés financiers avec LSTM & GRU

Ce projet applique des modèles de Deep Learning (RNN de type LSTM et GRU) à la prédiction de séries temporelles de prix boursiers, à partir de données récupérées via l’API [Alpha Vantage](https://www.alphavantage.co/).

## 📌 Objectifs

- Charger automatiquement les données boursières (prix, volume, etc.) d'une entreprise donnée.
- Intégrer les splits (divisions d'actions) pour lisser les historiques.
- Prétraiter les données (scaling, création de fenêtres temporelles).
- Entraîner plusieurs architectures :
  - **LSTM à deux couches**
  - **LSTM à trois couches**
  - **GRU simple**
  - **GRU bidirectionnel**
- Comparer les performances sur jeux de validation et test.

## 📂 Fichiers

- `notebooks/market_forecasting.ipynb` : notebook principal (anciennement `markets_alpha-vantage.ipynb`)
- `data/CA.PA_1D.csv` : exemple de données téléchargées (ici Carrefour) 🔗
- `inputs/companies_list.txt` : liste des entreprises disponibles avec nom, secteur, etc. 🔗
- `alpha_api_key.txt` : votre clé API personnelle (à ne pas versionner)

🔗 Données [ici](https://huggingface.co/datasets/0wI/market-forecasting)

## ⚙️ Dépendances

Installez les bibliothèques nécessaires via pip :

```bash
pip install yfinance alpha_vantage pandas numpy tensorflow matplotlib seaborn

⚠️ Vous devez obtenir une clé API gratuite sur Alpha Vantage et la placer dans le fichier alpha_api_key.txt. Même si elle est gratuite, elle est liée à un quota journalier (5 requêtes/minute, 500/jour). 

*https://www.alphavantage.co/support/#api-key*
