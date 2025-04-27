open Component_defs
(* A module to initialize and retrieve the global state *)
type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable cam_y : float;
  txt_tbl : (string, Texture.t) Hashtbl.t;
}

val get : unit -> t
val set : t -> unit

val set_camera : float -> unit
val camera : unit -> float
val get_texture : string -> Texture.t