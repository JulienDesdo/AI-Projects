"""
@file test_agent.py
@brief Script de test pour un modèle DQN entraîné sur le simulateur de course.

@details
Permet de :
- Charger un modèle pré-entraîné (racing_agent.zip),
- Simuler et visualiser des épisodes en direct avec rendu Pygame,
- Tester la robustesse de l'IA sur la carte spécifiée.

@functions:
    - test_model(map_name, show_vision, num_episodes): Lance la simulation IA.
"""


import stable_baselines3 as sb3
import pygame
import numpy as np
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

MODEL_PATH = "racing_agent.zip"

def test_model(map_name="Map 1", show_vision=True, num_episodes=1):
    """
    @brief Lance la simulation IA en utilisant le modèle entraîné (DQN).

    @param map_name (str): Nom de la carte à charger (ex: "Map 1").
    @param show_vision (bool): True pour afficher les capteurs (rayons) pendant la simulation.
    @param num_episodes (int): Nombre d'épisodes à simuler (par défaut: 1).

    @details
    - Si le modèle 'racing_agent.zip' n'est pas trouvé, la fonction renvoie une erreur.
    - Chaque épisode est rendu en direct avec Pygame (1280x720).
    - La simulation s'arrête si la fenêtre est fermée ou si l'épisode est terminé.

    @return None

    @note
    Ce script suppose que le fichier modèle a été généré par train_agent.py.
    """

    if not os.path.exists(MODEL_PATH):
        print("❌ Erreur : Modèle IA 'racing_agent.zip' introuvable !")
        return

    pygame.init()
    screen = pygame.display.set_mode((1280, 720))
    clock = pygame.time.Clock()

    from racing_env import RacingEnv
    env = RacingEnv(map_name=map_name, show_vision=show_vision, with_images=True,screen=screen)
    model = sb3.DQN.load(MODEL_PATH)

    for ep in range(num_episodes):
        obs = env.reset()
        done = False
        while not done:
            # Gestion event (permet de fermer la fenêtre si besoin)
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    done = True

            # L'IA choisit l'action
            action, _ = model.predict(obs)
            obs, reward, done, _ = env.step(action)

            # On dessine l'état
            env.render()
            clock.tick(30)

        print(f"Épisode {ep+1} terminé.")

    pygame.quit()

if __name__ == "__main__":
    test_model("Map 1", show_vision=True, num_episodes=1)
