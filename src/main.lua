-- === main ===
function _init()
 poke(0x5f2d,1)
 poke(0x5f30,1)
 init_camera()
 init_platforms()
 init_pits()
 init_player()
 init_enemies()
 state="title"
end

function init_enemies()
 enemies={}
 e_projs={}
 -- ground-level enemies (near spawn)
 spawn_grunt(90,rm_f-16)
 spawn_lurker(80,rm_t)
 spawn_crawler(100,rm_f-8)
 spawn_crawler(105,rm_f-8)
 -- on stairs (top step at x=188,y=64)
 spawn_turret(190,64-16)
 -- on floating platforms
 spawn_grunt(250,80-16)    -- plat at y=80
 spawn_crawler(310,60-8)   -- plat at y=60
 -- far-level ground enemies
 spawn_grunt(320,rm_f-16)
 spawn_lurker(300,rm_t)
 spawn_crawler(340,rm_f-8)
end

function _update()
 read_input()

 if state=="title" then
  if key("x") then
   init_camera()
   init_platforms()
   init_pits()
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
