"""
@file racing_env.py
@brief Définition de l'environnement Gym compatible avec Stable-Baselines3.

Ce module permet l'entraînement et le test d'agents IA dans un simulateur de course basé sur Gym.
Il contient également une fonction utilitaire pour redimensionner et centrer des images Pygame.

@details
- Observation: vecteur de 7 distances des capteurs (vision rayons).
- Actions: 0 = accélérer, 1 = tourner à gauche, 2 = tourner à droite.
- Utilisé avec Stable-Baselines3 pour des agents DQN par ex.

@dependencies:
- gym
- numpy
- pygame

@classes:
    - RacingEnv: Environnement Gym pour la course.

@functions:
    - resize_and_center_image: Redimensionne une image et la centre dans un cadre donné.
"""


import gym
import numpy as np
import pygame
from gym import spaces
from track import Track
from vehicule_class import Vehicule

# Fonction pour redimensionner sans déformer
def resize_and_center_image(image, target_width, target_height):
    """
    @brief Redimensionne l'image sans la déformer et la centre dans un cadre cible.

    @param image pygame.Surface: Image source à redimensionner.
    @param target_width int: Largeur cible du cadre.
    @param target_height int: Hauteur cible du cadre.

    @return pygame.Surface: Surface redimensionnée et centrée.

    @details
    - Conserve le ratio hauteur pour ne pas déformer l'image.
    - Centre l'image horizontalement dans le cadre donné.
    """
    original_width, original_height = image.get_size()
    ratio = target_height / original_height
    new_width = int(original_width * ratio)
    new_height = target_height

    image_resized = pygame.transform.smoothscale(image, (new_width, new_height))
    
    # Création d'une surface vide (fond transparent)
    surface = pygame.Surface((target_width, target_height), pygame.SRCALPHA)
    offset_x = (target_width - new_width) // 2
    surface.blit(image_resized, (offset_x, 0))
    
    return surface

class RacingEnv(gym.Env):
    """
    @brief Environnement Gym pour entraîner et tester des IA de course.

    @param map_name str: Nom de la carte (ex: "Map 1").
    @param show_vision bool: Active/désactive l'affichage des capteurs.
    @param with_images bool: True pour charger les images graphiques.
    @param screen pygame.Surface: Surface Pygame à utiliser pour le rendu (optionnel).

    @attributes:
        - screen (pygame.Surface): Surface Pygame pour l'affichage.
        - map_name (str): Nom de la carte utilisée.
        - show_vision (bool): Si True, affiche les capteurs en mode render().
        - track (Track): Instance de la classe Track.
        - vehicle (Vehicule): Instance de la classe Vehicule.
        - action_space (gym.spaces.Discrete): Espace des actions (3 actions).
        - observation_space (gym.spaces.Box): Observation (7 rayons capteurs).
        - done (bool): Indique si l'épisode est terminé.

    @example
        env = RacingEnv(map_name="Map 1")
    """
    
    def __init__(self, map_name="Map 1", show_vision=False, with_images=False, screen=None):
        super(RacingEnv, self).__init__()

        self.screen = screen
        self.map_name = map_name
        self.show_vision = show_vision
        # with_images=False => pas de chargement d'images, pas d'erreur headless
        self.track = Track(map_name, with_images=with_images)
        self.vehicle = Vehicule(10, 0.3, self.track.get_track()[0], vision_active=True)

        # Actions: 0=accélérer, 1=gauche, 2=droite
        self.action_space = spaces.Discrete(3)
        # Observation: 7 distances de vision
        self.observation_space = spaces.Box(low=0, high=120, shape=(7,), dtype=np.float32)

        self.done = False

    def reset(self):
        """
        @brief Réinitialise l'environnement pour un nouvel épisode.

        @return np.ndarray: Observation initiale (7 distances des capteurs).

        @details
        - Réinitialise la voiture à la position de départ.
        - Remet done à False.
        """
        self.vehicle = Vehicule(10, 0.3, self.track.get_track()[0], vision_active=True)
        self.done = False
        return np.array(self.vehicle.get_vision(self.track), dtype=np.float32)

    def step(self, action):
        """
        @brief Applique une action et retourne le résultat.

        @param action int: Action choisie (0=accélérer, 1=gauche, 2=droite).

        @return tuple: (observation, reward, done, info)
            - observation (np.ndarray): Nouvelle observation des capteurs.
            - reward (float): Récompense.
            - done (bool): True si l'épisode est terminé.
            - info (dict): Infos supplémentaires (vide).

        @details
        - Donne une grosse récompense en cas d'arrivée (1000).
        - Pénalise (-50) si le véhicule sort de la piste.
        - Récompense continue basée sur la vitesse sinon.
        """
        if action == 0:
            self.vehicle.accelerate()
        elif action == 1:
            self.vehicle.setChamp('left')
        elif action == 2:
            self.vehicle.setChamp('right')

        self.vehicle.setMoveAway()
        pos = self.vehicle.getPosition()

        # Arrivée ?
        if np.linalg.norm(np.array(pos) - np.array(self.track.finish_pos)) < 40:
            self.done = True
            reward = 1000
        elif not self.track.is_on_road(pos[0], pos[1]):
            reward = -50
        else:
            reward = self.vehicle.speed

        obs = self.vehicle.get_vision(self.track)
        return np.array(obs, dtype=np.float32), reward, self.done, {}

    def render(self, mode="human"):
        """
        @brief Affiche visuellement l'environnement avec Pygame.

        @param mode str: Mode de rendu (inutile ici, par défaut "human").

        @note Nécessite que self.screen soit initialisé. Sinon renvoie un message.

        @details
        - Dessine la piste, la voiture et les rayons (si activés).
        """
        if self.screen is None:
            return("screen is None L-62, class racing_env")

        self.screen.fill((30, 30, 30))

        # Dessin de la piste
        self.track.draw_track(self.screen)

        # Dessin de la voiture
        car_img = pygame.image.load("assets/voiture.png").convert_alpha()
        car_img = resize_and_center_image(car_img, 50, 80)
        angle = -np.degrees(self.vehicle.getOrientation()) + 270
        rotated_car = pygame.transform.rotate(car_img, angle)
        rect_car = rotated_car.get_rect(center=self.vehicle.getPosition())
        self.screen.blit(rotated_car, rect_car)

        # Rayons
        if self.show_vision:
            self.vehicle.draw_vision(self.screen, self.track)

        pygame.display.flip()
