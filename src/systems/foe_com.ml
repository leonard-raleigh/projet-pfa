open Ecs
open Component_defs

type t = foe

let init _ = ()

let update dt el =
  let cam = Global.camera () in
  Seq.iter (fun (e:t) ->
    let Vector.{x;y} = e#position#get in
    if y < cam -. (float Cst.window_height) then ()
    else (
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
      | _ -> ()
    )
    ) el