-- === enemies ===
enemies={}
e_projs={}
grenades={}

-- helper: axis-aligned box overlap
function box_hit(ax,ay,aw,ah,bx,by,bw,bh)
 return ax<bx+bw and ax+aw>bx
    and ay<by+bh and ay+ah>by
end

-- helper: spawn ammo drop
function spawn_ammo(x,y)
 add(particles,{
  x=x,y=y,vx=0,vy=-0.5,
  life=60,c=11
 })
 local amt=p.gun_id=="auto" and 10 or 3
 p.ammo=min(p.ammo+amt,p.gun.max)
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
  flash=0,
  vy=0,
  grounded=false,
  jump_cd=0,
  alert=false,
  last_px=0,last_py=0,
  can_see=false
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
  anim_t=0,
  vy=0,
  grounded=false
 })
end

-- === update all enemies ===

function update_enemies()
 for e in all(enemies) do
  if e.flash>0 then e.flash-=1 end

  if e.type=="grunt" then
   update_grunt(e)
  elseif e.type=="crawler" then
   update_crawler(e)
  end
 end

 update_e_projs()
 update_grenades()
 check_bullet_enemy()
 check_eproj_player()
 check_contact_player()
end

-- shared gravity + tile collision
function enemy_physics(e)
 e.vy+=grav
 if e.vy>max_vy then e.vy=max_vy end
 e.y+=e.vy
 e.grounded=false
 collide_y(e)
 -- fell off map
 if e.y>lvl_h+16 then
  del(enemies,e)
  return
 end
 collide_x(e)
end

-- === grunt ===

-- safe distance (avoids pico-8 overflow)
function safe_dist(dx,dy)
 local adx=abs(dx)
 local ady=abs(dy)
 -- fast reject if clearly far
 if adx>200 or ady>200 then
  return 300
 end
 -- scale down to avoid overflow in multiply
 local m=max(adx,ady,1)
 local nx=dx/m
 local ny=dy/m
 return m*sqrt(nx*nx+ny*ny)
end

function update_grunt(e)
 local ex=e.x+e.w/2
 local ey=e.y+e.h/2
 local px=p.x+p.w/2
 local py=p.y+p.h/2
 local dx=px-ex
 local dy=py-ey
 local dist=safe_dist(dx,dy)

 -- vision: range + los check
 e.can_see=false
 if dist<grunt_sight then
  e.can_see=has_los(ex,ey,
   p.x+p.w/2,p.y+p.h/2)
 end

 -- alert state
 if e.can_see then
  e.alert=true
  e.last_px=p.x
  e.last_py=p.y
 end

 -- also alert if hit
 if e.flash>0 then
  e.alert=true
  e.last_px=p.x
  e.last_py=p.y
 end

 -- not alert: idle
 if not e.alert then
  enemy_physics(e)
  return
 end

 -- === alerted behavior ===
 local retreating=false
 local p_below=e.last_py>e.y+8

 -- retreat if too close + can see
 if e.can_see
 and dist<grunt_retreat and e.grounded then
  local rdir=p.x<ex and 1 or -1
  local can_retreat=not solid_at(
   rdir==1 and e.x+e.w+4 or e.x-4,
   ey)
  and not at_edge(e,rdir)
  if can_retreat then
   retreating=true
   e.facing=rdir
   e.x+=e.spd*rdir*2.5
  end
 end

 if not retreating then
  if e.can_see then
   -- face player
   if p.x<ex then e.facing=-1
   else e.facing=1 end
   -- approach if too far
   if dist>grunt_ideal then
    local blocked=at_edge(e,e.facing)
     and not p_below
    if not blocked then
     e.x+=e.spd*e.facing
    end
   end
  else
   -- lost sight: move toward last known pos
   local ldx=e.last_px-ex
   if abs(ldx)>8 then
    e.facing=ldx>0 and 1 or -1
    if not at_edge(e,e.facing)
    or p_below then
     e.x+=e.spd*e.facing
    end
   else
    -- reached last known pos, lose alert
    e.alert=false
   end
  end
 end

 -- jump toward target if above
 if e.jump_cd>0 then e.jump_cd-=1 end
 local ty=e.can_see and p.y or e.last_py
 local tdx=e.can_see and dx
  or (e.last_px-ex)
 if e.grounded and e.jump_cd<=0
 and not retreating
 and ty<e.y-20 and abs(tdx)<80 then
  e.vy=jump_spd*0.9
  e.grounded=false
  e.jump_cd=60
 end

 enemy_physics(e)

 -- no shooting while retreating or blind
 if retreating or not e.can_see then
  return
 end

 -- fire: aimed within 90° cone
 e.fire_t-=1
 if e.fire_t<=0 then
  local in_front=(e.facing==1 and dx>0)
   or (e.facing==-1 and dx<0)
  if in_front and abs(dy)<=abs(dx) then
   if rnd(1)<grunt_nade_chance then
    spawn_grenade(e)
   else
    -- safe normalization
    local m=max(abs(dx),abs(dy),1)
    local nx=dx/m
    local ny=dy/m
    local len=sqrt(nx*nx+ny*ny)
    nx/=len ny/=len
    local bx=ex+8*e.facing
    local by=ey
    add(e_projs,{
     x=bx,y=by,
     vx=grunt_proj_spd*nx,
     vy=grunt_proj_spd*ny,
     spr_id=spr_eproj,
     life=120
    })
   end
  end
  e.fire_t=grunt_fire_cd
 end
end

-- === grenades ===

