open Ecs
open Component_defs
open System_defs


let create (x, y, v, width, height, mass, perish, lifetime, player) =
  let e = new bullet () in
  if player then e#texture#set (Global.get_texture "player_bullet.png")
  else e#texture#set (Global.get_texture "enemy_bullet.png");
  e#position#set Vector.{x= x;y =  y};
  e#velocity#set v;
  e#box#set Rect.{width;height};
  e#mass#set mass;
  e#tag#set (Bullet player);

  e#resolve#set (fun pv tag ->
      match tag with
      | Wall | Enemy _ ->
        if player then Entity.delete e else ()
      | _ -> ());
  if perish then (
    e#lifetime#set lifetime;
    Perish_system.(register (e:>t));
  );
  Collision_system.(register (e:>t));
  Move_system.(register (e:>t));
  Draw_system.(register (e:>t));
  e



