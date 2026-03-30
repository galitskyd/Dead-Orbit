# Dead-Orbit

A Pico-8 game project.

## Platform

- **Engine:** Pico-8
- **Language:** Lua (Pico-8 dialect)
- **Cartridge format:** `.p8` or `.p8.png`

## Pico-8 Constraints

- Screen: 128x128 pixels, 16 colors
- Tokens: 8192 max
- Sprites: 256 (8x8 each), 2 sprite sheets (128x128 px each)
- Map: 128x64 tiles (lower half shared with sprite sheet 2)
- Sound: 64 SFX, 64 music patterns
- Memory limits apply — keep code tight

## Code Conventions

- Use Pico-8 Lua idioms (short variable names are fine given token limits)
- Prefer `add()`/`del()` for table manipulation
- Game loop: `_init()`, `_update()` (or `_update60()`), `_draw()`

## Reference files

- In the /documentation folder there are three files.
- overview.md - This has all the details from for the game.
- progress.md - This is where you will be making updates showcasing your progress throughout the project. This will help other agents know where to start and where to end. This should be updated after each task.
- breakdown.md - This is mostly for me but you are welcome to look. Each section will be a new agent to go through the process. 
