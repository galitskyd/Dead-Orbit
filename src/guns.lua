-- === guns & pickups ===
pickups={}

function equip_gun(def)
 p.gun=def
 p.ammo=def.max
 p.gun_cd=0
 p.reloading=false
 p.reload_t=0
end

function spawn_gun_drop(x,y,gun_id)
 add(pickups,{
  x=x,y=y,w=8,h=8,
  gun_id=gun_id,
  bob_t=0
 })
end

function update_pickups()
 for pk in all(pickups) do
  pk.bob_t+=1
  -- check player overlap
  if box_hit(p.x,p.y,p.w,p.h,
             pk.x,pk.y,pk.w,pk.h) then
   -- drop current gun
   local old_id=p.gun_id
   if old_id~="revolver" then
    spawn_gun_drop(pk.x,pk.y+4,old_id)
   end
   -- equip new gun
   p.gun_id=pk.gun_id
   equip_gun(gun_defs[pk.gun_id])
   del(pickups,pk)
   sfx(1)
  end
 end
end

function draw_pickups()
 for pk in all(pickups) do
  local by=pk.y+sin(pk.bob_t/60)*2
  local def=gun_defs[pk.gun_id]
  if pk.gun_id=="auto" then
   -- auto gun: small dark rect with barrel
   rectfill(pk.x,by+1,pk.x+7,by+5,5)
   rectfill(pk.x+5,by+2,pk.x+9,by+3,6)
   pset(pk.x+1,by+5,13)
  else
   -- revolver: small shape
   rectfill(pk.x,by+2,pk.x+6,by+5,4)
   rectfill(pk.x+4,by+1,pk.x+8,by+3,9)
  end
 end
end

-- draw gun at end of player model
function draw_player_gun()
 if not p.gun then return end
 local gx,gy
 if p.facing==1 then
  gx=p.x+p.w-2
 else
  gx=p.x-6
 end
 gy=p.y+8
 if p.crouching then gy=p.y+10 end
 if p.sliding then return end -- no gun visible during slide

 if p.gun_id=="auto" then
  -- auto gun barrel
  if p.facing==1 then
   rectfill(gx,gy,gx+7,gy+2,6)
   rectfill(gx,gy+2,gx+4,gy+4,5)
  else
   rectfill(gx,gy,gx+7,gy+2,6)
   rectfill(gx+3,gy+2,gx+7,gy+4,5)
  end
 end
 -- revolver uses the sprite's built-in gun, no extra draw
end
