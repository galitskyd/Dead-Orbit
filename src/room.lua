-- === room / map ===
platforms={}
pits={}

function init_platforms()
 platforms={}
 -- stairs (ascending right)
 add_plat(140,96,32,4)
 add_plat(164,80,32,4)
 add_plat(188,64,32,4)
 -- floating platforms
 add_plat(245,80,48,4)
 add_plat(295,60,48,4)
end

function init_pits()
 pits={}
 -- pit 1: between start area and stairs
 add(pits,{x=115,w=24})
 -- pit 2: between floating platforms
 add(pits,{x=268,w=24})
end

function add_plat(x,y,w,h)
 add(platforms,{x=x,y=y,w=w,h=h})
end

-- check if a single x point is over a pit
function is_pit(x)
 for pt in all(pits) do
  if x>=pt.x and x<pt.x+pt.w then
   return true
  end
 end
 return false
end

-- check if an object's center is over a pit
function over_pit(x,w)
 return is_pit(x+w/2)
end

-- one-way platform collision
-- obj needs: x,y,w,h,vy
-- returns true if landed
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

function draw_room()
 -- floor (full level width)
 rectfill(0,rm_f,lvl_w-1,lvl_h-1,5)
 -- floor highlight
 line(rm_l,rm_f,rm_r-1,rm_f,6)
 -- cut out pits
 for pt in all(pits) do
  rectfill(pt.x,rm_f,
   pt.x+pt.w-1,lvl_h-1,0)
  -- edge highlights (walls of the pit)
  line(pt.x-1,rm_f,pt.x-1,lvl_h-1,6)
  line(pt.x+pt.w,rm_f,pt.x+pt.w,lvl_h-1,6)
 end
 -- ceiling
 rectfill(0,0,lvl_w-1,rm_t-1,5)
 -- left wall
 rectfill(0,0,rm_l-1,lvl_h-1,5)
 -- right wall
 rectfill(rm_r,0,lvl_w-1,lvl_h-1,5)
 -- edge highlights (walls/ceiling)
 line(rm_l,rm_t,rm_r-1,rm_t,6)
 line(rm_l,rm_t,rm_l,rm_f,6)
 line(rm_r-1,rm_t,rm_r-1,rm_f,6)
 -- platforms
 draw_platforms()
end

function draw_platforms()
 for pl in all(platforms) do
  rectfill(pl.x,pl.y,
   pl.x+pl.w-1,pl.y+pl.h-1,5)
  -- top edge highlight
  line(pl.x,pl.y,pl.x+pl.w-1,pl.y,6)
 end
end
