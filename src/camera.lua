-- === camera ===
cam_x=0

function init_camera()
 cam_x=mid(0,p.x-64,lvl_w-128)
end

function update_camera()
 local sx=p.x-cam_x
 local dz_l,dz_r
 if p.facing==1 then
  -- facing right: push player left so more room ahead
  dz_l=30
  dz_r=128-55-p.w
 else
  -- facing left: push player right
  dz_l=55
  dz_r=128-30-p.w
 end

 if sx<dz_l then
  cam_x=p.x-dz_l
 elseif sx>dz_r then
  cam_x=p.x-dz_r
 end

 cam_x=mid(0,cam_x,lvl_w-128)
end
