(*
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
V                               V
V  1                         2  V
V  1 B                       2  V
V  1                         2  V
V  1                         2  V
V                               V
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
*)


let window_width = 800
let window_height = 600

let wall_thickness = 32

let hwall_width = window_width
let hwall_height = wall_thickness
let hwall1_x = 0
let hwall1_y = 0
let hwall2_x = 0
let hwall2_y = window_height -  wall_thickness

let vwall_width = wall_thickness
let vwall_height = window_height - 2 * wall_thickness
let vwall1_x = 0
let vwall1_y = wall_thickness
let vwall2_x = window_width - wall_thickness
let vwall2_y = vwall1_y
let g = Vector.{x = 0.0; y = 0.00000001 }


let player_hitbox_width = 40
let player_hitbox_height = 40
let player_mass = 1.0
let player_sprite = Texture.Color (Gfx.color 255 0 0 255)
let player_stunned_sprite = Texture.Color (Gfx.color 255 255 0 255)
let double_jump_sprite = Texture.Color (Gfx.color 120 120 120 255)
let bullet_sprite = Texture.Color (Gfx.color 0 0 0 255)

let max_jump_duration = 200.0
let jump_force = -8.0
let friction = 0.25

let gravity = 1.0
let max_fall_speed = 10.0
let player_floatiness = 0.3
let double_jumps = 1

let player_speed = 5.0
let player_hp = 4
let player_hit_knockback = 3.0

let jump_button = "p"
let shoot_button = "o"
let left_button = "w"
let right_button = "e"

let vwall_color = Texture.Color (Gfx.color 0 255 0 255)
let hwall_color = Texture.Color (Gfx.color 0 0 255 255)


let max_scroll = 3.0
let level_height = 1000.0
let up_alpha = 0.15
let down_alpha = 0.05

let bullet_speed = 8.0
let bullet_size = 10
let bullet_lifetime = 500.0
let bullet_reload_time = 300.0
let bullet_knockback = 5.0


let frog_sprite = Texture.Color (Gfx.color 0 255 0 255)
let frog_hitbox_width = 25
let frog_hitbox_height = 25
let frog_jump_force = 10.0
let frog_jump_delay = 1500.0

let bat_sprite = Texture.Color (Gfx.color 255 0 255 255)
let bat_hitbox_width = 25
let bat_hitbox_height = 25
let bat_speed = 2.5
