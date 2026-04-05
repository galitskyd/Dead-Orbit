-- === parallax stars ===
star_layers={}

function init_stars()
 star_layers={}
 local defs={
  {n=30,spd=0.1,c=1},  -- far: dark blue, slow
  {n=20,spd=0.3,c=13}, -- mid: indigo, medium
  {n=12,spd=0.5,c=6}   -- near: light gray, fast
 }
 for d in all(defs) do
  local layer={spd=d.spd,c=d.c,stars={}}
  for i=1,d.n do
   add(layer.stars,{
    x=flr(rnd(128)),
    y=flr(rnd(128))
   })
  end
  add(star_layers,layer)
 end
end

function draw_stars()
 for l in all(star_layers) do
  local ox=cam_x*l.spd
  for s in all(l.stars) do
   local sx=(s.x-ox%128+128)%128
   pset(sx+cam_x,s.y,l.c)
  end
 end
end
