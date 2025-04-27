open Component_defs

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable cam_y : float;
  txt_tbl : (string, Texture.t) Hashtbl.t;
}

let state = ref None

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s

let set s = state := Some s

let set_camera y =
  let g = get () in
  g.cam_y <- y

let camera () =
  let g = get () in
  g.cam_y

let get_texture name =
  let g = get () in
  try
    Hashtbl.find g.txt_tbl name
  with Not_found ->
    failwith (Printf.sprintf "Texture %s not found" name)