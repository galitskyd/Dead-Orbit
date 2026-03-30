# DEAD ORBIT
### A PICO-8 Space Cowboy Side-Scrolling Dungeon Crawler

---

## Concept Summary

The player is a lone space bounty hunter stranded in a derelict orbital station. Armed with a revolver and scrounged gear, they fight through procedurally arranged rooms to reach the warden at the station's core. Two mechanics drive everything: **deliberate semi-auto gunplay with a visible shot guideline** and a **committed ground slide with I-frames** that teaches the player exactly what they'll need against the final boss.

---

## Controls

Uses `stat(28)` raw keyboard scanning for WASD + F + Space, combined with PICO-8's native button map for X and Enter.

| Action | Key | Notes |
|---|---|---|
| Move left / right | A / D | |
| Jump | W | |
| Crouch | S | |
| ~~Aim up~~ | ~~↑~~ | removed — shots are fixed direction |
| ~~Aim down~~ | ~~↓~~ | removed — shots are fixed direction |
| Fire | F | semi-auto, one tap = one shot |
| Slide | Space | ground only, 1.5s cooldown, ~1s I-frames |
| Reload | R | ~1s, player vulnerable, can't slide during |
| Deadeye | X | hold to enter slow-mo |
| Inventory / pause | Enter | |

---

## Core Mechanic 1: Semi-Auto Gunplay

- Every tap of **F** fires one shot — no holding, no spray
- Bullets fire straight horizontally in the player's facing direction
- Player can shoot while standing, jumping, crouching, and sliding
- While sliding, shots fire upward at an angle (diagonal in facing direction)
- Each weapon has its own fire rate cap
- Reload is manual: **R** while crouching, ~1s, leaves player exposed
- **Deadeye (X)** slows time to ~10%, giving extra time to line up shots

---

## Core Mechanic 2: The Slide

- **Space** on the ground triggers a horizontal slide in current facing direction
- Player can tap **F** during the slide to fire — shots go upward at an angle
- **~1s of I-frames** — projectiles and contact damage pass through completely
- **1.5s cooldown** after slide completes — HUD indicator shows when ready
- Cannot slide while airborne
- Cannot slide while reloading

**The skill loop:**
1. Read the room — spot threats, note the Lurker in the back
2. Commit to the slide — I-frames carry through incoming fire
3. Fire mid-slide — angled shots hit elevated targets while dodging ground threats
4. Come out the other side with enemies behind you

---

## Slide as a Teaching System

| Enemy | Threat | Slide Interaction | Boss Preview |
|---|---|---|---|
| Drifter Grunt | Straight projectile | Slide through the gap between shots | Warden sustained fire |
| The Lurker | Arcing plasma glob | Aim at Lurker, slide under descending glob while firing | Warden Phase 1 orbs |
| Void Crawler | Rush / melee pack | Slide through the pack to escape being cornered | Warden Phase 2 summon rush |
| Station Turret | Stationary burst | Destroy or avoid | Warden Phase 3 (surprise) |

---

## Deadeye

- Hold **X** to enter Deadeye — time slows to ~10%
- Player still taps F to fire — Deadeye gives extra time to position and shoot
- Drains a meter while held — refills passively over time
- Deadeye Flask consumable refills it instantly
- **In the boss fight, The Warden uses its own Deadeye** — screen desaturates with a dramatic flash, Warden freezes briefly, then fires a precise high-damage burst. Player must slide through it. This is the surprise payoff for learning the system all run.

---

## Player Stats

| Stat | Value |
|---|---|
| HP | 5 hearts |
| Ammo | weapon-dependent |
| Deadeye meter | 0–100, passive refill |
| Slide cooldown | 1.5s |

---

## Weapons & Items

**3 item slots max.**

### Starting Weapon
**Rusty Revolver** — 6 shots, medium damage, manual reload (R)

### Weapon Pickups
| Weapon | Flavor | Mechanic |
|---|---|---|
| Plasma Repeater | sci-fi SMG | fast fire cap, no reload, overheats after 20 shots |
| Void Scatter | space shotgun | 5-pellet spread, short range, 2-shot clip |
| Lasso Coil | magnetic grapple | stuns enemy briefly, pulls item drops toward player |

### Consumables
| Item | Effect |
|---|---|
| Stim Pack | restore 1 HP |
| Deadeye Flask | instantly refill Deadeye meter |
| Gravity Shard | slows all enemies for ~3s |

