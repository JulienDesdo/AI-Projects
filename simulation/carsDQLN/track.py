import math
import pygame

class Track:
    def __init__(self, map_name, with_images=True):
        """
        :param with_images: True si on charge terminus_line.png
        """
        self.road_width = 120
        self.with_images = with_images

        if map_name == "Map 1":
            self.track = [(100, 300), (300, 300), (500, 500), (700, 500), (900, 300), (1100, 300)]
        elif map_name == "Map 2":
            self.track = [(100, 600), (300, 400), (500, 300), (700, 400), (900, 500), (1100, 600)]
        elif map_name == "Map 3":
            self.track = [(200, 200), (400, 300), (600, 400), (800, 500), (1000, 400), (1200, 300)]
        else:
            print(f"⚠️ Carte inconnue : {map_name}. Utilisation de Map 1 par défaut.")
            self.track = [(100, 300), (300, 300), (500, 500), (700, 500), (900, 300), (1100, 300)]

        self.finish_pos = self.track[-1]

        if self.with_images:
            self.terminus_img = pygame.image.load("assets/terminus_line.png").convert_alpha()
            self.terminus_img = pygame.transform.scale(self.terminus_img, (80, 80))
        else:
            self.terminus_img = None

    def get_track(self):
        return self.track

    def draw_track(self, screen):
        """Dessine la route + drapeau."""
        if len(self.track) > 1:
            color = (120, 120, 120)
            pygame.draw.lines(screen, color, False, self.track, width=self.road_width)

        if self.terminus_img:
            rect = self.terminus_img.get_rect(center=self.finish_pos)
            screen.blit(self.terminus_img, rect)

    def is_on_road(self, x, y):
        half_width = self.road_width / 2.0
        min_dist = float('inf')
        for i in range(len(self.track) - 1):
            p1 = self.track[i]
            p2 = self.track[i+1]
            dist = self.point_to_segment_distance(x, y, p1[0], p1[1], p2[0], p2[1])
            if dist < min_dist:
                min_dist = dist

        return (min_dist <= half_width)

    def point_to_segment_distance(self, px, py, x1, y1, x2, y2):
        vx = x2 - x1
        vy = y2 - y1
        wx = px - x1
        wy = py - y1

        seg_len_sq = vx*vx + vy*vy
        if seg_len_sq == 0:
            return math.hypot(px - x1, py - y1)

        t = (wx*vx + wy*vy) / seg_len_sq
        t = max(0, min(1, t))
        proj_x = x1 + t * vx
        proj_y = y1 + t * vy
        return math.hypot(px - proj_x, py - proj_y)
