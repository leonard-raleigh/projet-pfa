open Component_defs

type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable cam_y : float;
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