### Passive Relics (one slot)
| Relic | Effect |
|---|---|
| Spur Charm | Deadeye recharges 25% faster |
| Dead Man's Badge | +1 max HP |
| Void Lens | Deadeye shots deal 2x damage |

---

## Enemies

### 1. Drifter Grunt
- Walks toward player, fires a straight projectile every 2s
- 3 HP, drops ammo on death
- **Slide lesson:** time the slide to pass through the gap between shots
- **Boss preview:** Warden sustained straight fire in all phases

### 2. The Lurker
- Pale alien, clings to walls or hangs from ceilings at the back of rooms
- Stationary — charges a glowing bioluminescent sac, spits a slow heavy plasma glob in a high arc
- Telegraph: sac brightens as it charges
- 2 HP — dies in one clean shot if player prioritizes it
- Drops nothing
- Paired with Grunts as a backline threat
- **Slide lesson:** set aim angle on Lurker, slide under the descending glob while firing mid-slide
- **Boss preview:** Warden Phase 1 homing orbs follow the same arc logic

### 3. Void Crawler
- Fast rusher, no ranged attack, spawns in pairs or small packs
- 2 HP, erratic movement along platforms
- **Slide lesson:** slide through the pack to escape being cornered
- **Boss preview:** Warden Phase 2 summons 2 Grunts mid-fight

### 4. Station Turret
- Stationary, fires rapid burst when player in line-of-sight
- 5 HP, destructible
- No slide interaction — destroy it or avoid LOS
- **Boss preview:** Warden Phase 3 Deadeye burst (the surprise)

---

## Boss: The Warden

Large 2x2 sprite. Three phases.

**Phase 1 — Patrol & Orbs** (full HP)
- Patrols the platform, fires homing orbs in a slow arc
- Player applies Lurker slide skills

**Phase 2 — Summon Rush** (below 50% HP)
- Summons 2 Drifter Grunts, moves faster
- Player applies Crawler crowd management

**Phase 3 — Warden's Deadeye** (below 25% HP) ← *the surprise*
- Screen desaturates with a dramatic flash
- Warden enters its own Deadeye — freezes briefly, fires a precise high-damage burst
- Player must slide through it using the I-frame window
- Drops a unique relic on death

---

## Map & Room Design

- ~8–10 hand-crafted room templates per floor, shuffled each run
- Rooms are 1–2 screens wide, side-scrolling with platforms and cover
- Doors lock until all enemies cleared, then open
- 2 floors of regular rooms + 1 boss room
- Room templates include wall and ceiling anchor points for Lurker placement

---

## HUD

```
Top-left:     ❤❤❤❤❤  HP hearts
Top-center:   [========]  Deadeye meter (pulses when full)
Top-right:    gun icon + ammo  |  3 item slots
Bottom-right: [●] slide cooldown indicator (fills back over 1.5s)
Always-on:    (none — shots are fixed direction, no guideline)
```

---

## Sprite Budget

| Category | Count |
|---|---|
| Player frames (run, jump, crouch, slide, shoot) | ~16 |
| Enemy frames — Grunt, Lurker, Crawler, Turret | ~24 |
| Boss frames (3 phases) | ~16 |
| Bullets / projectiles / plasma glob | 8 |
| Items / weapons / relics | 16 |
| Tileset (floor, wall, cover, doors, anchor points) | 22 |
| UI elements (hearts, meter, icons, dotted line) | 12 |
| Background / decoration | ~20 |
| **Total** | **~134** — well within 256 budget |

---

## Audio Plan

| SFX | Trigger |
|---|---|
| Gunshot | player fires |
| Slide activate | quick whoosh |
| Deadeye on | pitch-shift down, world slows |
| Enemy hit | short thud |
| Player hurt | harsh buzz |
| Lurker charge | rising hum as sac glows |
| Item pickup | bright ding |
| Boss phase change | dramatic chord stab |

Music: 2 tracks — tense ambient loop for rooms, driving percussion loop for boss fight.

---

## Code Structure

```lua
-- === CONSTANTS ===
-- === HELPERS ===
-- === STATE MACHINE ===
-- === INPUT (stat(28) raw keyboard) ===
-- === PLAYER ===
-- === SLIDE ===
-- === DEADEYE ===
-- === SHOOTING ===
-- === ENEMIES ===
--     grunt
--     lurker
--     crawler
--     turret
-- === BULLETS ===
-- === ITEMS ===
-- === ROOM / MAP ===
-- === BOSS ===
-- === UI / HUD ===
-- _init()
-- _update()
-- _draw()
```
