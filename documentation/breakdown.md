# DEAD ORBIT — Session Breakdown

---

## How to Use This Document

Each session below is a self-contained Claude Code prompt scope. Before starting a session:
1. Paste `overview.md` for full game context
2. Paste the current `dead_orbit.p8` file
3. Paste the session brief below
4. Verify the session output against the checklist before moving on

---

## Session 1 — Foundation & Project Structure

**Assets:** Player sprites only (idle, run, jump, crouch)

**Prompt scope:**
- Create `dead_orbit.p8` with full code section headers as comments
- Implement state machine: `title`, `game`, `pause`, `gameover`
- Implement `stat(28)` raw keyboard input for A/D/W/S/F/Space
- Implement player movement: run left/right, jump, crouch, basic gravity and collision
- Draw a blank room using `rectfill()` for floor and walls
- Generate minimal placeholder sprites in `__gfx__` for: player idle, run (2 frames), jump, crouch

**Verify before continuing:**
- Player moves, jumps, and crouches correctly
- No physics bugs (no clipping through floor, no infinite jumps)
- `stat(28)` reads all required keys
- Player sprite is visible and animates between states

---

## Session 2 — Core Combat Loop

**Assets:** Bullet sprite only

**Prompt scope:**
- Render a dotted line from player origin to crosshair showing shot trajectory
- ↑/↓ arrows adjust aim angle; dotted line updates in real time
- F key fires one bullet per tap (semi-auto); bullet travels and despawns on wall hit
- Space triggers ground-only horizontal slide:
  - Aim angle locks at slide start
  - Dotted line shows locked angle during slide
  - I-frames active for ~1s
  - Player can tap F to fire during slide
  - 1.5s cooldown after slide; small HUD indicator bottom-right
- Generate placeholder bullet sprite in `__gfx__`

**Verify before continuing:**
- Dotted line tracks aim angle accurately
- Bullets travel in the correct direction
- Slide I-frames pass through a test projectile (add a static test bullet to verify)
- Firing during slide works and follows locked angle
- Cooldown indicator fills correctly

---

## Session 3 — Deadeye

**Assets:** None

**Prompt scope:**
- Hold X to enter Deadeye: game time slows to ~10% speed
- Deadeye meter (0–100) drains while X is held, refills passively at normal rate
- Dotted line remains active and responsive to ↑/↓ during Deadeye
- Player can still tap F to fire during Deadeye
- Add Deadeye meter to HUD (top-center); pulses when full

**Verify before continuing:**
- Time visibly slows on X hold
- Meter drains and refills correctly
- Cannot hold Deadeye indefinitely (meter empties)
- Shooting during Deadeye fires at slow-mo speed, bullet travels at normal speed on release

---

## Session 4 — Room System

**Assets:** Placeholder tile sprites (floor, wall, door open, door closed)

**Prompt scope:**
- Replace `rectfill()` room with PICO-8 tilemap rendering
- Implement platform collision with tilemap
- Build 2–3 hand-crafted room templates in the map editor
- Door logic: doors lock on room enter, unlock when all enemies cleared
- Room shuffle: each run selects from the room pool in random order
- Mark wall and ceiling anchor points in tileset for Lurker placement (reserved tile flags)
- Generate placeholder tile sprites in `__gfx__`

**Verify before continuing:**
- Player navigates all 3 rooms without collision bugs
- Doors lock and unlock correctly
- Room order is different between two test runs

---

## Session 5 — Enemies

**Assets:** Placeholder sprite for each enemy (Grunt, Lurker, Crawler, Turret)

**Prompt scope:**
- Drifter Grunt: walks toward player, fires straight projectile every 2s, 3 HP, drops ammo on death
- The Lurker: spawns at wall/ceiling anchor points, charges sac (visual telegraph), spits slow arcing plasma glob, 2 HP, drops nothing
- Void Crawler: fast rush toward player, spawns in pairs, 2 HP, erratic platform movement
- Station Turret: stationary, LOS raycast, fires rapid burst, 5 HP, destructible
- All enemies: verify slide I-frames cause projectiles and contact damage to pass through
- Generate one placeholder sprite per enemy type in `__gfx__`

**Verify before continuing:**
- Each enemy behaves correctly in isolation
- Slide I-frames confirmed working against each enemy's attack type
- Grunt straight shot vs Lurker arc shot are visually distinct

---

## Session 6 — Items & Inventory

**Assets:** Placeholder sprites for each item and relic

