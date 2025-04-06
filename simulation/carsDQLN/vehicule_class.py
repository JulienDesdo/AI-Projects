import numpy as np
import pygame

class Vehicule:
    """Gestion du véhicule : physique + capteurs."""

    def __init__(self, vit_max, acc, position, vision_active=True):
        self.speed = 0
        self.max_speed = vit_max
        self.acceleration = acc
        self.deceleration = 0.1
        self.friction = 0.05
        self.position = [position[0], position[1]]
        self.orientation = 0  # 0 rad = vers la DROITE
        self.maniability = np.pi / 20
        self.vision_active = vision_active
        self.num_rays = 7
        self.ray_length = 120
        self.ray_angles = np.linspace(-np.pi / 4, np.pi / 4, self.num_rays)

    def accelerate(self):
        if self.speed < self.max_speed:
            self.speed += self.acceleration

    def decelerate(self):
        if self.speed > 0:
            self.speed -= self.deceleration
        if self.speed < 0:
            self.speed = 0

    def setMoveAway(self):
        """Avance selon la speed + orientation."""
        self.position[0] += self.speed * np.cos(self.orientation)
        self.position[1] += self.speed * np.sin(self.orientation)

    def setChamp(self, direction):
        if direction == 'right':
            self.orientation += self.maniability
        elif direction == 'left':
            self.orientation -= self.maniability

    def getPosition(self):
        return self.position

    def getOrientation(self):
        return self.orientation

    def get_vision(self, track):
        """Retourne les distances détectées par les rayons."""
        if not self.vision_active:
            return []

        distances = []
        for angle_offset in self.ray_angles:
            angle = self.orientation + angle_offset
            for dist in range(self.ray_length):
                x = int(self.position[0] + np.cos(angle) * dist)
                y = int(self.position[1] + np.sin(angle) * dist)
                if not track.is_on_road(x, y):
                    distances.append(dist)
                    break
            else:
                distances.append(self.ray_length)
        return distances

    def draw_vision(self, screen, track):
        """Dessine les rayons en rouge."""
        if not self.vision_active:
            return
        for i, angle_offset in enumerate(self.ray_angles):
            angle = self.orientation + angle_offset
            distance = self.get_vision(track)[i]
            end_x = int(self.position[0] + np.cos(angle) * distance)
            end_y = int(self.position[1] + np.sin(angle) * distance)
            pygame.draw.line(screen, (255, 0, 0), self.position, (end_x, end_y), 2)
