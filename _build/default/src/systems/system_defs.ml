open Ecs

module Collision_system = System.Make(Collision)

module Move_system = System.Make(Move)

module Draw_system = System.Make(Draw)

module Gravity_system = System.Make(Gravity)

module Perish_system = System.Make(Perish)

module Foe_com_system = System.Make(Foe_com)

module Die_system = System.Make(Die)

(* module Play_system = System.Make(Play) *)
