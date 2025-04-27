open System_defs
open Component_defs
open Play_system_def
open Ecs


let init dt =
  Ecs.System.init_all dt;
  Some ()


let spawn_vague f =
  let y = int_of_float (f -. 300.) in
  match f with
  | -100.0 -> (* Handle case for 0.0 *)
    Enemy.spawn (100, y) Fly;
    Enemy.spawn (300, y - 100) Fly;
    ()
  | -300.0 -> (* Handle case for -300.0 *)
    Enemy.spawn (300, y) Bat
  | -600.0 -> (* Handle case for -600.0 *)
    ()
  | -900.0 -> (* Handle case for -900.0 *)
    Enemy.spawn (100, y) Bat;
    Enemy.spawn (400, y - 100) Bat;
    ()
  | -1200.0 -> (* Handle case for -1200.0 *)
    Enemy.spawn (200, y) Fly;
    Enemy.spawn (400, y - 100) Fly;
    Enemy.spawn (600, y - 200) Fly;
  | -1500.0 -> (* Handle case for -1500.0 *)
    ()
  | -1800.0 -> (* Handle case for -1800.0 *)
    ()
  | _ -> (* Handle default case *)
    ()

let threshold = ref [-.100.; -.300.; -.600.; -.900.; -.1200.; -.1500.; -.1800.]


let update dt =
  let () = Input.handle_input () in
  Perish_system.update dt;
  Play_system.update dt;
  Foe_com_system.update dt;
  Gravity_system.update dt;
  Move_system.update dt;  
  Collision_system.update dt;
  Die_system.update dt;
  Draw_system.update dt;
  timer := dt;
  if !threshold <> [] && !player_y < (List.hd !threshold) then (
    let () = spawn_vague (List.hd !threshold) in
    threshold := List.tl !threshold;
  );
  None

let (let@) f k = f k




let run () =
  let window_spec = 
    Format.sprintf "game_canvas:%dx%d:"
      Cst.window_width Cst.window_height
  in
  let window = Gfx.create  window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in

  let tileset = Gfx.load_file "resources/tileset.txt" in
  let texture_tbl = Hashtbl.create 10 in

  Gfx.main_loop
    (fun _dt -> Gfx.get_resource_opt tileset)
    (fun txt ->
       let image_files =
         txt
         |> String.split_on_char '\n'
         |> List.filter (fun s -> s <> "")
       in

       let images_r =
         image_files
         |> List.map (fun filename -> 
              let image = Gfx.load_image ctx ("resources/images/" ^ filename) in
              (filename, image)
            )
       in

       Gfx.main_loop 
         (fun _dt ->
            if List.for_all (fun (_, img) -> Gfx.resource_ready img) images_r then
              Some (List.map (fun (filename, img) -> (filename, Gfx.get_resource img)) images_r)
            else 
              None
         )
         (fun images ->
           List.iter (fun (filename, img) -> Hashtbl.add texture_tbl filename (Texture.Image img)) images;
         )
    );


  let global = Global.{ window; ctx; cam_y = 0.0; txt_tbl = texture_tbl} in
  Global.set global;
  let _walls = Wall.walls () in
  let _ = Player.create (3* Cst.window_width / 4, Cst.window_height - Cst.wall_thickness*2) in
  Enemy.spawn (1* Cst.window_width / 4, Cst.window_height - Cst.wall_thickness*2 - 200) Frog;
  Enemy.spawn (2* Cst.wall_thickness, 100) Bat;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in ()








