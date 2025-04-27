open Component_defs
open System_defs


let wall (x, y, txt, width, height) =
  let e = new wall () in
  let txt = Printf.sprintf "wall-%d.png" txt in
  e#texture#set (Global.get_texture txt);
  e#position#set Vector.{x = x; y = y};
  e#tag#set (Wall);
  e#box#set Rect.{width = int_of_float width; height = int_of_float height};
  e#forces#set Vector.zero;
  e#velocity#set Vector.zero;
  e#mass#set Float.infinity;
  e#resolve#set (fun _ _ -> ());
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e



  let walls () =
    let window_width = float Cst.window_width in
    let window_height = float Cst.window_height in
    let wall_thickness = 32.0 in
    List.map wall [
      (* ─── Bordures verticales continues ─────────────────────────────── *)
      (0.0,                           -2000.0, 3, wall_thickness, window_height +. 2000.0);
      (window_width -. wall_thickness, -2000.0, 3, wall_thickness, window_height +. 2000.0);
  

  
      (* ─── Ascension 1 : petites plateformes échelonnées ──────────────── *)
      (wall_thickness +.  50.0, -. 300.0, 2, 120.0, 24.0);
      (wall_thickness +. 220.0,  -. 470.0, 1, 140.0, 24.0);
      (wall_thickness +. 390.0,  -. 650.0, 2, 160.0, 24.0);  
      (window_width -. wall_thickness -. 200.0,  -. 1130.0, 3, 200.0, 330.0);

      (0.25 *. window_width, -.850., 2, 0.25 *. window_width, 50.);
      (wall_thickness, -.1200., 1, 0.25 *. window_width -. wall_thickness, 475.);

      (window_width -. wall_thickness -. 400.0,  -. 1180.0, 1, 200.0, 130.0);

      (2. *. window_width /. 5., -. 1700., 2, 1. *. window_width /. 5., 350.);
      (wall_thickness, -.1500., 1, 64., 64.);
      (window_width -. wall_thickness -. 64., -.1500., 1, 64., 64.);

      (wall_thickness, -.1850., 1, 64., 64.);
      (window_width -. wall_thickness -. 64., -.1850., 1, 64., 64.);

  



       (wall_thickness, window_height -. 150., 1, 3. *. window_width /. 5., 100.);
      (2. *. window_width /. 5., 200., 2, 3. *. window_width /. 5. -. wall_thickness, 100.);
      (3.*.window_width /. 5., 0., 1, 2. *. window_width /. 5. -. wall_thickness, 200.);

      (window_width/.2. -. 60., -.220., 3, window_width *. 0.5 +. 28., 220.);
  
      (wall_thickness, 150., 1, 70., 70.);
      (wall_thickness +. 70., 80., 2, 70., 70.);
      (wall_thickness +. 140., 10., 1, 70., 70.);
  
      (window_width /. 2.0 -. 96.0, -2000.0, 1, 192.0, 32.0);
      (float Cst.hwall2_x, float (Cst.hwall2_y - 20), 3, float Cst.hwall_width, float (Cst.hwall_height + 100));
    ]

  (* let walls () =
    List.map wall Cst.[
      (* Bordures verticales *)
      (0,                  -2000, 3, wall_thickness, Cst.window_height + 2000);
      (Cst.window_width-32, -2000, 3, wall_thickness, Cst.window_height + 2000);
  
      (wall_thickness, window_height - 150, 1, 3 * window_width / 5, 100);
      (2 * window_width / 5, 200, 2, 3 * window_width / 5 - wall_thickness, 100);
      (3*window_width / 5, 0, 1, 2 * window_width / 5 - wall_thickness, 200);

      (window_width/2 - 60, -300, 3, 40, 300);
  
      (* Bordures horizontales *)

      (wall_thickness, 150, 1, 70, 70);
      (wall_thickness + 70, 80, 2, 70, 70);
      (wall_thickness + 140, 10, 1, 70, 70);
  
      (* Bordures horizontales *)

      (hwall2_x, hwall2_y - 20, 3, hwall_width, hwall_height + 100);
    ] *)
  

(* let walls () = 
  List.map wall
    Cst.[ 
      (hwall1_x, hwall1_y, Cst.hwall_color, hwall_width, hwall_height, true);
      (hwall2_x, hwall2_y, Cst.hwall_color, hwall_width, hwall_height, false);
      (vwall1_x, vwall1_y, Cst.vwall_color, vwall_width, vwall_height, true);
      (vwall2_x, vwall2_y, Cst.vwall_color, vwall_width, vwall_height, true);
      (Cst.window_width/3, Cst.window_height/3, Cst.vwall_color, Cst.window_width/3, Cst.window_height/3, true);
    ] *)