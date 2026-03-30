-- === helpers ===
particles={}

function spawn_dust(x,y)
 for i=1,5 do
  add(particles,{
   x=x+rnd(8),
   y=y,
   vx=rnd(2)-1,
   vy=-rnd(1),
   life=10+flr(rnd(8)),
   c=6
  })
 end
end

function update_particles()
 for pt in all(particles) do
  pt.x+=pt.vx
  pt.y+=pt.vy
  pt.vy+=0.05
  pt.life-=1
  if pt.life<4 then pt.c=5 end
  if pt.life<=0 then del(particles,pt) end
 end
end

function draw_particles()
 for pt in all(particles) do
  pset(pt.x,pt.y,pt.c)
 end
end
