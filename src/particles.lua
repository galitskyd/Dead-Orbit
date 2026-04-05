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

function spawn_explosion(x,y)
 -- bright core burst
 for i=1,12 do
  local a=rnd(1) -- random angle
  local spd=0.5+rnd(2)
  local l=10+flr(rnd(12))
  add(particles,{
   x=x,y=y,
   vx=cos(a)*spd,
   vy=sin(a)*spd,
   life=l,maxlife=l,
   c=10,
   fade={10,9,8}
  })
 end
 -- hot sparks that fly further
 for i=1,6 do
  local a=rnd(1)
  local spd=1.5+rnd(2)
  add(particles,{
   x=x,y=y,
   vx=cos(a)*spd,
   vy=sin(a)*spd-0.5,
   life=14+flr(rnd(8)),
   c=10
  })
 end
 -- lingering smoke puffs
 for i=1,5 do
  local l=18+flr(rnd(10))
  add(particles,{
   x=x+rnd(6)-3,
   y=y+rnd(6)-3,
   vx=rnd(0.4)-0.2,
   vy=-0.3-rnd(0.3),
   life=l,maxlife=l,
   c=6,
   fade={6,5,1}
  })
 end
 -- sfx placeholder: crawler explosion
 sfx(2)
end

function spawn_nade_explosion(x,y)
 -- tall vertical column
 for i=1,20 do
  local l=15+flr(rnd(15))
  add(particles,{
   x=x+rnd(8)-4,y=y,
   vx=rnd(1)-0.5,
   vy=-1.5-rnd(4),
   life=l,maxlife=l,
   c=10,fade={10,9,8}
  })
 end
 -- downward splash
 for i=1,8 do
  local l=10+flr(rnd(8))
  add(particles,{
   x=x+rnd(6)-3,y=y,
   vx=rnd(1)-0.5,
   vy=0.5+rnd(2),
   life=l,maxlife=l,
   c=9,fade={9,8,2}
  })
 end
 -- medium horizontal spread
 for i=1,14 do
  local l=10+flr(rnd(10))
  add(particles,{
   x=x,y=y+rnd(4)-2,
   vx=rnd(4)-2,
   vy=-rnd(1),
   life=l,maxlife=l,
   c=10,fade={10,9,5}
  })
 end
 -- plasma sparks
 for i=1,8 do
  local a=rnd(1)
  local l=8+flr(rnd(8))
  add(particles,{
   x=x,y=y,
   vx=cos(a)*1.5,
   vy=sin(a)*1.5-1,
   life=l,maxlife=l,
   c=12,fade={12,13,1}
  })
 end
 sfx(2)
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
