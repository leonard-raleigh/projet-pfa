open Component_defs
open System_defs


let wall (x, y, txt, width, height, horiz) =
  let e = new wall () in
  e#texture#set txt;
  e#position#set Vector.{x = float x; y = float y};
  e#tag#set (Wall horiz);
  e#box#set Rect.{width; height};
  e#forces#set Vector.zero;
  e#velocity#set Vector.zero;
  e#mass#set Float.infinity;
  e#resolve#set (fun _ _ -> ());
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e


  let walls () =
    List.map wall Cst.[
      (* Bordures verticales *)
      (0,                  -2000, Cst.vwall_color, 32, Cst.window_height + 2000, false);
      (Cst.window_width-32, -2000, Cst.vwall_color, 32, Cst.window_height + 2000, false);
  
      (* Plateformes horizontales *)
      (  64,  Cst.window_height -  100, Cst.hwall_color, 160, 32, false);
      (Cst.window_width-192, Cst.window_height -  100, Cst.hwall_color, 160, 32, false);
  
      (  32,  Cst.window_height -  300, Cst.hwall_color, 200, 32, false);
      (Cst.window_width-232, Cst.window_height -  300, Cst.hwall_color, 200, 32, false);
  
      ( 128,  Cst.window_height -  600, Cst.hwall_color, 256, 32, true);
  
      (  64,  Cst.window_height -  900, Cst.hwall_color, 128, 32, false);
      (Cst.window_width-160, Cst.window_height -  900, Cst.hwall_color, 128, 32, false);
  
      (Cst.window_width/2-128, Cst.window_height - 1200, Cst.hwall_color, 256, 32, false);
  
      ( 100,  Cst.window_height - 1500, Cst.hwall_color, 224, 32, true);
      ( 150,  Cst.window_height - 1800, Cst.hwall_color, 160, 32, true);
  
      (* Dernière plateforme au sommet du niveau *)
      (Cst.window_width/2-96, -2000, Cst.hwall_color, 192, 32, false);
  
      (* Murs verticaux intérieurs pour cheminements secondaires *)
      (256, Cst.window_height -  400, Cst.vwall_color,  32, 400, false);
      (400, Cst.window_height -  800, Cst.vwall_color,  32, 500, false);
      (200, Cst.window_height - 1300, Cst.vwall_color,  32, 300, false);

      (hwall2_x, hwall2_y - 20, Cst.hwall_color, hwall_width, hwall_height + 100, false);
    ]
  

(* let walls () = 
  List.map wall
    Cst.[ 
      (hwall1_x, hwall1_y, Cst.hwall_color, hwall_width, hwall_height, true);
      (hwall2_x, hwall2_y, Cst.hwall_color, hwall_width, hwall_height, false);
      (vwall1_x, vwall1_y, Cst.vwall_color, vwall_width, vwall_height, true);
      (vwall2_x, vwall2_y, Cst.vwall_color, vwall_width, vwall_height, true);
      (Cst.window_width/3, Cst.window_height/3, Cst.vwall_color, Cst.window_width/3, Cst.window_height/3, true);
    ] *)