open Ecs

let timer = ref 0.0
let player_x = ref 0.0
let player_y = ref 0.0

class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end

class mass () =
  let r = Component.init 0.0 in
  object
    method mass = r
  end

class forces () =
  let r = Component.init Vector.zero in
  object
    method forces = r
  end

class box () =
  let r = Component.init Rect.{width = 0; height = 0} in
  object
    method box = r
  end

class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

class floatiness () =
  let r = Component.init 0.0 in
  object
    method floatiness = r
  end

class on_ground () =
  let r = Component.init false in
  object
    method on_ground = r
  end


type enemy_type =
  | Frog
  | Bat
  | Slime

type tag = 
  | Player of bool
  | Enemy of enemy_type
  | Wall of bool
  | Ground
  | Bullet
  | Item
  | No_tag


class tagged () =
  let r = Component.init No_tag in
  object
    method tag = r
  end

class resolver () =
  let r = Component.init (fun (_ : Vector.t) (_ : tag) -> ()) in
  object
    method resolve = r
  end

class score1 () =
  let r = Component.init 0 in
  object
    method score1 = r
  end
class score2 () =
  let r = Component.init 0 in
  object
    method score2 = r
  end

class jump_count () =
  let r = Component.init 0 in
  object
    method jump_count = r
  end

class facing () =
  let r = Component.init 1 in
  object
    method facing = r
  end

class on_wall () =
  let r = Component.init 0 in
  object
    method on_wall = r
  end

class double_jumps () =
  let r = Component.init 1 in
  object
    method double_jumps = r
  end

class jump_timer () =
  let r = Component.init 0.0 in
  object
    method jump_timer = r
  end

class will_jump () =
  let r = Component.init true in
  object
    method will_jump = r
  end

class will_shoot () =
  let r = Component.init true in
  object
    method will_shoot = r
  end

class reload_timer () =
  let r = Component.init 0.0 in
  object
    method reload_timer = r
  end

class lifetime () =
  let r = Component.init 0.0 in
  object
    method lifetime = r
  end

class hp () =
  let r = Component.init 0 in
  object
    method hp = r
  end

class stunned () =
  let r = Component.init false in
  object
    method stunned = r
  end
class stunned_timer () =
  let r = Component.init 0.0 in
  object
    method stunned_timer = r
  end



(** Archetype *)
class type movable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
  end

class type collidable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit mass
    inherit velocity
    inherit resolver
    inherit tagged
    (* inherit forces *)
  end

class type physics =
  object 
    inherit Entity.t
    inherit mass
    inherit forces
    inherit velocity
  end

class type gravitable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
    inherit floatiness
    inherit on_ground
    inherit on_wall
  end

class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit texture
  end

class type playable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit mass
    inherit forces
    inherit velocity
    inherit floatiness
    inherit on_ground
    inherit tagged
    inherit resolver
    inherit jump_count
    inherit facing
    inherit double_jumps
    inherit on_wall
    inherit texture
    inherit jump_timer
    inherit will_jump
    inherit will_shoot
    inherit reload_timer
    inherit hp
    inherit stunned
    inherit stunned_timer
  end

class type perishable =
  object
    inherit Entity.t
    inherit lifetime
  end

class type foe =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit mass
    inherit velocity
    inherit floatiness
    inherit on_ground
    inherit tagged
    inherit resolver
    inherit hp
    inherit facing
    inherit jump_timer
  end

class type killable =
  object
    inherit Entity.t
    inherit hp
  end

(** Real objects *)

class block () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit resolver ()
    inherit tagged ()
    inherit texture ()
    inherit mass ()
    inherit forces ()
    inherit velocity () 
  end

class player () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()
    inherit resolver ()
    inherit tagged ()
    inherit texture ()
    inherit mass ()
    inherit forces ()
    inherit velocity ()
    inherit floatiness ()
    inherit on_ground ()
    inherit on_wall ()
    inherit jump_count ()
    inherit facing ()
    inherit double_jumps ()
    inherit jump_timer ()
    inherit will_jump ()
    inherit will_shoot ()
    inherit reload_timer ()
    inherit hp ()
    inherit stunned ()
    inherit stunned_timer ()
  end

class wall () =
object
  inherit resolver ()
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit mass ()
  inherit forces ()
  inherit velocity ()
end

class bullet () =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit velocity ()
  inherit resolver ()
  inherit mass ()
  inherit lifetime ()
end

class enemy () =
object
  inherit Entity.t ()
  inherit position ()
  inherit box ()
  inherit tagged ()
  inherit texture ()
  inherit mass ()
  inherit velocity ()
  inherit floatiness ()
  inherit on_ground ()
  inherit on_wall ()
  inherit resolver ()
  inherit hp ()
  inherit facing ()
  inherit jump_timer ()
end