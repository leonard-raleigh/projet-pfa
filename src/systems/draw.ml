open Ecs
open Component_defs


type t = drawable

let init _ = ()

let white = Gfx.color 200 200 200 255

let draw_function ctx surface cam_y el =
  Seq.iter (fun (e:t) ->
   let pos = Vector.add e#position#get Vector.{x = 0.0; y = 0.0-.cam_y} in
   let box = e#box#get in
   let txt = e#texture#get in
   Format.eprintf "%a\n%!" Vector.pp e#position#get;
   Texture.draw ctx surface pos box txt
 ) el


let update _dt el =
  let Global.{window;ctx;cam_y} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  Gfx.set_color ctx white;
  Gfx.fill_rect ctx surface 0 0 ww wh;
  draw_function ctx surface cam_y (Seq.filter (fun e -> e#tag#get = Wall) el);
  draw_function ctx surface cam_y (Seq.filter (fun e -> e#tag#get <> Wall) el);
  Gfx.commit ctx
