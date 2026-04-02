-- === main ===
lvl_dir=1   -- 1=left-to-right, -1=right-to-left
lvl_depth=0 -- floor counter, enemies scale with this

function _init()
 poke(0x5f2d,1)
 poke(0x5f30,1)
 lvl_dir=1
 lvl_depth=0
 generate_level()
 init_player()
 init_camera()
 init_enemies()
 state="title"
end

function new_game()
 lvl_dir=1
 lvl_depth=0
 generate_level()
 init_player()
 init_camera()
 init_enemies()
 particles={}
end

function advance_level()
 lvl_depth+=1
 lvl_dir*=-1
 generate_level()
 drop_player()
 init_camera()
 init_enemies()
 particles={}
end

function init_enemies()
 enemies={}
 e_projs={}

 -- scale with depth
 local d=lvl_depth
 local ng=2+min(d,4)       -- grunts: 2-6
 local nc=1+min(flr(d/2),3) -- crawler pairs: 1-4
 local nl=1+min(flr(d/2),2) -- lurkers: 1-3
 local plat_chance=min(0.3+d*0.05,0.6)

 -- ground grunts
 for i=1,ng do
  local x=rand_ground_x(16)
  if x then spawn_grunt(x,rm_f-16) end
 end

 -- ground crawlers in pairs
 for i=1,nc do
  local x=rand_ground_x(8)
  if x then
   spawn_crawler(x,rm_f-8)
   if not over_pit(x+12,8) then
    spawn_crawler(x+12,rm_f-8)
   end
  end
 end

 -- ceiling lurkers
 for i=1,nl do
  local ml,mr=mid_zone()
  local x=ml+flr(rnd(mr-ml-20))
  spawn_lurker(x,rm_t)
 end

 -- enemies on platforms
 for pl in all(platforms) do
  if rnd(1)<plat_chance then
   local r=rnd(1)
   local px=pl.x+flr(rnd(max(pl.w-16,1)))
   if r<0.35 then
    spawn_turret(px,pl.y-16)
   elseif r<0.7 then
    spawn_grunt(px,pl.y-16)
   else
    spawn_crawler(
     pl.x+flr(rnd(max(pl.w-8,1))),
     pl.y-8)
   end
  end
 end
end

-- find valid ground x (outside safe zone,
-- not over any pit)
function rand_ground_x(w)
 local ml,mr=mid_zone()
 for try=1,15 do
  local x=ml+flr(rnd(mr-ml-w))
  if not over_pit(x,w) then
   return x
  end
 end
 return nil
end

function _update()
 read_input()

 if state=="title" then
  if key("x") then
   new_game()
   set_state("game")
  end
 elseif state=="game" then
  if key("p") then
   set_state("pause")
   return
  end
  update_player()
  update_enemies()
  update_particles()
  update_camera()
 elseif state=="pause" then
  if key("x") then
   set_state("game")
  end
  if key("d") then
   god_mode=not god_mode
  end
 elseif state=="gameover" then
  if key("x") then
   set_state("title")
  end
 end
end

function _draw()
 if state=="title" then
  draw_title()
 elseif state=="game" then
  cls(0)
  camera(cam_x,0)
  draw_room()
  draw_enemies()
  draw_e_projs()
  draw_player()
  draw_bullets()
  draw_particles()
  camera(0,0)
  draw_hud()
 elseif state=="pause" then
  cls(0)
  camera(cam_x,0)
  draw_room()
  draw_enemies()
  draw_e_projs()
  draw_player()
  draw_bullets()
  draw_particles()
  camera(0,0)
  draw_hud()
  draw_pause()
 elseif state=="gameover" then
  draw_gameover()
 end
end
