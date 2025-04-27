open Ecs
open Component_defs

type t = playable

let init _ = ()

let invincibility = ref (false, 0.0)


let jump (e:t) =
  let Vector.{x;y} = e#velocity#get in
  if e#on_ground#get then (
    (* e#on_ground#set false; *)
    let new_v = Vector.{x = x; y = Cst.jump_force} in
    e#velocity#set new_v;
    true
  ) else if e#on_wall#get < 0 then (
    e#on_wall#set 0;
    let new_v = Vector.{x = x; y = Cst.jump_force} in
    e#velocity#set new_v;
    e#position#set (Vector.add e#position#get Vector.{x = 15.0; y = 0.0});
    e#facing#set 1;
    true
  ) else if e#on_wall#get > 0 then (
    e#on_wall#set 0;
    let new_v = Vector.{x = x; y = Cst.jump_force} in
    e#velocity#set new_v;
    e#position#set (Vector.add e#position#get Vector.{x = -15.0; y = 0.0});
    e#facing#set (-1);
    true
  ) else (
    let jc = e#jump_count#get in
    if jc < e#double_jumps#get then (
      let new_v = Vector.{x = x; y = Cst.jump_force} in
      e#velocity#set new_v;
      e#jump_count#set (jc + 1);
      true
    ) else false
  )
  

let update dt el =
  Seq.iter (fun (e:t) ->

    if not e#stunned#get then (
      
      if Input.has_key Cst.jump_button then (
        if e#will_jump#get then (
          if jump e then (
            e#will_jump#set false;
            e#jump_timer#set 0.0;
          )
        ) else (
          let jtimer = e#jump_timer#get in
          if jtimer < Cst.max_jump_duration then (
            let Vector.{x; y} = e#velocity#get in
            let new_v = Vector.{x = x; y = Cst.jump_force} in
            e#velocity#set new_v;
            e#jump_timer#set (jtimer +. (dt -. !timer));
          );
        );
      ) else (
        e#will_jump#set true;
        e#jump_timer#set 0.0;
      );
  
      if Input.has_key Cst.left_button then (
        e#facing#set (-1);
        let Vector.{x; y} = e#position#get in
        e#position#set Vector.{x = x -. Cst.player_speed; y = y};
      );
      if Input.has_key Cst.right_button then (
        e#facing#set 1;
        let Vector.{x; y} = e#position#get in
        e#position#set Vector.{x = x +. Cst.player_speed; y = y};
      );
    
      if Input.has_key Cst.shoot_button then (
        if e#will_shoot#get && (e#reload_timer#get <= 0.0) then (
          e#will_shoot#set false;
          e#reload_timer#set Cst.bullet_reload_time;
          let Vector.{x; y} = e#position#get in
          let x_offset = if e#facing#get > 0 then (float Cst.player_hitbox_width) else 0.0 in
          let v = Vector.{x = (float e#facing#get) *. Cst.bullet_speed; y = 0.0} in
          let _ = Bullet.create ((x +. x_offset), (y +. (float Cst.player_hitbox_height) /. 2.0),
                                v, Cst.bullet_size, Cst.bullet_size, 1.0, true, Cst.bullet_lifetime, true) in
  
          e#position#set Vector.{x = x -. (float e#facing#get) *. Cst.bullet_knockback; y = y};
        )
      ) else (
        e#will_shoot#set true;
      );

      if e#jump_count#get < 1 then (
        e#texture#set Cst.player_sprite;
        e#tag#set (Player false);
      ) else (
        e#texture#set Cst.double_jump_sprite;
        e#tag#set (Player true);
      );
      ) else (
        e#texture#set Cst.player_stunned_sprite;
      );


    if e#reload_timer#get > 0.0 then (
      e#reload_timer#set (e#reload_timer#get -. (dt -. !timer));
    );


    if e#invicible_timer#get > 0.0 then (
      e#invicible_timer#set (e#invicible_timer#get -. (dt -. !timer));
      let (b, t) = !invincibility in
      let sprite = if b then Cst.player_invincible_sprite else e#texture#get in
      e#texture#set sprite;
      if t > 0.0 then (
        invincibility := (b, t -. (dt -. !timer));
      ) else (
        invincibility := (not b, Cst.invincibility_sprite_delay);
      )
    );


    let target_y = e#position#get.y -. (float Cst.window_height) /. 2.0 in
    let max_cam_y = (float Cst.window_height) /.20. in
    let new_cam_y =
      if target_y > max_cam_y then
        max_cam_y
      else target_y
    in
    let cam = Global.camera () in
    let alpha = if target_y < cam then Cst.up_alpha else Cst.down_alpha in
    Global.set_camera (cam +. (new_cam_y -. cam) *. alpha);

    player_x := e#position#get.x;
    player_y := e#position#get.y;
    
     
    Printf.printf "jump_count: %d\njump_timer: %f\non_ground: %b\n%!" e#jump_count#get e#jump_timer#get e#on_ground#get;
    ) el;