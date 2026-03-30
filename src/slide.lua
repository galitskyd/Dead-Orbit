-- === slide ===

function init_slide()
 p.sliding=false
 p.slide_t=0
 p.iframe_t=0
 p.slide_cd=0
 p.slide_dir=1
 p.slide_v=0
end

function start_slide()
 if p.sliding or not p.grounded
 or p.slide_cd>0 then return end
 p.sliding=true
 p.slide_t=slide_dur
 p.iframe_t=slide_iframes
 p.slide_dir=p.facing
 p.slide_v=slide_spd
 spawn_dust(p.x+p.w/2,p.y+p.h)
end

function update_slide()
 -- cooldown tick
 if p.slide_cd>0 then
  p.slide_cd-=1
 end

 -- iframe tick (can outlast slide)
 if p.iframe_t>0 then
  p.iframe_t-=1
 end

 if not p.sliding then return end

 p.slide_t-=1
 p.slide_v*=(1-slide_fric)
 p.vx=p.slide_v*p.slide_dir

 -- wall stop
 if p.x<=rm_l or p.x+p.w>=rm_r then
  p.sliding=false
  p.slide_cd=slide_cd_max
  p.vx=0
  return
 end

 if p.slide_t<=0 then
  p.sliding=false
  p.slide_cd=slide_cd_max
  p.vx=0
 end
end
