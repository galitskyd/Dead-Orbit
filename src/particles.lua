-- === helpers ===
particles={}

function spawn_dust(x,y)
 for i=1,5 do
  add(particles,{
   x=x+rnd(16),
   y=y,
   vx=rnd(2)-1,
   vy=-rnd(1),
   life=10+flr(rnd(8)),
   c=6
  })
 end
end

function spawn_smoke(x,y,dir)
 for i=1,4 do
  local l=12+flr(rnd(8))
  add(particles,{
   x=x+rnd(2)-1,
   y=y+rnd(2)-1,
   vx=dir*rnd(0.3),
   vy=-0.2-rnd(0.3),
   life=l,maxlife=l,
   c=7,
   fade={7,6,5}
  })
 end
end

function spawn_impact(x,y)
 for i=1,6 do
  add(particles,{
   x=x,
   y=y,
   vx=rnd(2)-1,
   vy=rnd(2)-1,
   life=6+flr(rnd(6)),
   c=10
  })
 end
end

function update_particles()
 for pt in all(particles) do
  pt.x+=pt.vx
  pt.y+=pt.vy
  if not pt.fade then
   pt.vy+=0.05
  end
  pt.life-=1
  if pt.fade then
   local f=pt.fade
   local pct=pt.life/pt.maxlife
   if pct<0.33 then pt.c=f[3]
   elseif pct<0.66 then pt.c=f[2]
   else pt.c=f[1]
   end
  elseif pt.life<4 then pt.c=5 end
  if pt.life<=0 then del(particles,pt) end
 end
end

function draw_particles()
 for pt in all(particles) do
  pset(pt.x,pt.y,pt.c)
 end
end
