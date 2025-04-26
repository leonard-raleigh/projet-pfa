open Ecs
open Component_defs
open System_defs


let create (x, y, v, txt, width, height, floatiness, typ) =
  let e = new enemy () in
  e#tag#set (Enemy typ);
  e#texture#set txt;
  e#position#set Vector.{x=float x;y = float y};
  e#velocity#set v;
  e#box#set Rect.{width;height};
  e#mass#set 1.0;
  e#floatiness#set floatiness;
  e#hp#set 2;
  let f_rand = Random.int 2 in
  (match f_rand with
  | 0 -> e#facing#set (-1)
  | 1 -> e#facing#set 1
  | _ -> e#facing#set (-1));
  e#resolve#set (fun pv tag ->
    match tag with
    | Wall b ->
      let pv = if b then pv else Vector.{x = -.pv.x; y = -.pv.y} in
      if abs_float pv.x > abs_float pv.y then (
        e#position#set Vector.{x = e#position#get.x -. pv.x; y = e#position#get.y};
        e#velocity#set Vector.{x = (match typ with
          | Frog -> e#facing#set ((-1) * e#facing#get); -. e#velocity#get.x
          | _ -> 0.0)
          ;
            y = e#velocity#get.y};
        (if not e#on_ground#get then
          if pv.x > 0.0 then
            e#on_wall#set 1
          else
            e#on_wall#set (-1));
      ) else (
        e#position#set Vector.{x = e#position#get.x; y = e#position#get.y -. pv.y};
        let newv_x = match typ with
          | Bat -> e#velocity#get.x
          | _ -> if pv.y > 0.0 then 0.0 else e#velocity#get.x
        in
        e#velocity#set Vector.{x = newv_x; y = 0.0};
        if pv.y > 0.0 then (
          e#on_ground#set true;
        )
      )
    | Bullet | Player true ->
      e#hp#set (e#hp#get - 1);
    | _ -> ());
  Foe_com_system.(register (e:>t));
  Die_system.(register (e:>t));
  Gravity_system.(register (e:>t));
  Collision_system.(register (e:>t));
  Move_system.(register (e:>t));
  Draw_system.(register (e:>t));
  e



