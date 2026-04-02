-- === room / map ===
function draw_room()
 -- floor (full level width)
 rectfill(0,rm_f,lvl_w-1,lvl_h-1,5)
 -- ceiling
 rectfill(0,0,lvl_w-1,rm_t-1,5)
 -- left wall
 rectfill(0,0,rm_l-1,lvl_h-1,5)
 -- right wall
 rectfill(rm_r,0,lvl_w-1,lvl_h-1,5)
 -- edge highlights
 line(rm_l,rm_f,rm_r-1,rm_f,6)
 line(rm_l,rm_t,rm_r-1,rm_t,6)
 line(rm_l,rm_t,rm_l,rm_f,6)
 line(rm_r-1,rm_t,rm_r-1,rm_f,6)
end
