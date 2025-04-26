open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable cam_y : float;
}

val get : unit -> t
val set : t -> unit

val set_camera : float -> unit
val camera : unit -> float
