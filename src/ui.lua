-- === ui / hud ===
function draw_hud()
 draw_hearts()
 draw_ammo()
 draw_slide_cd()
end

function draw_hearts()
 for i=1,p_hp_max do
  local hx=2+(i-1)*9
  local hy=2
  if i<=p.hp then
   draw_heart(hx,hy,8) -- filled red
  else
   draw_heart(hx,hy,2) -- empty dark
  end
 end
end

-- draw a small heart at x,y
function draw_heart(x,y,c)
 -- 7px wide, 6px tall pixel heart
 pset(x+1,y,c)
 pset(x+2,y,c)
 pset(x+4,y,c)
 pset(x+5,y,c)
 line(x,y+1,x+6,y+1,c)
 line(x,y+2,x+6,y+2,c)
 line(x+1,y+3,x+5,y+3,c)
 line(x+2,y+4,x+4,y+4,c)
 pset(x+3,y+5,c)
end

function draw_ammo()
 local gn=p.gun.name
 local txt=p.ammo.."/"..p.gun.max
 local tx=126-#txt*4
 -- gun name above ammo
 local nx=126-#gn*4
 print(gn,nx,2,13)
 if p.reloading then
  local c=6
  if p.anim_t%10<5 then c=8 end
  print(txt,tx,8,c)
 else
  print(txt,tx,8,7)
 end
end

function draw_slide_cd()
 local cx,cy,r=118,118,4
 -- background circle
 circ(cx,cy,r,1)
 if p.slide_cd>0 then
  -- fill based on remaining cooldown
  local pct=p.slide_cd/slide_cd_max
  local fill=flr(pct*r)
  for dy=-r,r do
   if dy>=-r+fill then
    local dx=flr(sqrt(r*r-dy*dy))
    line(cx-dx,cy+dy,cx+dx,cy+dy,8)
   end
  end
 else
  -- ready indicator
  circfill(cx,cy,r,11)
 end
 circ(cx,cy,r,7)
end

function draw_title()
 cls(0)
 print("dead orbit",44,30,7)
 print("a space cowboy tale",26,42,6)
 print("press x to start",32,80,10)
end

function draw_gameover()
 cls(0)
 print("game over",46,38,8)
 print("press x to retry",32,70,6)
end

function draw_pause()
 rectfill(24,35,103,92,0)
 rect(24,35,103,92,7)
 print("paused",52,42,7)
 print("x to resume",42,55,6)
 local dc=11
 local dt="on"
 if not god_mode then
  dc=8
  dt="off"
 end
 print("d: god mode "..dt,32,70,dc)
 print("(no damage)",40,80,5)
end
