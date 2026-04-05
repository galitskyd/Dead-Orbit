-- dead orbit
-- a space cowboy side-scroller

-- === constants ===
grav=0.25
max_vy=4
jump_spd=-4
move_spd=1.5

-- (level bounds set by load_room)

-- bullets
blt_spd=3
blt_spr=12 -- sprite index for bullet
blt_life=120 -- frames before despawn

-- gun definitions {name,max_ammo,fire_cd,reload_dur,auto}
gun_defs={
 revolver={name="revolver",max=6,cd=8,rld=30,auto=false},
 auto={name="auto",max=30,cd=5,rld=45,auto=true}
}


-- gun drops
gun_drop_chance=0.3 -- 30% chance grunt drops auto gun

-- slide
slide_spd=2.5
slide_dur=18 -- ~0.6s at 30fps
slide_fric=0.10 -- friction per frame
slide_iframes=18 -- ~0.6s at 30fps
slide_cd_max=45 -- 1.5s cooldown at 30fps
slide_shot_vy=-1.5 -- upward component for angled slide shots

-- debug
god_mode=false -- default: no damage taken

-- player hp
p_hp_max=5
p_hurt_cd=30 -- invuln after hit (~1s)

-- enemy sprites
spr_grunt=32 -- 2x2
spr_crawler=13 -- frame 1; frame 2 = 14
spr_eproj=30 -- enemy projectile (1x1)

-- grunt
grunt_hp=3
grunt_spd=0.4
grunt_fire_cd=60 -- 2s at 30fps
grunt_proj_spd=1.5
grunt_retreat=40 -- back up if closer
grunt_ideal=80  -- stop approaching
grunt_nade_chance=0.12 -- 12% grenade
grunt_sight=120 -- alert range in pixels

-- grenade
nade_tick=60  -- 2s fuse at 30fps
nade_grav=0.15
nade_bounce=0.4
nade_dmg_r=14 -- damage radius

-- crawler
crawler_hp=1
crawler_spd=1.2
crawler_accel=0.08
