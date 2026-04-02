-- === ui / hud ===
function draw_hud()
 -- floor depth (top-left)
 print("floor "..(lvl_depth+1),2,2,6)
 -- slide cooldown indicator (bottom-right)
 draw_slide_cd()
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
 print("reached floor "..(lvl_depth+1),34,50,6)
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
