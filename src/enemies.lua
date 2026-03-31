-- === enemies ===
enemies={}
e_projs={} -- enemy projectiles

-- helper: axis-aligned box overlap
function box_hit(ax,ay,aw,ah,bx,by,bw,bh)
 return ax<bx+bw and ax+aw>bx
    and ay<by+bh and ay+ah>by
end

-- helper: spawn ammo drop at position
function spawn_ammo(x,y)
 add(particles,{
  x=x,y=y,vx=0,vy=-0.5,
  life=60,c=11
 })
 -- give player ammo
 p.ammo=min(p.ammo+3,gun_max)
end

-- === spawn functions ===

function spawn_grunt(x,y)
 add(enemies,{
  type="grunt",
  x=x,y=y,w=16,h=16,
  hp=grunt_hp,
  spd=grunt_spd,
  fire_t=grunt_fire_cd,
  facing=-1,
  flash=0
 })
end

function spawn_lurker(x,y)
 add(enemies,{
  type="lurker",
  x=x,y=y,w=16,h=16,
  hp=lurker_hp,
  charge=0,
  charging=false,
  flash=0
 })
end

function spawn_crawler(x,y)
 add(enemies,{
  type="crawler",
  x=x,y=y,w=8,h=8,
  hp=crawler_hp,
  spd=0,
  facing=-1,
  jitter_t=0,
  flash=0,
  tumble=0,
  dying=false,
  die_t=0,
  anim_t=0
 })
end

function spawn_turret(x,y)
 add(enemies,{
  type="turret",
  x=x,y=y,w=16,h=16,
  hp=turret_hp,
  burst_left=0,
  burst_t=0,
  cooldown=30,
  flash=0
 })
end

-- === update all enemies ===

function update_enemies()
 for e in all(enemies) do
  if e.flash>0 then e.flash-=1 end

  if e.type=="grunt" then
   update_grunt(e)
  elseif e.type=="lurker" then
   update_lurker(e)
  elseif e.type=="crawler" then
   update_crawler(e)
  elseif e.type=="turret" then
   update_turret(e)
  end
 end

 update_e_projs()
 check_bullet_enemy()
 check_eproj_player()
 check_contact_player()
end

-- === grunt ===

function update_grunt(e)
 -- face player
 if p.x<e.x then e.facing=-1
 else e.facing=1 end

 -- walk toward player
 local dx=p.x-e.x
 if abs(dx)>24 then
  e.x+=e.spd*e.facing
 end

 -- floor clamp
 if e.y+e.h>rm_f then
  e.y=rm_f-e.h
 end
 -- wall clamp
 if e.x<rm_l then e.x=rm_l end
 if e.x+e.w>rm_r then e.x=rm_r-e.w end

 -- fire
 e.fire_t-=1
 if e.fire_t<=0 then
  local bx=e.x+e.w/2+8*e.facing
  local by=e.y+e.h/2
  add(e_projs,{
   x=bx,y=by,
   vx=grunt_proj_spd*e.facing,
   vy=0,
   spr_id=spr_eproj,
   life=120
  })
  e.fire_t=grunt_fire_cd
 end
end

-- === lurker ===

function update_lurker(e)
 -- stationary, just charge and spit
 if not e.charging then
  -- start charging if player is in range
  local dx=abs(p.x-e.x)
  if dx<90 then
   e.charging=true
   e.charge=0
  end
 else
  e.charge+=1
  if e.charge>=lurker_charge_t then
   -- spit arcing glob toward player
   local dx=p.x-e.x
   local dy=p.y-e.y
   local dist=max(abs(dx),1)
   local t=dist/lurker_glob_spd/30
   local gvx=dx/(t*30)
   -- clamp horizontal speed
   gvx=mid(-lurker_glob_spd,gvx,lurker_glob_spd)
   add(e_projs,{
    x=e.x+e.w/2,
    y=e.y+e.h/2,
    vx=gvx,
    vy=-1.5, -- arc upward first
    grav=lurker_glob_grav,
    spr_id=spr_glob,
    life=150
   })
   e.charging=false
   e.charge=0
  end
 end
end

-- === crawler ===

function update_crawler(e)
 e.anim_t+=1

 -- dying tumble animation
 if e.dying then
  e.die_t-=1
  e.x+=e.spd*0.5
  e.y-=0.5
  if e.die_t<=0 then
   spawn_explosion(e.x+e.w/2,e.y+e.h/2)
   del(enemies,e)
  end
  return
 end

 -- tumble tick
 if e.tumble>0 then e.tumble-=1 end

 -- face player
 if p.x<e.x then e.facing=-1
 else e.facing=1 end

 -- accelerate toward player
 e.spd=mid(-crawler_spd,
  e.spd+crawler_accel*e.facing,
  crawler_spd)

 -- jitter for erratic feel
 e.jitter_t+=1
 if e.jitter_t>10 then
  e.spd+=rnd(0.4)-0.2
  e.jitter_t=0
 end

 e.x+=e.spd

 -- floor clamp
 if e.y+e.h>rm_f then
  e.y=rm_f-e.h
 end
 -- wall bounce
 if e.x<rm_l then
  e.x=rm_l
  e.spd=abs(e.spd)
  e.tumble=10
 end
 if e.x+e.w>rm_r then
  e.x=rm_r-e.w
  e.spd=-abs(e.spd)
  e.tumble=10
 end
