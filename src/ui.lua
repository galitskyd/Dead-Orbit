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
