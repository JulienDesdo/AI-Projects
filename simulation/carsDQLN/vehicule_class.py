"""
@file vehicule_class.py
@brief Module définissant la classe Vehicule pour le simulateur de course.

@details
Cette classe gère :
- La physique du véhicule (accélération, rotation, friction).
- Le déplacement du véhicule sur la piste.
- Les capteurs de vision (rayons) permettant de détecter la piste autour.

@classes:
    - Vehicule: Représente le véhicule (mouvements, capteurs, affichage).
"""

import numpy as np
import pygame

class Vehicule:
    """
    @brief Classe représentant le véhicule : physique + capteurs (vision).

    @attributes:
        speed (float): Vitesse actuelle du véhicule.
        max_speed (float): Vitesse maximale autorisée.
        acceleration (float): Facteur d'accélération appliqué.
        deceleration (float): Facteur de décélération appliqué.
        friction (float): Coefficient de friction simulant les pertes naturelles.
        position (list[float]): Position [x, y] actuelle du véhicule.
        orientation (float): Angle d'orientation (en radians, 0 = droite).
        maniability (float): Capacité de rotation (radians par action).
        vision_active (bool): True si la vision (capteurs) est activée.
        num_rays (int): Nombre total de capteurs (rayons).
        ray_length (int): Longueur maximale des rayons (pixels).
        ray_angles (np.ndarray): Tableau des angles (offsets) des rayons.
    """

    def __init__(self, vit_max, acc, position, vision_active=True):
        """
        @brief Initialise le véhicule avec ses paramètres physiques.

        @param vit_max (float): Vitesse maximale autorisée.
        @param acc (float): Facteur d'accélération.
        @param position (tuple): Position initiale (x, y).
        @param vision_active (bool, optional): True pour activer la vision (default: True).

        @note Initialise aussi :
            - orientation à 0 (vers la droite),
            - les rayons (7 par défaut) avec une longueur maximale de 120 pixels.
        """
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
        """
        @brief Augmente la vitesse du véhicule jusqu'à la vitesse maximale.

        @details
        Si la vitesse est déjà maximale, ne fait rien.
        """
        if self.speed < self.max_speed:
            self.speed += self.acceleration

    def decelerate(self):
        """
        @brief Réduit la vitesse du véhicule (sans passer sous zéro).

        @details
        Applique une décélération et assure que la vitesse reste positive.
        """
        if self.speed > 0:
            self.speed -= self.deceleration
        if self.speed < 0:
            self.speed = 0

    def setMoveAway(self):
        """
        @brief Avance le véhicule selon sa vitesse et orientation actuelles.

        @note
        Met à jour la position [x, y] directement.
        """
        self.position[0] += self.speed * np.cos(self.orientation)
        self.position[1] += self.speed * np.sin(self.orientation)

    def setChamp(self, direction):
        """
        @brief Modifie l'orientation du véhicule (rotation).

        @param direction (str): 'right' ou 'left' pour tourner dans la direction choisie.
        """
        if direction == 'right':
            self.orientation += self.maniability
        elif direction == 'left':
            self.orientation -= self.maniability

    def getPosition(self):
        """
        @brief Retourne la position actuelle du véhicule.

        @return list: Position [x, y].
        """
        return self.position

    def getOrientation(self):
        """
        @brief Retourne l'orientation actuelle du véhicule.

        @return float: Orientation en radians.
        """
        return self.orientation

    def get_vision(self, track):
        """
        @brief Calcule les distances des capteurs (rayons) par rapport aux bords de la piste.

        @param track (Track): Objet piste pour tester si un point est sur la route.

        @return list[int]: Distances (en pixels) pour chaque rayon.
        """
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
        """
        @brief Dessine les capteurs (rayons) sur la surface Pygame.

        @param screen (pygame.Surface): Surface d'affichage.
        @param track (Track): Objet piste pour savoir où tracer les rayons.

        @note
        Les rayons sont affichés en rouge.
        """

        if not self.vision_active:
            return
        for i, angle_offset in enumerate(self.ray_angles):
            angle = self.orientation + angle_offset
            distance = self.get_vision(track)[i]
            end_x = int(self.position[0] + np.cos(angle) * distance)
            end_y = int(self.position[1] + np.sin(angle) * distance)
            pygame.draw.line(screen, (255, 0, 0), self.position, (end_x, end_y), 2)
