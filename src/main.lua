-- === main ===

function _init()
 poke(0x5f2d,1)
 poke(0x5f30,1)
 load_room(room1)
 init_player()
 spawn_from_map()
 init_camera()
 state="title"
end

function new_game()
 load_room(room1)
 init_player()
 spawn_from_map()
 init_camera()
 particles={}
 pickups={}
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
  update_pickups()
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
  draw_pickups()
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
  draw_pickups()
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
