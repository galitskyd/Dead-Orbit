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
  if key("x") then
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
  if key("x") then
   set_state("game")
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
  draw_room()
  draw_player()
  draw_bullets()
  draw_particles()
  draw_hud()
 elseif state=="pause" then
  cls(0)
  draw_room()
  draw_player()
  draw_bullets()
  draw_particles()
  draw_hud()
  draw_pause()
 elseif state=="gameover" then
  draw_gameover()
 end
end
