# DEAD ORBIT — Progress

---

## Session 1 — Foundation & Project Structure
- [x] Project file created (`dead_orbit.p8`)
- [x] Code structure scaffolded with section headers
- [x] State machine implemented (title, game, pause, gameover)
- [x] `stat(28)` raw keyboard input implemented
- [x] Player movement: run, jump, crouch, physics
- [ ] Player placeholder sprites: idle, run, jump, crouch
- [x] Blank room renders with `rectfill()` floor and walls

## Session 2 — Core Combat Loop
- [x] Shooting: semi-auto X key, bullet spawns in front of player, travels straight, despawns on wall/off-screen
- [x] Bullet collision with walls
- [x] Shooting while jumping and crouching (straight horizontal)
- [x] Sprite note: bullet = sprite index 5 (`blt_spr`), currently drawn as 4x2 yellow rect placeholder. Slide uses crouch sprite (index 4) — draw a slide variant there or add a dedicated sprite later
- [x] Slide: Space triggers horizontal slide, ground only
- [x] Slide: I-frames (~1s), cooldown (1.5s)
- [x] Slide: player can fire mid-slide (shots go up at an angle)
- [x] Slide cooldown HUD indicator

## Session 3 — Deadeye
- [ ] Deadeye: X key hold slows time to ~10%
- [ ] Deadeye: meter drains while held, refills passively
- [ ] Deadeye: player can still move, shoot, and slide during slow-mo
- [ ] Deadeye meter HUD element

## Session 4 — Room System (Tilemap Rewrite)
- [x] String-based tilemap system (# = solid, - = platform, . = air)
- [x] Spawn markers in map data (S=player, G=grunt, C=crawler, L=lurker, T=turret)
- [x] Tile collision: collide_x, collide_y with solid + one-way platform support
- [x] get_tile, solid_at, find_ground, at_edge helper functions
- [x] Enemies and player use shared tile collision (replaces old boundary checks)
- [x] Bullets and projectiles use solid_at for wall hits
- [x] Slide wall-stop uses solid_at
- [x] Camera follows player with centered deadzone
- [x] Room1 defined: 48x16 tile room with platforms, enemies, player spawn
- [x] Removed: procedural generation, level depth, floor advancement, pits, ceiling holes
- [ ] Door lock / unlock logic (clears when enemies gone)
- [ ] Additional hand-crafted room templates
- [ ] Placeholder tiles replace `rectfill()` blocks

## Session 5 — Enemies
- [x] Drifter Grunt: movement, straight projectile, 3 HP, ammo drop
- [x] Grunt placeholder sprite
- [x] The Lurker: wall/ceiling clinging, arc spit, charge telegraph, 2 HP
- [x] Lurker placeholder sprite
- [x] Void Crawler: fast rush, pack spawning, 2 HP
- [x] Crawler placeholder sprite
- [x] Station Turret: LOS detection, burst fire, 5 HP, destructible
- [x] Turret placeholder sprite
- [x] All enemies: slide I-frame interaction verified

## Session 5.5 — Weapon System
- [x] Gun definitions table (revolver, auto gun) with per-gun stats
- [x] Auto gun: 30-round clip, 0.5s fire delay, hold-to-fire
- [x] Player starts with revolver, one weapon at a time
- [x] Equip system: p.gun_id + p.gun reference to gun_defs
- [x] Gun drops: grunts have 30% chance to drop auto gun on death
- [x] Pickup system: walk over dropped gun to pick it up
- [x] Dropping current gun when picking up new one (revolver not dropped)
- [x] Placeholder auto gun drawn at end of player model (rectfill)
- [x] Pickup bob animation on ground
- [x] HUD shows gun name + ammo count
- [x] Ammo drops scale per weapon (3 for revolver, 10 for auto)
- [x] Gun persists across floor transitions

## Session 6 — Items & Inventory
- [ ] Item pickup system
- [ ] 3 item slots implemented
- [ ] Consumables: Stim Pack, Deadeye Flask, Gravity Shard
- [ ] Passive relics: Spur Charm, Dead Man's Badge, Void Lens
- [ ] Relic effects applied correctly
- [ ] Inventory screen opens on Enter
- [ ] Item placeholder sprites

## Session 7 — HUD
- [x] HP hearts (top-left)
- [ ] Deadeye meter (top-center, pulses when full)
- [x] Ammo count (top-right, blinks during reload)
- [ ] Item slots (top-right)
- [ ] Slide cooldown indicator (bottom-right)
- [ ] No visual overlap between HUD elements

## Session 8 — Boss
- [ ] Warden spawns in boss room
- [ ] Phase 1: patrol, homing orb arc attack
- [ ] Phase 2: summons 2 Grunts, speed increase (triggers at 50% HP)
- [ ] Phase 3: Deadeye flash, precision burst (triggers at 25% HP)
- [ ] Slide I-frames work against all Warden attacks
- [ ] Unique relic drops on death
- [ ] Win condition triggers
- [ ] Warden placeholder sprites (2x2, 3 phase variants)

## Session 9 — Token Audit
- [ ] Full codebase reviewed for token count
- [ ] Dead code removed
- [ ] Systems refactored to reduce token usage if needed
- [ ] Confirmed under PICO-8 32,768 token limit

## Session 10 — Art Pass
- [ ] Player sprites painted (idle, run, jump, crouch, slide, shoot)
- [ ] Enemy sprites painted — Grunt, Lurker, Crawler, Turret
- [ ] Boss sprites painted (3 phase variants)
- [ ] Bullet and projectile sprites
- [ ] Item, weapon, relic sprites
- [ ] Tileset painted (floor, wall, cover, doors, anchor points)
- [ ] UI sprites (hearts, meter, icons)
- [ ] Background decoration sprites

## Session 11 — Audio
- [ ] SFX: gunshot
- [ ] SFX: slide whoosh
- [ ] SFX: Deadeye activate
- [ ] SFX: enemy hit
- [ ] SFX: player hurt
- [ ] SFX: Lurker charge hum
- [ ] SFX: item pickup
- [ ] SFX: boss phase change chord
- [ ] Music: room ambient loop
- [ ] Music: boss fight loop

## Session 12 — Polish & Completion
- [ ] Title screen
- [ ] Game over screen
- [ ] Full run playtested start to finish
- [ ] No crashes or logic errors
- [ ] Ship it
