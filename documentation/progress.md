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

## Session 4 — Room System
- [x] World coordinate system (entities use world-space x,y)
- [x] Camera system with 80% deadzone scrolling
- [x] Level expanded to 3x screen width (384px)
- [x] Room drawing uses world-space bounds
- [x] HUD draws in screen-space (unaffected by camera)
- [x] One-way platforms (jump through from below, land on top)
- [x] Enemy gravity + platform collision (shared enemy_physics())
- [x] Grunts jump toward player when player is above them
- [x] Pits — player falls through, dies below level
- [x] Grunt pit avoidance (stops at edge), crawler reverses at edge
- [x] Enemies that fall in pits are removed
- [x] Procedural level generation (pits, platforms, staircases)
- [x] Procedural enemy placement (ground, platforms, ceiling)
- [x] Safe spawn zone (spawn side clear of hazards/enemies)
- [x] Looping descent: goal pit on far side, jump in to advance
- [x] Direction flips each floor (left→right, right→left)
- [x] Enemy count scales with depth (grunts 2-6, crawlers 1-4 pairs, lurkers 1-3)
- [x] Player keeps HP/ammo between floors, falls in from ceiling
- [x] Goal pit has green edges + down arrow indicator
- [x] Hazard pits in the middle still kill
- [x] Floor counter on HUD and game over screen
- [x] Ceiling hole on spawn side — player drops in from above
- [x] Player spawns above ceiling, falls through hole into level
- [x] Red color theme on floor 10+ (walls, floor, platforms)
- [ ] Tilemap rendering
- [ ] Platform collision
- [ ] Door lock / unlock logic (clears when enemies gone)
- [ ] 2–3 hand-crafted room templates
- [ ] Room shuffle logic for each floor
- [ ] Lurker wall and ceiling anchor points in tileset
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
