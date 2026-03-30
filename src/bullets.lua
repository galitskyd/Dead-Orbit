-- === bullets ===
bullets={}

function spawn_bullet()
 local bx=p.x+p.w/2
 local by=p.y+p.h/2
 local bvx=blt_spd*p.facing
 local bvy=0

 -- offset spawn to front of player
 if p.facing==1 then
  bx=p.x+p.w+1
 else
  bx=p.x-5
 end

 -- angled shot during slide
 if p.sliding then
  bvy=slide_shot_vy
 end

 -- adjust spawn y for crouch
 if p.crouching then
  by=p.y+p.h/2+2
 end

 add(bullets,{
  x=bx,y=by,
  vx=bvx,vy=bvy,
  life=blt_life
 })
 spawn_smoke(bx,by,p.facing)
end

function update_bullets()
 for b in all(bullets) do
  b.x+=b.vx
  b.y+=b.vy
  b.life-=1
  -- wall/ceiling/floor collision
  if b.x<rm_l or b.x>rm_r
  or b.y<rm_t or b.y>rm_f then
   spawn_impact(b.x,b.y)
   del(bullets,b)
  elseif b.life<=0 then
   del(bullets,b)
  end
 end
end

function draw_bullets()
 for b in all(bullets) do
  spr(blt_spr,b.x-4,b.y-4,1,1,b.vx<0)
 end
end
