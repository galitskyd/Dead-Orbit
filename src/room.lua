-- === room / map ===
platforms={}
pits={}
goal_pit=nil
ceil_hole=nil -- ceiling gap where player drops in

function generate_level()
 platforms={}
 pits={}
 ceil_hole=nil

 -- goal pit on far side from spawn
 if lvl_dir==1 then
  goal_pit={x=rm_r-34,w=30,goal=true}
 else
  goal_pit={x=rm_l+4,w=30,goal=true}
 end
 add(pits,goal_pit)

 -- ceiling hole on spawn side (after first floor)
 if lvl_depth>0 then
  if lvl_dir==1 then
   ceil_hole={x=rm_l+4,w=30}
  else
   ceil_hole={x=rm_r-34,w=30}
  end
 end

 gen_hazard_pits()
 gen_platforms()
end

-- safe zone boundaries (spawn side)
function safe_zone()
 if lvl_dir==1 then
  return rm_l,rm_l+80
 else
  return rm_r-80,rm_r
 end
end

-- middle zone (between safe zone and goal pit)
function mid_zone()
 if lvl_dir==1 then
  return rm_l+90,rm_r-50
 else
  return rm_l+50,rm_r-90
 end
end

-- level colors: red theme after floor 9
function lvl_col()
 if lvl_depth>=9 then
  return 2,8 -- dark red fill, red highlight
 end
 return 5,6 -- dark purple fill, light purple highlight
end

-- === hazard pit generation ===

function gen_hazard_pits()
 local ml,mr=mid_zone()
 local count=flr(rnd(3)) -- 0-2 hazard pits
 for i=1,count do
  for try=1,10 do
   local px=ml+flr(rnd(mr-ml-30))
   local pw=20+flr(rnd(10))
   if not pit_conflicts(px,pw) then
    add(pits,{x=px,w=pw})
    break
   end
  end
 end
end

function pit_conflicts(px,pw)
 for pt in all(pits) do
  if px<pt.x+pt.w+60
  and px+pw>pt.x-60 then
   return true
  end
 end
 return false
end

-- === platform generation ===

function gen_platforms()
 local ml,mr=mid_zone()
 local x=ml+flr(rnd(20))
 while x<mr-30 do
  local r=rnd(1)
  if r<0.3 then
   -- staircase
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

function over_goal_pit(x,w)
 local cx=x+w/2
 return cx>=goal_pit.x
    and cx<goal_pit.x+goal_pit.w
end

-- check if x is inside ceiling hole
function in_ceil_hole(x,w)
 if not ceil_hole then return false end
 local cx=x+w/2
 return cx>=ceil_hole.x
    and cx<ceil_hole.x+ceil_hole.w
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
 local fc,hc=lvl_col()
 -- floor
 rectfill(0,rm_f,lvl_w-1,lvl_h-1,fc)
 line(rm_l,rm_f,rm_r-1,rm_f,hc)
 -- cut out floor pits
 for pt in all(pits) do
  rectfill(pt.x,rm_f,
   pt.x+pt.w-1,lvl_h-1,0)
  local c=pt.goal and 11 or hc
  line(pt.x-1,rm_f,pt.x-1,lvl_h-1,c)
  line(pt.x+pt.w,rm_f,pt.x+pt.w,lvl_h-1,c)
  if pt.goal then
   local ax=pt.x+pt.w/2
   line(ax,rm_f+3,ax,rm_f+10,11)
   line(ax-3,rm_f+7,ax,rm_f+10,11)
   line(ax+3,rm_f+7,ax,rm_f+10,11)
  end
 end
 -- ceiling
 rectfill(0,0,lvl_w-1,rm_t-1,fc)
 -- cut out ceiling hole
 if ceil_hole then
  rectfill(ceil_hole.x,0,
   ceil_hole.x+ceil_hole.w-1,rm_t-1,0)
  line(ceil_hole.x-1,0,
   ceil_hole.x-1,rm_t,hc)
  line(ceil_hole.x+ceil_hole.w,0,
   ceil_hole.x+ceil_hole.w,rm_t,hc)
 end
 -- walls
 rectfill(0,0,rm_l-1,lvl_h-1,fc)
 rectfill(rm_r,0,lvl_w-1,lvl_h-1,fc)
 line(rm_l,rm_t,rm_r-1,rm_t,hc)
 line(rm_l,rm_t,rm_l,rm_f,hc)
 line(rm_r-1,rm_t,rm_r-1,rm_f,hc)
 -- platforms
 for pl in all(platforms) do
  rectfill(pl.x,pl.y,
   pl.x+pl.w-1,pl.y+pl.h-1,fc)
  line(pl.x,pl.y,pl.x+pl.w-1,pl.y,hc)
 end
end
