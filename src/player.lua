-- === player ===
p={}

function init_player()
 p.x=56
 p.y=rm_f-8
 p.w=8
 p.h=8
 p.vx=0
 p.vy=0
 p.grounded=true
 p.crouching=false
 p.facing=1
 p.spr=0
 p.anim_t=0
end

function update_player()
 local moving=false
 p.crouching=false

 -- horizontal movement
 if key("a") then
  p.vx=-move_spd
  p.facing=-1
  moving=true
 elseif key("d") then
  p.vx=move_spd
  p.facing=1
  moving=true
 else
  if p.grounded then
   p.vx=0
  end
 end

 -- jump
 if key("w") and p.grounded then
  spawn_dust(p.x,p.y+p.h)
  p.vy=jump_spd
  p.grounded=false
  -- carry facing direction into jump
  if not moving then
   p.vx=move_spd*p.facing
  end
 end

 -- crouch (ground only)
 if key("s") and p.grounded then
  p.crouching=true
  p.vx=0
  moving=false
 end

 -- gravity
 if not p.grounded then
  p.vy+=grav
  if p.vy>max_vy then p.vy=max_vy end
 end

 -- apply velocity
 p.x+=p.vx
 p.y+=p.vy

 -- floor collision
 if p.y+p.h>rm_f then
  p.y=rm_f-p.h
  p.vy=0
  p.grounded=true
 end

 -- ceiling collision
 if p.y<rm_t then
  p.y=rm_t
  if p.vy<0 then p.vy=0 end
 end

 -- wall collision
 if p.x<rm_l then p.x=rm_l end
 if p.x+p.w>rm_r then p.x=rm_r-p.w end

 -- animation
 p.anim_t=(p.anim_t+1)%120
 if not p.grounded then
  p.spr=3
 elseif p.crouching then
  p.spr=4
 elseif moving then
  p.spr=1+flr(p.anim_t/6)%2
 else
  p.spr=0
 end
end

function draw_player()
 spr(p.spr,p.x,p.y,1,1,p.facing==-1)
end
