-- === player ===
p={}

function init_player()
 -- position set by spawn_from_map()
 p.x=0
 p.y=0
 p.w=16
 p.h=16
 p.vx=0
 p.vy=0
 p.grounded=true
 p.crouching=false
 p.facing=1
 p.spr=0
 p.anim_t=0
 init_slide()
 bullets={}
 pickups={}
 -- default weapon: revolver
 p.gun_id="revolver"
 p.gun=gun_defs.revolver
 p.ammo=p.gun.max
 p.gun_cd=0
 p.reloading=false
 p.reload_t=0
 p.hp=p_hp_max
 p.hurt_t=0
end

function update_player()
 local moving=false
 p.crouching=false

 -- slide input
 if key(" ") then
  start_slide()
 end
 update_slide()

 if not p.sliding then
  if btn(0) then
   p.vx=-move_spd
   p.facing=-1
   moving=true
  elseif btn(1) then
   p.vx=move_spd
   p.facing=1
   moving=true
  else
   if p.grounded then
    p.vx=0
   end
  end

  if btn(2) and p.grounded then
   spawn_dust(p.x,p.y+p.h)
   p.vy=jump_spd
   p.grounded=false
  end

  if btn(3) and p.grounded then
   p.crouching=true
   p.vx=0
   moving=false
  end
 end

 -- hurt invuln tick
 if p.hurt_t>0 then p.hurt_t-=1 end

 -- gun cooldown
 if p.gun_cd>0 then p.gun_cd-=1 end

 local g=p.gun

 -- reload
 if key("r") and not p.reloading
 and p.ammo<g.max then
  p.reloading=true
  p.reload_t=g.rld
 end

 if p.reloading then
  p.reload_t-=1
  if p.reload_t<=0 then
   p.reloading=false
   p.ammo=g.max
  end
 end

 -- auto-reload on empty
 if p.ammo<=0 and not p.reloading then
  p.reloading=true
  p.reload_t=g.rld
 end

 -- shoot
 local fire=false
 if g.auto then
  fire=btn(5)
 else
  fire=key("x")
 end
 if fire and not p.reloading
 and p.gun_cd<=0 and p.ammo>0 then
  spawn_bullet()
  p.ammo-=1
  p.gun_cd=g.cd
 end

 -- gravity
 p.vy+=grav
 if p.vy>max_vy then p.vy=max_vy end

 -- movement + tile collision
 p.x+=p.vx
 collide_x(p)
 p.y+=p.vy
 p.grounded=false
 collide_y(p)

 -- fell off map
 if p.y>lvl_h+16 then
  p.hp=0
  set_state("gameover")
 end

 update_bullets()

 -- animation
 p.anim_t=(p.anim_t+1)%120
 if p.sliding then
  p.spr=10
 elseif not p.grounded then
  p.spr=8
 elseif p.crouching then
  p.spr=6
 elseif moving then
  local f=flr(p.anim_t/6)%2
  p.spr=2+f*2
 else
  p.spr=0
 end
end

function hurt_player()
 if god_mode then return end
 if p.iframe_t>0 or p.hurt_t>0 then return end
 p.hp-=1
 p.hurt_t=p_hurt_cd
 if p.hp<=0 then
  set_state("gameover")
 end
end

function draw_player()
 if (p.iframe_t>0 or p.hurt_t>0)
 and p.anim_t%4<2 then
  return
 end
 spr(p.spr,p.x,p.y,2,2,p.facing==-1)
 draw_player_gun()

 if p.reloading then
  local bx=p.x+2
  local by=p.y-5
  local bw=12
  local pct=1-p.reload_t/p.gun.rld
  rect(bx,by,bx+bw,by+2,7)
  rectfill(bx+1,by+1,
   bx+flr(pct*(bw-1)),by+1,11)
 end
end
