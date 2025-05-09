"""
@file menu.py
@brief Module gérant le menu principal (interface utilisateur Pygame).

@details
Permet à l'utilisateur de :
- Choisir la carte de course.
- Sélectionner le mode de jeu (Joueur, TEST, ENTRAÎNEMENT).
- Activer ou désactiver l'affichage des capteurs de vision.

@classes:
    - Menu: Interface utilisateur pour la configuration avant le lancement du jeu.
"""


import pygame
import os

class Menu:
    """
    @brief Classe représentant le menu principal (écran de configuration).

    @attributes:
        screen (pygame.Surface): Surface d'affichage.
        font (pygame.Font): Police utilisée pour le texte.
        options (list[str]): Liste des cartes disponibles.
        modes (list[str]): Liste des modes disponibles.
        show_vision (bool): True si les capteurs doivent être affichés.
        selected_map (int): Index actuel de la carte sélectionnée.
        selected_mode (int): Index actuel du mode sélectionné.
        error_message (str|None): Message d'erreur affiché si besoin.

    @note
    - Les cartes par défaut sont : "Map 1", "Map 2", "Map 3", "Quitter".
    - Les modes sont : "Joueur", "TEST", "ENTRAÎNEMENT".
    """
    def __init__(self, screen):
        self.screen = screen
        self.font = pygame.font.Font(None, 48)
        self.options = ["Map 1", "Map 2", "Map 3", "Quitter"]
        self.modes = ["Joueur", "TEST", "ENTRAÎNEMENT"]
        self.show_vision = True
        self.selected_map = 0
        self.selected_mode = 0
        self.error_message = None

    def draw(self):
        """
        @brief Dessine le menu (cartes, modes, options, messages) sur la surface d'affichage.

        @details
        - Les éléments actifs sont affichés en jaune, les autres en blanc.
        - Affiche également un message d'erreur si nécessaire (en rouge).
        - Met à jour l'écran avec pygame.display.flip().
        """
        self.screen.fill((20, 20, 20))

        map_title = self.font.render("Sélectionner une carte", True, (200, 200, 200))
        self.screen.blit(map_title, (100, 50))

        mode_title = self.font.render("Mode de jeu", True, (200, 200, 200))
        self.screen.blit(mode_title, (800, 50))

        # Colonne gauche (cartes)
        for i, option in enumerate(self.options):
            color = (255, 255, 0) if i == self.selected_map else (255, 255, 255)
            text = self.font.render(option, True, color)
            self.screen.blit(text, (100, 150 + i * 60))

        # Colonne droite (modes)
        for i, mode in enumerate(self.modes):
            color = (255, 255, 0) if i == self.selected_mode else (255, 255, 255)
            text = self.font.render(mode, True, color)
            self.screen.blit(text, (800, 150 + i * 60))

        # Option "Champ de vision"
        vision_txt = self.font.render(f"Champ de vision : {'Oui' if self.show_vision else 'Non'}", True, (200, 200, 200))
        self.screen.blit(vision_txt, (100, 550))

        # Message d'erreur
        if self.error_message:
            error_text = self.font.render(self.error_message, True, (255, 0, 0))
            self.screen.blit(error_text, (400, 650))

        pygame.display.flip()

    def run(self):
        """
        @brief Boucle principale du menu, attend la sélection de l'utilisateur.

        @return tuple:
            - selected_map (str): La carte choisie par l'utilisateur (ex: "Map 1").
            - selected_mode (str): Le mode choisi (ex: "TEST").
            - show_vision (bool): True si les capteurs de vision doivent être affichés.

        @note
        - Retourne (None, None, None) si l'utilisateur quitte sans sélection.
        - Affiche un message d'erreur si le mode TEST est choisi sans modèle disponible.
        - Contrôles clavier :
            - UP/DOWN: navigue entre les cartes.
            - LEFT/RIGHT: change le mode de jeu.
            - V: toggle capteurs de vision.
            - RETURN: valide la sélection.
        """
        running = True
        while running:
            self.draw()
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return None, None, None
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_UP:
                        self.selected_map = (self.selected_map - 1) % len(self.options)
                    elif event.key == pygame.K_DOWN:
                        self.selected_map = (self.selected_map + 1) % len(self.options)
                    elif event.key == pygame.K_LEFT:
                        self.selected_mode = (self.selected_mode - 1) % len(self.modes)
                    elif event.key == pygame.K_RIGHT:
                        self.selected_mode = (self.selected_mode + 1) % len(self.modes)
                    elif event.key == pygame.K_v:
                        self.show_vision = not self.show_vision
                    elif event.key == pygame.K_RETURN:
                        if self.options[self.selected_map] == "Quitter":
                            return None, None, None
                        # Vérifier si TEST sans modèle
                        if self.modes[self.selected_mode] == "TEST" and not os.path.exists("racing_agent.zip"):
                            self.error_message = "❌ Modèle IA introuvable ! Lancez d'abord l'entraînement."
                        else:
                            return self.options[self.selected_map], self.modes[self.selected_mode], self.show_vision

        return None, None, None
