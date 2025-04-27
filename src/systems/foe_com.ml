open Ecs
open Component_defs

type t = foe

let init _ = ()

let next_sprite typ i b =
  let rev = if not b then "-reversed" else "" in
  match typ with
  | Enemy Frog -> Printf.sprintf "frog-%d%s.png" i rev
  | Enemy Bat -> Printf.sprintf "bat-%d%s.png" i rev
  | Enemy Fly -> Printf.sprintf "fly-%d.png" i
  | _ -> "frog-1.png"


let update dt el =
  let cam = Global.camera () in
  Seq.iter (fun (e:t) ->
    let Vector.{x;y} = e#position#get in
    if y < cam -. (float Cst.window_height) then ()
    else (
      e#animation_timer#set (e#animation_timer#get +. (dt -. !timer));
      if e#animation_timer#get >= Cst.animation_delay then (
        let i = e#sprite_index#get in
        let b = e#facing#get < 0 in
        let new_sprite = next_sprite (e#tag#get) i b in
        e#texture#set (Global.get_texture new_sprite);
        e#sprite_index#set (if i < 6 then i + 1 else 1);
        e#animation_timer#set 0.0;
      );
      match e#tag#get with
      | Enemy Frog ->
        if e#on_ground#get then (
          if e#jump_timer#get <= 0.0 then (
            e#velocity#set Vector.{x = (float e#facing#get) *. Cst.frog_jump_force; y = -. Cst.frog_jump_force *. 2.0};
            e#on_ground#set false;
            e#jump_timer#set (Cst.frog_jump_delay);
          ) else (
            e#jump_timer#set (e#jump_timer#get -. (dt -. !timer));
          )
        );
      | Enemy Bat ->
        let new_x =
          if x < !player_x -. 5.0 then (
            e#facing#set 1;
            Cst.bat_speed
          ) else if x > !player_x +. 5.0 then (
            e#facing#set (-1);
            (-. Cst.bat_speed)
          ) else 0.0
        in
        let new_y =
          if y < !player_y -. 5.0 then
            Cst.bat_speed
          else if y > !player_y +. 5.0 then
            (-. Cst.bat_speed)
          else 0.0
        in
        e#velocity#set Vector.{x = new_x; y = new_y};
      | Enemy Fly ->
        if e#facing#get = 1 then (
          if x < (float Cst.window_width) *. 0.9 then (
            e#velocity#set Vector.{x = ((float Cst.window_width) -. x) *. Cst.fly_speed_factor; y = 3.0 *. (sin (x *. 0.01) *. 0.5)};
          ) else (
            e#facing#set (-1);
            let _ = Bullet.create ((x +. (float Cst.fly_hitbox_width) /. 2.), (y +. (float Cst.fly_hitbox_height) /. 2.0),
                                (Vector.mult (-. Cst.fly_bullet_speed) (Vector.normalize Vector.{x = x -. !player_x; y = y -. !player_y})),
                                Cst.bullet_size, Cst.bullet_size, 1.0, true, 5.0 *. Cst.bullet_lifetime, false) in
            ()
          )
        ) else (
          if x > (float Cst.window_width) *. 0.1 then (
            e#velocity#set Vector.{x = (-. x) *. Cst.fly_speed_factor; y = 3.0 *. (sin (x *. 0.01) *. 0.5) -. 0.5};
          ) else (
            e#facing#set 1;
            let _ = Bullet.create ((x +. (float Cst.fly_hitbox_width) /. 2.), (y +. (float Cst.fly_hitbox_height) /. 2.0),
                                (Vector.mult (-. Cst.fly_bullet_speed) (Vector.normalize Vector.{x = x -. !player_x; y = y -. !player_y})),
                                Cst.bullet_size, Cst.bullet_size, 1.0, true, 5.0 *. Cst.bullet_lifetime, false) in
            ()
          ) 
        )
      | _ -> ()
    )
    ) el