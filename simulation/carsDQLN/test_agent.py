import stable_baselines3 as sb3
import pygame
import numpy as np
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

MODEL_PATH = "racing_agent.zip"

def test_model(map_name="Map 1", show_vision=True, num_episodes=1):
    """
    Replay ANIMÉ (pas à pas).
    => On appelle env.step() + env.render() en boucle.
    => Pas d'effet "tuyau" : on voit la voiture bouger "en direct".
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
