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
blt_spr=6 -- sprite index for bullet
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
