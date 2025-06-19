#!/usr/bin/env python3
import os
import sys
import pygame
import time
import subprocess

pygame.init()

DEFAULT_WIDTH, DEFAULT_HEIGHT = 640, 320
BG_COLOR = (10, 20, 10)
BTN_COLOR = (0, 80, 0)
BTN_HOVER = (0, 130, 0)
TEXT_COLOR = (0, 255, 255)
BAR_COLOR = (160, 160, 160)

FONT = pygame.font.SysFont("monospace", 28, bold=True)
TITLE_FONT = pygame.font.SysFont("monospace", 36, bold=True)

screen = pygame.display.set_mode((DEFAULT_WIDTH, DEFAULT_HEIGHT), pygame.RESIZABLE)
pygame.display.set_caption("Chipocalypse")

# -------------------
# CRT Style Utilities
# -------------------

def draw_border(surface):
    pygame.draw.rect(surface, (0, 80, 0), surface.get_rect(), 8)

def draw_overlay_glow(surface):
    width, height = surface.get_size()
    overlay = pygame.Surface((width, height), pygame.SRCALPHA)
    overlay.fill((0, 255, 0, 10))
    surface.blit(overlay, (0, 0))

# -------------------
# Splash Screen
# -------------------

def splash_screen():
    start_time = time.time()
    duration = 5  # seconds
    clock = pygame.time.Clock()

    while True:
        elapsed = time.time() - start_time
        progress = min(elapsed / duration, 1.0)

        width, height = screen.get_size()

        screen.fill(BG_COLOR)

        loading_text = TITLE_FONT.render("LOADING CHIPOCALYPSE", True, TEXT_COLOR)
        text_rect = loading_text.get_rect(center=(width // 2, height // 2 - 30))
        screen.blit(loading_text, text_rect)

        bar_w, bar_h = width // 2, 25
        bar_x = (width - bar_w) // 2
        bar_y = height // 2 + 10

        pygame.draw.rect(screen, (0, 80, 0), (bar_x, bar_y, bar_w, bar_h), 3)
        pygame.draw.rect(screen, BAR_COLOR, (bar_x + 2, bar_y + 2, int((bar_w - 4) * progress), bar_h - 4))

        draw_border(screen)
        draw_overlay_glow(screen)
        pygame.display.flip()
        clock.tick(60)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == pygame.VIDEORESIZE:
                pygame.display.set_mode((event.w, event.h), pygame.RESIZABLE)

        if progress >= 1.0:
            break

# -------------------
# Game Selector
# -------------------

class Button:
    def __init__(self, text):
        self.text = text
        self.rect = pygame.Rect(0, 0, 160, 50)

    def update_position(self, center_x, y):
        self.rect.center = (center_x, y)

    def draw(self, surface):
        mouse_pos = pygame.mouse.get_pos()
        color = BTN_HOVER if self.rect.collidepoint(mouse_pos) else BTN_COLOR
        pygame.draw.rect(surface, color, self.rect, border_radius=8)
        label = FONT.render(self.text, True, TEXT_COLOR)
        label_rect = label.get_rect(center=self.rect.center)
        surface.blit(label, label_rect)

    def is_click(self, event):
        return event.type == pygame.MOUSEBUTTONDOWN and self.rect.collidepoint(event.pos)
    
def parse_display_dump(filename):
    frames = []
    with open(filename, "r") as f:
        lines = f.readlines()

    current_frame = []
    for line in lines:
        line = line.strip()
        if line.startswith("Frame") or line.startswith("PC:") or not line or any(c not in "01" for c in line):
            if current_frame:
                frames.append(current_frame)
                current_frame = []
            continue

        current_frame.append([int(c) for c in line])

    if current_frame:
        frames.append(current_frame)

    return frames

def play_game_in_gui(frames):
    SCALE = 10
    DISPLAY_WIDTH = 64
    DISPLAY_HEIGHT = 32
    clock = pygame.time.Clock()
    FRAME_DELAY = 100  # ms

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                return

        screen.fill((0, 0, 0))  # clear

        for y in range(DISPLAY_HEIGHT):
            for x in range(DISPLAY_WIDTH):
                color = (0, 255, 0) if frames[0][y][x] else (0, 0, 0)
                rect = pygame.Rect(x * SCALE, y * SCALE, SCALE, SCALE)
                pygame.draw.rect(screen, color, rect)

        pygame.display.flip()
        pygame.time.delay(FRAME_DELAY)

        if len(frames) > 1:
            frames.append(frames.pop(0)) 

    
def run_chip8_sim(game_name):
    rom_paths = {
        "Pong": "/home/prawns/Chipocalypse/roms/pong.mem",
        "Tetris": "/home/prawns/Chipocalypse/roms/tetris.mem",
        "TicTac": "/home/prawns/Chipocalypse/roms/tictac.mem"
    }

    rom = rom_paths.get(game_name)
    if rom:
        script_path = "/home/prawns/Chipocalypse/scripts/launch_sim.sh"
        subprocess.run([script_path, rom])

        dump_file = "/home/prawns/CHIP8_Real/CHIP8_Real.sim/sim_1/behav/xsim/display_dump.txt" # ask mentees to change this path 
        if os.path.exists(dump_file):
            frames = parse_display_dump(dump_file)
            play_game_in_gui(frames)
        else:
            print("[ERROR] No display_dump.txt found.")
    else:
        print("[ERROR] Invalid game selected.")

buttons = [Button("Pong"), Button("Tetris"), Button("TicTac")]

def main_menu():
    running = True
    clock = pygame.time.Clock()

    button_width = 160
    button_height = 50
    gap = 20

    while running:
        width, height = screen.get_size()
        center_y = height // 2

        title = TITLE_FONT.render("CHOOSE YOUR GAME", True, TEXT_COLOR)
        title_rect = title.get_rect(center=(width // 2, 50))

        total_width = len(buttons) * button_width + (len(buttons) - 1) * gap
        start_x = (width - total_width) // 2

        for i, btn in enumerate(buttons):
            x = start_x + i * (button_width + gap)
            y = center_y
            btn.rect = pygame.Rect(x, y, button_width, button_height)

        screen.fill(BG_COLOR)
        screen.blit(title, title_rect)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.VIDEORESIZE:
                pygame.display.set_mode((event.w, event.h), pygame.RESIZABLE)
            for btn in buttons:
                if btn.is_click(event):
                    run_chip8_sim(btn.text)

        for btn in buttons:
            btn.draw(screen)

        draw_border(screen)
        draw_overlay_glow(screen)
        pygame.display.flip()
        clock.tick(60)

    pygame.quit()
    sys.exit()

def main():
    splash_screen()
    main_menu()

if __name__ == "__main__":
    main()