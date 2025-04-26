open System_defs
open Component_defs
open Play_system_def
open Ecs


let init dt =
  Ecs.System.init_all dt;
  Some ()



let update dt =
  let () = Input.handle_input () in
  Perish_system.update dt;
  Play_system.update dt;
  Foe_com_system.update dt;
  Gravity_system.update dt;
  Move_system.update dt;  
  Collision_system.update dt;
  Die_system.update dt;
  Draw_system.update dt;
  timer := dt;
  None

let (let@) f k = f k


let run () =
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
  let _walls = Wall.walls () in
  let global = Global.{ window; ctx; cam_y = 0.0 } in
  Global.set global;
  let _ = Player.create (Cst.window_width / 2, Cst.window_height - Cst.wall_thickness*2) in
  let _ = Enemy.create (Cst.window_width / 2 - 40, Cst.window_height - Cst.wall_thickness*2 - 40, Vector.zero, Cst.frog_sprite, Cst.frog_hitbox_width, Cst.frog_hitbox_height, 0.0, Frog) in
  let _ = Enemy.create (Cst.window_width / 2 + 40, Cst.window_height - Cst.wall_thickness*2 - 200, Vector.zero, Cst.bat_sprite, Cst.bat_hitbox_width, Cst.bat_hitbox_height, 0.0, Bat) in
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in ()