function spawn_grenade(e)
 local dx=p.x-(e.x+e.w/2)
 local dist=max(abs(dx),1)
 -- aim slightly behind player
 local behind=-sgn(dx)*12
 local tx=dx+behind
 -- slower lob
 add(grenades,{
  x=e.x+e.w/2,
  y=e.y,
  vx=tx/max(abs(tx),1)*1.0,
  vy=-3.5,
  tick=nade_tick,
  landed=false
 })
end

function update_grenades()
 for g in all(grenades) do
  g.vy+=nade_grav
  g.x+=g.vx
  g.y+=g.vy

  -- ceiling
  if solid_at(g.x,g.y-2) then
   g.vy=abs(g.vy)*nade_bounce
  end

  -- ground bounce
  if solid_at(g.x,g.y+3) then
   local ty=flr((g.y+3)/tile_sz)
   g.y=ty*tile_sz-3
   if not g.landed then
    g.landed=true
    g.tick=nade_tick
   end
   if abs(g.vy)>0.3 then
    g.vy=-g.vy*nade_bounce
    g.vx*=0.7
   else
    g.vy=0
    g.vx*=0.85
   end
  end

  -- wall bounce
  if solid_at(g.x+3,g.y) then
   g.x=flr((g.x+3)/tile_sz)*tile_sz-3
   g.vx=-g.vx*0.5
  elseif solid_at(g.x-3,g.y) then
   local tx=flr((g.x-3)/tile_sz)
   g.x=(tx+1)*tile_sz+3
   g.vx=-g.vx*0.5
  end

  -- only tick after landing
  if g.landed then
   g.tick-=1
   if g.tick<=0 then
    explode_grenade(g)
    del(grenades,g)
   end
  end
 end
end

function explode_grenade(g)
 -- damage check (width-based)
 local dx=abs(p.x+p.w/2-g.x)
 local dy=abs(p.y+p.h/2-g.y)
 if dx<nade_dmg_r and dy<nade_dmg_r+8 then
  hurt_player()
 end
 spawn_nade_explosion(g.x,g.y)
end

function draw_grenades()
 for g in all(grenades) do
  -- plasma body
  circfill(g.x,g.y,2,12)

  if g.landed then
   local pct=1-g.tick/nade_tick
   -- pulse faster as timer runs out
   local rate=g.tick<15 and 2
    or (g.tick<30 and 4 or 8)
   if g.tick%rate<rate/2 then
    circ(g.x,g.y,3,11)
   end
   -- danger radius grows in last half
   if pct>0.5 then
    local r=flr(nade_dmg_r*pct)
    local c=pct>0.75 and 8 or 2
    circ(g.x,g.y,r,c)
   end
  else
   -- in-flight glow
   circ(g.x,g.y,3,13)
  end
 end
end

-- === crawler ===

function update_crawler(e)
 e.anim_t+=1

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

 if e.tumble>0 then e.tumble-=1 end

 if p.x<e.x then e.facing=-1
 else e.facing=1 end

 e.spd=mid(-crawler_spd,
  e.spd+crawler_accel*e.facing,
  crawler_spd)

 e.jitter_t+=1
 if e.jitter_t>10 then
  e.spd+=rnd(0.4)-0.2
  e.jitter_t=0
 end

 local move_dir=e.spd>0 and 1 or -1
 if at_edge(e,move_dir) then
  e.spd=-e.spd*0.5
 else
  e.x+=e.spd
 end

 enemy_physics(e)
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
  if blocked_at(ep.x,ep.y)
  or ep.life<=0 then
   del(e_projs,ep)
  end
 end
end

-- === collisions ===

function check_bullet_enemy()
 for b in all(bullets) do
  for e in all(enemies) do
   local ex,ey,ew,eh=e.x,e.y,e.w,e.h
   if e.type=="crawler" then
    ey=e.y+2 eh=6
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

function check_eproj_player()
 local hx,hy,hw,hh=p_hurtbox()
 for ep in all(e_projs) do
  if box_hit(ep.x-3,ep.y-3,6,6,
             hx,hy,hw,hh) then
   if p.iframe_t<=0 and p.hurt_t<=0 then
    hurt_player()
    del(e_projs,ep)
   end
  end
 end
end

function check_contact_player()
 local hx,hy,hw,hh=p_hurtbox()
 for e in all(enemies) do
  if box_hit(hx,hy,hw,hh,
             e.x,e.y,e.w,e.h) then
   if p.sliding and e.type=="crawler" then
    e.hp-=1
    e.flash=4
    if e.hp<=0 then
     kill_enemy(e)
    end
   elseif not p.sliding
   and (e.type=="crawler" or e.type=="grunt")
   and p.hurt_t<=0 then
    hurt_player()
   end
  end
 end
end

function kill_enemy(e)
 if e.type=="crawler" then
  e.dying=true
  e.die_t=12
  e.tumble=12
  e.spd=p.facing*1.5
  sfx(0)
  return
 end
 spawn_impact(e.x+e.w/2,e.y+e.h/2)
 if e.type=="grunt" then
  if rnd(1)<gun_drop_chance then
   spawn_gun_drop(e.x+e.w/2-4,e.y+4,"auto")
  else
   spawn_ammo(e.x+e.w/2,e.y)
  end
 end
 del(enemies,e)
end

-- === draw ===

function draw_enemies()
 for e in all(enemies) do
  if e.flash>0 and e.flash%2==0 then
   rectfill(e.x,e.y,
    e.x+e.w-1,e.y+e.h-1,7)
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
   end
   spr(s,e.x,e.y,2,2,flip)
  end
 end
end

function draw_e_projs()
 for ep in all(e_projs) do
  spr(ep.spr_id,ep.x-4,ep.y-4)
 end
end
