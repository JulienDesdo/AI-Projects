"""
@file main.py
@brief Script principal pour lancer la simulation de course avec Pygame.

@details
Ce script permet :
- De lancer la simulation en mode joueur.
- De tester un modèle IA déjà entraîné.
- D'entraîner un nouvel agent IA via Stable-Baselines3.

@dependencies:
- pygame
- numpy
- menu (Menu)
- track (Track)
- vehicule_class (Vehicule)
- train_agent (train_model)
- test_agent (test_model)

@functions:
    - resize_and_center_image: Redimensionne et centre l'image du véhicule.
    - run_game: Exécute la boucle principale du jeu selon le mode choisi.
"""

import pygame
import numpy as np
import os
from menu import Menu
from track import Track
from vehicule_class import Vehicule
from train_agent import train_model
from test_agent import test_model

MODEL_PATH = "racing_agent.zip"

# Fonction pour redimensionner sans déformer
def resize_and_center_image(image, target_width, target_height):
    """
    @brief Redimensionne une image sans déformation et la centre dans un cadre donné.

    @param image pygame.Surface: Image source.
    @param target_width int: Largeur cible du cadre.
    @param target_height int: Hauteur cible du cadre.

    @return pygame.Surface: Image redimensionnée et centrée.

    @details
    - Le ratio hauteur est conservé.
    - L'image est centrée horizontalement dans la surface retournée.
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


def run_game(map_name, mode, show_vision):
    """
    @brief Lance la simulation, le test ou l'entraînement en fonction du mode choisi.

    @param map_name str: Nom de la carte sélectionnée (ex: "Map 1").
    @param mode str: Mode choisi parmi ["Joueur", "TEST", "ENTRAÎNEMENT"].
    @param show_vision bool: Active/désactive l'affichage des capteurs de vision.

    @return None

    @details
    - Si mode == "ENTRAÎNEMENT" : entraîne l'IA (ferme la fenêtre Pygame puis appelle train_model()).
    - Si mode == "TEST" : teste un modèle pré-entraîné (test_model()).
    - Sinon : lance la course en mode joueur.

    @note
    - Le modèle est sauvegardé sous le nom 'racing_agent.zip' par défaut.
    - Si aucun modèle n'existe pour le mode TEST, une erreur est affichée.
    """
    pygame.init()
    screen = pygame.display.set_mode((1280, 720))
    pygame.display.set_caption("Course avec IA et Pygame")
    clock = pygame.time.Clock()

    # -- Mode ENTRAÎNEMENT
    if mode == "ENTRAÎNEMENT":
        pygame.quit()  # On ferme la fenêtre du menu
        train_model(map_name)
        return

    # -- Mode TEST
    if mode == "TEST":
        if not os.path.exists(MODEL_PATH):
            print("❌ Erreur : Modèle 'racing_agent.zip' introuvable !")
            return
        # NE PAS quitter pygame ici, on veut charger des images
        test_model(map_name, show_vision)
        pygame.quit()
        return

    # -- Mode NORMAL (Joueur ou IA)
    # On veut afficher la piste => with_images=True
    track = Track(map_name, with_images=True)
    vehicle = Vehicule(vit_max=10, acc=0.3, position=track.get_track()[0], vision_active=show_vision)

    # Charger le sprite de la voiture
    car_image = pygame.image.load("assets/voiture.png").convert_alpha()
    car_image = pygame.transform.rotate(car_image, 180)  
    car_image = resize_and_center_image(car_image, 50, 80)

    font = pygame.font.Font(None, 48)
    start_time = pygame.time.get_ticks()

    running = True
    while running:
        elapsed_time = (pygame.time.get_ticks() - start_time) / 1000.0

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        # Contrôles du joueur
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT]:
            vehicle.setChamp('left')
        if keys[pygame.K_RIGHT]:
            vehicle.setChamp('right')
        if keys[pygame.K_UP]:
            vehicle.accelerate()
        else:
            vehicle.decelerate()

        # Déplacement
        vehicle.setMoveAway()
        position = vehicle.getPosition()

        # Hors piste => ralentit
        if not track.is_on_road(position[0], position[1]):
            vehicle.speed *= 0.5

        # Collision ligne d'arrivée => stop
        dist_finish = np.linalg.norm(np.array(position) - np.array(track.finish_pos))
        if dist_finish < 40:
            print("🚩 Course terminée !")
            running = False

        # -- Affichage
        screen.fill((30, 30, 30))
        track.draw_track(screen)

        # Rotation 
        offset_angle = 90
        angle_deg = -np.degrees(vehicle.getOrientation()) + offset_angle
        rotated_car = pygame.transform.rotate(car_image, angle_deg)
        rect_car = rotated_car.get_rect(center=(position[0], position[1]))
        screen.blit(rotated_car, rect_car)

        # Dessin des rayons IA si demandé
        if show_vision:
            vehicle.draw_vision(screen, track)

        # Chrono
        txt = font.render(f"Temps : {elapsed_time:.2f} s", True, (0, 255, 0))
        screen.blit(txt, (50, 50))

        pygame.display.flip()
        clock.tick(30)

    pygame.quit()

if __name__ == "__main__":
    """
    @brief Point d'entrée du script.

    @details
    - Initialise Pygame et le menu utilisateur (classe Menu).
    - Récupère la sélection utilisateur (carte, mode, vision).
    - Lance run_game() avec les paramètres choisis.
    - Affiche un message si aucune sélection n'est faite.
    """
    pygame.init()
    screen = pygame.display.set_mode((1280, 720))
    menu = Menu(screen)

    print("🎮 Affichage du menu Pygame...")
    selected_map, mode, show_vision = menu.run()

    if selected_map:
        print(f"✅ Menu sélectionné : {mode} sur {selected_map}")
        run_game(selected_map, mode, show_vision)
    else:
        print("🔴 Fermeture du programme (aucune sélection faite).")
