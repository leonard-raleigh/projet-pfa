open Ecs
open System_defs
open Play

module Play_system = System.Make(Play)

module Foe_com_system = System.Make(Foe_com)
