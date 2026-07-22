## Ghastly

![Banner](https://github.com/abhijato-c/Ghastly/blob/main/Images/4x3.png)
>  A 2D escape room puzzle game with a twist... 

---

## Description
Ghastly is a game where you play as a character which spawns as different colored blobs with different abilities. Each player has a lifespan of 15 seconds, and when you die, you respawn as the next color player. However, all you past runs spawn as ghosts, completing their previous movements and interactions. You have to use this mechanism to move around in levels, find the portal and move to the next level.

---

## Setup and Playing
Playable on the web and download files on [Ghastly on Itch](m-8000.itch.io/ghastly). Double click the executables after unzipping to play locally.

---

## Player Colors
1. **Red:** A heavy player. It cannot jump high because of its weight, and cannot reach most blocks which needed to be reached with a jump. However, its weight also makes it able to activate and interact with certain interactables which are unaffected by other players.

2. **Yellow:** Just the opposite of red - a light player. Can jump very high, reaching relatively high places that other players cannot. Use Yellow to reach very high places (and deactivate them) to let other players progress.

3. **Green:** Kinda like a sticky slimeball. Has the ability to stick to and slide down walls slowly, including interactables. Used in places where you may not expect it, you can use it to hold items active for longer or maybe to buy yourself time.

4. **Blue:** A regular player. Has no quirks, moves jumps and walks at a normal speed.

---

## Controls

All controls are keyboard only, mouse cursor is disabled

| Key | Action |
| :--- | :--- |
| **WASD / Arrows** | Movement|
| **T** | Skip to next color |
| **R** | Reset Level |
| **E/F/G/H** | Interact |

---

## Mechanics

All interactions and movement of a player is stored in an array, and is passed to the ghost instance once the player dies. The ghost runs on a 30fps tick cycle, and updates itself in real time. Interactables have 2 functions, Activate and Deactivate, triggered by the player or other interactables. They are detected by the player by an area 2d, and when they come in range, the player assigns an interact key to it. Configs are stored in a file, loaded on game start, and accessible globally.

---

## Engine and development
Developed entirely in godot, minor image editing done in GIMP.

---

## AI Usage
AI was used for art generation mainly, and debugging.