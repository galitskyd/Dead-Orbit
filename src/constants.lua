-- dead orbit
-- a space cowboy side-scroller

-- === constants ===
grav=0.25
max_vy=4
jump_spd=-4
move_spd=1.5

-- room bounds (rectfill room)
rm_l=8
rm_r=120
rm_t=8
rm_f=112

-- bullets / revolver
blt_spd=3
blt_spr=12 -- sprite index for bullet
blt_life=120 -- frames before despawn
gun_max=6 -- revolver capacity
gun_cd_max=8 -- delay between shots (~0.27s at 30fps)
reload_dur=30 -- reload time (~1s at 30fps)

-- slide
slide_spd=2.5
slide_dur=18 -- ~0.6s at 30fps
slide_fric=0.10 -- friction per frame
slide_iframes=18 -- ~0.6s at 30fps
slide_cd_max=45 -- 1.5s cooldown at 30fps
slide_shot_vy=-1.5 -- upward component for angled slide shots

-- debug
god_mode=true -- default: no damage taken

-- player hp
p_hp_max=5
p_hurt_cd=30 -- invuln after hit (~1s)

-- enemy sprites (2x2 each)
-- grunt=32, lurker=34, crawler=36, turret=38
spr_grunt=32
spr_lurker=34
spr_crawler=13 -- frame 1; frame 2 = 14
spr_turret=38
spr_eproj=30 -- enemy projectile (1x1)
spr_glob=31 -- lurker plasma glob (1x1)

-- grunt
grunt_hp=3
grunt_spd=0.4
grunt_fire_cd=60 -- 2s at 30fps
grunt_proj_spd=1.5

-- lurker
lurker_hp=2
lurker_charge_t=90 -- 3s charge
lurker_glob_spd=1.0
lurker_glob_grav=0.04

-- crawler
crawler_hp=1
crawler_spd=1.2
crawler_accel=0.08

-- turret
turret_hp=5
turret_burst=3
turret_burst_cd=6 -- between burst shots
turret_cooldown=90 -- 3s between bursts
turret_proj_spd=2.0
turret_range=80 -- los range in pixels
