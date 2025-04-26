open Ecs
open Component_defs
open System_defs


let create (x, y, v, txt, width, height, mass, perish, lifetime) =
  let e = new bullet () in
  e#texture#set txt;
  e#position#set Vector.{x= x;y =  y};
  e#velocity#set v;
  e#box#set Rect.{width;height};
  e#mass#set mass;
  e#tag#set Bullet;
  e#resolve#set (fun pv tag ->
      match tag with
      | Wall _ | Enemy _ ->
        Entity.delete e
      | _ -> ());
  if perish then (
    e#lifetime#set lifetime;
    Perish_system.(register (e:>t));
  );
  Collision_system.(register (e:>t));
  Move_system.(register (e:>t));
  Draw_system.(register (e:>t));
  e