end

-- === turret ===

function update_turret(e)
 -- stationary, los check
 e.cooldown-=1
 if e.cooldown>0 then return end

 -- check los: same horizontal band
 local dy=abs((p.y+p.h/2)-(e.y+e.h/2))
 local dx=abs((p.x+p.w/2)-(e.x+e.w/2))
 if dy<16 and dx<turret_range then
  -- determine facing
  local dir=1
  if p.x<e.x then dir=-1 end

  if e.burst_left<=0 then
   e.burst_left=turret_burst
   e.burst_t=0
  end

  e.burst_t-=1
  if e.burst_t<=0 and e.burst_left>0 then
   local bx=e.x+e.w/2+8*dir
   local by=e.y+e.h/2
   add(e_projs,{
    x=bx,y=by,
    vx=turret_proj_spd*dir,
    vy=0,
    spr_id=spr_eproj,
    life=90
   })
   e.burst_left-=1
   e.burst_t=turret_burst_cd
   if e.burst_left<=0 then
    e.cooldown=turret_cooldown
   end
  end
 end
end

-- === enemy projectiles ===

function update_e_projs()
 for ep in all(e_projs) do
  ep.x+=ep.vx
  ep.y+=ep.vy
  if ep.grav then
   ep.vy+=ep.grav
  end
  ep.life-=1
  if ep.x<rm_l or ep.x>rm_r
  or ep.y<rm_t or ep.y>rm_f
  or ep.life<=0 then
   del(e_projs,ep)
  end
 end
end

-- === collisions ===

-- player bullets vs enemies
function check_bullet_enemy()
 for b in all(bullets) do
  for e in all(enemies) do
   local ex,ey,ew,eh=e.x,e.y,e.w,e.h
   -- crawler hitbox: bottom half only
   if e.type=="crawler" then
    ey=e.y+4 eh=4
   end
   if box_hit(b.x-2,b.y-2,4,4,
              ex,ey,ew,eh) then
    e.hp-=1
    e.flash=4
    spawn_impact(b.x,b.y)
    del(bullets,b)
    if e.hp<=0 then
     kill_enemy(e)
    end
    break
   end
  end
 end
end

-- enemy projectiles vs player
function check_eproj_player()
 for ep in all(e_projs) do
  if box_hit(ep.x-3,ep.y-3,6,6,
             p.x+2,p.y+2,p.w-4,p.h-4) then
   -- i-frames: projectile passes through completely
   if p.iframe_t<=0 and p.hurt_t<=0 then
    hurt_player()
    del(e_projs,ep)
   end
  end
 end
end

-- enemy contact vs player
function check_contact_player()
 for e in all(enemies) do
  if box_hit(p.x+2,p.y+2,p.w-4,p.h-4,
             e.x,e.y,e.w,e.h) then
   -- slide kills crawlers on contact
   if p.iframe_t>0 and e.type=="crawler" then
    e.hp-=1
    e.flash=4
    if e.hp<=0 then
     kill_enemy(e)
    end
   -- otherwise contact enemies hurt player
   elseif (e.type=="crawler" or e.type=="grunt")
   and p.hurt_t<=0 then
    hurt_player()
   end
  end
 end
end

-- enemy death
function kill_enemy(e)
 if e.type=="crawler" then
  -- tumble briefly then explode
  e.dying=true
  e.die_t=12
  e.tumble=12
  e.spd=p.facing*1.5 -- knocked in slide dir
  sfx(0)
  return
 end
 spawn_impact(e.x+e.w/2,e.y+e.h/2)
 if e.type=="grunt" then
  spawn_ammo(e.x+e.w/2,e.y)
 end
 del(enemies,e)
end

-- === draw ===

function draw_enemies()
 for e in all(enemies) do
  -- flash white on hit
  if e.flash>0 and e.flash%2==0 then
   rectfill(e.x,e.y,e.x+e.w-1,e.y+e.h-1,7)
  elseif e.type=="crawler" then
   local flip=e.facing==-1
   local vflip=e.tumble>0 and e.tumble%4<2
   local f=spr_crawler+flr(e.anim_t/4)%2
   spr(f,e.x,e.y,1,1,flip,vflip)
  else
   local s,flip=0,false
   if e.type=="grunt" then
    s=spr_grunt
    flip=e.facing==-1
   elseif e.type=="lurker" then
    s=spr_lurker
   elseif e.type=="turret" then
    s=spr_turret
   end
   spr(s,e.x,e.y,2,2,flip)
  end

  -- lurker charge telegraph
  if e.type=="lurker" and e.charging then
   local pct=e.charge/lurker_charge_t
   local r=1+flr(pct*3)
   local c=8+flr(pct*3) -- 8->9->10->11
   circfill(e.x+e.w/2,e.y+4,r,c)
  end
 end
end

function draw_e_projs()
 for ep in all(e_projs) do
  spr(ep.spr_id,ep.x-4,ep.y-4)
 end
end
