import pygame
import os

class Menu:
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
