-- === room / map ===
tile_sz=8
map_w=0
map_h=0
map_tiles={} -- [y][x]: 0=air,1=solid,2=platform
spawn_pts={}
lvl_w=0
lvl_h=0

-- tile char lookup
t_chars={
 ["#"]=1,["-"]=2,["."]=0,
 ["S"]=0,["G"]=0,["C"]=0,
 ["L"]=0,["T"]=0
}
s_chars={
 S="player",G="grunt",C="crawler",
 L="lurker",T="turret"
}

-- === room data ===
room1={
 "################################################",
 "#..............................................#",
 "#..............L...................L...........#",
 "#..............................................#",
 "#..............................................#",
 "#..............................................#",
 "#.....-------.........-------.....-------......#",
 "#..............................................#",
 "#..............................................#",
 "#.................--------.....................#",
 "#..............................................#",
 "#..............................................#",
 "#.....CC...-------.......T...-------...........#",
 "#..............................................#",
 "#S.......G...............G...........G.........#",
 "################################################"
}

-- === load & parse ===

function load_room(room)
 map_h=#room
 map_w=#room[1]
 lvl_w=map_w*tile_sz
 lvl_h=map_h*tile_sz
 map_tiles={}
 spawn_pts={}
 for y=0,map_h-1 do
  map_tiles[y]={}
  local row=room[y+1]
  for x=0,map_w-1 do
   local ch=sub(row,x+1,x+1)
   map_tiles[y][x]=t_chars[ch] or 0
   if s_chars[ch] then
    add(spawn_pts,{
     type=s_chars[ch],tx=x,ty=y
    })
   end
  end
 end
end

-- === tile helpers ===

function get_tile(tx,ty)
 if tx<0 or tx>=map_w
 or ty<0 or ty>=map_h then
  return 1 -- out of bounds=solid
 end
 return map_tiles[ty][tx]
end

function solid_at(wx,wy)
 return get_tile(
  flr(wx/tile_sz),
  flr(wy/tile_sz))==1
end

-- find ground y below tile pos
function find_ground(tx,ty)
 for y=ty+1,map_h-1 do
  if get_tile(tx,y)==1 then
   return y*tile_sz
  end
 end
 return map_h*tile_sz
end

-- === tile collision ===

function collide_x(obj)
 local ty1=flr(obj.y/tile_sz)
 local ty2=flr((obj.y+obj.h-1)/tile_sz)
 -- right
 local rtx=flr((obj.x+obj.w)/tile_sz)
 for ty=ty1,ty2 do
  if get_tile(rtx,ty)==1 then
   obj.x=rtx*tile_sz-obj.w
   if obj.vx and obj.vx>0 then
    obj.vx=0
   end
   break
  end
 end
 -- left
 local ltx=flr(obj.x/tile_sz)
 for ty=ty1,ty2 do
  if get_tile(ltx,ty)==1 then
   obj.x=(ltx+1)*tile_sz
   if obj.vx and obj.vx<0 then
    obj.vx=0
   end
   break
  end
 end
end

function collide_y(obj)
 if obj.vy>=0 then
  -- falling: solid + platform
  local by=obj.y+obj.h
  local prev_by=by-obj.vy
  local tx1=flr(obj.x/tile_sz)
  local tx2=flr((obj.x+obj.w-1)/tile_sz)
  local ty=flr(by/tile_sz)
  for tx=tx1,tx2 do
   local t=get_tile(tx,ty)
   if t==1 then
    obj.y=ty*tile_sz-obj.h
    obj.vy=0
    obj.grounded=true
    return
   elseif t==2
   and prev_by<=ty*tile_sz then
    obj.y=ty*tile_sz-obj.h
    obj.vy=0
    obj.grounded=true
    return
   end
  end
 elseif obj.vy<0 then
  -- rising: solid only
  local tx1=flr(obj.x/tile_sz)
  local tx2=flr((obj.x+obj.w-1)/tile_sz)
  local ty=flr(obj.y/tile_sz)
  for tx=tx1,tx2 do
   if get_tile(tx,ty)==1 then
    obj.y=(ty+1)*tile_sz
    obj.vy=0
    return
   end
  end
 end
end

-- edge detection for enemies
function at_edge(obj,dir)
 if not obj.grounded then return false end
 local cx=dir==1 and obj.x+obj.w+2
  or obj.x-2
 local cy=obj.y+obj.h+1
 return get_tile(
  flr(cx/tile_sz),
  flr(cy/tile_sz))~=1
end

-- === spawn from map ===

function spawn_from_map()
 enemies={}
 e_projs={}
 for sp in all(spawn_pts) do
  local wx=sp.tx*tile_sz
  local gy=find_ground(sp.tx,sp.ty)
  if sp.type=="player" then
   p.x=wx
   p.y=gy-p.h
  elseif sp.type=="grunt" then
   spawn_grunt(wx,gy-16)
  elseif sp.type=="crawler" then
   spawn_crawler(wx,gy-8)
  elseif sp.type=="lurker" then
   spawn_lurker(wx,sp.ty*tile_sz)
  elseif sp.type=="turret" then
   spawn_turret(wx,gy-16)
  end
 end
end

-- === draw ===

function draw_room()
 for y=0,map_h-1 do
  for x=0,map_w-1 do
   local t=map_tiles[y][x]
   local px=x*tile_sz
   local py=y*tile_sz
   if t==1 then
    rectfill(px,py,
     px+tile_sz-1,py+tile_sz-1,5)
    if get_tile(x,y-1)~=1 then
     line(px,py,px+tile_sz-1,py,6)
    end
   elseif t==2 then
    line(px,py,px+tile_sz-1,py,6)
    line(px,py+1,px+tile_sz-1,py+1,5)
   end
  end
 end
end
