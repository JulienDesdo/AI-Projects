"""
@file train_agent.py
@brief Script d'entraînement pour l'agent DQN dans l'environnement de course.

Ce script utilise Stable Baselines 3 pour entraîner un agent DQN à naviguer sur des pistes définies.
Le modèle entraîné est sauvegardé dans un fichier zip.

@details
- Utilise la classe RacingEnv comme environnement de simulation.
- Le modèle utilise une architecture MLP (Multi-Layer Perceptron).
- Sauvegarde automatique du modèle après entraînement.

@dependencies:
- tqdm
- stable_baselines3
- racing_env

@functions:
    - train_model(map_name, total_timesteps): Entraîne l'agent DQN sur la carte spécifiée.

@example
    python train_agent.py
    (Exécute l'entraînement de l'agent sur la carte par défaut avec 300 000 itérations.)
"""


import tqdm
import stable_baselines3 as sb3
from racing_env import RacingEnv
import os

MODEL_PATH = "racing_agent.zip"

def train_model(map_name="Map 1", total_timesteps=300000):
    """
    @brief Entraîne l'agent IA (DQN) sur la carte spécifiée.

    @param map_name str: Nom de la carte à charger (ex: "Map 1").
    @param total_timesteps int: Nombre total d'itérations d'entraînement.

    @return None

    @details
    - Crée un environnement RacingEnv avec ou sans vision selon les paramètres.
    - L'agent est entraîné par batchs de 1000 steps jusqu'à atteindre le nombre total d'itérations.
    - Utilise une politique MLP.
    - Le modèle est sauvegardé sous 'racing_agent.zip'.

    @note Modifier le nombre d'itérations directement dans l'appel de la fonction pour ajuster l'entraînement.
    """
    env = RacingEnv(map_name=map_name, show_vision=False, with_images=False)
    model = sb3.DQN("MlpPolicy", env, verbose=0, learning_rate=0.0005, batch_size=32)

    with tqdm.tqdm(total=total_timesteps, desc="Entraînement en cours") as pbar:
        steps_done = 0
        while steps_done < total_timesteps:
            model.learn(total_timesteps=1000)
            steps_done += 1000
            pbar.update(1000)

    model.save(MODEL_PATH)
    print(f"[OK] Entraînement terminé. Modèle sauvegardé sous '{MODEL_PATH}'.")

if __name__ == "__main__":
    # Exemple : on entraîne 20k steps sur Map 1
    train_model("Map 1", total_timesteps=300000) # -> Modifier ici le nombre d'itération si entrainement. 
