-- === camera ===
cam_x=0

function init_camera()
 -- snap camera so player is on the
 -- trailing side, showing ahead
 if lvl_dir==1 then
  cam_x=p.x-30
 else
  cam_x=p.x-82
 end
 cam_x=mid(0,cam_x,lvl_w-128)
end

function update_camera()
 local sx=p.x-cam_x

 -- asymmetric deadzone: player stays
 -- in back 30%, sees 70% ahead
 local dz_l,dz_r
 if lvl_dir==1 then
  -- going right: player near left edge
  dz_l=20
  dz_r=48
 else
  -- going left: player near right edge
  dz_l=128-48-p.w
  dz_r=128-20-p.w
 end

 if sx<dz_l then
  cam_x=p.x-dz_l
 elseif sx>dz_r then
  cam_x=p.x-dz_r
 end

 cam_x=mid(0,cam_x,lvl_w-128)
end