**Prompt scope:**
- Item pickup: player walks over item to collect, auto-fills next open slot
- 3 item slots max; slots shown in HUD top-right
- Consumables: Stim Pack (+1 HP), Deadeye Flask (refill meter), Gravity Shard (slow all enemies 3s)
- Passive relics (one slot): Spur Charm (Deadeye +25% recharge), Dead Man's Badge (+1 max HP), Void Lens (Deadeye shots 2x damage)
- Inventory screen on Enter: shows slots, weapon, flavor text; resume or quit to title
- Generate placeholder sprites for all items and relics in `__gfx__`

**Verify before continuing:**
- All three consumables produce correct effects
- All three relics apply passive bonuses correctly
- Inventory screen opens, displays correctly, and resumes cleanly

---

## Session 7 — HUD

**Assets:** Heart sprite, meter sprite, icon sprites

**Prompt scope:**
- HP hearts top-left (5 max, empties as damage taken)
- Deadeye meter top-center (pulses animation when full)
- Gun icon + ammo count top-right
- Item slots top-right (below ammo)
- Slide cooldown indicator bottom-right (circle fills over 1.5s)
- Confirm dotted line does not visually conflict with any HUD element
- Generate HUD sprites in `__gfx__`

**Verify before continuing:**
- All HUD elements visible and accurate during active gameplay
- Taking damage updates hearts immediately
- Firing updates ammo count correctly
- No visual overlap between HUD and dotted line

---

## Session 8 — Boss

**Assets:** Warden placeholder sprites (2x2 tile, 3 phase variants)

**Prompt scope:**
- Warden spawns in boss room (floor 3)
- Phase 1: patrols platform, fires homing orbs in slow arc
- Phase 2 trigger at 50% HP: summons 2 Drifter Grunts, movement speed increases
- Phase 3 trigger at 25% HP: screen desaturates, Warden freezes briefly, fires precision high-damage burst — player must slide through using I-frames
- Slide I-frames work against all three attack types
- Unique relic drops on Warden death
- Win condition: game state transitions to a win screen
- Generate Warden placeholder sprites in `__gfx__`

**Verify before continuing:**
- All three phase transitions trigger correctly
- Slide I-frames pass through Phase 3 precision burst
- Win screen displays after Warden death

---

## Session 9 — Token Audit

**Assets:** None

**Prompt scope:**
- Review full codebase for token count against PICO-8's 32,768 token limit
- Identify and remove dead code, unused variables, redundant logic
- Refactor verbose sections to reduce token usage without changing behavior
- Report final token count and confirm the game is under the limit
- Flag any systems at risk of token overrun as the art pass adds `__gfx__` data

**Verify before continuing:**
- Token count confirmed under 32,768
- Game still runs correctly after any refactoring
- No behavior changes introduced

---

## Session 10 — Art Pass

**Note: This session is done by you in PICO-8's sprite editor, not by Claude Code.**

Work through each sprite index and paint over placeholders:
- Player: idle, run (2 frames), jump, crouch, slide, shoot
- Enemies: Grunt, Lurker (wall + ceiling variants), Crawler, Turret
- Boss: Warden (Phase 1, 2, 3 variants)
- Projectiles: player bullet, Grunt shot, Lurker plasma glob, Warden orb
- Items: all consumables, all relics, all weapons
- Tileset: floor, wall, cover, doors (open/closed), anchor points, background details
- UI: hearts (full/empty), Deadeye meter fill, slide indicator, gun icons

**Verify before continuing:**
- Full run is visually readable
- No placeholder rectangles remaining
- Sprite indices match what the code references

---

## Session 11 — Audio

**Note: Tuning is done by you in PICO-8's sound editor. Claude Code generates stubs.**

**Prompt scope:**
- Generate SFX stubs in `__sfx__` for: gunshot, slide whoosh, Deadeye activate, enemy hit, player hurt, Lurker charge hum, item pickup, boss phase change chord
- Generate 2 music pattern loops in `__music__`: room ambient, boss fight

**Verify before continuing:**
- Every SFX trigger produces a sound (even if rough)
- Both music tracks loop without cutting out
- Tune all SFX and music by ear in PICO-8's sound editor before final session

---

## Session 12 — Polish & Completion

**Assets:** Title screen sprite, game over sprite

**Prompt scope:**
- Title screen: game name, start prompt, basic decoration
- Game over screen: death message, restart prompt
- Full run playtest: start from title, complete both floors, defeat Warden, reach win screen
- Fix any remaining bugs or logic errors found during playtest
- Final token count check

**Verify before continuing:**
- Full run completes without errors or crashes
- Title → game → win/lose → title loop works cleanly
- Token count still under 32,768 after art and audio data added
