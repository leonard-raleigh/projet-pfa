open Ecs
open Component_defs

type t = gravitable

let init _ = ()

let update _ el =
  Seq.iter (fun (e:t) ->

    (* if not e#on_ground#get then ( *)
      let Vector.{x; y} = e#velocity#get in
      let f = e#floatiness#get in
      let friction = if e#on_wall#get <> 0 && y > 0.0 then Cst.friction else 1.0 in
      let acc = Cst.gravity *. (1.0 -. f) *. friction in
      let v_max = Cst.max_fall_speed *. (1.0 -. f) *. friction in
      let new_dy = if y +. acc > v_max then v_max else y +. acc in
      e#velocity#set Vector.{x = x; y = new_dy};
    (* ); *)

    e#on_ground#set false;
    e#on_wall#set 0;

    ) el