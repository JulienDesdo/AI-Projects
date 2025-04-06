import gym
import numpy as np
import pygame
from gym import spaces
from track import Track
from vehicule_class import Vehicule

# Fonction pour redimensionner sans déformer
def resize_and_center_image(image, target_width, target_height):
    """Redimensionne l'image en gardant le ratio hauteur, puis centre dans un cadre de taille cible."""
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
    """Environnement Gym pour l'entraînement IA ou le test."""
    
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
        self.vehicle = Vehicule(10, 0.3, self.track.get_track()[0], vision_active=True)
        self.done = False
        return np.array(self.vehicle.get_vision(self.track), dtype=np.float32)

    def step(self, action):
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
        Affiche l'état (facultatif).
        => Appelé si tu veux un replay "live".
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
