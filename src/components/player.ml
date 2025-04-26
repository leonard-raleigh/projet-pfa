open Ecs
open Component_defs
open System_defs
open Play_system_def

let create (x, y) =
  let p = new player () in
  p#texture#set Cst.player_sprite;
  p#position#set Vector.{x=float x;y = float y};
  p#velocity#set Vector.zero;
  p#box#set Rect.{width = Cst.player_hitbox_width; height = Cst.player_hitbox_height};
  p#forces#set Vector.zero;
  p#tag#set (Player false);
  p#hp#set Cst.player_hp;
  p#stunned#set false;
  p#resolve#set (fun pv tag ->
      match tag with
      | Wall b ->
        let pv = if b then pv else Vector.{x = -.pv.x; y = -.pv.y} in
        if abs_float pv.x > abs_float pv.y then (
          p#position#set Vector.{x = p#position#get.x -. pv.x; y = p#position#get.y};
          p#velocity#set Vector.{x = 0.0; y = p#velocity#get.y};
          (if not p#on_ground#get then
            if pv.x > 0.0 then
              p#on_wall#set 1
            else
              p#on_wall#set (-1));
            p#jump_count#set (0)
        ) else (
          p#position#set Vector.{x = p#position#get.x; y = p#position#get.y -. pv.y};
          p#velocity#set Vector.{x = if pv.y > 0.0 then 0.0 else p#velocity#get.x; y = 0.0};
          if pv.y > 0.0 then (
            p#on_ground#set true;
            p#jump_count#set (0);
            p#stunned#set false;
          )
        )
        
      | Ground ->
        if abs_float pv.x > abs_float pv.y then (
          p#position#set Vector.{x = p#position#get.x +. pv.x; y = p#position#get.y};
          p#velocity#set Vector.{x = 0.0; y = p#velocity#get.y};
          (if not p#on_ground#get then
            if pv.x < 0.0 then
              p#on_wall#set 1
            else
              p#on_wall#set (-1));
            p#jump_count#set (0)
        ) else (
          p#position#set Vector.{x = p#position#get.x; y = p#position#get.y +. pv.y};
          p#velocity#set Vector.{x = 0.0; y = 0.0};
          if pv.y < 0.0 then (
            p#on_ground#set true;
            p#jump_count#set (0);
            p#stunned#set false;
          )
        )
      | Enemy _ ->
        if not p#stunned#get then (
          if p#jump_count#get < 1 then (
            p#hp#set (p#hp#get - 1);
            p#stunned#set true;
            p#texture#set Cst.player_stunned_sprite;
            let x_knockback = if pv.x < 0.0 then (-1.0) else 1.0 in
            p#velocity#set Vector.{x = x_knockback *. Cst.player_hit_knockback; y = 0.0 -. 2.0  *. Cst.player_hit_knockback}
          ) else (
            let y_factor = if pv.y > 0.0 then (-1.0) else 1.0 in
            let y_bounce = if Input.has_key Cst.jump_button then 1.65 else 1.1 in
            p#velocity#set Vector.{x = p#velocity#get.x; y = y_bounce *. Cst.jump_force *. y_factor}
          )
        )
      | _ -> ());
  p#mass#set Cst.player_mass; 
  p#floatiness#set Cst.player_floatiness;
  p#double_jumps#set Cst.double_jumps;
  Collision_system.(register (p:>t));
  Gravity_system.(register (p:>t));
  Play_system.(register (p:>t));
  Move_system.(register (p:>t));
  Draw_system.(register (p:>t));
  p
