import tqdm
import stable_baselines3 as sb3
from racing_env import RacingEnv
import os

MODEL_PATH = "racing_agent.zip"

def train_model(map_name="Map 1", total_timesteps=300000):
    """Entraîne l'IA sur la map donnée."""
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
