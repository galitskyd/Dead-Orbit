-- === player ===
p={}

function init_player()
 -- spawn on correct side based on direction
 if lvl_dir==1 then
  p.x=rm_l+8
  p.facing=1
 else
  p.x=rm_r-24
  p.facing=-1
 end
 p.y=rm_f-16
 p.w=16
 p.h=16
 p.vx=0
 p.vy=0
 p.grounded=true
 p.crouching=false
 p.spr=0
 p.anim_t=0
 init_slide()
 bullets={}
 p.ammo=gun_max
 p.gun_cd=0
 p.reloading=false
 p.reload_t=0
 p.hp=p_hp_max
 p.hurt_t=0
end

-- called when descending to next floor
function drop_player()
 if lvl_dir==1 then
  p.x=rm_l+8
  p.facing=1
 else
  p.x=rm_r-24
  p.facing=-1
 end
 p.y=rm_t+4
 p.vy=2
 p.vx=0
 p.grounded=false
 p.crouching=false
 p.sliding=false
 p.slide_t=0
 p.iframe_t=0
 p.slide_cd=0
 bullets={}
 -- keep current hp and ammo
end

function update_player()
 local moving=false
 p.crouching=false

 -- slide input (space key via stat(28))
 if key(" ") then
  start_slide()
 end

 -- update slide state
 update_slide()

 if not p.sliding then
  -- horizontal movement (btn: 0=left,1=right)
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

  -- jump (btn: 2=up)
  if btn(2) and p.grounded then
   spawn_dust(p.x,p.y+p.h)
   p.vy=jump_spd
   p.grounded=false
  end

  -- crouch (btn: 3=down, ground only)
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

 -- reload (r key via stat(28))
 if key("r") and not p.reloading
 and p.ammo<gun_max then
  p.reloading=true
  p.reload_t=reload_dur
 end

 -- reload tick
 if p.reloading then
  p.reload_t-=1
  if p.reload_t<=0 then
   p.reloading=false
   p.ammo=gun_max
  end
 end

 -- auto-reload on empty
 if p.ammo<=0 and not p.reloading then
  p.reloading=true
  p.reload_t=reload_dur
 end

 -- shoot (x key via stat(28))
 if key("x") and not p.reloading
 and p.gun_cd<=0 and p.ammo>0 then
  spawn_bullet()
  p.ammo-=1
  p.gun_cd=gun_cd_max
 end

 -- gravity (always apply, floor/plat collision cancels)
 p.vy+=grav
 if p.vy>max_vy then p.vy=max_vy end

 -- apply velocity
 p.x+=p.vx
 p.y+=p.vy
 p.grounded=false

 -- platform collision (one-way from above)
 if p.vy>=0 and plat_collide(p) then
  p.grounded=true
 end

 -- floor collision (skip if over pit)
 if p.y+p.h>rm_f
 and not over_pit(p.x,p.w) then
  p.y=rm_f-p.h
  p.vy=0
  p.grounded=true
 end

 -- fell below level
 if p.y>lvl_h+16 then
  if over_goal_pit(p.x,p.w) then
   advance_level()
   return
  else
   p.hp=0
   set_state("gameover")
  end
 end

 -- ceiling collision
 if p.y<rm_t then
  p.y=rm_t
  if p.vy<0 then p.vy=0 end
 end

 -- wall collision
 if p.x<rm_l then p.x=rm_l end
 if p.x+p.w>rm_r then p.x=rm_r-p.w end

 -- update bullets
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
  p.spr=2+f*2 -- 2 or 4
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
 -- flash during i-frames or hurt invuln
 if (p.iframe_t>0 or p.hurt_t>0) and p.anim_t%4<2 then
  return
 end
 spr(p.spr,p.x,p.y,2,2,p.facing==-1)

 -- reload bar above head
 if p.reloading then
  local bx=p.x+2
  local by=p.y-5
  local bw=12
  local pct=1-p.reload_t/reload_dur
  rect(bx,by,bx+bw,by+2,7)
  rectfill(bx+1,by+1,bx+flr(pct*(bw-1)),by+1,11)
 end
end
