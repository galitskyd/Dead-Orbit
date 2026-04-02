-- === main ===
function _init()
 poke(0x5f2d,1)
 poke(0x5f30,1)
 init_camera()
 generate_level()
 init_player()
 init_enemies()
 state="title"
end

function init_enemies()
 enemies={}
 e_projs={}

 -- ground grunts (3-4)
 for i=1,3+flr(rnd(2)) do
  local x=rand_ground_x(16)
  if x then spawn_grunt(x,rm_f-16) end
 end

 -- ground crawlers in pairs (2-4)
 for i=1,2+flr(rnd(3)) do
  local x=rand_ground_x(8)
  if x then
   spawn_crawler(x,rm_f-8)
   -- pair: second crawler nearby
   if not over_pit(x+12,8) then
    spawn_crawler(x+12,rm_f-8)
   end
  end
 end

 -- ceiling lurkers (1-2)
 for i=1,1+flr(rnd(2)) do
  local x=safe_r+flr(rnd(rm_r-safe_r-20))
  spawn_lurker(x,rm_t)
 end

 -- enemies on platforms (~40% chance each)
 for pl in all(platforms) do
  if rnd(1)<0.4 then
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

-- find a random valid ground x
-- (outside safe zone, not over pit)
function rand_ground_x(w)
 for try=1,15 do
  local x=safe_r+flr(rnd(rm_r-safe_r-w))
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
   init_camera()
   generate_level()
   init_player()
   init_enemies()
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
