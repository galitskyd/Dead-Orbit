-- === room / map ===
platforms={}
pits={}

-- safe zone: no hazards or enemies
safe_r=rm_l+80

function generate_level()
 platforms={}
 pits={}
 gen_pits()
 gen_platforms()
end

-- === pit generation ===

function gen_pits()
 local count=1+flr(rnd(2)) -- 1-2 pits
 for i=1,count do
  for try=1,10 do
   local px=safe_r+20+flr(rnd(rm_r-safe_r-60))
   local pw=20+flr(rnd(10)) -- 20-29px
   if not pit_conflicts(px,pw) then
    add(pits,{x=px,w=pw})
    break
   end
  end
 end
end

function pit_conflicts(px,pw)
 for pt in all(pits) do
  -- min 60px between pits
  if px<pt.x+pt.w+60
  and px+pw>pt.x-60 then
   return true
  end
 end
 return false
end

-- === platform generation ===

function gen_platforms()
 local x=safe_r+10+flr(rnd(20))
 while x<rm_r-50 do
  local r=rnd(1)
  if r<0.3 then
   -- staircase: 2-3 ascending steps
   local steps=2+flr(rnd(2))
   local sy=rm_f-16-flr(rnd(16))
   for s=0,steps-1 do
    local sx=x+s*24
    local step_y=sy-s*16
    if step_y>rm_t+20
    and sx+32<rm_r
    and not span_hits_pit(sx,32) then
     add_plat(sx,step_y,32,4)
    end
   end
   x+=steps*24+20+flr(rnd(20))
  elseif r<0.7 then
   -- floating platform
   local pw=32+flr(rnd(24))
   local py=rm_t+24+flr(rnd(rm_f-rm_t-48))
   if x+pw<rm_r
   and not span_hits_pit(x,pw) then
    add_plat(x,py,pw,4)
   end
   x+=pw+20+flr(rnd(30))
  else
   -- empty space, advance
   x+=30+flr(rnd(40))
  end
 end
end

function span_hits_pit(x,w)
 for pt in all(pits) do
  if x<pt.x+pt.w+4 and x+w>pt.x-4 then
   return true
  end
 end
 return false
end

function add_plat(x,y,w,h)
 add(platforms,{x=x,y=y,w=w,h=h})
end

-- === pit helpers ===

function is_pit(x)
 for pt in all(pits) do
  if x>=pt.x and x<pt.x+pt.w then
   return true
  end
 end
 return false
end

function over_pit(x,w)
 return is_pit(x+w/2)
end

-- === platform collision ===

function plat_collide(obj)
 if obj.vy<0 then return false end
 local feet=obj.y+obj.h
 local prev=feet-obj.vy
 for pl in all(platforms) do
  if prev<=pl.y and feet>=pl.y
  and obj.x+obj.w>pl.x
  and obj.x<pl.x+pl.w then
   obj.y=pl.y-obj.h
   obj.vy=0
   return true
  end
 end
 return false
end

-- === drawing ===

function draw_room()
 -- floor
 rectfill(0,rm_f,lvl_w-1,lvl_h-1,5)
 line(rm_l,rm_f,rm_r-1,rm_f,6)
 -- cut out pits
 for pt in all(pits) do
  rectfill(pt.x,rm_f,
   pt.x+pt.w-1,lvl_h-1,0)
  line(pt.x-1,rm_f,pt.x-1,lvl_h-1,6)
  line(pt.x+pt.w,rm_f,pt.x+pt.w,lvl_h-1,6)
 end
 -- ceiling
 rectfill(0,0,lvl_w-1,rm_t-1,5)
 -- walls
 rectfill(0,0,rm_l-1,lvl_h-1,5)
 rectfill(rm_r,0,lvl_w-1,lvl_h-1,5)
 line(rm_l,rm_t,rm_r-1,rm_t,6)
 line(rm_l,rm_t,rm_l,rm_f,6)
 line(rm_r-1,rm_t,rm_r-1,rm_f,6)
 -- platforms
 for pl in all(platforms) do
  rectfill(pl.x,pl.y,
   pl.x+pl.w-1,pl.y+pl.h-1,5)
  line(pl.x,pl.y,pl.x+pl.w-1,pl.y,6)
 end
end
