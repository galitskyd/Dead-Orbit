pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
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

-- === helpers ===
particles={}

function spawn_dust(x,y)
 for i=1,5 do
  add(particles,{
   x=x+rnd(8),
   y=y,
   vx=rnd(2)-1,
   vy=-rnd(1),
   life=10+flr(rnd(8)),
   c=6
  })
 end
end

function update_particles()
 for pt in all(particles) do
  pt.x+=pt.vx
  pt.y+=pt.vy
  pt.vy+=0.05
  pt.life-=1
  if pt.life<4 then pt.c=5 end
  if pt.life<=0 then del(particles,pt) end
 end
end

function draw_particles()
 for pt in all(particles) do
  pset(pt.x,pt.y,pt.c)
 end
end

-- === state machine ===
state="title"

function set_state(s)
 state=s
end

-- === input (stat(28) raw keyboard) ===
keys={}

function read_input()
 keys={}
 local n=0
 while stat(28) and n<16 do
  keys[stat(31)]=true
  n+=1
 end
end

function key(k)
 return keys[k]
end

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

-- === slide ===
-- (session 2)

-- === deadeye ===
-- (session 3)

-- === shot guideline ===
-- (session 2)

-- === enemies ===
--   grunt
--   lurker
--   crawler
--   turret
-- (session 5)

-- === bullets ===
-- (session 2)

-- === items ===
-- (session 6)

-- === room / map ===
function draw_room()
 -- floor
 rectfill(0,rm_f,127,127,5)
 -- ceiling
 rectfill(0,0,127,rm_t-1,5)
 -- left wall
 rectfill(0,0,rm_l-1,127,5)
 -- right wall
 rectfill(rm_r,0,127,127,5)
 -- edge highlights
 line(rm_l,rm_f,rm_r-1,rm_f,6)
 line(rm_l,rm_t,rm_r-1,rm_t,6)
 line(rm_l,rm_t,rm_l,rm_f,6)
 line(rm_r-1,rm_t,rm_r-1,rm_f,6)
end

-- === boss ===
-- (session 8)

-- === ui / hud ===
function draw_hud()
 -- minimal for session 1
end

function draw_title()
 cls(0)
 print("dead orbit",44,30,7)
 print("a space cowboy tale",26,42,6)
 print("press f to start",32,80,10)
end

function draw_gameover()
 cls(0)
 print("game over",46,45,8)
 print("press f to retry",32,70,6)
end

function draw_pause()
 rectfill(24,35,103,85,0)
 rect(24,35,103,85,7)
 print("paused",52,50,7)
 print("f to resume",42,65,6)
end

-- === main ===
function _init()
 poke(0x5f2d,1)
 poke(0x5f30,1)
 init_player()
 state="title"
end

function _update()
 read_input()

 if state=="title" then
  if key("f") then
   init_player()
   set_state("game")
  end
 elseif state=="game" then
  if key("p") then
   set_state("pause")
   return
  end
  update_player()
  update_particles()
 elseif state=="pause" then
  if key("f") then
   set_state("game")
  end
 elseif state=="gameover" then
  if key("f") then
   set_state("title")
  end
 end
end

function _draw()
 if state=="title" then
  draw_title()
 elseif state=="game" then
  cls(0)
  draw_room()
  draw_player()
  draw_particles()
  draw_hud()
 elseif state=="pause" then
  cls(0)
  draw_room()
  draw_player()
  draw_particles()
  draw_hud()
  draw_pause()
 elseif state=="gameover" then
  draw_gameover()
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077700000000770077770000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000000007700777000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000007700077000000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007000000077700007700000880000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777000000070000000770000000000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00808000000080000000888000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00808000000080000000808000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
