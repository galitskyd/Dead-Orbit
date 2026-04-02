-- === camera ===
cam_x=0

function init_camera()
 cam_x=0
end

function update_camera()
 -- screen-space position of player
 local sx=p.x-cam_x

 -- deadzone edges (inner 80% of 128px screen)
 local margin=128*(1-cam_dz)/2 -- 12.8px
 local dz_l=margin
 local dz_r=128-margin-p.w

 -- push camera if player exits deadzone
 if sx<dz_l then
  cam_x=p.x-dz_l
 elseif sx>dz_r then
  cam_x=p.x-dz_r
 end

 -- clamp to level bounds
 cam_x=mid(0,cam_x,lvl_w-128)
end
